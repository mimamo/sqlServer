USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetHistory]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetHistory]
	(
		@CompanyKey int,
		@Entity varchar(50),
		@EntityKey int,
		@ExcludeProjects tinyint,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@VisibleToClient tinyint,
		@UserKey int,
		@CurrentUserKey int
	)
AS

/*
|| When      Who Rel      What
|| 1/16/09   CRG 10.5.0.0 Added IsThread column.
||                        Added Order By to the calendar queries.
||                        Also changed ProjectKey to check for 0 rather than NULL because it's 0 in Calendar.
|| 4/30/09   CRG 10.5.0.0 Added ActivityTypeKey so history search will work for Activity Types
|| 6/03/09   RTC 10.5.0.0 Added date range logic, UserKey logic
|| 6/30/09   CRG 10.5.0.0 Fixed joins to prevent duplicate rows
|| 07/20/09  GWG 10.5.0.5 Added Start time to the sort date.
|| 08/12/09  GHL 10.5.0.7 (59630) Added attachment count
|| 09/18/09  GWG 10.5.1.0 Modified sort date
|| 9/23/09   CRG 10.5.1.1 (59625) Modified for threaded view.
|| 11/23/09  RLB 10.5.1.4 (68940) Changed the join to a.UserLeadKey.
|| 7/15/10   CRG 10.5.3.2 Added ProjectNumber, TaskID, TaskName
|| 7/22/10   GHL 10.5.3.2 Added AssignedUserName and TaskName to meetings since meetings are joined with activities
||                        and part of the groups on the grid display
|| 12/9/10   CRG 10.5.3.9 Added restriction on meetings for Deleted = 0
|| 09/17/12  RLB 10.5.6.0 (154528) Added UpdatedByKey and User Name
|| 06/15/14  GWG 10.5.8.1 Added the case statement to the Sort Date to follow how we now display information for proper sorting
|| 06/17/14  GWG 10.5.8.1 Rolling back that sort date change
|| 07/14/14  MFT 10.5.8.2 Added ReplyCount to Activity query and AssignedUserKey to Meeting query
|| 07/16/14  MFT 10.5.8.2 Added UnreadCount to Activity query
|| 08/11/14  QMD 10.5.8.3 Added EventEnd, AllDayEvent to meetings
|| 08/19/14  MFT 10.5.8.3 Added override to SortDate
|| 08/28/14  MFT 10.5.8.3 Corrected UnreadCount
|| 09/03/14  KMC 10.5.8.3 (227029) Added OriginatorName
|| 10/03/14  QMD 10.5.8.4 Added ContactCompanyKey, ContactKey, ProjectKey, UserLeadKey, LeadKey
|| 10/30/14  QMD 10.5.8.5 Added a3.RootActivityKey > 0 
|| 02/25/15  QMD 10.5.8.9 Added a.AddedByKey 
*/

if @StartDate is null
	Select @StartDate = '1/1/1920'

if @EndDate is null
	Select @EndDate = '12/31/2040'

	Select  a.ActivityKey as EntityKey, 
		'Activity' as Entity,
		'menuCMActivities' as IconStyle,
		ISNULL(a.ActivityDate, ISNULL(a.DateAdded, a.DateUpdated)) as SortDate,
		a.DateUpdated,
		a.ActivityKey,
		a.Private,
		a.AssignedUserKey,
		a.OriginatorUserKey,
		a.ContactCompanyKey,
		a.RootActivityKey,
		a.ActivityDate,
		a.Completed,
		a.DateCompleted,
		a.Subject,
		a.TaskKey,
		a.Notes,
		u.FirstName + ' ' + u.LastName as AssignedUserName,
		lk.CompanyKey as LinkedCompanyKey,
		con.FirstName + ' ' + con.LastName as ContactName,
		o.FirstName + ' ' + o.LastName as OriginatorName,
		ul.FirstName + ' ' + ul.LastName as LeadName,
		c.CompanyName as CompanyName,
		l.Subject as OpportunityName,
		p.ProjectNumber,
		p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
		case when ta.TaskID is null then ta.TaskName else ta.TaskID + ' - ' + ta.TaskName end as TaskFullName,
		ta.TaskID,
		ta.TaskName,
		CASE
			WHEN ISNULL(a.ParentActivityKey, 0) > 0 THEN 1
			WHEN EXISTS (SELECT NULL FROM tActivity a2 (nolock) WHERE a2.RootActivityKey = a.RootActivityKey AND a2.ActivityKey <> a.ActivityKey) THEN 1
			ELSE 0
		END AS IsThread,
		(SELECT COUNT(*) FROM tActivity a3 (nolock) WHERE a3.RootActivityKey = a.RootActivityKey AND a3.RootActivityKey > 0 AND a3.ActivityKey <> a.ActivityKey) AS ReplyCount,
		(
			SELECT COUNT(*)
			FROM tActivity a4 (nolock) LEFT JOIN tAppRead ar (nolock) ON ar.Entity = 'tActivity' AND a4.ActivityKey = ar.EntityKey
			WHERE ISNULL(ar.IsRead, 0) = 0 AND a.ActivityKey = a4.RootActivityKey AND ISNULL(ar.UserKey, @CurrentUserKey) = @CurrentUserKey
		) AS UnreadCount,
		a.ActivityTypeKey,
		ISNULL((SELECT COUNT(*) FROM tAttachment (NOLOCK)
		WHERE AssociatedEntity = 'tActivity' AND EntityKey = a.ActivityKey), 0)
		AS AttachmentCount,
		a.DateUpdated AS ThreadSort,
		a.ParentActivityKey,
		a.UpdatedByKey,
		u2.FirstName + ' ' + u2.LastName as UpdatedUserName,
		a.StartTime,
		a.EndTime,
		a.ContactCompanyKey,
		a.ContactKey,
		a.ProjectKey,
		a.UserLeadKey,
		a.LeadKey,
		a.AddedByKey
	From
		tActivity a (nolock)
		inner join tActivityLink al (nolock) on a.ActivityKey = al.ActivityKey
		left outer join tUser lk (nolock) on al.EntityKey = lk.UserKey
		left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
		left outer join tUser u2 (nolock) on a.UpdatedByKey = u2.UserKey
		left outer join tUser con (nolock) on a.ContactKey = con.UserKey
		left outer join tUser o (nolock) on a.OriginatorUserKey = o.UserKey
		left outer join tUserLead ul (nolock) on a.UserLeadKey = ul.UserLeadKey
		left outer join tCompany c (nolock) on a.ContactCompanyKey = c.CompanyKey
		left outer join tLead l (nolock) on a.LeadKey = l.LeadKey
		left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
		left outer join tTask ta (nolock) on a.TaskKey = ta.TaskKey
	Where
		al.Entity = @Entity and EntityKey = @EntityKey and a.CompanyKey = @CompanyKey
		and (@ExcludeProjects = 0 OR ISNULL(a.ProjectKey, 0) = 0)
		and (a.ActivityDate is null OR (a.ActivityDate > @StartDate and a.ActivityDate < @EndDate))
		and ISNULL(a.VisibleToClient, 0) >= @VisibleToClient
		and (a.AssignedUserKey = @UserKey or @UserKey is null)
	Order By a.ActivityDate DESC, a.DateUpdated DESC


if @Entity = 'tUser'
	Select
		c.CalendarKey as EntityKey,
		'Meeting' as Entity,
		'menuMainCalendar' as IconStyle,
		c.EventStart as SortDate,
		org.FirstName + ' ' + org.LastName as Organizer,
		org.UserKey as OrganizerKey,
		u.FirstName + ' ' + u.LastName as ContactName,
		u.Phone1,
		u.Phone2,
		u.Cell,
		u.Email,
		co.CompanyName as ContactCompany,
		c.ContactCompanyKey,
		u.CompanyKey as LinkedCompanyKey,
		ct.TypeName,
		c.*,
		0 AS ParentActivityKey,
		c.EventStart as ThreadSort,
		ISNULL((Select 1 from tCalendarAttendee (nolock) Where Entity in ('Organizer', 'Attendee') and EntityKey = @CurrentUserKey and CalendarKey = c.CalendarKey), 0) as IsAttendee,
		-- these are groups on the ActivityHistory
		org.FirstName + ' ' + org.LastName as AssignedUserName,
		org.UserKey AS AssignedUserKey,
		'' as TaskName,
		c.EventEnd,
		c.AllDayEvent

	From tCalendar c (nolock)
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey and ca.Entity = 'Organizer'
		inner join tCalendarAttendee cac (nolock) on c.CalendarKey = cac.CalendarKey and cac.Entity = 'Attendee'
		left outer join tCalendarAttendee au (nolock) on c.CalendarKey = au.CalendarKey and au.Entity = 'Attendee' and au.EntityKey = @UserKey --Restrict EntityKey here to prevent multiple rows
		left outer join tUser org (nolock) on ca.EntityKey = org.UserKey
		left outer join tCompany co (nolock) on c.ContactCompanyKey = co.CompanyKey
		left outer join tUser u (nolock) on c.ContactUserKey = u.UserKey
		left outer join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
	Where
		cac.EntityKey = @EntityKey
		and (@ExcludeProjects = 0 OR ISNULL(c.ProjectKey, 0) = 0)
		and (@StartDate is null or (EventStart > @StartDate and EventStart < @EndDate))
		and (@UserKey is null or ca.EntityKey = @UserKey or au.EntityKey = @UserKey)
	ORDER BY EventStart DESC

ELSE
	
	Select
		c.CalendarKey as EntityKey,
		'Meeting' as Entity,
		'menuMainCalendar' as IconStyle,
		c.EventStart as SortDate,
		org.FirstName + ' ' + org.LastName as Organizer,
		org.UserKey as OrganizerKey,
		u.FirstName + ' ' + u.LastName as ContactName,
		u.Phone1,
		u.Phone2,
		u.Cell,
		u.Email,
		co.CompanyName as ContactCompany,
		c.ContactCompanyKey,
		u.CompanyKey as LinkedCompanyKey,
		ct.TypeName,
		c.*,
		0 AS ParentActivityKey,
		c.EventStart as ThreadSort,
		ISNULL((Select 1 from tCalendarAttendee (nolock) Where Entity in ('Organizer', 'Attendee') and EntityKey = @CurrentUserKey and CalendarKey = c.CalendarKey), 0) as IsAttendee,
		-- these are groups on the ActivityHistory
		org.FirstName + ' ' + org.LastName as AssignedUserName,
		org.UserKey AS AssignedUserKey,
		'' as TaskName,
		c.EventEnd,
		c.AllDayEvent

	From tCalendar c (nolock)
		inner join tCalendarLink cl (nolock) on c.CalendarKey = cl.CalendarKey
		inner join tCalendarAttendee ca (nolock) on c.CalendarKey = ca.CalendarKey and ca.Entity = 'Organizer'
		left outer join tCalendarAttendee au (nolock) on c.CalendarKey = au.CalendarKey and au.Entity = 'Attendee' and au.EntityKey = @UserKey --Restrict EntityKey here to prevent multiple rows
		left outer join tUser org (nolock) on org.UserKey = ca.EntityKey
		left outer join tCompany co (nolock) on c.ContactCompanyKey = co.CompanyKey
		left outer join tUser u (nolock) on c.ContactUserKey = u.UserKey
		left outer join tCalendarType ct (nolock) on c.CalendarTypeKey = ct.CalendarTypeKey
	Where
		cl.Entity = @Entity and cl.EntityKey = @EntityKey
		and (@ExcludeProjects = 0 OR ISNULL(c.ProjectKey, 0) = 0)
		and (@StartDate is null or (EventStart > @StartDate and EventStart < @EndDate))
		and (@UserKey is null or ca.EntityKey = @UserKey or au.EntityKey = @UserKey)
		and c.Deleted = 0
	ORDER BY EventStart DESC
GO
