USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalGet]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalGet]
 @ApprovalKey int,
 @UserKey int = NULL
AS --Encrypt

/*
|| When      Who Rel      What
|| 2/2/10    CRG 10.5.1.8 (73441) Now returning AllowApproval which indicates whether it's OK for the current UserKey to approve the art review.
||                        Also added code to fix the ActiveApprover if it's not correct.
|| 04/11/11  MFT 10.5.3.4 Added ProjectFullName
*/
 
if @UserKey is null
 SELECT tApproval.*, tProject.ProjectNumber, tProject.ProjectName, tUser.Email,
 	tProject.ProjectNumber + ' - ' + tProject.ProjectName AS ProjectFullName
 FROM tApproval (nolock)
 inner join tProject (nolock) on tApproval.ProjectKey = tProject.ProjectKey
 Left Outer Join tUser (nolock) on tApproval.SendUpdatesTo = tUser.UserKey
 WHERE
  ApprovalKey = @ApprovalKey
else
BEGIN
	DECLARE	@ApprovalOrderType smallint, 
			@CurrentApprovalPos int,
			@CurrentApprover int,
			@ActiveApprover int

	--Get the Order Type for the approval:
	-- 1 All At Once
	-- 2 Approval In Order
	SELECT	@ApprovalOrderType = ApprovalOrderType,
			@ActiveApprover = ActiveApprover
	FROM	tApproval (nolock)
	WHERE	ApprovalKey = @ApprovalKey

	IF @ApprovalOrderType = 2
	BEGIN
		--Get the current approval position
		SELECT	@CurrentApprovalPos = MIN(ApprovalOrder)
		FROM	tApprovalList (nolock)
		WHERE	ApprovalKey = @ApprovalKey
		AND		ISNULL(Completed, 0) = 0
		
		--Get the approver at that position
		SELECT	@CurrentApprover = MIN(UserKey) --Using MIN To prevent duplicates
		FROM	tApprovalList (nolock)
		WHERE	ApprovalKey = @ApprovalKey
		AND		ApprovalOrder = @CurrentApprovalPos
		
		--If the ActiveApprover on tApproval is not correct, fix it
		IF @ActiveApprover <> @CurrentApprover
			UPDATE	tApproval
			SET		ActiveApprover = @CurrentApprover
			WHERE	ApprovalKey = @ApprovalKey
	END
		
	SELECT	tApproval.*, tProject.ProjectNumber, tProject.ProjectName, tApprovalList.Completed, tUser.Email,
			CASE
				WHEN ApprovalOrderType = 2 AND tApproval.ActiveApprover <> @UserKey THEN 0
				ELSE 1
			END AS AllowApproval,
 		tProject.ProjectNumber + ' - ' + tProject.ProjectName AS ProjectFullName
	FROM	tApproval (nolock)
	inner join tProject (nolock) on tApproval.ProjectKey = tProject.ProjectKey
	inner join tApprovalList (nolock) on tApproval.ApprovalKey = tApprovalList.ApprovalKey
	Left Outer Join tUser (nolock) on tApproval.SendUpdatesTo = tUser.UserKey
	WHERE	tApproval.ApprovalKey = @ApprovalKey 
	AND		tApprovalList.UserKey = @UserKey
		
 END

 RETURN 1
GO
