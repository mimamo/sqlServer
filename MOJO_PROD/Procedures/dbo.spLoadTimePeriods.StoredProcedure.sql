USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadTimePeriods]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadTimePeriods]
	@CompanyKey int,
	@UserKey int,
	@LowerRange int = 7,
	@MustInclude smalldatetime = NULL

AS --Encrypt

  /*
  || When     Who Rel    What
  || 08/17/09 MFT 10.507 Added optional logic to create/drop temp table
  || 09/11/09 MFT 10.510 Fixed optional logic to create/drop temp table
  || 09/14/09 GWG 10.510 Reverse internal create of temp table
  || 08/17/11 MFT 10.547 Added @MustInclude param & logic (119120)
  || 03/16/12 RLB 10.554 (137312) added some protection to make sure we are finding the right time period for @MustInclude
  */

DECLARE
	@TimeSheetPeriod smallint,
	@StartTimeOn smallint,
	@BeginDate smalldatetime,
	@EndDate smalldatetime,
	@EndLoop smalldatetime,
	@FirstPeriodDate smalldatetime,
	@Interval int,
	@DayOfWeek smallint,
	@StartInterval smallint,
	@Day int,
	@BeginPeriod smalldatetime,
	@EndPeriod smalldatetime,
	@Month int,
	@Year int,
	@LoopNum int,
	@CurDate smalldatetime
 
SELECT @TimeSheetPeriod = TimeSheetPeriod, @StartTimeOn = StartTimeOn
FROM tTimeOption (nolock)
WHERE CompanyKey = @CompanyKey

Select @CurDate = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
Select @EndLoop = DATEADD(m,2,GETDATE())
IF @MustInclude IS NOT NULL AND @MustInclude > @EndLoop
	SELECT @EndLoop = @MustInclude

--Begin Date is 2 months previous
IF @TimeSheetPeriod = 1
	BEGIN
		IF @LowerRange >= 7
			SELECT @LowerRange = @LowerRange -5

		SELECT @BeginDate = DATEADD(m,-@LowerRange,@CurDate)
		IF @MustInclude IS NOT NULL AND @MustInclude < @BeginDate
			SELECT @BeginDate = DATEADD(d,-1,@MustInclude)
		SELECT @DayOfWeek = DATEPART(dw,@BeginDate)
		Select @LoopNum = 4
	END
ELSE IF @TimeSheetPeriod = 3
	BEGIN
		
		Declare @BegYear smalldatetime, @BegDayOfWeek int
		Select @BegYear = Cast('1/1/' + Cast(DatePart(yyyy, @CurDate) as varchar) as smalldatetime)
		SELECT @BeginDate = DATEADD(m,-@LowerRange,@CurDate)
		IF @MustInclude IS NOT NULL AND @MustInclude < @BeginDate
			SELECT @BeginDate = DATEADD(d, -15,@MustInclude)
		
		IF @BeginDate < @BegYear
			Select @BegYear = DateAdd(yy, -1, @BegYear)

		Select @BeginDate = @BegYear	
	
		IF @StartTimeOn > 7
			Select @BeginDate = DATEADD(d, 7, @BeginDate)

		SELECT @DayOfWeek = DATEPART(dw,@BeginDate)
		Select @LoopNum = 9
	END
ELSE
	BEGIN
		SELECT @BeginDate = DATEADD(m,-@LowerRange,@CurDate)
		IF @MustInclude IS NOT NULL AND @MustInclude < @BeginDate
			SELECT @BeginDate = DATEADD(d,-7,@MustInclude)
		SELECT @DayOfWeek = DATEPART(dw,@BeginDate)
		Select @LoopNum = 9
	END
 
IF @TimeSheetPeriod = 1 --Daily
	BEGIN
		SELECT @StartInterval = 0
		SELECT @Interval = 0
	END

IF (@TimeSheetPeriod = 2) --Weekly
	BEGIN
		IF @DayOfWeek <= @StartTimeOn
			SELECT @StartInterval = (@StartTimeOn - @DayOfWeek)
		ELSE
			SELECT @StartInterval = (7 - (@DayOfWeek - @StartTimeOn))

		SELECT @Interval = 6
	END

IF (@TimeSheetPeriod = 3) -- Bi Weekly
	BEGIN
		IF @DayOfWeek <= @StartTimeOn
			SELECT @StartInterval = (@StartTimeOn - @DayOfWeek)
		ELSE
			SELECT @StartInterval = (7 - (@DayOfWeek - @StartTimeOn))

		SELECT @Interval = 13

	END

IF @TimeSheetPeriod = 4 --Semi-Monthly
	BEGIN
		SELECT @Interval = 15 --Not real interval
		SELECT @Day = DATEPART(d,@CurDate)
		IF @Day < 15
			SELECT @StartInterval = 1 - @Day
		ELSE
			SELECT @StartInterval = 15 - @Day     
	END

IF @TimeSheetPeriod = 5 --Monthly
	BEGIN
		SELECT @Interval = 30 --Not real interval
		SELECT @Day = DATEPART(d,@CurDate)
		SELECT @StartInterval = 1 - @Day
	END

SELECT @FirstPeriodDate = DATEADD(d,@StartInterval,@BeginDate)
SELECT @BeginPeriod = @FirstPeriodDate
--Loop for 4 months
--WHILE DATEDIFF(m,@FirstPeriodDate,@BeginPeriod) <= @LoopNum
WHILE @BeginPeriod < @EndLoop
	BEGIN
		IF @Interval = 15 --Semi-Monthly
			BEGIN
				SELECT @Day = DATEPART(d,@BeginPeriod)
				IF @Day = 1
					SELECT @EndPeriod = DATEADD(d,14,@BeginPeriod)
				ELSE
					BEGIN
						SELECT @Month = DATEPART(m,@BeginPeriod)
						SELECT @Year = DATEPART(yy,@BeginPeriod)
						IF @Month = 12
							BEGIN
								SELECT @Month = 1
								SELECT @Year = @Year + 1
							END
						ELSE
							SELECT @Month = @Month + 1
						
						SELECT @EndPeriod = DATEADD(d,-1,CAST(CAST(@Month AS char(2)) + '/1/' + CAST(@Year AS char(4)) AS smalldatetime))
					END
			END
		ELSE IF @Interval = 30 --Monthly
			BEGIN
				SELECT @Month = DATEPART(m,@BeginPeriod)
				SELECT @Year = DATEPART(yy,@BeginPeriod)
				IF @Month = 12
					BEGIN
						SELECT @Month = 1
						SELECT @Year = @Year + 1
					END
				ELSE
					SELECT @Month = @Month + 1

				SELECT @EndPeriod = DATEADD(d,-1,CAST(CAST(@Month AS char(2)) + '/1/' + CAST(@Year AS char(4)) AS smalldatetime))
			END
		ELSE --Everything else
			SELECT @EndPeriod = DATEADD(d,@Interval,@BeginPeriod)

		--Insert into Temp Table
		INSERT #TimePeriods(BeginPeriod, EndPeriod)
		VALUES(@BeginPeriod, @EndPeriod)

		--Increment BeginPeriod
		SELECT @BeginPeriod = DATEADD(d,1,@EndPeriod)
	END

--Note periods that have already been created
UPDATE #TimePeriods
SET  AlreadyCreated = 'Exists'
FROM tTimeSheet ts (nolock)
WHERE ts.UserKey = @UserKey
AND BeginPeriod <= EndDate and EndPeriod >= StartDate

SELECT BeginPeriod, EndPeriod, ltrim(rtrim(isnull(AlreadyCreated, ''))) as AlreadyCreated
FROM #TimePeriods
GO
