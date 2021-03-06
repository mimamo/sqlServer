USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGet]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGet]
	(
	@TaskUserKey int
	)
AS
	
  /*
  || When     Who Rel    What
  || 04/20/11 GWG 10.543 Addeded the restriction to only pick up budget tasks.
  || 06/05/15 MAS 10.580 (218643) Change tu.ServiceKey to s.ServiceKey as the query was returning multiple rows
  ||                    
  */
declare @TaskKey int, @BudgetTaskKey int
Select @TaskKey = ISNULL(TaskKey, 0) from tTaskUser (nolock) Where TaskUserKey = @TaskUserKey
Select @BudgetTaskKey = ISNULL(BudgetTaskKey, 0) from tTask (nolock) Where TaskKey = @TaskKey

if @BudgetTaskKey > 0 

	-- Used in the creation of new time entries when a task user key is passed in
	Select tu.UserKey, u.FirstName + ' ' + u.LastName as UserName, 
		tu.ServiceKey, s.Description as ServiceDescription,
		bt.TaskKey, bt.TaskID, bt.TaskName, t.TaskKey as DetailTaskKey,
		p.ProjectKey, p.ProjectNumber, p.ProjectName
	From tTaskUser tu (nolock)
		inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
		left outer join tTask bt (nolock) on t.BudgetTaskKey = bt.TaskKey
		inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tUser u (nolock) on tu.UserKey = u.UserKey
		-- left outer join tService s (nolock) on tu.ServiceKey = ISNULL(tu.ServiceKey, u.DefaultServiceKey)
		left outer join tService s (nolock) on tu.ServiceKey = ISNULL(s.ServiceKey, u.DefaultServiceKey)
	Where tu.TaskUserKey = @TaskUserKey

else
	-- Used in the creation of new time entries when a task user key is passed in
	Select tu.UserKey, u.FirstName + ' ' + u.LastName as UserName, 
		tu.ServiceKey, s.Description as ServiceDescription,
		p.ProjectKey, p.ProjectNumber, p.ProjectName
	From tTaskUser tu (nolock)
		inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
		inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
		left outer join tUser u (nolock) on tu.UserKey = u.UserKey
		-- left outer join tService s (nolock) on tu.ServiceKey = ISNULL(tu.ServiceKey, u.DefaultServiceKey)
		left outer join tService s (nolock) on tu.ServiceKey = ISNULL(s.ServiceKey, u.DefaultServiceKey)
	Where tu.TaskUserKey = @TaskUserKey
GO
