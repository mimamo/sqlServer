USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptActualVsMinimumHours]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptActualVsMinimumHours]
	(
		 @CompanyKey INT
		,@StartDate DATETIME
		,@EndDate DATETIME
		,@OfficeKey INT
		,@DepartmentKey INT
		,@Weekly TINYINT
		,@ExcludeZeroRemaining TINYINT
	)
AS -- Encrypt

 /*
  || When     Who Rel    What
  || 01/10/07 GHL 8.4    Increased size of fields in temp table. Causing truncating errors
  || 10/27/10 RLB 10.537 (85219) Added Office Name and Department Name for grouping on the report  
  || 06/03/11 GHL 10.545 (113173) Added new temp table for work dates. There was an unusual cartesion product
  ||                     between #tUserDate and tUser with the results into #tUserDate. I changed that to
  ||                     a cartesian product between #tWorkDate and tUser. Reason is that it was causing
  ||                     logical page fetch errors
  || 05/16/12 RLB 10.556 (141636) changes made for this issue
  || 09/21/12 KMC 10.560 (141636) Added @ExcludeZeroRemaining to exclude any rows where the remaining hours equals 0
  || 10/29/12 MFT 10.561 (158216) Added join to tUser when calculating MinimumHours to exclude dates prior to DateHired
  || 02/28/13 WDF 10.565 (169231) Added WeekOfDate for Report Grouping and rollup hours per user per week
  || 05/29/13 MFT 10.568 (177887) Changed DateHired exclusion methodology to remove prior records rather than show them as 0 hours
  */
  
	SET NOCOUNT ON
	
	CREATE TABLE #tUserDate	(UserKey INT NULL, FullName VARCHAR(300) NULL, WeekOfDate VARCHAR(18) NULL,WorkDate DATETIME NULL, MinimumHours DECIMAL(24, 4) NULL, 
								ActualHours DECIMAL(24, 4) NULL, Remaining DECIMAL(24, 4) NULL, OfficeName VARCHAR(200), DepartmentName VARCHAR(200))
				
	CREATE TABLE #tWorkDate(WorkDate DATETIME NULL)
	
	DECLARE @WorkDate DATETIME
	SELECT @WorkDate = @StartDate
	WHILE (DATEDIFF(day, @WorkDate, @EndDate) >= 0)
	BEGIN
		INSERT #tWorkDate (WorkDate) VALUES (@WorkDate)
		SELECT 	@WorkDate = DATEADD(day, 1, @WorkDate)
	END

	-- Use a cartesian product to get all users for all days
	INSERT #tUserDate (UserKey, FullName, WorkDate, ActualHours, MinimumHours, Remaining, OfficeName, DepartmentName)
	SELECT u.UserKey, 
		   case  
			   when u.MiddleName is null then  ISNULL(u.FirstName, '') +  ' ' + ISNULL(u.LastName, '') 
			   else  ISNULL(u.FirstName, '') +  ' ' + ISNULL(u.MiddleName, '') + ' ' + ISNULL(u.LastName, '')
			   end as FullName, b.WorkDate, 0, 0, 0, ISNULL(o.OfficeName, '[ No Office ]'), ISNULL(d.DepartmentName, '[ No Department ]') 
	FROM   tUser u (NOLOCK)
		   left outer join tOffice o (nolock) on u.OfficeKey = o.OfficeKey
		   left outer join tDepartment d (nolock) on u.DepartmentKey = d.DepartmentKey
		   ,#tWorkDate b
		   
	WHERE  u.CompanyKey = @CompanyKey
	AND	   u.Active = 1
	AND    (@OfficeKey = -1 Or (ISNULL(@OfficeKey, 0) = ISNULL(u.OfficeKey, 0)) )
	AND    (@DepartmentKey = -1 Or (ISNULL(@DepartmentKey, 0) = ISNULL(u.DepartmentKey, 0)) )
	
	-- Now get actual hours	 
	UPDATE #tUserDate
	SET	   #tUserDate.ActualHours = (SELECT (SUM(ActualHours)) 
			FROM tTime t (NOLOCK)
			INNER JOIN tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
			WHERE ts.CompanyKey = @CompanyKey
			AND   ts.UserKey = #tUserDate.UserKey
			AND   t.WorkDate = #tUserDate.WorkDate)
	
	-- Now get minimum required
	UPDATE #tUserDate
	SET	   #tUserDate.MinimumHours = (SELECT 
	CASE 
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 1  THEN up.HoursSunday
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 2  THEN up.HoursMonday
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 3  THEN up.HoursTuesday
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 4  THEN up.HoursWednesday
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 5  THEN up.HoursThursday
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 6  THEN up.HoursFriday
	WHEN DATEPART(weekday, #tUserDate.WorkDate) = 7  THEN up.HoursSaturday
	ELSE 0
	END
	FROM
		tUserPreference up (NOLOCK)
	WHERE
		#tUserDate.UserKey = up.UserKey)
	
	-- Remove records prior to DateHired
	DELETE
		#tUserDate
	FROM
		#tUserDate ud
		INNER JOIN tUser u (nolock) ON ud.UserKey = u.UserKey
	WHERE
		WorkDate <= ISNULL(u.DateHired, '1/1/1900')
	
	UPDATE #tUserDate SET ActualHours = 0 WHERE ActualHours IS NULL
	UPDATE #tUserDate SET MinimumHours = 0 WHERE MinimumHours IS NULL

	UPDATE #tUserDate 
	Set Remaining = MinimumHours - ActualHours
	WHERE #tUserDate.MinimumHours - #tUserDate.ActualHours > 0

	-- Update WeekOfDate with a calculated date 
	DECLARE @WeekStart int
	SELECT @WeekStart = CASE TimeSheetPeriod
	                      WHEN 2 THEN StartTimeOn  -- Use the Weekly Start On day
	                      WHEN 3 THEN StartTimeOn  -- Use the Bi-Weekly Start On day
	                      ELSE 1 -- Start on Sunday
	                    END
      FROM tTimeOption WHERE CompanyKey = @CompanyKey

    UPDATE #tUserDate
       SET WeekOfDate =  'Week Of ' + CASE 
                                       WHEN DATEPART(dw, WorkDate) = @WeekStart THEN CONVERT(char(10), WorkDate,126)
                                       WHEN DATEPART(dw, WorkDate) > @WeekStart THEN CONVERT(char(10), DATEADD (dw , (@WeekStart - DATEPART(dw, WorkDate)), WorkDate ),126)
                                       WHEN DATEPART(dw, WorkDate) < @WeekStart THEN CONVERT(char(10), DATEADD (dw , - ((7 - @WeekStart) + DATEPART(dw, WorkDate)), WorkDate ),126)
                                      END 
	-- Roll up hours for Weekly grouping
	IF @Weekly = 1
	BEGIN

		SELECT TOP 0 * INTO #tUserDateWeek FROM #tUserDate

		INSERT #tUserDateWeek(UserKey, WeekOfDate, ActualHours, MinimumHours, Remaining)
		SELECT UserKey, WeekOfDate,  sum(ActualHours), sum(MinimumHours), sum(Remaining)
		  FROM #tUserDate
		 group by WeekOfDate, UserKey

		UPDATE udw
		   SET udw.FullName =  ud.FullName
			  ,udw.OfficeName = ud.OfficeName
			  ,udw.DepartmentName = ud.DepartmentName
		  FROM #tUserDateWeek udw INNER JOIN #tUserDate ud ON (ud.UserKey = udw.UserKey)

		TRUNCATE TABLE #tUserDate
		
		INSERT #tUserDate
		SELECT * FROM #tUserDateWeek 
	END
	
	IF @ExcludeZeroRemaining = 0
	BEGIN
		SELECT * FROM #tUserDate
		ORDER BY FullName, UserKey, WorkDate
	END
	ELSE
	BEGIN
		SELECT * FROM #tUserDate
		WHERE Remaining > 0
		ORDER BY FullName, UserKey, WorkDate
	END

	RETURN 1
GO
