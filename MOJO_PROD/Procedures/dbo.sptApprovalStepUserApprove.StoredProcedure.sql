USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserApprove]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserApprove]

	(
		@ApprovalStepKey int,
		@UserKey int,
		@Comments varchar(500),
		@DateCompleted smalldatetime,
		@WithChanges tinyint = 0
	)

AS --Encrypt
/*
|| When     Who Rel			What
|| 09/25/12 GWG 10.5.6.0    Added in a call to rollup status label
|| 10/5/12  GWG 10.5.6.0    Added in @WithChanges
*/

Update tApprovalStepUser
	Set
		ActiveUser = 0,
		CompletedUser = 1,
		Comments = @Comments,
		Action = 1,
		DateCompleted = @DateCompleted,
		WithChanges = @WithChanges
	Where
		ApprovalStepKey = @ApprovalStepKey and
		AssignedUserKey = @UserKey
		

exec sptApprovalStepUpdateStatusNames @ApprovalStepKey
GO
