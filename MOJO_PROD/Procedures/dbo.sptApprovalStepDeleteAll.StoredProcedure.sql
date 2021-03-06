USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepDeleteAll]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepDeleteAll]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS


Delete tApprovalStepUser
From
	tApprovalStep (nolock)
Where
	tApprovalStepUser.ApprovalStepKey = tApprovalStep.ApprovalStepKey and
	tApprovalStep.Entity = @Entity and
	tApprovalStep.EntityKey = @EntityKey

Delete tApprovalStep
Where
	tApprovalStep.Entity = @Entity and
	tApprovalStep.EntityKey = @EntityKey
GO
