USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetBlockOutOnSchedule]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetBlockOutOnSchedule]
	(
		@Entity varchar(50)
		,@EntityKey int
	)
AS -- Encrypt

  /*
  || When     Who Rel   What
  || 09/21/06 GHL 8.35  Added attendees to personal events 
  ||                    So that they show up in traffic for attendees as well  (Bug 6573 Gig Productions)
  || 11/10/09 GWG 10.513 Modified the queries to conform to the new get style for blockouts. 
  */
	
	SET NOCOUNT ON
	
	IF @Entity = 'Company'
	BEGIN
		-- First take all COMPANY events 
		SELECT c.*
			  ,-1 As UserKey	
			  ,u.TimeZoneIndex
		FROM   tCalendar c (NOLOCK)
			INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey and ca.Entity = 'Organizer'
			INNER JOIN tUser u (nolock) on ca.EntityKey = u.UserKey
			INNER JOIN tCMFolder f (nolock) ON f.CMFolderKey = c.CMFolderKey
		WHERE  c.CompanyKey = @EntityKey
		AND    f.UserKey = 0
		AND    BlockOutOnSchedule = 1
		AND    u.Active = 1		-- So that inactive users do not affect other users schedule
		AND    c.AllDayEvent = 1
		AND    isnull(c.Deleted,0) = 0
		AND	   ISNULL(f.BlockoutAttendees, 0) = 0 --These are regular public calendars where they have selected BlockOutOnSchedule
	END
	ELSE
	BEGIN		

		-- Then take all USER events starting at current date
		SELECT c.*, u.UserKey
				  ,(Select u_org.TimeZoneIndex 
						From tCalendarAttendee ca_org (NOLOCK)
						INNER JOIN tUser u_org (NOLOCK) ON ca_org.EntityKey = u_org.UserKey
					WHERE ca_org.CalendarKey = c.CalendarKey
					AND   ca_org.Entity = 'Organizer'	
					) AS TimeZoneIndex
		FROM   tCalendar c (NOLOCK)
			INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey 
			INNER JOIN tUser u (nolock) on ca.EntityKey = u.UserKey
			INNER JOIN tCMFolder f (nolock) ON f.CMFolderKey = ca.CMFolderKey
		WHERE  ca.EntityKey = @EntityKey
		AND    f.UserKey > 0
		AND    c.BlockOutOnSchedule = 1
		AND    c.AllDayEvent = 1
		AND	   (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
		AND    (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet
		AND    isnull(c.Deleted,0) = 0	

		UNION ALL

		-- Include any events from Public calendars where BlockoutAttendees is set (only for the Attendee of the event).
		SELECT c.*, u.UserKey
				  ,(Select u_org.TimeZoneIndex 
						From tCalendarAttendee ca_org (NOLOCK)
						INNER JOIN tUser u_org (NOLOCK) ON ca_org.EntityKey = u_org.UserKey
					WHERE ca_org.CalendarKey = c.CalendarKey
					AND   ca_org.Entity = 'Organizer'	
					) AS TimeZoneIndex
		FROM   tCalendar c (NOLOCK)
			INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey 
			INNER JOIN tUser u (nolock) on ca.EntityKey = u.UserKey
			INNER JOIN tCMFolder f (nolock) ON f.CMFolderKey = c.CMFolderKey
		WHERE  ca.EntityKey = @EntityKey
		AND    f.UserKey = 0
		AND    f.BlockoutAttendees = 1
		AND    c.AllDayEvent = 1
		AND	   (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
		AND    (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet
		AND    isnull(c.Deleted,0) = 0
	
	END
	
	RETURN 1
GO
