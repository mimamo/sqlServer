USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetDiary]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetDiary]
	(
		@CompanyKey int,
		@Entity varchar(50),
		@EntityKey int,
		@StartDate smalldatetime, 
		@EndDate smalldatetime,
		@VisibleToClient tinyint,
		@UserKey int,
		@SubscribedUserKey int,
		@ActivityKey int = null,
		@RootOnly tinyint = 0
	)
AS --Encrypt

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
|| 12/3/10   GHL 10.5.3.9 Cloned sptActivityGetHistory for the new diary functionality
|| 12/14/10  GHL 10.5.3.9 Added parameter ActivityKey to get the thread for a single activity
|| 12/16/10  GHL 10.5.3.9 Added IsSubscribed column to support subscription function
|| 12/29/10  GHL 10.5.3.9 Added RootActivityKey in joins used in subqueries (i.e. use IX_RootActivityKey)
|| 01/17/11  GHL 10.5.4.0 Changed ThreadSort date as max(DateUpdated, LastReplyDate) for root activities
|| 04/01/11  GHL 10.5.4.2 (107646) Added AddedByUserName to show true idendity of diary post creator
|| 03/14/14  MAS 10.5.7.8 Added IsRead to support the 'New App'
|| 03/17/15  GWG 10.5.9.0 Added rootonly param to pull just top level posts for the project diary.
*/

declare @RootActivityKey int

if @ActivityKey is not null
	Select @RootActivityKey = RootActivityKey from tActivity (nolock) Where ActivityKey = @ActivityKey

if @StartDate is null
	Select @StartDate = '1/1/1920'

if @EndDate is null
	Select @EndDate = '12/31/2040'

	create table #activity (
			EntityKey int null
			,Entity varchar(25) null
			,IconStyle varchar(25) null

			,SortDate datetime null
			,ThreadSort datetime null
			,DateAdded datetime null
			,DateUpdated datetime null
			,ActivityDate datetime null


			,ActivityKey int null
			,ParentActivityKey int null
			,RootActivityKey int null
			,CustomFieldKey int null
			
			,Subject varchar(2000) null
			,Notes Text null
			,VisibleToClient int null
			,ActivityTypeKey int null
			,TypeName varchar(500) null
			
			,OriginatorUserKey int null
			,AddedByKey int null
			,OriginatorUserName varchar(250) null
			,AddedByUserName varchar(250) null
			
			,ProjectKey int null
			,ProjectNumber varchar(50) null
			,ProjectFullName varchar(155) null
			
			,TaskKey int null
			,TaskFullName varchar(535) null
			,TaskID varchar(30) null
			,TaskName varchar(500) null

			,AttachmentCount int null
			,ReplyCount int null

			,LastReplyUserName varchar(250) null
			,LastReplyDate Datetime null
			,IsSubscribed int null
			,IsRead int null
			,UnreadCount int null
			)

	
	insert #activity (
			EntityKey 
			,Entity 
			,IconStyle 

			,SortDate
			,ThreadSort 
			,DateAdded 
			,DateUpdated 
			,ActivityDate 


			,ActivityKey 
			,ParentActivityKey 
			,RootActivityKey 
			,CustomFieldKey
			
			,Subject 
			,Notes 
			,VisibleToClient 
			,ActivityTypeKey 
			,TypeName 
			
			,OriginatorUserKey 
			,AddedByKey 
			,OriginatorUserName 
			,AddedByUserName 

			,ProjectKey
			,ProjectNumber 
			,ProjectFullName 
			
			,TaskKey 
			,TaskFullName 
			,TaskID 
			,TaskName 

			,AttachmentCount 
			,ReplyCount 

			,LastReplyUserName 
			,LastReplyDate 
			,IsSubscribed 
			,IsRead
			,UnreadCount
			)

	Select  a.ActivityKey as EntityKey
			,'Activity' as Entity
			,'menuCMActivities' as IconStyle
			
			,ISNULL(a.StartTime, a.DateAdded) as SortDate
			,a.DateUpdated AS ThreadSort
			,a.DateAdded 
			,a.DateUpdated
			,a.ActivityDate
			
			,a.ActivityKey
			,a.ParentActivityKey
			,a.RootActivityKey
			,a.CustomFieldKey
			
			,a.Subject
			,a.Notes
			,ISNULL(a.VisibleToClient, 0) as VisibleToClient
			,a.ActivityTypeKey
			,aty.TypeName
			
			,a.OriginatorUserKey
			,a.AddedByKey
			,isnull(u.FirstName + ' ', '') + isnull(u.LastName, '') as OriginatorUserName
			,isnull(uadd.FirstName + ' ', '') + isnull(uadd.LastName, '') as AddedByUserName
			
			,p.ProjectKey
			,p.ProjectNumber
			,p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName
			
			,a.TaskKey
			,case when ta.TaskID is null then ta.TaskName else ta.TaskID + ' - ' + ta.TaskName end as TaskFullName
			,ta.TaskID
			,ta.TaskName
			
			
			,(SELECT COUNT(att.AttachmentKey) FROM tAttachment att (NOLOCK)
			     WHERE att.AssociatedEntity = 'tActivity' 
			    AND att.EntityKey = a.ActivityKey)
			AS AttachmentCount
			
			,(SELECT COUNT(*) FROM tActivity a2 (nolock) 
			    where a.RootActivityKey = a2.RootActivityKey 
				and a.ActivityKey = a2.ParentActivityKey ) 
			As ReplyCount
		
			,(
			SELECT lru.FirstName + ' ' + lru.LastName 
			from    tUser lru (nolock)
				inner join tActivity a3 (nolock) on a3.AddedByKey = lru.UserKey
			where  a3.ActivityKey = 
				(SELECT MAX(a4.ActivityKey) FROM tActivity a4 (nolock) 
				where a.RootActivityKey = a4.RootActivityKey 
				and a.ActivityKey = a4.ParentActivityKey)
				) 
			As LastReplyUserName
			
			,(SELECT MAX(a5.DateAdded) FROM tActivity a5 (nolock) 
			    where a.RootActivityKey = a5.RootActivityKey 
			    and a.ActivityKey = a5.ParentActivityKey)
			As LastReplyDate
			
			, isnull((
				select count(*) from tActivityEmail ae (nolock)
				where ae.ActivityKey = a.ActivityKey
				and   ae.UserKey = @SubscribedUserKey
			),0) as IsSubscribed

			,(SELECT COUNT(ap.IsRead) 
				FROM tAppRead ap (NOLOCK)
			    WHERE ap.UserKey = @SubscribedUserKey
			    AND ap.Entity = 'tActivity'
			    AND ap.EntityKey = a.ActivityKey)
			AS IsRead
			,CASE When @RootOnly = 1 then  --only gets called when looking for the root only ie. platinum
				(select count(*)
				from tActivity ur (nolock)
				left outer join (Select * from tAppRead (nolock) Where UserKey = @SubscribedUserKey and Entity = 'tActivity') as appRead on ur.ActivityKey = appRead.EntityKey
				Where ur.RootActivityKey = a.ActivityKey 
				and ISNULL(appRead.IsRead, 0) = 0) ELSE 0 END as UnReadCount
	
	From tActivity a (nolock)
	inner join tActivityLink al (nolock) on a.ActivityKey = al.ActivityKey
	left outer join tUser u (nolock) on a.OriginatorUserKey = u.UserKey
	left outer join tUser uadd (nolock) on a.AddedByKey = uadd.UserKey
	left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	left outer join tTask ta (nolock) on a.TaskKey = ta.TaskKey
	left outer join tActivityType aty (nolock) on a.ActivityTypeKey = aty.ActivityTypeKey
	Where a.ActivityEntity = 'Diary'
	and al.Entity = @Entity and al.EntityKey = @EntityKey 
	and a.CompanyKey = @CompanyKey
	and (a.ActivityDate is null OR (a.ActivityDate > @StartDate and a.ActivityDate < @EndDate))
	and ISNULL(a.VisibleToClient, 0) >= @VisibleToClient
	and (@RootActivityKey is null Or a.RootActivityKey = @RootActivityKey)
	and (@RootOnly = 0 OR a.ActivityKey = a.RootActivityKey)
	--Order by a.DateUpdated DESC

	update #activity
	set    ThreadSort = LastReplyDate 
	where  ActivityKey = RootActivityKey 
	and    LastReplyDate is not null
	and    LastReplyDate > ThreadSort

	select * from #activity
	Order By ThreadSort DESC

	if @RootActivityKey is null and @RootOnly = 0
	Select
		c.CalendarKey as EntityKey,
		'Meeting' as Entity,
		'menuMainCalendar' as IconStyle,
		c.EventStart as SortDate,
		org.FirstName + ' ' + org.LastName as Organizer,
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
		
		-- these are groups on the ActivityHistory
		org.FirstName + ' ' + org.LastName as AssignedUserName,
		'' as TaskName

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
		and (@StartDate is null or (EventStart > @StartDate and EventStart < @EndDate))
		and (@UserKey is null or ca.EntityKey = @UserKey or au.EntityKey = @UserKey)
		ORDER BY EventStart DESC
GO
