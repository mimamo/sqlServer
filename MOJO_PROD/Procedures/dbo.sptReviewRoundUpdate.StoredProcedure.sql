USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundUpdate]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundUpdate]
 @ReviewRoundKey INT,
 @ReviewDeliverableKey INT,
 @Status INT,
 @TaskKey	INT,
 @CompleteTaskWhenDone TINYINT,
 @DueDate SMALLDATETIME,
 @WorkflowType TINYINT,
 @UserKey INT
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 08/04/11	QMD 10.5.4.8	Created for new ArtReview
  || 09/21/11	MAS 10.5.4.8	Added the call to sptReviewRoundUpdateSequence
  || 12/13/11	QMD	10.5.5.1    Added Cancelled logic and removed send parm
  || 09/26/12	QMD	10.5.6.0    Update LastestRound flag
  || 05/06/15   QMD 10.5.9.1    (255737) Date sent gets updated if they hit save.
  */

IF ISNULL(@ReviewRoundKey,0) > 0 --UPDATE 
	BEGIN
		IF @Status = 2 --Send
			UPDATE	tReviewRound
			SET		ReviewDeliverableKey = @ReviewDeliverableKey,				
					[Status] = @Status,
					TaskKey = @TaskKey,
					CompleteTaskWhenDone = @CompleteTaskWhenDone,
					DueDate = @DueDate,
					DateSent = CASE 
								WHEN DateSent IS NULL THEN GETDATE()
								ELSE DateSent 
							   END,
					SentByUserKey = @UserKey				
			WHERE	ReviewRoundKey = @ReviewRoundKey
		IF @Status = 4 --Cancel
			UPDATE	tReviewRound
			SET		ReviewDeliverableKey = @ReviewDeliverableKey,				
					[Status] = @Status,
					TaskKey = @TaskKey,
					CompleteTaskWhenDone = @CompleteTaskWhenDone,
					DueDate = @DueDate,
					CancelledDate = GETDATE(),
					CancelledByUserKey = @UserKey,
					LatestRound = 0			
			WHERE	ReviewRoundKey = @ReviewRoundKey
		ELSE
			UPDATE	tReviewRound
			SET		ReviewDeliverableKey = @ReviewDeliverableKey,				
					[Status] = @Status,
					TaskKey = @TaskKey,
					CompleteTaskWhenDone = @CompleteTaskWhenDone,
					DueDate = @DueDate				
			WHERE	ReviewRoundKey = @ReviewRoundKey
		
	END
ELSE  --INSERT
	BEGIN
		INSERT INTO tReviewRound 
				(
				ReviewDeliverableKey,		
				[Status],
				TaskKey,
				CompleteTaskWhenDone,
				DueDate,
				WorkflowType			
				)
		VALUES	(
				@ReviewDeliverableKey,		
				@Status,
				@TaskKey,
				@CompleteTaskWhenDone,
				@DueDate,
				@WorkflowType	
				)
		Set @ReviewRoundKey = @@IDENTITY		
		
		Update tReviewRound Set LatestRound = 0 where ReviewDeliverableKey = @ReviewDeliverableKey
		Update tReviewRound Set LatestRound = 1 where ReviewRoundKey = @ReviewRoundKey

	END	

	-- Cycle though the Rounds for this Deliverable and resequence the round numbers
	EXEC sptReviewRoundUpdateSequence @ReviewDeliverableKey

RETURN @ReviewRoundKey
GO
