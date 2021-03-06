USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetTaskList2]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetTaskList2]
 (  
 @UserKey int  
 ,@PredecessorsComplete int -- 0 All or 1 PredecessorsComplete only    
 ,@DateOption int   
 ,@IncludeActivities tinyint = 0  
 ,@Completed tinyint = 0
 ,@RestrictActivitiesToAssigned tinyint = 0 --If 1, only activites that are assigned to @UserKey, or are not assigned at all will be returned
 ,@ProjectTypeKey int = 0
 ,@OpenToDoOnly tinyint = 0
 )  
AS --Encrypt  
  
 SET NOCOUNT ON  
  
/*  
|| When     Who Rel      What  
|| 01/14/14 GWG 10.5.7.6 Created for today page in new app
|| 04/28/14	MAS 10.5.7.6 Copied sptTaskUserGetTaskList and modified for the new app adding the count(*)s for the
||                       (!) XX New Update counts in the Today Task cards
|| 07/10/14 MAS 10.5.8.1 (222322) Exclude tasks that are already included in the user's favorites
|| 07/31/14 QMD 10.5.8.2 Changed User.Today.MyTasks to today.creative.myTasks
|| 01/13/14 MAS 10.5.8.8 (242143)Added security to check if the user has the prjViewOtherToDos right.
|| 04/20/15 GWG 10.5.9.1 Added a hook out to deliverables through the taskuser record.
*/  
  
/*
		ATTENTION: BE CAREFUL WHEN PULLING DATA DURING INITIAL QUERY
		THE DATA HAS TO BE PART OF AN INDEX
		IF IT IS NOT, THIS WILL RESULT IN PERFORMANCE DEGRADATION
		ON THE MY TASKS WIDGET
*/

declare @SecurityGroupKey int, @Administrator tinyint

Select @SecurityGroupKey = SecurityGroupKey,  @Administrator = ISNULL(Administrator, 0) from tUser Where UserKey = @UserKey
  
CREATE TABLE #tTask (TaskUserKey INT NULL  
     --,ClientKey INT NULL  
     ,ProjectKey INT NULL  
     ,CampaignKey INT NULL  
    ,BudgetTaskKey INT NULL
     ,TaskKey INT NULL  
     ,UserKey INT NULL  
     ,ServiceKey INT NULL  
     ,AssignedServiceKey INT NULL  
     --,ProjectNumber VARCHAR(50) NULL  
     --,ProjectName VARCHAR(100) NULL  
     --,ProjectFullName VARCHAR(155) NULL  
     --,BillingContact INT NULL  
     ,ProjectStatus VARCHAR(300) NULL
     ,TaskID VARCHAR(30) NULL  
     ,TaskName VARCHAR(500) NULL  
     ,TaskIDName VARCHAR(535) NULL  
     --,AccountManagerName VARCHAR(500) NULL  
     
     ,DetailTaskKey INT NULL --Used by TimeEntryWidget  
     ,DetailTaskName VARCHAR(500) NULL --Used by TimeEntryWidget  
     ,BudgetTaskID VARCHAR(30) NULL --Used by TimeEntryWidget  
       
     ,TaskDescription VARCHAR(6000) NULL  
     ,PlanStart SMALLDATETIME NULL  
     ,PlanComplete SMALLDATETIME NULL  
     ,PlanDuration  INT NULL
	 ,BaseStart SMALLDATETIME null
	 ,BaseComplete SMALLDATETIME null
     
     ,ScheduleNote VARCHAR(200) NULL  
     ,Comments VARCHAR(4000) NULL  
     ,DueBy VARCHAR(200) NULL  
     ,TaskStatus SMALLINT NULL  
     ,Priority SMALLINT NULL
     ,PriorityName VARCHAR(10) NULL
     ,TaskType SMALLINT NULL  -- Needed for task status renderer 
     ,TaskTypeDesc VARCHAR(200) NULL   
     ,ScheduleTask SMALLINT NULL -- Needed for task status renderer  
     ,TimeActive SMALLINT NULL -- need to distinguish if this row allows time
     
     ,PredecessorsComplete INT NULL  
     ,PercComp INT NULL -- From tTaskUser  
     ,ActStart SMALLDATETIME NULL  
     ,ActComplete SMALLDATETIME NULL  
     ,AssignedPercComp INT NULL  
       
     ,AssignedHours DECIMAL(24, 4) NULL  
     ,ActualHours DECIMAL(24, 4) NULL
	 ,RemainingHours DECIMAL(24, 4) NULL
     ,TrackBudget TINYINT NULL
     ,ProjectOrder INT NULL
     ,SummaryTaskKey INT NULL
     ,SummaryTaskID VARCHAR(30) NULL  
     ,SummaryTaskName VARCHAR(500) NULL  
     ,SummaryTask VARCHAR(535) NULL
     ,ProjectTypeKey INT NULL
     ,ProjectTypeName VARCHAR(100) NULL
     ,OpenToDos INT NULL
     ,CustomFieldKey INT NULL
     )  
CREATE TABLE #tTime (TaskKey INT NULL, DetailTaskKey INT NULL, ServiceKey INT NULL, ActualHours DECIMAL(24, 4) NULL)  

DECLARE @CompanyKey INT, @RateLevel INT, @ShowActualHours INT
DECLARE @EndDate SMALLDATETIME, @BeginDate SMALLDATETIME
  
SELECT @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey)
      ,@RateLevel = RateLevel
FROM   tUser (NOLOCK)
WHERE  UserKey = @UserKey
  
Select @ShowActualHours = ISNULL(ShowActualHours, 0)
From   tPreference (nolock) 
Where  CompanyKey = @CompanyKey

  
if @Completed = 0
BEGIN
	/*  
	DateOption  
	0:Due on or before Today  
	1:Due on or before a week from Today  
	2:Due on or before 2 weeks from Today  
	3:Start on or before Today  
	4:Start on or before a week from Today  
	5:Start on or before 2 weeks from Today  
	6:All  
	*/  
	  
	IF @DateOption IN (0, 3)   
	 SELECT @EndDate = GETDATE()   
	IF @DateOption IN (1, 4)  
	BEGIN   
	 SELECT @EndDate = GETDATE()   
	 SELECT @EndDate = DATEADD(day, 7, @EndDate)  
	END  
	IF @DateOption IN (2, 5)  
	BEGIN   
	 SELECT @EndDate = GETDATE()   
	 SELECT @EndDate = DATEADD(day, 14, @EndDate)  
	END  
	  
	-- remove hours   
	SELECT @EndDate = CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), @EndDate, 101), 101)  

-- First do insert with minimum fields, all these fields MUST BE in indexes!!!!!!!!!!!!!
-- DO NOT GENERATE TABLE SCANS HERE
INSERT #tTask (
	-- keys
	TaskUserKey, ProjectKey, CampaignKey, TaskKey ,DetailTaskKey, UserKey, ServiceKey, AssignedServiceKey   
    -- project status info
   ,ProjectStatus, TimeActive, ProjectTypeKey
   -- task info  
   ,PlanStart,PlanComplete,PlanDuration, PredecessorsComplete  
   -- task user info
   ,PercComp,ActStart,ActComplete,AssignedPercComp,AssignedHours
   ,CustomFieldKey
   )  
SELECT tu.TaskUserKey, t.ProjectKey, p.CampaignKey, t.TaskKey, t.TaskKey, tu.UserKey, ISNULL(tu.ServiceKey, u.DefaultServiceKey), tu.ServiceKey
  , ps.ProjectStatus, ps.TimeActive, 0 -- ,p.ProjectTypeKey -- removed by Gil because not part of an index
  , t.PlanStart, t.PlanComplete,t.PlanDuration ,t.PredecessorsComplete
  ,tu.PercComp,tu.ActStart,tu.ActComplete  
  ,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END  
  ,tu.Hours
  ,t.CustomFieldKey
FROM   tTask t (NOLOCK)  
inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey  
inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey  
inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey  
inner join tUser u (nolock) on tu.UserKey = u.UserKey
Where tu.UserKey = @UserKey
And p.CompanyKey = @CompanyKey   
And p.Closed = 0   
AND p.Active = 1
And ISNULL(ps.OnHold, 0) = 0   
And (  
 (ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) < 100)   
  Or   
 (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) < 100)  
 )  
And t.PredecessorsComplete >= @PredecessorsComplete  
And (  
 (@DateOption = 6)  
  Or  
 (@DateOption IN (0, 1, 2) AND t.PlanComplete <= @EndDate)  
  Or  
 (@DateOption IN (3, 4, 5) AND t.PlanStart <= @EndDate )  
 )  


END
ELSE
BEGIN

	/*  
	DateOption    
	1:In the last 1 week
	2:In the last 2 week
	3:In the last 3 week
	*/  
	  
	SELECT @EndDate = CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101), 101)  
	SELECT @BeginDate = DATEADD(week, -1 * @DateOption, @EndDate)   

	INSERT #tTask (
		-- keys
		TaskUserKey, ProjectKey, CampaignKey, TaskKey ,DetailTaskKey, UserKey, ServiceKey, AssignedServiceKey
		-- project status info
	   ,ProjectStatus, TimeActive, ProjectTypeKey
	   -- task info  
	   ,PlanStart,PlanComplete,PlanDuration, PredecessorsComplete  
	   -- task user info
	   ,PercComp,ActStart,ActComplete,AssignedPercComp,AssignedHours 
	   )  
	SELECT tu.TaskUserKey, t.ProjectKey, p.CampaignKey, t.TaskKey, t.TaskKey, tu.UserKey, ISNULL(tu.ServiceKey, u.DefaultServiceKey), tu.ServiceKey 
	  , ps.ProjectStatus, ps.TimeActive, 0 -- ,p.ProjectTypeKey -- removed by Gil because not part of an index
	  , t.PlanStart, t.PlanComplete,t.PlanDuration ,t.PredecessorsComplete
	  ,tu.PercComp,tu.ActStart,tu.ActComplete  
	  ,CASE WHEN ISNULL(t.PercCompSeparate, 0) = 0 THEN ISNULL(t.PercComp, 0) ELSE ISNULL(tu.PercComp, ISNULL(t.PercComp, 0)) END  
	  ,tu.Hours
	FROM   tTask t (NOLOCK)  
	inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey  
	inner join tProject p (nolock) on p.ProjectKey = t.ProjectKey  
	inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey  
	inner join tUser u (nolock) on tu.UserKey = u.UserKey
	Where tu.UserKey = @UserKey
	AND p.CompanyKey = @CompanyKey   
	AND p.Closed = 0   
	AND p.Active = 1
	AND ISNULL(ps.OnHold, 0) = 0   
	AND (  
	 (ISNULL(t.PercCompSeparate, 0) = 0 and ISNULL(t.PercComp, 0) = 100)   
	  Or   
	 (ISNULL(t.PercCompSeparate, 0) = 1 and ISNULL(tu.PercComp, 0) = 100)  
	 )  
	AND t.PlanStart <= @EndDate 
	AND t.PlanComplete >= @BeginDate  

END

-- After initial queries, delete as many records as we can based on filters
UPDATE	#tTask
SET		#tTask.ProjectTypeKey = p.ProjectTypeKey
		,#tTask.ProjectTypeName = pt.ProjectTypeName
FROM	tProject p (NOLOCK)
	    LEFT OUTER JOIN tProjectType pt (nolock) ON p.ProjectTypeKey = pt.ProjectTypeKey 
WHERE	#tTask.ProjectKey = p.ProjectKey

if isnull(@ProjectTypeKey, 0) > 0
	delete #tTask where isnull(ProjectTypeKey, 0) <> @ProjectTypeKey

if ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90933 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
	begin
		-- Can see all the todos
		update #tTask
		set    #tTask.OpenToDos = (
			select count(*) 
			from   tActivity a (nolock)
			where  #tTask.TaskKey = a.TaskKey
			and    a.ActivityEntity = 'ToDo'
			and    a.Completed = 0
			and    a.ParentActivityKey = 0			
		)
	end
else
	begin
		-- Can only see thier todos
		update #tTask
		set    #tTask.OpenToDos = (
			select count(*) 
			from   tActivity a (nolock)
			where  #tTask.TaskKey = a.TaskKey
			and    a.ActivityEntity = 'ToDo'
			and    a.Completed = 0
			and    a.ParentActivityKey = 0
			and	  (ISNULL(AssignedUserKey, 0) = 0 OR AssignedUserKey = @UserKey)
		)
	end	

if isnull(@OpenToDoOnly, 0) > 0
	delete #tTask where OpenToDos = 0

-- Only now get missing info on a smaller number of tasks

-- get task info, I prefer to do a separate join 
update #tTask
set    #tTask.TaskID = t.TaskID
	  ,#tTask.TaskName = t.TaskName
      ,#tTask.TaskIDName = ISNULL(t.TaskID, '') + '-' + ISNULL(t.TaskName, '')
      ,#tTask.DetailTaskName = t.TaskName
      ,#tTask.TaskDescription = t.Description
      ,#tTask.ScheduleNote = t.ScheduleNote
      ,#tTask.Comments = t.Comments
      ,#tTask.DueBy = t.DueBy
      ,#tTask.TaskStatus = t.TaskStatus
      ,#tTask.Priority = CASE WHEN t.Priority IN (1,2,3) THEN t.Priority ELSE 2 END
      ,#tTask.PriorityName = CASE t.Priority
		WHEN 1 THEN '1 - High'
		WHEN 2 THEN '2 - Medium'
		WHEN 3 THEN '3 - Low'
		ELSE '2 - Medium'
	  END
      ,#tTask.TaskType = t.TaskType
      ,#tTask.TaskTypeDesc = ta.TaskAssignmentType
      ,#tTask.ScheduleTask = t.ScheduleTask
      ,#tTask.TrackBudget = t.TrackBudget
      ,#tTask.ProjectOrder = t.ProjectOrder
      ,#tTask.BudgetTaskKey = t.BudgetTaskKey
      ,#tTask.SummaryTaskKey = st.TaskKey
      ,#tTask.SummaryTaskID = st.TaskID
      ,#tTask.SummaryTaskName = st.TaskName
      ,#tTask.SummaryTask = ISNULL(st.TaskID, '') + '-' + ISNULL(st.TaskName, '')
	  ,#tTask.BaseStart = t.BaseStart
	  ,#tTask.BaseComplete = t.BaseComplete

from   tTask t (nolock)
left outer join tTask st (NOLOCK) on t.SummaryTaskKey = st.TaskKey
left outer join tTaskAssignmentType ta (NOLOCK) on ta.TaskAssignmentTypeKey = t.TaskAssignmentTypeKey
where  #tTask.TaskKey = t.TaskKey

    
update #tTask
set    #tTask.BudgetTaskID = bt.TaskID
from   tTask bt (nolock)
where  #tTask.BudgetTaskKey = bt.TaskKey

  



IF @ShowActualHours = 1
BEGIN
	INSERT #tTime (TaskKey, DetailTaskKey, ServiceKey, ActualHours)  
	SELECT ti.TaskKey, ti.DetailTaskKey, ti.ServiceKey, ti.ActualHours   
	FROM tTime ti WITH (INDEX=IX_tTime_1, NOLOCK)  
		,(select Distinct(TaskKey) from #tTask (nolock)) as ta     
	WHERE ti.UserKey = @UserKey  
	AND   (ti.TaskKey = ta.TaskKey OR ti.DetailTaskKey = ta.TaskKey)
	
	UPDATE #tTask  
	SET    #tTask.ActualHours = ISNULL(  
       (SELECT SUM(ti.ActualHours) FROM #tTime ti   
       WHERE (ti.TaskKey = #tTask.TaskKey OR ti.DetailTaskKey = #tTask.TaskKey))   
       ,0)  
END
ELSE
BEGIN

	INSERT #tTime (TaskKey, DetailTaskKey, ServiceKey, ActualHours)  
	SELECT ti.TaskKey, ti.DetailTaskKey, ti.ServiceKey, ti.ActualHours   
	FROM tTime ti WITH (INDEX=IX_tTime_1, NOLOCK)  
		,#tTask ta     
	WHERE ti.UserKey = @UserKey  
	AND   (ti.TaskKey = ta.TaskKey OR ti.DetailTaskKey = ta.TaskKey)
	AND   (ta.AssignedServiceKey is null OR ti.ServiceKey = ta.AssignedServiceKey)

	UPDATE #tTask  
	SET    #tTask.ActualHours = ISNULL(  
       (SELECT SUM(ti.ActualHours) FROM #tTime ti   
       WHERE (ti.TaskKey = #tTask.TaskKey OR ti.DetailTaskKey = #tTask.TaskKey) AND (#tTask.AssignedServiceKey is null OR ti.ServiceKey = #tTask.AssignedServiceKey))   
       ,0)  
END  

       
UPDATE #tTask
SET #tTask.RemainingHours = ISNULL(#tTask.AssignedHours, 0) - ISNULL(#tTask.ActualHours, 0)

-- And final query
SELECT t.* 
	,ISNULL(c.CustomerID, '''') as ClientID
	,c.CompanyName as ClientName
	,c.Phone,c.CustomerID + '-' + c.CompanyName as ClientFullName   

    ,p.ProjectNumber
    ,p.ProjectName
    ,p.ProjectNumber + '-' + p.ProjectName AS ProjectFullName

    ,cp.CampaignID
    ,cp.CampaignName
    ,cp.CampaignID + '-' + cp.CampaignName AS CampaignFullName
 
	,cu.FirstName + ' ' + cu.LastName as PrimaryContact
	,cu.Phone1, cu.Email   
    ,am.FirstName + ' ' + am.LastName AS AccountManagerName
   
    ,rd.DeliverableName
    ,tu.DeliverableKey
    -- these keys were in original query
    ,p.ClientKey
    ,p.BillingContact

	,Case @RateLevel 
	When 1 then ISNULL(s.Description1, s.Description)
	When 2 then ISNULL(s.Description2, s.Description)
	When 3 then ISNULL(s.Description3, s.Description)
	When 4 then ISNULL(s.Description4, s.Description)
	When 5 then ISNULL(s.Description5, s.Description)
	else s.Description
	end as ServiceDescription
	
	,s.ServiceCode
    ,cf.*
    ,cf2.*
    
    -- if you modify this field, also modify sptAppFavoriteGetList
	,(select Count(*) from tActivity a (nolock)
	left outer join (Select * from tAppRead (nolock) Where UserKey = @UserKey) as ar on a.ActivityKey = ar.EntityKey and ar.Entity = 'tActivity'
	Where a.ActivityEntity = 'Diary' and a.TaskKey = t.TaskKey and ISNULL(ar.IsRead, 0) = 0) +

	(select Count(*) from tSpecSheet ss (nolock)
	left outer join (Select * from tAppRead (nolock) Where UserKey = @UserKey) as ar on ss.SpecSheetKey = ar.EntityKey and ar.Entity = 'tSpecSheet'
	Where ss.EntityKey = t.ProjectKey and ss.Entity = 'Project' and ISNULL(ar.IsRead, 0) = 0) as UpdateCount  
	 
 from #tTask t (nolock)
 INNER JOIN tProject p (nolock) ON t.ProjectKey = p.ProjectKey   
 INNER JOIN tTaskUser tu (nolock) ON t.TaskUserKey = tu.TaskUserKey
 LEFT OUTER JOIN tCampaign cp (nolock) ON cp.CampaignKey = t.CampaignKey   
 LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey   
 LEFT OUTER JOIN tUser cu (nolock) ON p.BillingContact = cu.UserKey   
 LEFT OUTER JOIN tUser am (nolock) on p.AccountManager = am.UserKey
 LEFT OUTER JOIN tService s (nolock) on t.ServiceKey = s.ServiceKey
 LEFT OUTER JOIN #tCustomFields cf (nolock) ON t.CustomFieldKey = cf.CustomFieldKey
 LEFT OUTER JOIN #tCustomFields2 cf2 (nolock) ON p.CustomFieldKey = cf2.CustomFieldKey
 LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey
 WHERE t.TaskUserKey NOT IN (Select ActionKey From tAppFavorite (nolock) Where UserKey = @UserKey AND ActionID = 'today.creative.myTasks')

 if @IncludeActivities = 1
 
 BEGIN
 
	Select  a.*,
			ISNULL(a.StartTime, a.ActivityDate) as SortDate,
			p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
			case when t.TaskID is null then t.TaskName else t.TaskID + ' - ' + t.TaskName end as TaskFullName,
			u.FirstName + ' ' + u.LastName as AssignedUserName,
			a.ActivityTypeKey,
			p.ProjectNumber,
			p.ProjectName,
			t.TaskID,
			t.TaskName
	From tActivity a (nolock)
	inner join tActivityLink al (nolock) on a.ActivityKey = al.ActivityKey
	inner join #tTask t (nolock) on al.EntityKey = t.TaskKey and al.Entity = 'tTask'
	left outer join tUser u (nolock) on a.AssignedUserKey = u.UserKey
	left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	Where a.CompanyKey = @CompanyKey and Completed = 0
	AND	(@RestrictActivitiesToAssigned = 0 OR ISNULL(a.AssignedUserKey, 0) = 0 OR a.AssignedUserKey = @UserKey)
	Order By a.ActivityDate DESC, a.DateUpdated DESC
 END
   
RETURN 1
GO
