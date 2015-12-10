USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetEventTimes]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetEventTimes]
	@CalendarKey int

AS --Encrypt

	SELECT EventStart,EventEnd
	FROM tCalendar (nolock)
	WHERE
			CalendarKey = @CalendarKey

	RETURN 1
GO
