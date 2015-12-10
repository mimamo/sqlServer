USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarMonthGetDays]    Script Date: 12/10/2015 10:54:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCalendarMonthGetDays]
	@Month	INTEGER
	,@Year	INTEGER
AS --Encrypt
	/*
	CREATE TABLE #tDays(
				 WeekNo	INT NULL
				,MonthNo	INT NULL
				,DayNo	INT NULL
				,Date	DATETIME NULL) 
	*/		
	DECLARE @Date VARCHAR(10)
	       ,@WeekDay VARCHAR(20)
				 ,@FirstDay DATETIME
				 ,@LastDay DATETIME
	
	TRUNCATE TABLE #tDays
	
	-- Get first day of the month			 	       
	SELECT @Date = CONVERT(VARCHAR(2),@Month)+'/1/'+CONVERT(VARCHAR(4),@Year)
	SELECT @WeekDay = DATEPART(weekday, @Date)
	
	IF @WeekDay = 1
		SELECT @FirstDay = @Date
	ELSE IF @WeekDay = 2
		SELECT @FirstDay = DATEADD(day, -1, @Date)
	ELSE IF @WeekDay = 3
		SELECT @FirstDay = DATEADD(day, -2, @Date)
	ELSE IF @WeekDay = 4
		SELECT @FirstDay = DATEADD(day, -3, @Date)
	ELSE IF @WeekDay = 5
		SELECT @FirstDay = DATEADD(day, -4, @Date)
	ELSE IF @WeekDay = 6
		SELECT @FirstDay = DATEADD(day, -5, @Date)
	ELSE IF @WeekDay = 7
		SELECT @FirstDay = DATEADD(day, -6, @Date)
		
	-- Get last day of the month
	IF @Month < 12 			 	       
		SELECT @Date = CONVERT(VARCHAR(2),@Month + 1)+'/1/'+CONVERT(VARCHAR(4),@Year)
	ELSE
		SELECT @Date = '1/1/'+CONVERT(VARCHAR(4), @Year + 1)
	
	SELECT @LastDay = DATEADD(day, -1, @Date)
	SELECT @WeekDay = DATEPART(weekday, @LastDay)
	
	IF @WeekDay = 1
		SELECT @LastDay = DATEADD(day, 6, @LastDay)
	ELSE IF @WeekDay = 2
		SELECT @LastDay = DATEADD(day, 5, @LastDay)
	ELSE IF @WeekDay = 3
		SELECT @LastDay = DATEADD(day, 4, @LastDay)
	ELSE IF @WeekDay = 4
		SELECT @LastDay = DATEADD(day, 3, @LastDay)
	ELSE IF @WeekDay = 5
		SELECT @LastDay = DATEADD(day, 2, @LastDay)
	ELSE IF @WeekDay = 6
		SELECT @LastDay = DATEADD(day, 1, @LastDay)
	
	DECLARE @CurrDay DATETIME
			   ,@Week INT
			   
	SELECT @CurrDay = @FirstDay
	WHILE (@CurrDay <= @LastDay)
	BEGIN
		-- We may have problems with partial week in December
		SELECT @Week = DATEPART(week, @CurrDay)

		IF @Month = 12 AND @Week < 25
			SELECT @Week = DATEPART(week, '12/31/' + CONVERT(VARCHAR(4), @Year))
	
		-- We may have problems with partial week in January
		IF @Month = 1 AND @Week > 25
			SELECT @Week = DATEPART(week, '1/1/'+ CONVERT(VARCHAR(4), @Year))
			 
		INSERT #tDays(
				 WeekNo
				,MonthNo
				,DayNo
				,Date)
		SELECT 
			@Week
			,DATEPART(month, @CurrDay)
			,DATEPART(day, @CurrDay)
			,@CurrDay
			
		SELECT @CurrDay = DATEADD(day, 1, @CurrDay)	
	END
	
	
	--SELECT * FROM #tDays
	
	
	/* set nocount on */
	return 1
GO
