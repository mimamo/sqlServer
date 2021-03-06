USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserSetNext]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserSetNext]

	(
		@ApprovalStepKey int,
		@UserKey int,
		@NextUserKey int,
		@Comments varchar(500),
		@DateActivated smalldatetime,
		@DueDate smalldatetime
	)

AS --Encrypt

Update tApprovalStepUser
	Set
		ActiveUser = 0,
		CompletedUser = 1,
		DateCompleted = @DateActivated
	Where
		ApprovalStepKey = @ApprovalStepKey and
		AssignedUserKey = @UserKey
		
Update tApprovalStepUser
	Set
		ActiveUser = 1,
		CompletedUser = 0,
		DateActivated = @DateActivated,
		DueDate = @DueDate
	Where
		ApprovalStepKey = @ApprovalStepKey and
		AssignedUserKey = @NextUserKey
GO
