USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestCheckStatus]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestCheckStatus]

	(
		@RequestKey int,
		@UserKey int
	)

AS
/*
|| When      Who Rel      What
|| 07/23/14   QMD 10.5.8.2 (220667) Created to updated the date sent for approval status
|| 03/25/15   WDF 10.5.9.0 (250961) Added @UserKey, UpdatedByKey and DateUpdated
*/

DECLARE @Status INT 

SELECT @Status = Status FROM tRequest (NOLOCK) WHERE RequestKey = @RequestKey 

--Update Sent For Approval Date
IF @Status = 2 OR @Status = 4
	UPDATE tRequest SET DateSentForApproval = GETDATE()
	                   ,DateCancelled = NULL
	                   ,DateCompleted = NULL 
	                   ,UpdatedByKey = @UserKey
	                   ,DateUpdated = GETUTCDATE()  
	 WHERE RequestKey = @RequestKey
GO
