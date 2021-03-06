USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepCancelAll]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepCancelAll]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS

	/*
	|| When     Who		Rel			What
	|| 12/21/12 QMD		10.5.6.3	Added Paused
	*/

Update tApprovalStepUser
Set
	ActiveUser = 0, CompletedUser = 0, DateActivated = NULL, DueDate = NULL, DateCompleted = NULL
From
	tApprovalStep (nolock)

Where
	tApprovalStepUser.ApprovalStepKey = tApprovalStep.ApprovalStepKey and
	tApprovalStep.Entity = @Entity and
	tApprovalStep.EntityKey = @EntityKey

Update tApprovalStep
set
	ActiveStep = 0, Completed = 0, Paused = NULL
Where
	tApprovalStep.Entity = @Entity and
	tApprovalStep.EntityKey = @EntityKey
GO
