USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateVisible]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  PROCEDURE [dbo].[sptCalendarUpdateVisible]
	@CalendarKey int,
	@Visible int 


AS --Encrypt


Update tCalendar set 
	Visibility = @Visible
where CalendarKey = @CalendarKey 


RETURN 1
GO
