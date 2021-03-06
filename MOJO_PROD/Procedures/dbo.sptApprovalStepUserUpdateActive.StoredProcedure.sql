USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserUpdateActive]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserUpdateActive]
	@ApprovalStepUserKey INT,
	@ApprovalStepKey INT

AS --Encrypt

  /*
  || When		Who Rel			What
  || 05/09/14	WDF 10.5.8.0	(215235) Added sptApprovalStepUpdateStatusNames
  */
  
DECLARE @EnableRouting AS TINYINT
DECLARE @DaysToApprove INT, @DateActivated SMALLDATETIME, @DueDate SMALLDATETIME

SELECT	@DaysToApprove = DaysToApprove, @EnableRouting = EnableRouting 
FROM	tApprovalStep (NOLOCK) 
WHERE	ApprovalStepKey = @ApprovalStepKey
		AND ActiveStep = 1

SELECT @DateActivated = Cast(Convert(varchar, GETDATE(), 101) AS SMALLDATETIME)
SELECT @DueDate = DATEADD(d, @DaysToApprove, @DateActivated)

IF @EnableRouting = 0
BEGIN
	UPDATE	tApprovalStepUser
	SET		ActiveUser = 1, DateActivated = @DateActivated, DueDate = @DueDate 
	WHERE	ApprovalStepKey = @ApprovalStepKey
			AND ApprovalStepUserKey = @ApprovalStepUserKey
			
	exec sptApprovalStepUpdateStatusNames @ApprovalStepKey
END
GO
