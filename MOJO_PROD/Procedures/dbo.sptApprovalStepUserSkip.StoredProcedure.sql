USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserSkip]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserSkip]

	(
		@ApprovalStepKey int,
		@UserKey int,
		@DateCompleted smalldatetime
	)

AS --Encrypt

/*  
|| When      Who Rel      What  
|| 01/19/12  QMD 10.5.5.3 Created for the new artReview
|| 09/25/12 GWG 10.5.6.0    Added in a call to rollup status label
*/  

	UPDATE tApprovalStepUser
	SET	
			ActiveUser = 0,
			CompletedUser = 1,
			Action = 3,
			DateCompleted = @DateCompleted
	WHERE
			ApprovalStepKey = @ApprovalStepKey AND
			AssignedUserKey = @UserKey
		

exec sptApprovalStepUpdateStatusNames @ApprovalStepKey
GO
