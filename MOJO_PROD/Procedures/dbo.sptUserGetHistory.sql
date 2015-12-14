USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetHistory]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetHistory]
	(
		@ContactKey int,
		@UserKey int,
		@ViewOthers tinyint
	)
	
AS

	
	Select 
		ca.ActivityKey as EntityKey,
		'Activity' as Entity,
		case When Completed = 1 then 'Open' else 'Completed' end as Stage,
		ActivityDate as HistoryDate,
		u.FirstName + ' ' + u.LastName as AssignedUserName,
		p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
		l.Subject as LeadSubject,
		c.CompanyName as ContactCompany,
		ca.*
	From tActivity ca (nolock)
		inner join tActivityLink al (nolock) on ca.ActivityKey = al.ActivityKey
		left outer join tCompany c (nolock) on ca.ContactCompanyKey = c.CompanyKey
		left outer join tProject p (nolock) on ca.ProjectKey = p.ProjectKey
		left outer join tLead l (nolock) on ca.LeadKey = l.LeadKey
		left outer join tUser u (nolock) on ca.AssignedUserKey = u.UserKey
	Where al.EntityKey = @ContactKey
			and al.Entity = 'tUser'
			and (@ViewOthers = 1 or AssignedUserKey = @UserKey)
	
	
	Select
		c.CalendarKey as EntityKey,
		'Meeting' as Entity,
		case When EventEnd >= GETUTCDATE() then 'Open' else 'Completed' end as Stage,
		EventStart as HistoryDate,
		org.FirstName + ' ' + org.LastName as Organizer,
		u.FirstName + ' ' + u.LastName as ContactName,
		u.Phone1,
		u.Phone2,
		u.Cell,
		u.Email,
		co.CompanyName as ContactCompany,
		ct.TypeName,
		c.*
	From tCalendar c (nolock)
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey and ca.Entity = 'Organizer'
		inner join tCalendarAttendee cac (nolock) on c.CalendarKey = cac.CalendarKey and cac.Entity = 'Attendee'
		left outer join tUser org (nolock) on org.UserKey = ca.EntityKey
		left outer join tCompany co (nolock) on c.ContactCompanyKey = co.CompanyKey
		left outer join tUser u (nolock) on c.ContactUserKey = u.UserKey
		left outer join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
	Where
		cac.EntityKey = @ContactKey
GO
