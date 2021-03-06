USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarTypeDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarTypeDelete]
	@CalendarTypeKey int

AS --Encrypt

	Update tCalendar Set CalendarTypeKey = NULL 
	Where CalendarTypeKey = @CalendarTypeKey 

	DELETE
	FROM tCalendarType
	WHERE
		CalendarTypeKey = @CalendarTypeKey 

	RETURN 1
GO
