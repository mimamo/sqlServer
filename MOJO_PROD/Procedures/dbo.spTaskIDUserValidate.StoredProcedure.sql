USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskIDUserValidate]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTaskIDUserValidate]
 @TaskID varchar(30),
 @ProjectKey int,
 @UserKey int
 
AS --Encrypt

/*
|| When     Who Rel   What
|| 12/14/06 RTC 8.40  Added logic to handle a user being assigned to tracking tasks below a summary budget task.
|| 11/05/14  RLB 10.5.8.6 Added changes for Abelson Taylor Enhancement AnyoneChargeTime
|| 11/12/14 RLB 10.5.8.6 removed check for AnyoneChargeTime will use AllowAnyone instead
*/
  
declare @TaskKey int
declare @BudgetTaskKey int
declare @AllowAnyone tinyint


	select @TaskKey = TaskKey
		  ,@BudgetTaskKey = TaskKey
		  ,@AllowAnyone = isnull(AllowAnyone, 0)
	from tTask (nolock)
	where ProjectKey = @ProjectKey
	and upper(TaskID) = upper(@TaskID)
	and  TrackBudget = 1

	-- if not a valid task ID and a budget tracking task, return error
	if @TaskKey is null
		return -1

	-- is this a task for anybody to use?	
	if @AllowAnyone = 1 
		return @TaskKey 

	-- check if user is assigned to it or it is the budget tracking task for one of it's children
	if exists(select UserKey 
				from tTaskUser (nolock) 
				where TaskKey = @TaskKey
				and UserKey = @UserKey)
		 return @TaskKey
	else
		--is the user assigned to a task that has this task as it's budget tasking task?
		if exists(select UserKey 
					from tTaskUser tu (nolock) inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
					where t.BudgetTaskKey = @BudgetTaskKey
					and tu.UserKey = @UserKey)
			return @TaskKey

	-- if we have not returned before here, no match was found, it is invalid
	return -1
GO
