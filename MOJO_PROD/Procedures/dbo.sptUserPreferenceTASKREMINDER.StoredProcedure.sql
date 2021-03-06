USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserPreferenceTASKREMINDER]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserPreferenceTASKREMINDER]

	@UserKey int,
	@Value int,
	@Value2 int

AS --Encrypt

/*
|| When     Who Rel	     What
|| 3/21/11  RLB 10.5.4.2 (105269) added for Task Reminder notifications
|| 5/14/12  RLB 10.5.5.6 (132477) Pull at tasks within the range instead of ones that just have To Do's and just pull User's and Unassigned To Do's
|| 2/28/13  RLB 10.5.6.5 (169681) Checking Task User PercComp not Task also only pull tasks for the users passed in
*/

-- Value or Mode
-- 1 = My Assigned Tasks on Active Projects
-- 2 = All Tasks on Active Projects I am Assigned to 
-- 3 = All Tasks on Active Projects I am Account Manager

-- Value2
-- 0 Due on or Before Today
-- 3 Due in next 3 days
-- 7 Due in next 7 days
-- 14 Due in next 14 days 

DECLARE @StartDate DATETIME, @EndDate DATETIME

select @StartDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)

select @EndDate = @StartDate


if @Value = 1
BEGIN
	if @Value2 = 0
	BEGIN
		--Get all Projects and complete task data, this is repeated in each section
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0) = 0 and tu.UserKey = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		--Get All Task User for the tasks, this is repeated in each section
		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		--Get all Todo's on those Tasks, this is repeated in each section
		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and tu.UserKey = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)

	END	

	if @Value2 = 3
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and tu.UserKey = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END
		
	if @Value2 = 7
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed= 0 and tu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END	

	if @Value2 = 14
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and tu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and tu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END


END	

if @Value = 2
BEGIN
	if @Value2 = 0
	BEGIN
		--Get all Projects and complete task data, this is repeated in each section
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		--Get All Task User for the tasks, this is repeated in each section
		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		--Get all Todo's on those Tasks, this is repeated in each section
		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and pu.UserKey = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)

	END	

	if @Value2 = 3
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and pu.UserKey = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END	

	if @Value2 = 7
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and pu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END	

	if @Value2 = 14
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and pu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			inner join tAssignment pu (nolock) on t.ProjectKey = pu.ProjectKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and pu.UserKey = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END	
END

if @Value = 3
BEGIN
	if @Value2 = 0
	BEGIN
		--Get all Projects and complete task data, this is repeated in each section
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		--Get All Task User for the tasks, this is repeated in each section
		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		--Get all Todo's on those Tasks, this is repeated in each section
		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and p.AccountManager = @UserKey and t.PlanComplete  <= @EndDate
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END
		
	if @Value2 = 3
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and p.AccountManager = @UserKey and  t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 4, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END

	if @Value2 = 7
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and p.AccountManager = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 8,@EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)
	END	

	if @Value2 = 14
	BEGIN
		select		p2.ProjectKey,
			p2.ProjectNumber + '-' + p2.ProjectName as FullProjectName,
			t2.TaskKey, 
			ISNULL(t2.TaskID, '') + '-' + ISNULL(t2.TaskName, '') as FullTaskName,
			t2.Description,
			t2.PercComp,
			
			t2.PlanComplete as DueDate,
			t2.ProjectOrder
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tProject p2 (nolock) on Data.ProjectKey = p2.ProjectKey
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		order by DueDate, FullProjectName, t2.ProjectOrder

		select	t2.TaskKey,
		u2.UserKey, 
		u2.FirstName,
		u2.LastName	
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			left outer join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and ISNULL(a.Completed, 0)= 0 and p.AccountManager = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		left outer join tTaskUser tu2 (nolock) on t2.TaskKey = tu2.TaskKey and tu2.UserKey = @UserKey
		left outer join tUser u2 (nolock) on tu2.UserKey = u2.UserKey
		order by t2.TaskKey,t2.ProjectOrder

		select	t2.TaskKey,
		a2.ActivityKey,
		a2.Subject,
		a2.AssignedUserKey
			
		from (
			select t.ProjectKey, t.TaskKey
			from tTask t (nolock)
			inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			inner join tActivity a (nolock) on t.TaskKey = a.TaskKey and a.ActivityEntity = 'ToDo'
			left outer join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
			where p.Active = 1 and tu.PercComp < 100 and t.TaskType = 2 and a.Completed = 0 and p.AccountManager = @UserKey and t.PlanComplete  >= @StartDate  and  t.PlanComplete < DATEADD(d, 15, @EndDate)
			group by t.ProjectKey, t.TaskKey
		) as Data
		inner join tTask t2 (nolock) on Data.TaskKey = t2.TaskKey
		inner join tActivity a2(nolock) on t2.TaskKey = a2.TaskKey
		where a2.AssignedUserKey = @UserKey or ISNULL(a2.AssignedUserKey, 0) = 0
		order by t2.TaskKey,t2.ProjectOrder, ISNULL(a2.AssignedUserKey, 0), ISNULL(a2.DisplayOrder, 0)

	END
END		
return 1
GO
