USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskIDValidateTime]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTaskIDValidateTime]

	 @TaskID varchar(30)
	,@ProjectKey int
	,@UserKey int
	,@AllTasksRight tinyint
 
as --Encrypt

declare @TaskKey int
declare @AllowAnyone tinyint
declare @ReturnTaskKey int
 
	select @TaskKey = TaskKey
	      ,@AllowAnyone = isnull(AllowAnyone,0)
	from tTask (nolock)
	where ProjectKey = @ProjectKey
	and upper(TaskID) = upper(@TaskID)
	and TrackBudget = 1 
	
	if isnull(@TaskKey,0) > 0
		-- does the user have the security right to enter time even if not assigned to the task?
		if @AllTasksRight = 1
			select @ReturnTaskKey = @TaskKey
		else
			-- does the task allow anyone (i.e. not assigned) to enter time for this task?
			if @AllowAnyone = 1
				select @ReturnTaskKey = @TaskKey
			else
				-- is the user assigned to the budget task?
				if exists(select 1 from tTaskUser (nolock) where TaskKey = @TaskKey and UserKey = @UserKey)
					select @ReturnTaskKey = @TaskKey
				else
					-- is the user assigned to one of the budget tasks subtasks?
					if exists(select 1 from tTask t (nolock) inner join tTaskUser tu (nolock) on t.TaskKey = tu.TaskKey
					          where t.BudgetTaskKey = @TaskKey
					          and tu.UserKey = @UserKey)
						select @ReturnTaskKey = @TaskKey
	else
		-- not a valid budget tracking task for this project
		return -1

	if @ReturnTaskKey is not null
		select *
		from tTask (nolock)
		where TaskKey = @ReturnTaskKey
	else
		-- not a valid budget tracking task for this project
		return -1
GO
