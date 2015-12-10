USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUpdateAttendeeStatus]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUpdateAttendeeStatus]
	@CalendarKey int,
	@UserKey int,
	@Comments varchar(500),
	@Status int
	
AS --Encrypt

/*
|| When     Who Rel      What
|| 10/09/09 MFT 10.5.1.2 Added 'Organizer' entity
|| 11/27/12 CRG 10.5.6.2 Now updating the DateUpdated on tCalendar after the attendee record has been modified.
||  9/05/13 KMC 10.5.7.1 (189075) Updated the Sequence number in tCalendar so iCalendar/CalDAV gets updated
*/
 
IF @Status > 0
	UPDATE
		tCalendarAttendee
	SET
		Status = @Status,
		Comments = @Comments	
	WHERE
		CalendarKey = @CalendarKey
		and 
		EntityKey = @UserKey
		and
		Entity IN ('Organizer', 'Attendee')
ELSE
	UPDATE
		tCalendarAttendee
	SET
		Comments = @Comments	
	WHERE
		CalendarKey = @CalendarKey
		and 
		EntityKey = @UserKey 
		and
		Entity IN ('Organizer', 'Attendee')

UPDATE	tCalendar
SET		DateUpdated = GETUTCDATE(), Sequence = ISNULL(Sequence, 0) + 1
WHERE	CalendarKey = @CalendarKey

RETURN 1
GO
