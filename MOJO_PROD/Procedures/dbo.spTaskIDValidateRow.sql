USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskIDValidateRow]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTaskIDValidateRow]
	 @CompanyKey int
	,@ProjectNumber varchar(50)
	,@TaskID varchar(30)
	,@UserKey int
	,@TimeAllTasks tinyint
 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/12/06 RTC 8.40  Added TimeAllTasks parameter to handle users who have the right to enter time on any task.
  || 12/13/06 RTC 8.40  Added logic to handle a user being assigned to tracking tasks below a summary budget task.
  || 12/21/06 RTC 8.40  Return task info even when the user is not assigned to the task or it's budget task in case
  ||                    the task allows anyone to charge time to it.
  || 9/12/07  CRG 8.5   Modified to pass in the ProjectNumber rather than the ProjectKey.
  */
  
	declare @TaskKey int
	declare @BudgetTaskKey int
	declare @ProjectKey int

	SELECT	@ProjectKey = p.ProjectKey
	FROM	tProject p (nolock) 
	INNER JOIN tAssignment a (nolock) ON p.ProjectKey = a.ProjectKey
	WHERE	p.CompanyKey = @CompanyKey
	AND		a.UserKey = @UserKey 
	AND		UPPER(p.ProjectNumber) = UPPER(@ProjectNumber)
	
	--If the ProjectNumber is not valid, do not return a row
	IF @ProjectKey IS NULL
		return 1

	select @TaskKey = TaskKey
		  ,@BudgetTaskKey = TaskKey
	from tTask (nolock)
	where ProjectKey = @ProjectKey
	and upper(TaskID) = upper(@TaskID)
	
	--if task id is not valid for the project, do not return a row
	if @TaskKey is null
		return 1

	--if user can assign time to any task, no need to verify assignment
	if @TimeAllTasks = 1
		select *
			  ,@UserKey as UserKey
		from tTask t (nolock) 
		where TaskKey = @TaskKey
	else
		--is user assigned to the budget tracking task?
		begin
			if exists(select UserKey 
					  from tTaskUser (nolock) 
					  where TaskKey = @TaskKey
					  and UserKey = @UserKey)
				begin
					select *
						  ,@UserKey as UserKey
					from tTask t (nolock) 
					where TaskKey = @TaskKey
				end
			else
				--is the user assigned to a task that has this task as it's budget tracking task?
				begin
					if exists(select UserKey 
							  from tTaskUser tu (nolock) inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
							  where t.BudgetTaskKey = @BudgetTaskKey
							  and tu.UserKey = @UserKey)
						begin
							select *
								  ,@UserKey as UserKey
							from tTask t (nolock) 
							where TaskKey = @TaskKey
						end
					else
						-- the user is not assigned to the task or it's budget task, return it in case the task allows anyone to charge time to it
						begin
							select *
								  ,-1 as UserKey
							from tTask t (nolock) 
							where TaskKey = @TaskKey
						end
				end
		end

 return 1
GO
