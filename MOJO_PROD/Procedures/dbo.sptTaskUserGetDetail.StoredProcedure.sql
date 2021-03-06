USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetDetail]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetDetail]

	(
		@TaskUserKey int,
		@Type smallint
	)
AS

/*
|| When      Who Rel      What
|| 01/28/14  RLB 10.5.7.7 Created for the new assignment page
|| 04/10/14  GWG 10.5.7.9 Added Counts
|| 01/13/14  MAS 10.5.8.8 (242143)Added security to check if the user has the prjViewOtherToDos right.
|| 01/19/14  MAS 10.5.8.8 (242794)Added ShowActualHours from tPref to help calculate the correct hours remaining 
||                        matching what we're doing in sptTaskUserGetTaskList and sptTaskUserGetTaskList2
*/


	declare @TaskKey int, @UserKey int, @Hrs as decimal(24,4), @CompanyKey as int, @ProjectKey as int, @ShowActualHours as int

	Select @TaskKey = TaskKey, @UserKey = UserKey from tTaskUser (nolock) Where TaskUserKey = @TaskUserKey

	Select @ProjectKey = ProjectKey from tTask (nolock) where TaskKey =  @TaskKey

	Select @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ProjectKey
	Select @ShowActualHours = ISNULL(ShowActualHours, 0) From tPreference (nolock) Where  CompanyKey = @CompanyKey
	
	if @Type = 1
	BEGIN
		-- Select @Hrs = ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where TaskKey = @TaskKey and (@UserKey is null OR UserKey = @UserKey)
		IF @ShowActualHours = 1	
			SELECT @Hrs = ISNULL(SUM(ti.ActualHours),0)	FROM tTime ti (nolock) WHERE (ti.TaskKey = @TaskKey OR ti.DetailTaskKey = @TaskKey)
		ELSE
			BEGIN
				SELECT @Hrs = ISNULL(SUM(ti.ActualHours),0)	
				FROM tTime ti (nolock) 
				Join tTaskUser tu (nolock) on ti.TaskKey = tu.TaskKey
				WHERE (ti.TaskKey = @TaskKey OR ti.DetailTaskKey = @TaskKey) 
				AND (tu.ServiceKey is null OR ti.ServiceKey = tu.ServiceKey)
			END  

		-- Get the assignment details
		Select tu.*, s.Description as Service,
			t.TaskKey as DetailTaskKey, t.TaskID as DetailTaskID, t.TaskName as DetailTaskName, t.PlanStart as TaskPlanStart, t.PlanComplete as TaskPlanComplete, t.Description as TaskDescription, t.Comments as TaskStatusComments, t.TaskID + ' - ' + t.TaskName as FullTaskName,
			DateDiff(d, GETDATE(), t.PlanComplete) as DaysRemaining, DateDiff(d,  t.PlanStart, t.PlanComplete) as TotalDays,
			bt.BudgetTaskKey, bt.TaskID as BudgetTaskID, bt.TaskName as BudgetTaskName,
			st.TaskName as SummaryTaskName, 
			p.ProjectKey, p.ProjectNumber, p.ProjectName, p.ProjectNumber + ' - ' + p.ProjectName as FullProjectName, c.CustomerID, c.CompanyName,rd.DeliverableName, rd.Description as DeliverableDescription,
			@Hrs as ActualHours, ISNULL(tu.Hours, 0) - @Hrs as HoursRemaining, un.UserFullName
			, (Select COUNT(*) FROM tSpecSheet (NOLOCK) WHERE EntityKey = p.ProjectKey and Entity = 'Project') as SpecSheetCount
			, (Select COUNT(*) from tReviewDeliverable (NOLOCK) Where ProjectKey = p.ProjectKey) as DeliverableCount
			, (Select COUNT(*) FROM tSpecSheet ss (NOLOCK) 
				left outer join (Select * from tAppRead (nolock) Where UserKey = @UserKey and Entity = 'tSpecSheet') as ar on ss.SpecSheetKey = ar.EntityKey
					WHERE ss.EntityKey = p.ProjectKey and ss.Entity = 'Project' and ISNULL(ar.IsRead, 0) = 0) as UnreadSpecSheetCount
		From tTaskUser tu (nolock)
			inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
			left outer join tTask st (nolock) on t.SummaryTaskKey = st.TaskKey
			left outer join tTask bt (nolock) on t.BudgetTaskKey = bt.TaskKey
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tCompany c (nolock) on p.ClientKey = c.CompanyKey
			left outer join tService s (nolock) on tu.ServiceKey = s.ServiceKey
			left outer join vUserName un (nolock) on tu.UserKey = un.UserKey
			LEFT OUTER JOIN tReviewDeliverable rd (nolock) on tu.DeliverableKey = rd.ReviewDeliverableKey
		Where tu.TaskUserKey = @TaskUserKey
	END

	if @Type = 2
		BEGIN
			declare @SecurityGroupKey int, @Administrator tinyint
			Select @SecurityGroupKey = SecurityGroupKey,  @Administrator = ISNULL(Administrator, 0) from tUser Where UserKey = @UserKey
			
			if ((@Administrator = 1) OR exists (Select 1 from tRightAssigned (nolock) Where RightKey = 90933 and EntityType = 'Security Group' and EntityKey = @SecurityGroupKey))
				begin
					-- get any to do's for the assignment
					Select a.ActivityKey, a.ProjectKey, a.TaskKey, a.Subject, a.Notes,a.Completed,a.AssignedUserKey,a.ActivityDate, ISNULL(un.UserFullName, 'Not Assigned') as UserFullName,
					a.RootActivityKey,a.ActivityTypeKey,a.VisibleToClient
					From tActivity a (nolock) 
					left outer join vUserName un (nolock) on a.AssignedUserKey = un.UserKey
					Where ActivityEntity = 'ToDo' 
					and TaskKey = @TaskKey
					and  ParentActivityKey = 0
					Order By un.UserFullName, a.Completed, a.ActivityKey
				end
			else
				begin
					-- get any to do's for the assignment
					Select a.ActivityKey, a.ProjectKey, a.TaskKey, a.Subject, a.Notes,a.Completed,a.AssignedUserKey,a.ActivityDate, ISNULL(un.UserFullName, 'Not Assigned') as UserFullName,
					a.RootActivityKey,a.ActivityTypeKey,a.VisibleToClient
					From tActivity a (nolock) 
					left outer join vUserName un (nolock) on a.AssignedUserKey = un.UserKey
					Where ActivityEntity = 'ToDo' 
					and TaskKey = @TaskKey
					and  ParentActivityKey = 0
					and  (ISNULL(a.AssignedUserKey, 0) = 0 OR a.AssignedUserKey = @UserKey)
					Order By un.UserFullName, a.Completed, a.ActivityKey
				end

		END


	if @Type = 3
	BEGIN
		-- get any specific diary post
		Select a.ActivityKey, a.ProjectKey, a.TaskKey, a.Subject, a.Notes, a.Completed
		From tActivity a (nolock) Where ActivityEntity = 'Diary' and TaskKey = @TaskKey
		Order By a.DateUpdated DESC

		Select * from tAttachment (nolock) Where AssociatedEntity = 'tActivity' and EntityKey in (select ActivityKey From tActivity a (nolock) Where ActivityEntity = 'ToDo' and TaskKey = @TaskKey)

		Select * from tAttachment (nolock) Where AssociatedEntity = 'tTask' and EntityKey = @TaskKey

	END
GO
