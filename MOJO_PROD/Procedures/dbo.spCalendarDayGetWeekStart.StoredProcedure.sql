USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarDayGetWeekStart]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spCalendarDayGetWeekStart]
	(
		@Date VARCHAR(10)
	)

AS --Encrypt

	DECLARE @WeekDay INT
					,@WeekStart DATETIME
	
	SELECT @WeekDay = DATEPART(Weekday, @Date)
	
	IF @WeekDay = 1
		SELECT @WeekStart = @Date
	ELSE IF @WeekDay = 2
		SELECT @WeekStart = DATEADD(day, -1, @Date)
	ELSE IF @WeekDay = 3
		SELECT @WeekStart = DATEADD(day, -2, @Date)
	ELSE IF @WeekDay = 4
		SELECT @WeekStart = DATEADD(day, -3, @Date)
	ELSE IF @WeekDay = 5
		SELECT @WeekStart = DATEADD(day, -4, @Date)
	ELSE IF @WeekDay = 6
		SELECT @WeekStart = DATEADD(day, -5, @Date)
	ELSE IF @WeekDay = 7
		SELECT @WeekStart = DATEADD(day, -6, @Date)
	
	SELECT @WeekStart AS WeekStart
	
	/* set nocount on */
	return 1
GO
