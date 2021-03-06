USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCalendarManagerGetEventBySubjectDate]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCalendarManagerGetEventBySubjectDate]
	@CompanyKey int,
	@UserKey int,
	@CMFolderKey int,
	@Subject varchar(100),
	@EventStart smalldatetime,
	@EventEnd smalldatetime
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 04/07/14  KMC 10.5.7.9 Created to check and see if an event already existed with the same subject and date/time for the
||                        same user.
*/

	DECLARE @CalendarKey int

	SELECT @CalendarKey = MIN(c.CalendarKey)
	  FROM tCalendar c (nolock)
	LEFT JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey
	 WHERE c.CompanyKey = @CompanyKey
	   AND (@CMFolderKey IS NULL
		    OR c.CMFolderKey = @CMFolderKey
		    OR ca.CMFolderKey = @CMFolderKey)
	   AND c.Subject = @Subject
	   AND c.EventStart = @EventStart
	   AND c.EventEnd = @EventEnd
	   
	RETURN @CalendarKey
GO
