USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetRemindersAttendees]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetRemindersAttendees]

	(
		@StartDate datetime,
		@EndDate datetime
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 2/1/07   CRG 8.4.0.3  Added extra clause to remove Entity 'Group' as well. 
|| 4/29/09  CRG 10.5.0.0 Added restriction to only get users who want to receive Email reminders for the Task Manager reminders
|| 6/22/10  gwg 10.5.3.0 changed the join to tCompany to a left join because a contact may not have a company
|| 12/20/10 CRG 10.5.3.9 Now restricting to only active attendees
*/

SELECT 
	c.CalendarKey,
	ca.EntityKey, 
        tUser.FirstName + ' ' + tUser.LastName AS UserFullName,
        tUser.Email,
        tUser.FirstName,
        tUser.LastName,
        tUser.TimeZoneIndex
FROM	
	tCalendarAttendee ca (nolock)
	INNER JOIN tUser (NOLOCK) ON ca.EntityKey = tUser.UserKey 
	LEFT OUTER JOIN tCompany (NOLOCK) ON tUser.CompanyKey = tCompany.CompanyKey
	INNER JOIN tCalendar c (NOLOCK) on ca.CalendarKey = c.CalendarKey
	INNER JOIN tCompany co (nolock) on c.CompanyKey = co.CompanyKey
	INNER JOIN tCalendarAttendee ca2 (nolock) on ca2.CalendarKey = c.CalendarKey and ca2.Entity = 'Organizer'
	INNER Join tUser u2 (nolock) on ca2.EntityKey = u2.UserKey
WHERE 
	((DateAdd("n", -1 * c.ReminderTime, c.EventStart) > @StartDate and DateAdd("n", -1 * c.ReminderTime, c.EventStart) <= @EndDate ) or (c.Recurring =1 ))
	and c.ReminderTime > 0 
	and ca.Entity <> 'Resource'
	and ca.Entity <> 'Group'
	and ca.Status <> 3
	and u2.Active = 1 -- organizer
	and co.Locked = 0
	AND (ISNULL(tUser.CalendarReminder, 0) = 0 OR tUser.CalendarReminder = 1) --Reminder option for the user is Both or Email Only
	AND tUser.Active = 1 --attendee
ORDER BY 
	tCompany.CompanyName, tUser.LastName
GO
