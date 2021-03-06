USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepEntityApprovalCount]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepEntityApprovalCount]

	(
		@Entity varchar(50),
		@UserKey int
	)

AS


Select Count(*) from tApprovalStep aps (nolock)
	Inner join tApprovalStepUser asu (nolock) on aps.ApprovalStepKey = asu.ApprovalStepKey
	Where
		aps.Entity = @Entity and
		asu.AssignedUserKey = @UserKey and
		aps.ActiveStep = 1 and
		asu.ActiveUser = 1
GO
