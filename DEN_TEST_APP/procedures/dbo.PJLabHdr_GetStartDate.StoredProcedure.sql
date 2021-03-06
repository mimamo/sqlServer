USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJLabHdr_GetStartDate]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[PJLabHdr_GetStartDate]
	@EndDate smalldatetime
	,@StartDate smalldatetime OUTPUT
	
AS

BEGIN

	declare @FirstDayOfWeek as varchar(3),
		@iFirstDayOfWeek as integer,
		@EndDayOfWeek as integer,
		@EndDayOfMonth as integer,
		@prevEndDate as smalldatetime

	SET @FirstDayOfWeek = ''

	--Get the first day of the week configured
	SELECT @FirstDayOfWeek = SUBString(control_data,221,3) from PJCONTRL where control_code = 'SETUP' and control_type = 'TM'

	SELECT @iFirstDayOfWeek = 
	      CASE @FirstDayOfWeek
	         WHEN '' THEN 7
	         WHEN 'Sun' THEN 7
	         WHEN 'Mon' THEN 1
	         WHEN 'Tue' THEN 2
	         WHEN 'Wed' THEN 3
	         WHEN 'Thu' THEN 4
	         WHEN 'Fri' THEN 5
	         WHEN 'Sat' THEN 6
	         ELSE 7
	      END

	--Get the previous week ending date if it exists and use to determine Start Date
	if exists (SELECT 1 from pjweek where We_Date < @EndDate)
		BEGIN
		--Get the previous end date
		SELECT @prevEndDate = max(we_date) from pjweek where We_Date < @EndDate

		-- Add one daye to get the Start Date
		SELECT @StartDate = DATEADD(day, 1, @prevEndDate)
		END
	--else determine the start date from the end date and the first day of week
	else
		BEGIN
		--Set the first day of the week
		SET DATEFIRST @iFirstDayOfWeek

		SELECT @EndDayOfWeek = Datepart(dw,@EndDate)
		SELECT @StartDate = DATEADD(day, -(@EndDayOfWeek-1), @EndDate)

		--If there is a partial week at the beginning of the month, then use the logic below to determine the start date
		-- A partial week can be determined when the StartDate calculated above is not in the same month as the EndDate
		if (Datepart(mm,@StartDate) <> Datepart(mm,@EndDate))
			BEGIN
			--Get the Day of the month for the EndDate
			SELECT @EndDayOfMonth = Datepart(dd,@EndDate)
			SELECT @StartDate = DATEADD(day, -(@EndDayOfMonth-1), @EndDate)
			END

		END
END
GO
