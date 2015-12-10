USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarAttendeeDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarAttendeeDelete]
	@CalendarKey int,
	@CalendarAttendeeKey int
AS --Encrypt

	delete	tCalendarAttendeeGroup
	where	CalendarKey = 	@CalendarKey  	
	and		CalendarAttendeeKey = @CalendarAttendeeKey 

	delete	tCalendarAttendee
	where	CalendarKey = 	@CalendarKey  	
	and		CalendarAttendeeKey = @CalendarAttendeeKey
GO
