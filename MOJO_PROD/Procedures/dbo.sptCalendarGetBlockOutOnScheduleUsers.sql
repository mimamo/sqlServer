USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetBlockOutOnScheduleUsers]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetBlockOutOnScheduleUsers]
	(
		@CompanyKey VARCHAR(50)
		,@StartDate DATETIME
	)
AS -- Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 09/20/06 GHL 8.4   Creation for traffic screens (especially in flash) 
  ||                    Returns a list of personal days off for certain users and date range
  ||                    Not intended for scheduling logic  
  */

	-- Assume done in VB
	-- CREATE TABLE #tUser (UserKey int null) 
	
	SELECT c.*, u.UserKey
		      ,(Select u_org.TimeZoneIndex 
					From tCalendarAttendee ca_org (NOLOCK)
					INNER JOIN tUser u_org (NOLOCK) ON ca_org.EntityKey = u_org.UserKey
				WHERE ca_org.CalendarKey = c.CalendarKey
				AND   ca_org.Entity = 'Organizer'	
		        ) AS TimeZoneIndex
	FROM   tCalendar c (NOLOCK)
		INNER JOIN tCalendarAttendee ca (NOLOCK) 
			ON c.CalendarKey = ca.CalendarKey 
		INNER JOIN tUser u (nolock) on ca.EntityKey = u.UserKey
		INNER JOIN #tUser tu (NOLOCK) on ca.EntityKey = tu.UserKey
	WHERE  c.CompanyKey = @CompanyKey
	AND    c.EventLevel = 1
	AND    c.BlockOutOnSchedule = 1
	AND    c.AllDayEvent = 1
	AND    c.EventStart > dateadd("d",-1,@StartDate)  -- due to variations in time zone, get events from the day before 
	AND	   (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
	AND    (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet	
	
	RETURN 1
GO
