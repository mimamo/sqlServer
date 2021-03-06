USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptReviewRoundCopy]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptReviewRoundCopy]
 @ReviewDeliverableKey INT,
 @CopyFiles tinyint
 
AS --Encrypt

  /*
  || When		Who Rel			What
  || 09/29/11	MAS 10.5.4.9	Created for new ArtReview - Creates a new round using the last round as a template
  || 12/13/11   QMD 10.5.5.1    Added Status value, fixed the logic for the file copy
  || 01/13/12   QMD 10.5.5.2    Added ActiveUser logic
  || 02/10/12   CRG 10.5.5.2    Removed the logic that was setting the ActiveUser and DateActivated because that's being done elsewhere now, per QMD.
  || 09/26/12   QMD 10.5.6.0    Added latestRound updates
  || 10/10/12   QMD 10.5.6.1    Added ReminderType, ReminderInterval, Added logic for duedate
  || 10/17/12   QMD 10.5.6.1    Added Pause
  || 05/16/13   QMD 10.5.6.7    Added TimeZoneIndex
  || 06/20/13   QMD 10.5.6.9    Added logic when calculating the duedate for PDT.  The time comes to 24 which is invalid and throws an error.
  || 12/04/13   QMD 10.5.7.4    Fixed duedate logic for PST. 
  */

Declare @CompleteTaskWhenDone int
Declare @WorkflowType int
Declare @ReviewRoundKey int
Declare @ApprovalStepKey int
Declare @NewApprovalStepKey int
Declare @CopiedReviewRoundKey int
Declare @CompanyKey int, @InternalDays int, @ClientDays int

-- Make sure the ReviewDeliverableKey is valid
If ISNULL(@ReviewDeliverableKey,0) = 0 
	Return -1 

SELECT TOP 1 
	@CopiedReviewRoundKey = r.ReviewRoundKey,
	@CompleteTaskWhenDone = r.CompleteTaskWhenDone,
	@WorkflowType = r.WorkflowType,
	@CompanyKey = rd.CompanyKey,
	@InternalDays = ISNULL(p.InternalReviewDaysToApprove,0),
	@ClientDays = ISNULL(p.ClientReviewDaysToApprove,0)	
FROM tReviewRound r (NOLOCK) INNER JOIN tReviewDeliverable rd (NOLOCK) ON r.ReviewDeliverableKey = rd.ReviewDeliverableKey
			INNER JOIN tPreference p (NOLOCK) ON rd.CompanyKey = p.CompanyKey
WHERE r.ReviewDeliverableKey = @ReviewDeliverableKey
ORDER BY ReviewRoundKey DESC
	
-- Add the new Review Round	
INSERT INTO tReviewRound( ReviewDeliverableKey, CompleteTaskWhenDone, WorkflowType, Status)
VALUES(	@ReviewDeliverableKey, @CompleteTaskWhenDone, @WorkflowType, 1)

Set @ReviewRoundKey = @@IDENTITY		

Update tReviewRound Set LatestRound = 0 where ReviewDeliverableKey = @ReviewDeliverableKey
Update tReviewRound Set LatestRound = 1 where ReviewRoundKey = @ReviewRoundKey

if @CopyFiles = 1
BEGIN
	-- Copy all the file and URL records 
	INSERT INTO tReviewRoundFile( ReviewRoundKey, FilePath, IsURL, DisplayOrder )
	Select @ReviewRoundKey, 
			FilePath, 
			IsURL,
			DisplayOrder
	FROM tReviewRoundFile (nolock) 
	where ReviewRoundKey = @CopiedReviewRoundKey
END

-- Find and add all the steps
select @ApprovalStepKey = -1
while 1=1
	begin
		select @ApprovalStepKey = min(ApprovalStepKey)
		from tApprovalStep (nolock)
		where EntityKey = @CopiedReviewRoundKey and Entity = 'tReviewRound' 
		and ApprovalStepKey > @ApprovalStepKey
		
		if @ApprovalStepKey is null
			break
			
		Insert into tApprovalStep ( CompanyKey, ApprovalTypeKey, Entity, EntityKey, Subject, DisplayOrder, Instructions, EnableRouting, AllApprove, DaysToApprove, Private, Internal, LoginRequired, SendReminder,
									ReminderType, ReminderInterval, DueDate, [Pause], TimeZoneIndex )
		Select	CompanyKey, 
				ApprovalTypeKey, 
				Entity, 
				@ReviewRoundKey, 
				Subject, 
				DisplayOrder, 
				Instructions,
				EnableRouting, 
				AllApprove, 
				DaysToApprove, 
				Private, 
				Internal, 
				LoginRequired, 
				SendReminder,
				ISNULL(ReminderType,0),
				ReminderInterval,
				CASE Internal
					WHEN 0 THEN 
						CASE 
							WHEN 17 + DATEDIFF(HOUR, GETDATE(), GETUTCDATE()) >= 24 THEN
								DATEADD(DAY,@InternalDays, CONVERT(VARCHAR(10), DATEADD(DAY,1,GETDATE()), 110) + ' 00:00:000')
							ELSE 
								DATEADD(DAY,@InternalDays, CONVERT(VARCHAR(10), GETDATE(), 110) + ' ' + CONVERT(VARCHAR(20),17 + DATEDIFF(HOUR, GETDATE(), GETUTCDATE())) + ':00:000')
						END						
					WHEN 1 THEN 
						CASE 
							WHEN 17 + DATEDIFF(HOUR, GETDATE(), GETUTCDATE()) >= 24 THEN
								DATEADD(DAY,@ClientDays, CONVERT(VARCHAR(10), DATEADD(DAY,1,GETDATE()), 110) + ' 00:00:000')					
							ELSE 
								DATEADD(DAY,@ClientDays, CONVERT(VARCHAR(10), GETDATE(), 110) + ' ' + CONVERT(VARCHAR(20),17 + DATEDIFF(HOUR, GETDATE(), GETUTCDATE())) + ':00:000')					
						END											
				END,
				[Pause],
				TimeZoneIndex
		From tApprovalStep (nolock)
		WHERE ApprovalStepKey = @ApprovalStepKey
		
		Set @NewApprovalStepKey = @@IDENTITY
		
		-- Copy over the Approval Users
		INSERT INTO tApprovalStepUser( ApprovalStepKey, AssignedUserKey, DisplayOrder)
		Select @NewApprovalStepKey, 
				AssignedUserKey, 
				DisplayOrder
		FROM tApprovalStepUser (nolock)
		where ApprovalStepKey = @ApprovalStepKey				

		-- Copy over the Notify Users
		INSERT INTO tApprovalStepNotify( ApprovalStepKey, AssignedUserKey )
		Select @NewApprovalStepKey, 
				AssignedUserKey
		FROM tApprovalStepNotify (nolock)
		where ApprovalStepKey = @ApprovalStepKey				
		
	end

	-- Cycle though the Rounds for this Deliverable and resequence the round numbers
	-- have to do this since they can copy a canceled round and we'll not know which round number to use
	EXEC sptReviewRoundUpdateSequence @ReviewDeliverableKey


RETURN @ReviewRoundKey
GO
