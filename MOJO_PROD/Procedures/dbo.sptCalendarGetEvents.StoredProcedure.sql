USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetEvents]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   Procedure [dbo].[sptCalendarGetEvents]
	(
		@UserKey int,
		@CompanyKey int,
		@ProjectKey int,
		@StartDate as smalldatetime,
		@EndDate as smalldatetime,
		@LoggedUserKey int
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 3/29/07   CRG 8.4.1    (8306) Added ContactEmail  
|| 4/10/07   QMD 8.4.2    (8638) Added Project Color
|| 5/07/07   GHL 8.4.2    (9173) Added Distinct to subquery of tAssignment
|| 7/09/07   QMD 8.4.3.2  (9755) Added ISNULL for AllDayEvent
|| 3/25/08   QMD WMJ 1.0  Added IsAllDay flag because AllDayEvent gets filtered out on the server side code
|| 7/25/08   CRG 10.5.0.0 Removed RecurCount column and wrapped Visiblity with ISNULL
|| 11/4/08   CRG 10.5.0.0 Added the new Recurring columns for use by the Today's Meetings widget. 
||                        Also changing EventLevel from 0 to 1, because new events in 10.5 are saved with an EventLevel of 0.
|| 1/7/09    CRG 10.5.0.0 Added Private column for CMP90.
|| 1/8/09    CRG 10.5.0.0 Added the LoggedUserKey parameter so that we can determine if the logged user is an attendee of the event.
*/

if @ProjectKey > 0

Select Distinct 
	c.CalendarKey,
	c.Subject,
	c.Location,
	c.[Description],
	c.ProjectKey,
	c.CompanyKey,
	ISNULL(c.Visibility, 0) AS Visibility,
	c.Recurring,
	c.RecurringCount,
	c.ReminderTime,
	c.ContactCompanyKey,
	c.ContactUserKey,
	c.ContactLeadKey,
	c.CalendarTypeKey,
	c.ReminderSent,
	CASE c.EventLevel
		WHEN 0 THEN 1
		ELSE c.EventLevel
	END AS EventLevel,
	c.EventStart,
	c.EventEnd,
	c.ShowTimeAs,
	c.RecurringSettings,
	c.RecurringEndType,
	c.RecurringEndDate,
	c.OriginalStart,
	c.ParentKey,
	c.Pattern,
	c.Deleted,
	ISNULL(c.AllDayEvent,0) AS AllDayEvent,
	ISNULL(c.AllDayEvent,0) AS IsAllDay,
	c.BlockOutOnSchedule,
	c.DateUpdated,
	c.DateCreated,
	c.[Sequence],
	c.Freq,
	c.Interval,
	c.BySetPos,
	c.ByMonthDay,
	c.ByMonth,
	c.Su,
	c.Mo,
	c.Tu,
	c.We,
	c.Th,
	c.Fr,
	c.Sa,
	auth.FirstName + ' ' + auth.LastName as AuthorName,
	auth.Email as AuthorEmail,
	auth.TimeZoneIndex,
	ISNULL((Select Distinct 1 from tCalendarAttendee (nolock) where Entity in ( 'Organizer', 'Attendee') and EntityKey = @UserKey and Status <> 3 and tCalendarAttendee.CalendarKey = c.CalendarKey), 0) as IsAttendee,
	ISNULL((Select Distinct 1 from tCalendarAttendee (nolock) where Entity in ( 'Organizer', 'Attendee') and EntityKey = @LoggedUserKey and Status <> 3 and tCalendarAttendee.CalendarKey = c.CalendarKey), 0) as UserIsAttendee,
	1 as IsAssigned,
	cc.CompanyName,
	case When caddr.AddressKey is null then addr.Address1 else caddr.Address1 end as Address1,
	case When caddr.AddressKey is null then addr.Address2 else caddr.Address2 end as Address2,
	case When caddr.AddressKey is null then addr.Address3 else caddr.Address3 end as Address3,
	case When caddr.AddressKey is null then addr.City else caddr.City end as City,
	case When caddr.AddressKey is null then addr.State else caddr.State end as State,
	case When caddr.AddressKey is null then addr.PostalCode else caddr.PostalCode end as PostalCode,
	u.Email as ContactEmail,
	p.ProjectNumber,
	p.ProjectName,
	u.FirstName + ' ' + u.LastName as ContactName,
	ISNULL(u.Phone1, cc.Phone) as Phone,
	ISNULL(ct.TypeColor,p.ProjectColor) as TypeColor,
	ISNULL(ct.DisplayOrder, 9999999) as DisplayOrder,
	convert(char(8), c.EventStart, 108) as StartTime,
	convert(char(8), c.EventEnd, 108) as EndTime,
	c.Private
	FROM tCalendar c (nolock)
		inner join tAssignment a (nolock) on c.ProjectKey = a.ProjectKey
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey
		inner join tUser auth (nolock) on ca.EntityKey = auth.UserKey
		left outer join tCompany cc (nolock) on c.ContactCompanyKey = cc.CompanyKey
		left outer join tUser u (nolock) on c.ContactUserKey = u.UserKey
		left outer join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
		left outer join tProject p (nolock) on c.ProjectKey = p.ProjectKey
		left outer join tAddress addr (nolock) on cc.DefaultAddressKey = addr.AddressKey
		left outer join tAddress caddr (nolock) on u.AddressKey = caddr.AddressKey
	WHERE   
	((c.EventEnd >= @StartDate AND c.EventStart <= @EndDate) or (c.Recurring = 1) or (ParentKey > 0))
	AND c.CompanyKey = @CompanyKey
	AND c.ProjectKey = @ProjectKey
	AND a.UserKey = @UserKey
	and ca.Entity = 'Organizer'
	and auth.Active = 1
else

Select 
	distinct
	c.CalendarKey,
	c.Subject,
	c.Location,
	c.[Description],
	c.ProjectKey,
	c.CompanyKey,
	ISNULL(c.Visibility, 0) AS Visibility,
	c.Recurring,
	c.RecurringCount,
	c.ReminderTime,
	c.ContactCompanyKey,
	c.ContactUserKey,
	c.ContactLeadKey,
	c.CalendarTypeKey,
	c.ReminderSent,
	CASE c.EventLevel
		WHEN 0 THEN 1
		ELSE c.EventLevel
	END AS EventLevel,
	c.EventStart,
	c.EventEnd,
	c.ShowTimeAs,
	c.RecurringSettings,
	c.RecurringEndType,
	c.RecurringEndDate,
	c.OriginalStart,
	c.ParentKey,
	c.Pattern,
	c.Deleted,
	ISNULL(c.AllDayEvent,0) AS AllDayEvent,
	ISNULL(c.AllDayEvent,0) AS IsAllDay,
	c.BlockOutOnSchedule,
	c.DateUpdated,
	c.DateCreated,
	c.[Sequence],
	c.Freq,
	c.Interval,
	c.BySetPos,
	c.ByMonthDay,
	c.ByMonth,
	c.Su,
	c.Mo,
	c.Tu,
	c.We,
	c.Th,
	c.Fr,
	c.Sa,
	auth.FirstName + ' ' + auth.LastName as AuthorName,
	auth.Email as AuthorEmail,
	auth.TimeZoneIndex,
	ISNULL((Select Distinct 1 from tCalendarAttendee (nolock) where Entity <> 'Resource' and Entity <> 'Group' and Status <> 3 and EntityKey = @UserKey and tCalendarAttendee.CalendarKey = c.CalendarKey), 0) as IsAttendee,
	ISNULL((Select Distinct 1 from tAssignment a (nolock) where a.UserKey = @UserKey and a.ProjectKey = c.ProjectKey), 0) as IsAssigned,
	ISNULL((Select Distinct 1 from tCalendarAttendee (nolock) where Entity in ( 'Organizer', 'Attendee') and EntityKey = @LoggedUserKey and Status <> 3 and tCalendarAttendee.CalendarKey = c.CalendarKey), 0) as UserIsAttendee,
	cc.CompanyName,
	case When caddr.AddressKey is null then addr.Address1 else caddr.Address1 end as Address1,
	case When caddr.AddressKey is null then addr.Address2 else caddr.Address2 end as Address2,
	case When caddr.AddressKey is null then addr.Address3 else caddr.Address3 end as Address3,
	case When caddr.AddressKey is null then addr.City else caddr.City end as City,
	case When caddr.AddressKey is null then addr.State else caddr.State end as State,
	case When caddr.AddressKey is null then addr.PostalCode else caddr.PostalCode end as PostalCode,	p.ProjectNumber,
	p.ProjectName,
	u.FirstName + ' ' + u.LastName as ContactName,
	u.Email as ContactEmail,
	ISNULL(u.Phone1, cc.Phone) as Phone,
	ISNULL(ct.TypeColor,p.ProjectColor) as TypeColor,
	ISNULL(ct.DisplayOrder, 9999999) as DisplayOrder,
	convert(char(8), c.EventStart, 108) as StartTime,
	convert(char(8), c.EventEnd, 108) as EndTime,
	c.Private
	FROM	tCalendar c (nolock)				
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey	
		inner join tUser auth (nolock) on ca.EntityKey = auth.UserKey
		left outer join tCompany cc (nolock) on c.ContactCompanyKey = cc.CompanyKey
		left outer join tUser u (nolock) on c.ContactUserKey = u.UserKey
		left outer join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
		left outer join tProject p (nolock) on c.ProjectKey = p.ProjectKey
		left outer join tAddress addr (nolock) on cc.DefaultAddressKey = addr.AddressKey
		left outer join tAddress caddr (nolock) on u.AddressKey = caddr.AddressKey
	WHERE 
		((c.EventEnd >= @StartDate AND    c.EventStart <= @EndDate) or 
		(c.Recurring = 1) or (ParentKey > 0))
	AND	c.CompanyKey = @CompanyKey and ca.Entity = 'Organizer' and auth.Active = 1
GO
