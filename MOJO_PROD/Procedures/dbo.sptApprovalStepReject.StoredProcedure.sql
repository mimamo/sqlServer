USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepReject]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepReject]

	(
		@ApprovalStepKey int,
		@UserKey int,
		@Comments varchar(500),
		@DateCompleted smalldatetime,
		@Action int = 1
	)

AS --Encrypt

/*
|| When     Who Rel			What
|| 02/08/12 QMD 10.5.5.3    Added the action to the sptApprovalStep update
|| 07/02/12 QMD 10.5.5.7    (145865) Changed the logic to only reject a step user if other users are active
|| 07/10/12 QMD 10.5.5.7    (145865) Added Begin and End 
|| 09/25/12 GWG 10.5.6.0    Added in a call to rollup status label
|| 10/05/12 GWG 10.5.6.0    Set With Changes back to 0 on reject
*/

Declare @AllApprove tinyint

Select @AllApprove = AllApprove From tApprovalStep (Nolock) Where ApprovalStepKey = @ApprovalStepKey

If @AllApprove = 1 And @Action = 2
	Update	tApprovalStepUser
	Set		ActiveUser = 0
	Where	ApprovalStepKey = @ApprovalStepKey
			And AssignedUserKey = @UserKey
Else
	Update	tApprovalStepUser
	Set		ActiveUser = 0
	Where	ApprovalStepKey = @ApprovalStepKey

Update tApprovalStepUser
Set
	CompletedUser = 1,
	Comments = @Comments,
	Action = 2,
	DateCompleted = @DateCompleted,
	WithChanges = 0
Where
	ApprovalStepKey = @ApprovalStepKey 
	And AssignedUserKey = @UserKey

If @Action = 2
	Begin
		-- If all approve is 1 then check to see if other users still need to view step
		If Not Exists (Select * From tApprovalStepUser a (Nolock) Inner Join tApprovalStep s (Nolock) On a.ApprovalStepKey = s.ApprovalStepKey 
				Where a.ApprovalStepKey = @ApprovalStepKey And a.ActiveUser = 1 And s.AllApprove = 1)
			Update tApprovalStep
			Set
				ActiveStep = 0,
				Completed = 1,
				Action = @Action --TODO: Check Action status ... need the Action for Reject
			Where
				ApprovalStepKey = @ApprovalStepKey
		
			
	End
Else
	Update tApprovalStep
	Set
		ActiveStep = 0,
		Completed = 1
	Where
		ApprovalStepKey = @ApprovalStepKey


exec sptApprovalStepUpdateStatusNames @ApprovalStepKey
GO
