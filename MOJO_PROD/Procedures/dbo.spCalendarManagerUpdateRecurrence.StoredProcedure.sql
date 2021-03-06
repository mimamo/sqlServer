USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerUpdateRecurrence]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerUpdateRecurrence]
	@CalendarKey int,
	@UserKey int,
	@Recurring tinyint,
	@RecurringEndType varchar(50),
	@RecurringCount int,
	@RecurringEndDate smalldatetime,
	@Freq varchar(25),
	@Interval int,
	@BySetPos int,
	@ByMonthDay int,
	@ByMonth int,
	@Su int,
	@Mo int,
	@Tu int,
	@We int,
	@Th int,
	@Fr int,
	@Sa int,
	@Application varchar(50)
AS --Encrypt

/*
|| When     Who Rel      What
|| 4/23/09  CRG 10.5.0.0 Created for the mobile calendar recurrence page
*/

	DECLARE @Parms varchar(500)
	
	SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
	EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'spCalendarManagerUpdate', @Parms, @Application

	UPDATE	tCalendar
	SET		Recurring = @Recurring,
			RecurringEndType = @RecurringEndType,
			RecurringCount = @RecurringCount,
			RecurringEndDate = @RecurringEndDate,
			Freq = @Freq,
			Interval = @Interval,
			BySetPos = @BySetPos,
			ByMonthDay = @ByMonthDay,
			ByMonth = @ByMonth,
			Su = @Su,
			Mo = @Mo,
			Tu = @Tu,
			We = @We,
			Th = @Th,
			Fr = @Fr,
			Sa = @Sa
	WHERE	CalendarKey = @CalendarKey 

	--Increment the Sequence number
	EXEC sptCalendarIncrementSequence @CalendarKey
GO
