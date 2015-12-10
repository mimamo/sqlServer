USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetAccepted]    Script Date: 12/10/2015 10:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetAccepted]
	@CalendarKey int,
	@UserKey int

AS --Encrypt

	SELECT *
	FROM tCalendarAttendee (NOLOCK)
	WHERE
		CalendarKey = @CalendarKey AND
		EntityKey = @UserKey AND
		Entity IN ('Organizer', 'Attendee')		

	RETURN 1
GO
