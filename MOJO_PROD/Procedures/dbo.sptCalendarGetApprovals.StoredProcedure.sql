USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetApprovals]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetApprovals]

	@CompanyKey int,
	@UserKey int,
	@OnlyMine tinyint
		

AS --Encrypt

if @OnlyMine = 1
		SELECT distinct c.*, u.UserKey, u.FirstName + ' ' + u.LastName as Attendee
		,(SELECT u2.TimeZoneIndex
		  FROM   tCalendarAttendee ca2 (nolock)
			INNER JOIN tUser u2 (nolock) ON ca2.EntityKey = u2.UserKey AND ca2.Entity = 'Organizer'  
			WHERE ca2.CalendarKey = c.CalendarKey
		 ) AS TimeZoneIndex 	-- needed to determine date of all day events for attendees 
		FROM tCalendar c (nolock), tCalendarAttendee ca (nolock), tUser u (nolock)
		WHERE c.CompanyKey = @CompanyKey
		and ca.Entity <> 'Resource' 
		and ca.Entity <> 'Group'
		and ca.EntityKey = u.UserKey
		and c.CalendarKey = ca.CalendarKey
		and ca.Status = 1
		and c.Deleted <> 1
		and ca.EntityKey = @UserKey
		and c.EventStart >= GETUTCDATE()
		Order By c.EventStart
else
		SELECT distinct c.*, u.UserKey, u.FirstName + ' ' + u.LastName as Attendee
		,(SELECT u2.TimeZoneIndex
		  FROM   tCalendarAttendee ca2 (nolock)
			INNER JOIN tUser u2 (nolock) ON ca2.EntityKey = u2.UserKey AND ca2.Entity = 'Organizer'  
			WHERE ca2.CalendarKey = c.CalendarKey
		 ) AS TimeZoneIndex 	-- needed to determine date of all day events for attendees 
		FROM tCalendar c (nolock), tCalendarAttendee ca (nolock), tUser u (nolock)
		WHERE c.CompanyKey = @CompanyKey
		and ca.Entity <> 'Resource' 
		and ca.Entity <> 'Group'
		and ca.EntityKey = u.UserKey
		and c.CalendarKey = ca.CalendarKey
		and ca.Status = 1
		and c.Deleted <> 1
		and (ca.EntityKey = @UserKey or ca.EntityKey in (Select UserKey from tCalendarUser (nolock) Where CalendarUserKey = @UserKey and AccessType = 2))
		and c.EventStart >= GETUTCDATE()
		Order By c.EventStart
	RETURN 1
GO
