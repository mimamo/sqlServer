USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarUserTrafficDetails]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarUserTrafficDetails]

	 @UserKey int
	,@Date smalldatetime
		
AS --Encrypt

/*
|| When     Who Rel	    What
|| 1/26/07  CRG 8.4.0.2 Changed the DateDiff to calculate in minutes rather than hours so that duration less than an
||                      hour will display.
|| 2/1/07   CRG 8.4.0.3 Removed restriction on CalendarTypeKey = 1
*/

	select c.Subject
			,c.EventStart
			,c.EventEnd
			,c.Description
			,round(isnull(datediff("mi",c.EventStart,c.EventEnd)/ 60.0,0),2) as Duration
			,u.FirstName + ' ' + u.LastName as Organizer
			,u.TimeZoneIndex
			,0 as Hide
	from tCalendar c (nolock) inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey
	inner join tCalendarAttendee ca2 (nolock) on c.CalendarKey = ca2.CalendarKey
	inner join tUser u (nolock) on ca2.EntityKey = u.UserKey
	
	where isnull(c.BlockOutOnSchedule,0) = 1
	and c.EventLevel = 1 -- personal events
	and c.EventStart between dateadd("d",-1,@Date) and dateadd("d",2,@Date) -- prior day midnight to next day midnight to handle time zone differences
	and (ca.Entity = 'Organizer' or ca.Entity = 'Attendee')
	and (ca.Status = 1 or ca.Status = 2)  -- attendee has not declined
	and ca.EntityKey = @UserKey
	and ca2.Entity = 'Organizer'
	
	order by c.EventStart
	
	return 1
GO
