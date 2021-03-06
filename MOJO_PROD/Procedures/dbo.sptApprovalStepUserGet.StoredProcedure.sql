USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepUserGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepUserGet]
	@ApprovalStepKey int,
	@UserKey int,
    @IgnoreActiveState tinyint = 0
AS --Encrypt

/*
|| When     Who Rel			What
|| 09/10/12 QMD 10.5.6.0    Added option parm and if statement
|| 12/04/14 RLB 10.5.6.1    Added for Platinum 
*/

	If @IgnoreActiveState = 1 
		SELECT *
			,Case WHEN tApprovalStepUser.Action = 1 and tApprovalStepUser.WithChanges = 1 then 'Approved With Changes'
				WHEN tApprovalStepUser.Action = 1 and ISNULL(tApprovalStepUser.WithChanges, 0) = 0 then 'Approved'
				WHEN tApprovalStepUser.Action = 2 then 'Changes Needed'
				Else 'No Decision'	
			END as ActionDescription 
		FROM tApprovalStepUser (nolock)
		WHERE
			tApprovalStepUser.ApprovalStepKey = @ApprovalStepKey and		
			tApprovalStepUser.AssignedUserKey = @UserKey
	Else
		SELECT *
			,Case WHEN tApprovalStepUser.Action = 1 and tApprovalStepUser.WithChanges = 1 then 'Approved With Changes'
				WHEN tApprovalStepUser.Action = 1 and ISNULL(tApprovalStepUser.WithChanges, 0) = 0 then 'Approved'
				WHEN tApprovalStepUser.Action = 2 then 'Changes Needed'
				Else 'No Decision'	
			END as ActionDescription 
		FROM tApprovalStepUser (nolock)
		WHERE
			tApprovalStepUser.ApprovalStepKey = @ApprovalStepKey and
			tApprovalStepUser.ActiveUser = 1 and
			tApprovalStepUser.AssignedUserKey = @UserKey

	RETURN 1
GO
