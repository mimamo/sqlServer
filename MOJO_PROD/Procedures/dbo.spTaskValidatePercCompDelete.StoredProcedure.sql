USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spTaskValidatePercCompDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTaskValidatePercCompDelete]
	(
	@Entity varchar(50), -- 'tTime', 'tMiscCost', 'tPurchaseOrderDetail', 'tVoucherDetail', 'tExpenseReceipt' 
	@EntityKey int,
	@EntityGUID UniqueIdentifier,
	@UserKey int = null 
	)
AS
	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 11/04/09  GHL 10.5.1.3 (47035) Created to handle the locking of tasks which are 100% complete
||                        This sp is designed to be used from VB/Flex with @ProjectKey/@TaskID
||                        or another sp with @TaskKey 
||
||                        - On a Delete we cannot enter transactions against a task which is 100% complete
||
||                        Returns:
||                        1 = OK to delete
||                        -1 = Cannot delete, old Task is 100% complete, and user has no rights to charge
*/
	
	declare @SecurityGroupKey int
	declare @Administrator int
	declare @HasRight int
	declare @TaskKey int
    declare @PercComp int
	declare @BudgetTaskKey int
	
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
			else 
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
		end -- not and admin	
	end -- UserKey not null
		
	if @HasRight = 1
		return 1
	
	if @Entity = 'tTime'
		select @TaskKey = TaskKey from tTime (nolock) where TimeKey = @EntityGUID
	else if @Entity = 'tMiscCost'
		select @TaskKey = TaskKey from tMiscCost (nolock) where MiscCostKey = @EntityKey
	else if @Entity = 'tPurchaseOrderDetail'
		select @TaskKey = TaskKey from tPurchaseOrderDetail (nolock) where PurchaseOrderDetailKey = @EntityKey
	else if @Entity = 'tVoucherDetail'
		select @TaskKey = TaskKey from tVoucherDetail (nolock) where VoucherDetailKey = @EntityKey
	else if @Entity = 'tExpenseReceipt'
		select @TaskKey = TaskKey from tExpenseReceipt (nolock) where ExpenseReceiptKey = @EntityKey

					
	if @TaskKey is null		
		return 1
		
	select @PercComp = isnull(PercComp, 0)
	      ,@BudgetTaskKey = isnull(BudgetTaskKey, 0)
	from   tTask (nolock)
	where  TaskKey = @TaskKey
						
	select @BudgetTaskKey = isnull(@BudgetTaskKey, 0)
	
	if @BudgetTaskKey > 0 and @BudgetTaskKey <> @TaskKey  
		select @PercComp = isnull(PercComp, 0)
	    from   tTask (nolock)
		where  TaskKey = @BudgetTaskKey
			
	select @PercComp = isnull(@PercComp, 0)	 
			 
	if @PercComp >= 100
		return -1
	else
		return 1
GO
