USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestUpdateStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestUpdateStatus]

	(
		@RequestKey int,
		@UserKey int,
		@Status smallint,
		@Cancelled smallint = 0,
		@RequestRejectReasonKey INT = null
	)

AS
/*
|| When      Who Rel      What
|| 6/13/13   WDF 10.5.6.9 (181051) Added 'Cancelled' 
|| 6/27/14   QMD 10.5.8.1 (220667) Added CancelledDate and SentForApprovalDate
|| 8/15/14   RLB 10.5.8.3 (226572) Only set current date for DateSentForApproval if it is null on approval
|| 3/25/15   WDF 10.5.9.0 (250961) Added @UserKey, UpdatedByKey and DateUpdated
|| 4/23/15   GHL 10.5.9.1 (250967) Added @RequestRejectReasonKey parameter for kohls enhancment
*/

DECLARE @DateSentForApproval as smalldatetime

Select @DateSentForApproval = DateSentForApproval From tRequest (nolock) Where RequestKey = @RequestKey

IF @Status <> 3
	SELECT @RequestRejectReasonKey = NULL

Update tRequest Set Status = @Status
                   ,Cancelled = @Cancelled
                   ,UpdatedByKey = @UserKey
                   ,DateUpdated = GETUTCDATE()  
				   ,RequestRejectReasonKey = @RequestRejectReasonKey
 Where RequestKey = @RequestKey

--Update Sent For Approval Date
if @Status = 2 
	Update tRequest Set DateSentForApproval = GETDATE(), DateCancelled = NULL, DateCompleted = NULL Where RequestKey = @RequestKey

if @Status = 4
BEGIN
	if @DateSentForApproval IS NOT NULL
		Update tRequest Set DateCancelled = NULL, DateCompleted = NULL Where RequestKey = @RequestKey
	else
		Update tRequest Set DateSentForApproval = GETDATE(), DateCancelled = NULL, DateCompleted = NULL Where RequestKey = @RequestKey

END
	

--Update Cancelled Date
if @Status = 1 And @Cancelled = 1
	Update tRequest Set DateCancelled = GETDATE() Where RequestKey = @RequestKey
GO
