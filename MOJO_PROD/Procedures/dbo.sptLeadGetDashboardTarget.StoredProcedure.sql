USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetDashboardTarget]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadGetDashboardTarget]
	@AccountManagerKey INT,
	@CurrentDate DATETIME = GETDATE

AS --Encrypt

/*
|| When     Who Rel			What
|| 01/08/15 RLB 10.5.8.8	Created for wjapp dashboard
*/

create table #targetData (UserKey int null
							,MonthTargetGoal int null
							,MonthTargetTotal int null
							,MonthPercComp int null
							,MonthMaxValue int null
							,QuarterTargetGoal int null
							,QuarterTargetTotal int null
							,QuarterPercComp int null
							,QuarterMaxValue int null
							,YearTargetGoal int null
							,YearTargetTotal int null
							,YearPercComp int null
							,YearMaxValue int  null
						  )
INSERT #targetData (
					UserKey
					,MonthTargetGoal
					,MonthTargetTotal
					,MonthPercComp
					,MonthMaxValue
					,QuarterTargetGoal
					,QuarterTargetTotal
					,QuarterPercComp
					,QuarterMaxValue
					,YearTargetGoal
					,YearTargetTotal
					,YearPercComp
					,YearMaxValue
					)
SELECT @AccountManagerKey, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


DECLARE @Year int, @Month int, @Quarter int, @QuarterStart DATETIME, @QuarterEnd DATETIME
		,@MonthStart DATETIME, @MonthEnd DATETIME, @YearStart DATETIME, @YearEnd DATETIME

SELECT @Month = CAST(DATEPART(MONTH, @CurrentDate) as int)
SELECT @Quarter = CAST(DATEPART(MONTH, @CurrentDate) as int)
SELECT @Year = CAST(DATEPART(YEAR, @CurrentDate) as int)

-- create month date range
SELECT @MonthStart = cast(cast(datepart(MONTH, @CurrentDate) as varchar(2)) + '/01/' + cast(datepart(yyyy, @CurrentDate) as varchar(4)) as datetime)
SELECT @MonthEnd = DATEADD(MONTH, 1, @MonthStart)


-- create Quarter Date range
IF @Quarter = 1 OR @Quarter = 2 OR @Quarter = 3
BEGIN
	SELECT @QuarterStart = cast( '01/01/' + cast(datepart(yyyy, @CurrentDate) as varchar(4)) as datetime)
	SELECT @QuarterEnd = DATEADD(MONTH, 3, @QuarterStart)

END
IF @Quarter = 4 OR @Quarter = 5 OR @Quarter = 6
BEGIN
	SELECT @QuarterStart = cast( '04/01/' + cast(datepart(yyyy, @CurrentDate) as varchar(4)) as datetime)
	SELECT @QuarterEnd = DATEADD(MONTH, 3, @QuarterStart)

END
IF @Quarter = 7 OR @Quarter = 8 OR @Quarter = 9
BEGIN
	SELECT @QuarterStart = cast( '07/01/' + cast(datepart(yyyy, @CurrentDate) as varchar(4)) as datetime)
	SELECT @QuarterEnd = DATEADD(MONTH, 3, @QuarterStart)

END
IF @Quarter = 10 OR @Quarter =11 OR @Quarter = 12
BEGIN
	SELECT @QuarterStart = cast( '10/01/' + cast(datepart(yyyy, @CurrentDate) as varchar(4)) as datetime)
	SELECT @QuarterEnd = DATEADD(MONTH, 3, @QuarterStart)

END

-- create month date range
SELECT @YearStart = cast('01/01/' + cast(datepart(yyyy, @CurrentDate) as varchar(4)) as datetime)
SELECT @YearEnd = DATEADD(YEAR, 1, @YearStart)

-- Set month goals & Totals
DECLARE @MonthGoal int, @MonthTotal int, @MonthMax int

Select 
	@MonthGoal = CASE @Month 
	when 1 then ISNULL(gl.Month1, 0)
	when 2 then ISNULL(gl.Month2, 0)
	when 3 then ISNULL(gl.Month3, 0)
	when 4 then ISNULL(gl.Month4, 0)
	when 5 then ISNULL(gl.Month5, 0)
	when 6 then ISNULL(gl.Month6, 0)
	when 7 then ISNULL(gl.Month7, 0)
	when 8 then ISNULL(gl.Month8, 0)
	when 9 then ISNULL(gl.Month9, 0)
	when 10 then ISNULL(gl.Month10, 0)
	when 11 then ISNULL(gl.Month11, 0)
	when 12 then ISNULL(gl.Month12, 0)
	END 
FROM tGoal gl (nolock) where gl.Entity = 'tUser' and gl.EntityKey = @AccountManagerKey and gl.Year = @Year

SELECT @MonthGoal = ISNULL(@MonthGoal, 0)

SELECT @MonthTotal = ISNULL(Sum(ch.CheckAmount), 0) 
FROM tCompany cl
inner join tCheck ch (nolock) on cl.CompanyKey = ch.ClientKey
WHERE cl.SalesPersonKey = @AccountManagerKey
AND ch.PostingDate >= @MonthStart
AND ch.PostingDate < @MonthEnd

-- set month max value
IF @MonthTotal > @MonthGoal
	SELECT @MonthMax = @MonthTotal
ELSE
	SELECT @MonthMax = @MonthGoal
	
UPDATE #targetData 
	SET MonthTargetGoal = @MonthGoal, MonthTargetTotal = @MonthTotal, MonthMaxValue = @MonthMax
WHERE #targetData.UserKey = @AccountManagerKey



-- Set quarter goals & Totals
DECLARE @QuarterGoal int, @QuarterTotal int, @QuarterMax int

Select 
	@QuarterGoal = CASE @Quarter 
	when 1 then (select ISNULL(Month1, 0) + ISNULL(Month2, 0) +  ISNULL(Month3, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 2 then (select ISNULL(Month1, 0) + ISNULL(Month2, 0) +  ISNULL(Month3, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 3 then (select ISNULL(Month1, 0) + ISNULL(Month2, 0) +  ISNULL(Month3, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 4 then (select ISNULL(Month4, 0) + ISNULL(Month5, 0) +  ISNULL(Month6, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 5 then (select ISNULL(Month4, 0) + ISNULL(Month5, 0) +  ISNULL(Month6, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 6 then (select ISNULL(Month4, 0) + ISNULL(Month5, 0) +  ISNULL(Month6, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 7 then (select ISNULL(Month7, 0) + ISNULL(Month8, 0) +  ISNULL(Month9, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 8 then (select ISNULL(Month7, 0) + ISNULL(Month8, 0) +  ISNULL(Month9, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 9 then (select ISNULL(Month7, 0) + ISNULL(Month8, 0) +  ISNULL(Month9, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 10 then (select ISNULL(Month10, 0) + ISNULL(Month11, 0) +  ISNULL(Month12, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 11 then (select ISNULL(Month10, 0) + ISNULL(Month11, 0) +  ISNULL(Month12, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	when 12 then (select ISNULL(Month10, 0) + ISNULL(Month11, 0) +  ISNULL(Month12, 0) from tGoal (nolock) where Entity = 'tUser' and EntityKey = @AccountManagerKey and Year = @Year)
	END 
FROM tGoal gl (nolock) where gl.Entity = 'tUser' and gl.EntityKey = @AccountManagerKey and gl.Year = @Year

SELECT @QuarterGoal = ISNULL(@QuarterGoal, 0)

SELECT @QuarterTotal = ISNULL(Sum(ch.CheckAmount), 0) 
FROM tCompany cl
inner join tCheck ch (nolock) on cl.CompanyKey = ch.ClientKey
WHERE cl.SalesPersonKey = @AccountManagerKey
AND ch.PostingDate >= @QuarterStart
AND ch.PostingDate < @QuarterEnd

-- set quarter max value
IF @QuarterTotal > @QuarterGoal
	SELECT @QuarterMax = @QuarterTotal
ELSE
	SELECT @QuarterMax = @QuarterGoal

UPDATE #targetData 
	SET QuarterTargetGoal = @QuarterGoal, QuarterTargetTotal = @QuarterTotal, QuarterMaxValue = @QuarterMax
WHERE #targetData.UserKey = @AccountManagerKey





-- Set quarter goals & Totals
DECLARE @YearGoal int, @YearTotal int, @YearMax int

Select 
	@YearGoal = gl.Total
FROM tGoal gl (nolock) where gl.Entity = 'tUser' and gl.EntityKey = @AccountManagerKey and gl.Year = @Year

SELECT @YearGoal = ISNULL(@YearGoal, 0)

SELECT @YearTotal = ISNULL(Sum(ch.CheckAmount), 0) 
FROM tCompany cl
inner join tCheck ch (nolock) on cl.CompanyKey = ch.ClientKey
WHERE cl.SalesPersonKey = @AccountManagerKey
AND ch.PostingDate >= @YearStart
AND ch.PostingDate < @YearEnd

-- set quarter max value
IF @YearTotal > @YearGoal
	SELECT @YearMax = @YearTotal
ELSE
	SELECT @YearMax = @YearGoal

UPDATE #targetData 
	SET YearTargetGoal = @YearGoal, YearTargetTotal = @YearTotal, YearMaxValue = @YearMax
WHERE #targetData.UserKey = @AccountManagerKey

UPDATE #targetData SET MonthPercComp = (MonthTargetGoal / MonthTargetTotal) * 100 WHERE UserKey = @AccountManagerKey AND MonthTargetTotal > 0

UPDATE #targetData SET QuarterPercComp = (QuarterTargetGoal / QuarterTargetTotal) * 100 WHERE UserKey = @AccountManagerKey AND QuarterTargetTotal > 0

UPDATE #targetData SET YearPercComp = (YearTargetGoal / YearTargetTotal) * 100 WHERE UserKey = @AccountManagerKey AND YearTargetTotal > 0

SELECT * FROM #targetData
GO
