USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTimeInsertFixTaskKeys]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTimeInsertFixTaskKeys]
	(
	@ProjectKey INT,
	@TaskKey INT OUTPUT,
	@DetailTaskKey INT OUTPUT
	)
AS --Encrypt

/*
|| When      Who Rel	What
|| 08/11/08  GHL 10.006 Creation to put in one place the validation of tasks, 
||                      this should solve the following issues:
||                      (9657) Added validation to ensure DetailTaskKey is still valid for the ProjectKey.
||                      (24776) Added similar validation to ensure that DetailTaskKey valid for the budget task
||                      These 2 issues above happen when an approver of a timesheet change task or project 
||                      (30569) Catch situations where TaskKey is null and DetailTaskKey is not null
||
||                      Also Updating now DetailTaskKey whenever possible to help with the traffic screens
||                      In time entry, this is not updated but in one case (Task is a detail), that can be done
||
||                      Note: There is a case when the DetailTaskKey cannot be updated. This would be when a task
||                      is a summary task and the time entry is entered from the time sheet entry screen (not widgets)
*/

	SET NOCOUNT ON
	
	declare @BudgetTaskKey int
	declare @TaskType int
	declare @NewTaskKey int
	declare @NewDetailTaskKey int
	
	if @ProjectKey is null
	begin
		select @TaskKey = null
	          ,@DetailTaskKey = null
	
		return 1
	end
	
	-- by default, keep same values
	select @NewTaskKey = @TaskKey
	      ,@NewDetailTaskKey = @DetailTaskKey
	
	
	if @TaskKey is null
	begin
		if @DetailTaskKey is not null
			select @NewTaskKey = BudgetTaskKey
				   ,@TaskType = TaskType
			from   tTask (nolock)
			where  TaskKey = @DetailTaskKey			
	
		if @NewTaskKey is null and @TaskType = 2
		begin
			-- This is a detail task 
			select @NewTaskKey = @DetailTaskKey			
		end
		
	end	
	else
	begin
		select @TaskType = TaskType
		from   tTask (nolock)
		where  TaskKey = @TaskKey
		
		if @TaskType = 2
		begin
			-- This is a detail task 
			select @NewDetailTaskKey = @TaskKey			
		end
		else 
		begin
			-- This is a summary task
			-- check if detail and summary tasks match
			if @DetailTaskKey is not null
			begin
				select @BudgetTaskKey = BudgetTaskKey
				from   tTask (nolock)
				where  TaskKey = @DetailTaskKey			
			
				-- the budget task key from the detail should match the task key
				-- if not, reset the detail task key
				if ISNULL(@BudgetTaskKey, 0) <> ISNULL(@TaskKey, 0)
					select @NewDetailTaskKey = null
			end
					
		end
			
	end
	
	select @TaskKey = @NewTaskKey
		   ,@DetailTaskKey = @NewDetailTaskKey
	
	RETURN 1
GO
