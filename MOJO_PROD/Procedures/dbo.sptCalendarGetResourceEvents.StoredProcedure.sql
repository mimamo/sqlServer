USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetResourceEvents]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCalendarGetResourceEvents] 
	
		(
		@UserKey int,
		@CompanyKey int,
		@StartDate as smalldatetime,
		@EndDate as smalldatetime
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 12/18/06 CRG 8.4     (7573) Modified the test of RecurringEndType to simply a check for Recurring = 1 to match the logic in the other calendar SPs.
|| 3/29/07  CRG 8.4.1   (8306) Added ContactEmail
*/

Select 
	c.*,
	auth.ResourceName as AuthorName,
	(Select tUser.TimeZoneIndex from tUser (nolock) inner join tCalendarAttendee (nolock) on tUser.UserKey = tCalendarAttendee.EntityKey Where tCalendarAttendee.Entity = 'Organizer' and tCalendarAttendee.CalendarKey = c.CalendarKey) as TimeZoneIndex,
	ISNULL((Select Distinct 1 from tCalendarAttendee ca (nolock) where ca.EntityKey = @UserKey and ca.Entity = 'Resource' and ca.CalendarKey = c.CalendarKey), 0) as IsAttendee,
	1 as IsAssigned,
	cc.CompanyName,
	caddr.Address1,
	caddr.Address2,
	caddr.Address3,
	caddr.City,
	caddr.State,
	caddr.PostalCode,
	p.ProjectNumber,
	p.ProjectName,
	u.FirstName + ' ' + u.LastName as ContactName,
	u.Email as ContactEmail,
	ISNULL(u.Phone1, cc.Phone) as Phone,
	ct.TypeColor,
	ca.EntityKey,
	ca.Entity,
	convert(char(8), c.EventStart, 108) as StartTime,
	convert(char(8), c.EventEnd, 108) as EndTime

	FROM	tCalendar c (nolock)				
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey and ca.Entity = 'Resource'
		inner join tCalendarResource auth (nolock) on ca.EntityKey = auth.CalendarResourceKey
		inner join tCalendarAttendee cAuth (nolock) on c.CalendarKey = cAuth.CalendarKey and cAuth.Entity = 'Organizer'
		inner join tUser uAuth (nolock) on cAuth.EntityKey = uAuth.UserKey
		left outer join tCompany cc (nolock) on c.ContactCompanyKey = cc.CompanyKey
		left outer join tAddress caddr (nolock) on cc.DefaultAddressKey = caddr.AddressKey
		left outer join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
		left outer join tProject p (nolock) on c.ProjectKey = p.ProjectKey
		left outer join tUser u (nolock) on c.ContactUserKey = u.UserKey
	WHERE 
		((c.EventEnd >= @StartDate AND    c.EventStart <= @EndDate) or (c.Recurring = 1) or (ParentKey > 0))
	AND	c.CompanyKey = @CompanyKey
		and ca.EntityKey = @UserKey and uAuth.Active = 1
	RETURN 1
GO
