USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerUpdateActivity]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerUpdateActivity]
	@ActivityKey int,
	@UserKey int,
	@ActivityDate smalldatetime,
	@StartTime smalldatetime,
	@EndTime smalldatetime
AS

/*
|| When      Who Rel      What
|| 12/1/08   CRG 10.5.0.0 Created for activity drag and drop from the calendar
|| 6/18/09   CRG 10.5.0.0 Added call to increment the Sequence number in tActivity after an update
*/

	IF @StartTime IS NULL
		UPDATE	tActivity
		SET		ActivityDate = @ActivityDate,
				UpdatedByKey = @UserKey
		WHERE	ActivityKey = @ActivityKey
	ELSE
		UPDATE	tActivity
		SET		ActivityDate = @ActivityDate,
				StartTime = @StartTime,
				EndTime = @EndTime,
				UpdatedByKey = @UserKey
		WHERE	ActivityKey = @ActivityKey
		
	--Increment the Sequence number
	EXEC sptActivityIncrementSequence @ActivityKey
GO
