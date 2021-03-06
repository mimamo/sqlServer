USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptApprovalStepMarkCompleted]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptApprovalStepMarkCompleted]

	(
		@ApprovalStepKey int,
		@LastStep tinyint = 0
	)

AS

if @LastStep = 1
BEGIN
	Declare @Entity varchar(100), @EntityKey int
	Select @Entity = Entity, @EntityKey = EntityKey from tApprovalStep (nolock) Where ApprovalStepKey = @ApprovalStepKey

	if @Entity = 'tReviewRound'
		Update tReviewDeliverable Set Approved = 1, ApprovedDate = dbo.fFormatDateNoTime(GETDATE()) 
		From tReviewRound
		Where tReviewRound.ReviewDeliverableKey = tReviewDeliverable.ReviewDeliverableKey and tReviewRound.ReviewRoundKey = @EntityKey
END


Update tApprovalStep Set Completed = 1, ActiveStep = 0 Where ApprovalStepKey = @ApprovalStepKey

Update	tApprovalStepUser
Set 
	ActiveUser = 0,
	CompletedUser = 1
Where
	ApprovalStepKey = @ApprovalStepKey
GO
