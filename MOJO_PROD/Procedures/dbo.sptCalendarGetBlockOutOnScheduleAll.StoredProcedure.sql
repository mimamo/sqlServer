USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetBlockOutOnScheduleAll]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetBlockOutOnScheduleAll]
	(
		@CompanyKey VARCHAR(50)
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 03/14/06 GHL wmj   Creation for wmj traffic screens  
  ||                    1) Returns calendar events for company and users with BlockOnSchedule = 1, AllDayEvent = 1 
  ||                    Company events affect task scheduling logic
  ||                    User events do not affect task scheduling logic but affect hours display on traffic screen
  ||                    Go back 6 months earlier, that should be enough to handle traffic displays
  ||					2) Then convert UTC to regular dates in VB
  ||                    3) Then send to flash data like:
  ||						 20081225, -1, 'Company Christmas Vacation'
  ||						 20090205, 236, 'Time off for Mike'    
  ||					Subject will be used for hints     
  || 11/19/08 GHL  10.013 (40341) Traffic screen does not display user time off when event starts yesterday
  ||                     I am pretty sure that I was taking events 6 months earlier
  ||                     OK, let's take 1 month earlier then   
  || 6/12/09  CRG  10.5.0.0 Fixed join for personal block out days 
  || 7/1/09   RLB  10.5.0.2 only pulling calendar events that are not deleted.          
  */
  
	Declare @StartDate As Datetime
	Select @StartDate = GetDate()  
	Select @StartDate = DATEADD(m, -1, @StartDate) -- go back 1 month earlier
 
	-- First take all COMPANY events 
	SELECT c.*
		  ,-1 As UserKey	
		  ,u.TimeZoneIndex
	FROM   tCalendar c (NOLOCK)
		INNER JOIN tCalendarAttendee ca (NOLOCK) ON c.CalendarKey = ca.CalendarKey and ca.Entity = 'Organizer'
		INNER JOIN tUser u (nolock) on ca.EntityKey = u.UserKey
		INNER JOIN tCMFolder f (nolock) ON f.CMFolderKey = c.CMFolderKey
	WHERE  c.CompanyKey = @CompanyKey
	AND    f.UserKey = 0
	AND    BlockOutOnSchedule = 1
	AND    u.Active = 1		-- So that inactive users do not affect other users schedule
	AND    c.AllDayEvent = 1
	AND    isnull(c.Deleted,0) = 0
	AND	   ISNULL(f.BlockoutAttendees, 0) = 0 --These are regular public calendars where they have selected BlockOutOnSchedule

UNION ALL

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
	WHERE  c.CompanyKey = @CompanyKey
	AND    f.UserKey > 0
	AND    c.BlockOutOnSchedule = 1
	AND    c.AllDayEvent = 1
	AND    c.EventStart > dateadd("d",-1,@StartDate)  -- due to variations in time zone, get events from the day before 
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
	WHERE  c.CompanyKey = @CompanyKey
	AND    f.UserKey = 0
	AND    f.BlockoutAttendees = 1
	AND    c.AllDayEvent = 1
	AND    c.EventStart > dateadd("d",-1,@StartDate)  -- due to variations in time zone, get events from the day before 
	AND	   (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
	AND    (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet
	AND    isnull(c.Deleted,0) = 0
GO
