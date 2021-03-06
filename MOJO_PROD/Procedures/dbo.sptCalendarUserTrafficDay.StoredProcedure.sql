USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUserTrafficDay]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUserTrafficDay]

	 @StartDate smalldatetime
	,@NumDays int
	,@UserKey int			-- By User
	,@CompanyKey int		-- Or By Company if @UserKey is null
		
AS --Encrypt

/*
|| When     Who Rel	    What
|| 06/03/08 GHL 8.512 Added fields EventEnd, Subject, Hide, Organizer to make it similar to 
||                    sptCalendarUserTrafficDetails with the difference that it 
||                    can be used with a date range
*/

	if @UserKey is null
		select 
			c.CalendarKey
			,c.Subject
			,c.EventStart 
			,c.EventEnd 
			,round(isnull(datediff(mi,c.EventStart,c.EventEnd),0) / 60.0,2) as TotalHours
			,ca.EntityKey as UserKey
			,u.TimeZoneIndex
			,u_org.FirstName + ' ' + u_org.LastName as Organizer
			,0 AS Hide 
		from tCalendar c (nolock) 
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey
		inner join tUser u (nolock) on ca.EntityKey = u.UserKey
		inner join tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey
			and ca2.Entity = 'Organizer'
		inner join tUser u_org (nolock) on ca2.EntityKey = u_org.UserKey
		where isnull(c.BlockOutOnSchedule,0) = 1
		and c.CompanyKey = @CompanyKey
		--and c.CalendarTypeKey = 1 -- personal calendars
		and c.EventLevel = 1 -- personal events
		and c.EventStart between dateadd("d",-1,@StartDate) and dateadd("d",@NumDays+2,@StartDate) -- due to variations in time zone, get events from the day before through midnight of the day after
		and (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
		and (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined yet
		and c.AllDayEvent = 0
		
	else
		select 
			c.CalendarKey
			,c.Subject
			,c.EventStart 
			,c.EventEnd 
			,round(isnull(datediff(mi,c.EventStart,c.EventEnd),0) / 60.0,2) as TotalHours
			,ca.EntityKey as UserKey
			,u.TimeZoneIndex 
			,u_org.FirstName + ' ' + u_org.LastName as Organizer			
			,0 AS Hide 
		from tCalendar c (nolock) inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey
		inner join tUser u (nolock) on ca.EntityKey = u.UserKey
		inner join tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey
			and ca2.Entity = 'Organizer'
		inner join tUser u_org (nolock) on ca2.EntityKey = u_org.UserKey
		where isnull(c.BlockOutOnSchedule,0) = 1
		--and c.CalendarTypeKey = 1 -- personal calendars
		and c.EventLevel = 1 -- personal events
		and c.EventStart between dateadd("d",-1,@StartDate) and dateadd("d",@NumDays+2,@StartDate) -- due to variations in time zone, get events from the day before through midnight of the day after
		and (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
		and (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined
		and ca.EntityKey = @UserKey
		and c.AllDayEvent = 0
			
	return 1
GO
