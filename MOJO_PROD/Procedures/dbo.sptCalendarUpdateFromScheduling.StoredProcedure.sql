USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateFromScheduling]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUpdateFromScheduling]
	@CalendarKey int,
	@OrganizerKey int,
	@Visibility int,
	@EventStart smalldatetime,
	@EventEnd smalldatetime,
	@UserKey int,
	@Application varchar(50)
	
AS --Encrypt

/*
|| When     Who Rel      What
|| 12/21/06 CRG 8.4      Added a call to sptCalendarIncrementSequence (needed for .ics files)
|| 4/1/09   CRG 10.5.0.0 Added UserKey and Application and added call to sptCalendarUpdateLogInsert
*/

-- Call the following SP to make sure that organizer will be correctly removed from attendees from dist groups
EXEC sptCalendarAttendeeInsert @CalendarKey, @OrganizerKey, 'Organizer', 2

DECLARE @Parms varchar(500)
SELECT @Parms = '@CalendarKey=' + Convert(varchar(7), @CalendarKey)
EXEC sptCalendarUpdateLogInsert @CalendarKey, @UserKey, 'U', 'sptCalendarUpdateFromScheduling', @Parms, @Application
 
UPDATE tCalendar
SET    Visibility = @Visibility
	  ,EventStart = @EventStart
	  ,EventEnd = @EventEnd
WHERE CalendarKey = @CalendarKey

--Increment the Sequence number
EXEC sptCalendarIncrementSequence @CalendarKey

RETURN 1
GO
