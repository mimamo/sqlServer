USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUpdateStatusNames]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUpdateStatusNames]
	(
	@ApprovalStepKey int
	)

AS
/*
|| When     Who Rel			What
|| 10/05/12 GWG 10.5.6.0    Added Withchanges logic
*/


declare @CurKey int, @Status varchar(5000), @UserStatus varchar(5000), @DateActivated smalldatetime
declare @DateCompleted smalldatetime, @Action int, @Name varchar(1000), @EnableRouting tinyint, @DisplayOrder int, @WithChanges tinyint

Select @CurKey = -1, @DisplayOrder = -1, @EnableRouting = EnableRouting from tApprovalStep (nolock) Where ApprovalStepKey = @ApprovalStepKey


While 1=1
BEGIN

	if @EnableRouting = 0
		Select @CurKey = Min(ApprovalStepUserKey) from tApprovalStepUser asu (nolock) Where ApprovalStepKey = @ApprovalStepKey and ApprovalStepUserKey > @CurKey
	else
	BEGIN
		-- If routing go in display order
		Select @DisplayOrder = Min(DisplayOrder) from tApprovalStepUser asu (nolock) Where ApprovalStepKey = @ApprovalStepKey and DisplayOrder > @DisplayOrder
		Select @CurKey = Min(ApprovalStepUserKey) from tApprovalStepUser asu (nolock) Where ApprovalStepKey = @ApprovalStepKey and DisplayOrder = @DisplayOrder
	END

		if @CurKey is null
			break

		Select @UserStatus = ISNULL(FirstName, '') + ' ' + ISNULL(LastName, ''), @DateActivated = DateActivated, @DateCompleted = DateCompleted, @Action = ISNULL(Action, -1), @WithChanges = ISNULL(WithChanges, 0)
		From tApprovalStepUser asu (nolock) 
		inner join tUser u (nolock) on asu.AssignedUserKey = u.UserKey
		Where ApprovalStepUserKey = @CurKey

		if @DateActivated is null
			Select @UserStatus = @UserStatus + ' (Waiting)'
		else
		BEGIN
			if @DateCompleted is null
				Select @UserStatus = @UserStatus + ' (Reviewing)'
			else
			BEGIN
				if @Action = 1 
				BEGIN
					if @WithChanges = 1
						Select @UserStatus = @UserStatus + ' (Approved With Changes)'
					else
						Select @UserStatus = @UserStatus + ' (Approved)'
				END
				if @Action = 2 
					Select @UserStatus = @UserStatus + ' (Resubmit)'
				if @Action = 3
					Select @UserStatus = @UserStatus + ' (Skipped)'
			END
		END

		if @Status is not null
			Select @Status = @Status + ', '

		Select @Status = ISNULL(@Status, '') + @UserStatus 


END

Update tApprovalStep Set ApproverStatus = @Status Where ApprovalStepKey = @ApprovalStepKey
GO
