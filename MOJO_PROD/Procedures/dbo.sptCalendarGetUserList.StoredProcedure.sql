USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetUserList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetUserList]

	(
		@UserKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime
	)

AS --Encrypt

Declare @CompanyKey int, @TimeZoneIndex int

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey), @TimeZoneIndex = TimeZoneIndex from tUser Where UserKey = @UserKey

Select  distinct 
	c.CalendarKey,
	c.EventLevel,
	c.Subject,
	@TimeZoneIndex as TimeZoneIndex,
	c.Description,
	c.Location,
	c.EventStart,
	c.EventEnd,
	c.ProjectKey,
	c.CompanyKey,
	c.ShowTimeAs,
	c.Visibility,
	c.Recurring,
	c.RecurringSettings,
	c.RecurringEndType,
	c.RecurringCount,
	c.RecurringEndDate,
	c.OriginalStart,
	c.ParentKey,
	c.ReminderTime,
	c.ContactCompanyKey,
	c.ContactUserKey,
	c.ContactLeadKey,
	c.CalendarTypeKey,
	c.ReminderSent,
	c.Pattern,
	c.Deleted



from tCalendar c (nolock) 

Where 
c.CalendarKey in (

	Select c2.CalendarKey from 
	tCalendar c2 (nolock) inner join tCalendarAttendee ca (nolock) on c2.CalendarKey = ca.CalendarKey
	Where ((c2.EventEnd > @StartDate
	AND c2.EventStart < @EndDate ) or Recurring = 1)
	and ca.EntityKey = @UserKey 
	and ca.Status <> 3
	and ca.Entity in ( 'Organizer', 'Attendee')
)

or

(

c.CalendarKey in (
	Select c2.CalendarKey from 
	tCalendar c2 (nolock)
	Where ((c2.EventEnd > @StartDate
	AND c2.EventStart < @EndDate  ) or Recurring = 1)
	and c2.CompanyKey = @CompanyKey 
	and Visibility = 1
	and EventLevel = 3)
)

or

(

c.CalendarKey in (
	Select c2.CalendarKey from 
	tCalendar c2 (nolock) inner join tProject p (nolock) on c2.ProjectKey = p.ProjectKey
	inner join tAssignment a (nolock) on p.ProjectKey = a.ProjectKey
	Where ((c2.EventEnd > @StartDate
	AND c2.EventStart < @EndDate  ) or Recurring = 1)
	and a.UserKey = @UserKey
	and Visibility = 1
	and EventLevel = 2)
)

Order By EventStart
GO
