USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetCountList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetCountList]
	(
	@CompanyKey int
	,@StartDate datetime
	,@EndDate datetime
	,@OpenActivities int -- vs Completed
	,@AllActivityTypes int = 1
	,@AllAssignedUsers int = 1
	,@AllFolders int = 1
	,@UserKey int
	)
AS
	SET NOCOUNT ON 
	
/*
|| When      Who Rel      What
|| 05/26/09  GHL 10.5.0.0 Creation for Activity Counts widget
|| 05/29/09  GHL 10.5.0.0 Added folder security and changed account managers to assigned users
|| 09/03/10  RLB 10.5.3.4 If private and session user is not Assigned or Originator set subject and notest to private.
*/

	-- Assume done in VB
	--create table #activity_params (Entity varchar(20) null, EntityKey int null)
	-- Entity: tActivityType, tUser, tCMFolder
	
	-- we should be able to view activities without folders
	if @AllFolders = 0
		insert #activity_params (Entity, EntityKey)
		values ('tCMFolder', 0)

	create table #activity(ActivityKey int null, ActivityDate datetime null, DateCompleted datetime null, AssignedUserKey int null, ActivityCount int null)

	if @OpenActivities = 1
		insert #activity(ActivityKey, ActivityDate, DateCompleted, AssignedUserKey)
		select ActivityKey, ActivityDate, DateCompleted, AssignedUserKey
		from   tActivity (nolock)
		where  CompanyKey = @CompanyKey
		and    ActivityDate >= @StartDate
		and    ActivityDate <= @EndDate
		and    DateCompleted is null
		and    (@AllActivityTypes = 1 
					or 
				(ActivityTypeKey in (select EntityKey from #activity_params where Entity = 'tActivityType')) 
				)
		and    (@AllFolders = 1 
				or 
				(isnull(CMFolderKey, 0) in (select EntityKey from #activity_params where Entity = 'tCMFolder')) 
				)
		and    (@AllAssignedUsers = 1 
				or 
				(AssignedUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
				or 
				(OriginatorUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
				)
	else
		insert #activity(ActivityKey, ActivityDate, DateCompleted, AssignedUserKey)
		select ActivityKey, ActivityDate, DateCompleted, AssignedUserKey
		from   tActivity (nolock)
		where  CompanyKey = @CompanyKey
		and    DateCompleted >= @StartDate
		and    DateCompleted <= @EndDate
		and    (@AllActivityTypes = 1 
					or 
				(ActivityTypeKey in (select EntityKey from #activity_params where Entity = 'tActivityType')) 
				)
		and    (@AllFolders = 1 
				or 
				(isnull(CMFolderKey, 0) in (select EntityKey from #activity_params where Entity = 'tCMFolder')) 
				)
		and    (@AllAssignedUsers = 1 
				or 
				(AssignedUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
				or 
				(OriginatorUserKey in (select EntityKey from #activity_params where Entity = 'tUser')) 
				)
				
				
	update #activity
	set    #activity.ActivityCount = (select count(b.ActivityKey) from #activity b where  
		isnull(b.AssignedUserKey, 0) = isnull(#activity.AssignedUserKey, 0)
		) 
				
	--select * from #activity	
	
	select ta.ActivityKey
	      ,case when a.Private = 1 and (a.AssignedUserKey <> @UserKey or a.OriginatorUserKey <> @UserKey) then
		  'Private Activity'
		  else
			a.Subject
		   end as Subject
	      ,case when @OpenActivities = 1 then ta.ActivityDate else ta.DateCompleted end as ActivityDate
	      ,case when a.Private = 1 and (a.AssignedUserKey <> @UserKey or a.OriginatorUserKey <> @UserKey) then
		  'Private Activity'
		  else
			a.Notes
			end as Notes
	      ,case when au.UserKey is null then
	        'Unassigned' + ' (' + cast(ta.ActivityCount as varchar(50)) + ')' 
	      else
	       isnull(au.FirstName, '') + ' ' + isnull(au.LastName, '') + ' (' + cast(ta.ActivityCount as varchar(50)) + ')'  
	      end as AssignedTo 
	      ,case when cu.UserKey is not null then 
			isnull(cu.FirstName, '') + ' ' + isnull(cu.LastName, '')
		   else 
		   	isnull(ul.FirstName, '') + ' ' + isnull(ul.LastName, '')
		   end as ContactName
		  
		  ,case when cu.UserKey is not null then 
			cu.UserCompanyName
		   else 
		   	 ul.CompanyName
		   end as ContactCompanyName

		  ,case when cu.UserKey is not null then 
			cu.Phone1
		   else 
		   	ul.Phone1
		   end as Phone1
		   		
	from   #activity ta
		inner join tActivity a (nolock) on ta.ActivityKey = a.ActivityKey
		left outer join tUser au (nolock) on a.AssignedUserKey = au.UserKey
		left outer join tUser cu (nolock) on a.ContactKey = cu.UserKey
		left outer join tUserLead ul (nolock) on a.UserLeadKey = ul.UserLeadKey
	where  a.CompanyKey = @CompanyKey
	order by isnull(au.FirstName, '') + ' ' + isnull(au.LastName, ''),ta.ActivityDate
	
	   
	RETURN 1
GO
