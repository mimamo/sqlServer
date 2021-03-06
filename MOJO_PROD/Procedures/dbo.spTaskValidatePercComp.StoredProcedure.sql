USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskValidatePercComp]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskValidatePercComp]
	(
	@Entity varchar(50), -- 'tTime', 'tMiscCost', 'tPurchaseOrderDetail', 'tVoucherDetail', 'tExpenseReceipt' 
	@EntityKey int,
	@EntityGUID UniqueIdentifier,
	@NewProjectKey int,
	@NewTaskID varchar(50),
	@NewTaskKey int = null,
	@UserKey int = null,
	@TrackBudget int = 1
	)
AS
	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 11/04/09  GHL 10.5.1.3 (47035) Created to handle the locking of tasks which are 100% complete
||                        This sp is designed to be used from VB/Flex with @NewProjectKey/@NewTaskID
||                        or another sp with @NewTaskKey 
||
||                        If we have the right to do so, no need to check for 100% complete 
||
||                        - On an Insert, we cannot enter transactions against a NEW task which is 100% complete
||
||                        - On an Update, we cannot enter transactions if either one of the OLD task or NEW task
||                        is 100% complete AND the tasks are different
||
||                        - On an Update, we may enter transactions if the 2 tasks are the same
||                        regardless of the 100% complete
||
||                        Parameters:
||                        @Entity           -- entity to determine right (time or expense) and old task 
||                        @EntityKey        -- transaction key to determine old task
||                        @EntityGUID       -- TimeKey to determine old task
||                        @NewProjectKey    -- New project
||                        @NewTaskID        -- New Task ID
||                        @NewTaskKey       -- OR New Task Key
||                        @UserKey          -- To get his rights
||                        @TrackBudget      -- By default, we look for budget tasks 
||
||                        This stored procedure can be used to validate a Task ID and check tTask.PercComp
||                        OR simply check tTask.PercComp if you pass a valid @NewTaskKey
||
||                        Returns:
||                        >0 = TaskKey, Valid Task
||                        -1 Invalid Task
||                        -2 New Task is 100% complete
||                        -3 Old Task is 100% complete
||
|| 11/30/09 GHL 10.514    (69313) Return now NewTaskKey = 0 if the company does not require tasks on expenses
||                         i.e. if both @NewTaskKey is null and @NewTaskID is null
*/
	
	declare @SecurityGroupKey int
	declare @Administrator int
	declare @HasRight int
    declare @OldPercComp int
	declare @NewPercComp int
	declare @OldTaskKey int
	declare @OldBudgetTaskKey int
	declare @NewBudgetTaskKey int
	declare @InsertMode int
	
	if isnull(@EntityKey, 0) > 0 Or @EntityGUID is not null
		select @InsertMode  = 0
	else
		select @InsertMode  = 1
	
	select @HasRight = 1 
	if @UserKey is not null
	begin
	
		select @SecurityGroupKey = SecurityGroupKey
		       ,@Administrator = Administrator
		from   tUser (nolock)
		where  UserKey = @UserKey
		
		if @Administrator = 0
		begin
			if @Entity = 'tTime'
			begin
				-- Labor
				if exists (select 1 from tRight r (nolock)
						inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
						where ra.EntityType = 'Security Group'
						and   ra.EntityKey = @SecurityGroupKey
						and   r.RightID = 'prjTimeCompletedTask')
					select @HasRight = 1
				else
					select @HasRight = 0
			end		
			else if @Entity <> 'All'
			-- Expenses
			begin
				if exists (select 1 from tRight r (nolock)
						inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
						where ra.EntityType = 'Security Group'
						and   ra.EntityKey = @SecurityGroupKey
						and   r.RightID = 'prjExpenseCompletedTask')
					select @HasRight = 1
				else
					select @HasRight = 0
			end
			else
			-- Must check labor and Expenses
			begin
				if exists (select 1 from tRight r (nolock)
						inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
						where ra.EntityType = 'Security Group'
						and   ra.EntityKey = @SecurityGroupKey
						and   r.RightID = 'prjTimeCompletedTask')
				and
					exists (select 1 from tRight r (nolock)
						inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
						where ra.EntityType = 'Security Group'
						and   ra.EntityKey = @SecurityGroupKey
						and   r.RightID = 'prjExpenseCompletedTask')
					select @HasRight = 1
				else
					select @HasRight = 0
			end	-- entity
		end -- not and admin	
	end -- UserKey not null
	
		
	if @HasRight = 1
	begin
		-- If nothing to validate, return 0, that would be companies which do not require tasks
		if @NewTaskKey is null And @NewTaskID is null
			return 0
		
		if @NewTaskKey is null
			select @NewTaskKey = TaskKey
			from   tTask (nolock)
			where  ProjectKey = @NewProjectKey
			and    UPPER(TaskID) = UPPER(@NewTaskID)
			-- if @TrackBudget = 0, we query all tasks
			-- if @TrackBudget = 1, we query budget tasks only
		    and    TrackBudget >= @TrackBudget  
		    
		if @NewTaskKey is null
			return -1
		else
			return @NewTaskKey
	end

	-- at this point, we know we do not have rights
	
	if @InsertMode  = 0
	begin
		if @Entity = 'tTime'
			select @OldTaskKey = TaskKey from tTime (nolock) where TimeKey = @EntityGUID
		else if @Entity = 'tMiscCost'
			select @OldTaskKey = TaskKey from tMiscCost (nolock) where MiscCostKey = @EntityKey
		else if @Entity = 'tPurchaseOrderDetail'
			select @OldTaskKey = TaskKey from tPurchaseOrderDetail (nolock) where PurchaseOrderDetailKey = @EntityKey
		else if @Entity = 'tVoucherDetail'
			select @OldTaskKey = TaskKey from tVoucherDetail (nolock) where VoucherDetailKey = @EntityKey
		else if @Entity = 'tExpenseReceipt'
			select @OldTaskKey = TaskKey from tExpenseReceipt (nolock) where ExpenseReceiptKey = @EntityKey
	
		select @OldTaskKey = isnull(@OldTaskKey, 0)
				
		select @OldPercComp = isnull(PercComp, 0)
		      ,@OldBudgetTaskKey = isnull(BudgetTaskKey, 0)
		from   tTask (nolock)
		where  TaskKey = @OldTaskKey
		
		select @OldBudgetTaskKey = isnull(@OldBudgetTaskKey, 0)
		
		if @OldBudgetTaskKey > 0 and @OldBudgetTaskKey <> @OldTaskKey  
			select @OldPercComp = isnull(PercComp, 0)
		    from   tTask (nolock)
			where  TaskKey = @OldBudgetTaskKey
		
	end

	-- In insert mode, we may not have any old task, it would be null, so cleanup the nulls
	select @OldPercComp = isnull(@OldPercComp, 0)	 
			 
	if @NewTaskKey is null		
	begin 
	    if @NewTaskID is not null
	    begin
			select @NewPercComp = isnull(PercComp, 0)
				  ,@NewTaskKey = TaskKey
				  ,@NewBudgetTaskKey = isnull(BudgetTaskKey, 0)
			from   tTask (nolock)
			where  ProjectKey = @NewProjectKey
			and    UPPER(TaskID) = UPPER(@NewTaskID)
			-- if @TrackBudget = 0, we query all tasks
			-- if @TrackBudget = 1, we query budget tasks only
			and    TrackBudget >= @TrackBudget  
    
    		if isnull(@NewTaskKey, 0) = 0
				-- no matter the other conditions, exit out if we cannot find the task from the task ID
				return -1
    
        end
        
        --if @NewTaskID is null,  @NewTaskKey will remain null and we will return isnull(@NewTaskKey, 0) i.e. 0
        
    end
	else
		select @NewPercComp = isnull(PercComp, 0)
		      ,@NewBudgetTaskKey = isnull(BudgetTaskKey, 0)
		from   tTask (nolock)
		where  TaskKey = @NewTaskKey
	
	select @NewTaskKey = isnull(@NewTaskKey, 0)
	select @NewBudgetTaskKey = isnull(@NewBudgetTaskKey, 0)
		
	if @NewBudgetTaskKey > 0 and @NewBudgetTaskKey <> @NewTaskKey  
		select @NewPercComp = isnull(PercComp, 0)
	    from   tTask (nolock)
		where  TaskKey = @NewBudgetTaskKey
		
	-- cleanup
	select @NewPercComp = isnull(@NewPercComp, 0)
	
		
	-- at this point, we found a task that matches our task ID
	
	-- if in Insert mode, just check the percent complete of the new task only
 	if @InsertMode = 1
	begin
		if @NewPercComp >= 100
			return -2
		else
			return @NewTaskKey			
	end 	
			 
	-- at this point, we know that we are in Update mode
	
	-- if the tasks have not changed, return the task key
	if @OldTaskKey = @NewTaskKey
		return @NewTaskKey
	
	-- at this point, we know that we are in Update mode AND the tasks are different	
	
	-- if either one is 100% complete, exit out with an error
	if @OldPercComp >= 100 Or @NewPercComp >= 100
	begin
		if @NewPercComp >= 100
			return -2
		else
			return -3
	end
	else
		return @NewTaskKey			
	
						 
	return -1
GO
