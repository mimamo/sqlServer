USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarGetUserAvailability]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCalendarGetUserAvailability]

	(
		@UserKey int,
		@EventDate smalldatetime
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 7/22/09   GHL 10.5     getting address from tAddress
*/

Declare @CompanyKey int, @EndDate smalldatetime, @StartDate smalldatetime

Select @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (nolock) Where UserKey = @UserKey
Select @StartDate = DATEADD(d, -1, @EventDate)
Select @EndDate = DATEADD(d, 1, @EventDate)

Select Distinct c.*,
	cc.CompanyName,
	da.Address1,
	da.Address2,
	da.Address3,
	da.City,
	da.State,
	da.PostalCode,
	ct.TypeName,
	ct.TypeColor,
	ISNULL(ct.DisplayOrder, 0) as DisplayOrder,
	u.FirstName + ' ' + u.LastName as ContactName,
	u.TimeZoneIndex
From
	tCalendar c (nolock)
	left Outer Join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey 
	Left Outer Join tCompany cc (nolock) on c.ContactCompanyKey = cc.CompanyKey
	Left Outer Join tAddress da (nolock) on cc.DefaultAddressKey = da.AddressKey
	inner Join tUser u (nolock) on ca.EntityKey = u.UserKey
	Left Outer Join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
Where
	c.EventEnd >= @StartDate and
	c.EventStart <= @EndDate and
	ca.EntityKey = @UserKey and
	ca.Entity in ('Organizer', 'Attendee')

	
or 

(

c.CalendarKey in (
	Select c2.CalendarKey from 
	tCalendar c2 (nolock)
	Where c2.EventEnd > @StartDate
	AND c2.EventStart < @EndDate 
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
	Where c2.EventEnd > @StartDate
	AND c2.EventStart < @EndDate 
	and a.UserKey = @UserKey
	and Visibility = 1
	and EventLevel = 2)
)



Order By EventStart
GO
