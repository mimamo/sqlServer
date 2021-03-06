USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeSheetValidateMinimum]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeSheetValidateMinimum]
	@TimeSheetKey int

AS --Encrypt

/*
|| When      Who Rel      What
|| 05/13/13  MFT 10.5.6.8 Created
|| 02/27/14  WDF 10.5.7.7 (207859) Comment out section checking if tTime records exist for the TimeSheetKey
|| 06/04/14  MFT 10.5.8.0 (218418) Added check for NULL TransferToKey
*/

DECLARE
	@UserKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ActualHours decimal(24,4)
SELECT
	@UserKey = UserKey,
	@StartDate = StartDate,
	@EndDate = EndDate,
	@ActualHours = 0
FROM tTimeSheet (nolock)
WHERE	TimeSheetKey = @TimeSheetKey

DECLARE	@RequireMinimumHours tinyint
SELECT	@RequireMinimumHours = ISNULL(RequireMinimumHours, 0)
FROM	tUserPreference (nolock)
WHERE	UserKey = @UserKey

IF ISNULL(@RequireMinimumHours, 0) = 0
	RETURN 1
/*
-- Issue 207859 - More relevant for Daily Timesheet submissions.
-- A user may not have a time record for the day in question
-- because they have 0 hours defined as its 'minimum hours per day' 
-- but are still required to submit a timesheet.

IF NOT EXISTS (
	SELECT *
	FROM tTime (nolock)
	WHERE	TimeSheetKey = @TimeSheetKey)
	RETURN -101
*/
DECLARE @tMinimumHours table (DW tinyint, MinHours decimal(24,4))
INSERT INTO @tMinimumHours
SELECT 1, HoursSunday FROM tUserPreference (nolock) WHERE UserKey = @UserKey
INSERT INTO @tMinimumHours
SELECT 2, HoursMonday FROM tUserPreference (nolock) WHERE UserKey = @UserKey
INSERT INTO @tMinimumHours
SELECT 3, HoursTuesday FROM tUserPreference (nolock) WHERE UserKey = @UserKey
INSERT INTO @tMinimumHours
SELECT 4, HoursWednesday FROM tUserPreference (nolock) WHERE UserKey = @UserKey
INSERT INTO @tMinimumHours
SELECT 5, HoursThursday FROM tUserPreference (nolock) WHERE UserKey = @UserKey
INSERT INTO @tMinimumHours
SELECT 6, HoursFriday FROM tUserPreference (nolock) WHERE UserKey = @UserKey
INSERT INTO @tMinimumHours
SELECT 7, HoursSaturday FROM tUserPreference (nolock) WHERE UserKey = @UserKey

DECLARE @tActualHours table (WorkDate smalldatetime, ActualHours decimal(24,4), DW tinyint)

WHILE @StartDate <= @EndDate
	BEGIN
		SELECT @ActualHours = SUM(ActualHours)
		FROM tTime (nolock)
		WHERE
			TimeSheetKey = @TimeSheetKey AND
			WorkDate = @StartDate AND
			TransferToKey IS NULL
		GROUP BY WorkDate
		
		INSERT INTO @tActualHours
		VALUES (@StartDate, @ActualHours, DATEPART(dw, @StartDate))
		
		SELECT
			@StartDate = DATEADD(d, 1, @StartDate),
			@ActualHours = 0
	END

IF EXISTS (
	SELECT *
	FROM
		@tActualHours ah
		LEFT JOIN @tMinimumHours mh ON ah.DW = mh.DW
	WHERE ah.ActualHours < mh.MinHours)
	RETURN -101

RETURN 1
GO
