USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepRejectUpdate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepRejectUpdate]

	(
		@ApprovalStepKey int,
		@Action int = 2 --ArtReview 2 is Rejected at step level
	)

AS --Encrypt

/*
|| When     Who Rel			What
|| 07/02/12 QMD 10.5.5.7    Update status to reject
*/

Update tApprovalStep
Set
	ActiveStep = 0,
	Completed = 1,
	Action = @Action 
Where
	ApprovalStepKey = @ApprovalStepKey
GO
