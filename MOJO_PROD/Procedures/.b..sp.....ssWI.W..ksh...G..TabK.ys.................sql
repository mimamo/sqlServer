USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetGetTabKeys]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetGetTabKeys]
	(
	@ProjectKey int
	,@GroupBy int = 0					-- 0: Group by Task, 1: Group by Item
	,@StartDate smalldatetime = null
	,@EndDate smalldatetime = null
	,@TabIndex int
	,@Action int
	,@OrdersOnly int = 0
	)
	
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/16/13 GHL 10.567 Creation to support the tabs on the new billing screen in project central
||                     similar to spProcessWIPWorksheetGetTabDetails but this can handle several 
||                     tasks or entities. Called before billing, putting on hold, etc....
|| 04/26/13 GHL 10.567 Added OrdersOnly so that we can return the orders to close
|| 08/25/14 GHL 10.583 (227184) Changed the way we process #tProcWIPTransaction to speed up perfo
||                      split labor and expenses. Added ProjectKey to query. see below
|| 02/26/15 GHL 10.589 Added transferred adjustments for new tab (users must be able to change transfer dates)
*/

	SET NOCOUNT ON

	-- Index of tabs on the screen
	declare @kTabUnbilled int							select @kTabUnbilled = 0
	declare @kTabUnapproved int							select @kTabUnapproved = 1
	declare @kTabBilled int								select @kTabBilled = 2
	declare @kTabMarkedAsBilled int						select @kTabMarkedAsBilled = 3
	declare @kTabWriteOff int							select @kTabWriteOff = 4
	declare @kTabOnHold int								select @kTabOnHold = 5
	declare @kTabTransferred int						select @kTabTransferred = 6
	declare @kTabTransferredAdj int						select @kTabTransferredAdj = 7


	-- Billing Status in vProjectCosts
	declare @kBillingStatusUnapproved varchar(20)		select @kBillingStatusUnapproved = 'Unapproved'
	declare @kBillingStatusBilled varchar(20)			select @kBillingStatusBilled = 'Billed'
	declare @kBillingStatusUnbilled varchar(20)			select @kBillingStatusUnbilled = 'UnBilled'
	declare @kBillingStatusWriteOff varchar(20)			select @kBillingStatusWriteOff = 'Writeoff'
	-- this is a new one which I added to capture the transferred transactions
	declare @kBillingStatusTransferred varchar(20)		select @kBillingStatusTransferred = 'Transferred'
	declare @kBillingStatusTransferredAdj varchar(20)	select @kBillingStatusTransferredAdj = 'Adjusted'
	
	-- Types in vProjectCosts
	declare @kTypeLabor varchar(20)						select @kTypeLabor = 'LABOR'
	declare @kTypeExpenseReport varchar(20)				select @kTypeExpenseReport = 'EXPRPT'
	declare @kTypeMiscCost varchar(20)					select @kTypeMiscCost = 'MISCCOST'
	declare @kTypeVoucher varchar(20)					select @kTypeVoucher = 'VOUCHER'
	declare @kTypeOrder varchar(20)						select @kTypeOrder = 'ORDER'
	
	-- Types in proc wip 
	declare @kWIPLabor varchar(20)						select @kWIPLabor = 'Time'
	declare @kWIPExpenseReport varchar(20)				select @kWIPExpenseReport = 'Expense'
	declare @kWIPMiscCost varchar(20)					select @kWIPMiscCost = 'MiscExpense'
	declare @kWIPVoucher varchar(20)					select @kWIPVoucher = 'Voucher'
	declare @kWIPOrder varchar(20)						select @kWIPOrder = 'Order'
	
	-- Actions in wip
	declare @kWIPActionNone int							select @kWIPActionNone = -1 
	declare @kWIPActionBill int							select @kWIPActionBill = 1
	declare @kWIPActionMarkBilled int					select @kWIPActionMarkBilled = 2
	declare @kWIPActionWriteOff int						select @kWIPActionWriteOff = 0
	declare @kWIPActionHold int							select @kWIPActionHold = 3
	declare @kWIPActionUndoHold int						select @kWIPActionUndoHold = 4
	declare @kWIPActionTransfer int						select @kWIPActionTransfer = 5
	declare @kWIPActionUndoMarkBilled int				select @kWIPActionUndoMarkBilled = 6
	declare @kWIPActionUndoWriteOff int					select @kWIPActionUndoWriteOff = 7
	declare @kWIPActionTransferDate int					select @kWIPActionTransferDate = 8


	declare @kGroupByTask int							select @kGroupByTask = 0
	declare @kGroupByItem int							select @kGroupByItem = 1

	if @StartDate is null
		select @StartDate = '01/01/1900'
	if @EndDate is null
		select @EndDate = '01/01/2070'

	declare @CompanyKey int
	select @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ProjectKey

	declare @TaskKey int
	,@Entity varchar(20)
	,@EntityKey int

	/* Assume done in vb

	inputs are in: 
	sql = "create table #tProcWIPSummary ( "
            sql &= " TaskKey int null "
            sql &= ",Entity varchar(20) null " ' tItem or tService
            sql &= ",EntityKey varchar(50) null "
            sql &= ")"

	or
	sql = "create table #tProcWIPTransaction ( "
            sql &= "Entity varchar(20) null " ' same as from vProjectCosts.Type
            sql &= ",EntityKey varchar(50) null "
            sql &= ")"

     outputs will be in:
	 sql = "create table #tProcWIPKeys ( "
            sql &= "ProjectKey int null "
            sql &= ",EntityType varchar(20) null " -- This is the wip types
            sql &= ",EntityKey varchar(50) null "
            sql &= ",Action int null "
			sql &= ",InvoiceLineKey  int null"
			sql &= ",BillingID int null"
			sql &= ",WIPPostingInKey int null"
			sql &= ",WIPPostingOutKey int null"
            sql &= ")"

	*/


/*
in vProjectCosts:
Bill Status |Unapproved    WriteOff       Billed      Unbilled
--------------------------------------------------------------
Status      | <4           4              4           4
WriteOff    |              1              0           0
ILK         |                            >=0          null

In this SP:
Tab         | Unbilled     Unapproved     Billed      MarkedAsBilled     WO       OnHold       Transferred
----------------------------------------------------------------------------------------------------------
Bill Status | Unbilled     Unapproved     Billed       Billed           WriteOff
On Hold     | 0            0                                                      1
ILK         |                             >0            0          
TTK         |                                                                                  TTK > 0
            |
CanEdit     |If WIK = 0     If Not Order  No           No               No        No            No
            |And WOK = 0
			|And Not Order
*/

	-- handle [No Task] case
	update #tProcWIPSummary
	set    TaskKey = 0
    where  TaskKey = -1
	
	update #tProcWIPSummary
	set    TaskKey = isnull(TaskKey, 0)
	 
	--select * from #tProcWIPSummary
	--select * from #tProcWIPTransaction

	if @TabIndex = @kTabUnbilled
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusUnbilled and v.OnHold = 0

		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusUnbilled and v.OnHold = 0
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )

	end

	if @TabIndex = @kTabUnapproved
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusUnapproved and v.OnHold = 0
		
		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusUnapproved and v.OnHold = 0
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )

	end


	if @TabIndex = @kTabMarkedAsBilled
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusBilled and v.InvoiceLineKey = 0
		
		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusBilled and v.InvoiceLineKey = 0
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )
		
	end

	if @TabIndex = @kTabWriteOff
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusWriteOff
		
		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.BillingStatus = @kBillingStatusWriteOff
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )
		
	end

	if @TabIndex = @kTabOnHold
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.OnHold = 1
		
		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCosts v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.OnHold = 1
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )
		
	end

	if @TabIndex = @kTabTransferred
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCostsTransfer v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.WIPPostingInKey >= 0 -- do not take reversals 

		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCostsTransfer v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.WIPPostingInKey >= 0 -- do not take reversals 
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )
		
	end

	if @TabIndex = @kTabTransferredAdj
	begin
		if @GroupBy = @kGroupByTask

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCostsTransferAdj v
			inner join #tProcWIPSummary b on isnull(v.TaskKey, 0) = b.TaskKey
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.WIPPostingInKey >= 0 -- do not take reversals 

		else

		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, v.Type, v.TranKey, @Action, v.InvoiceLineKey, 0, v.WIPPostingInKey, v.WIPPostingOutKey 
		from   vProjectCostsTransferAdj v
			  ,#tProcWIPSummary b
		where  v.ProjectKey = @ProjectKey
		and    v.TransactionDate >= @StartDate
		and    v.TransactionDate <= @EndDate
		and    v.LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    v.WIPPostingInKey >= 0 -- do not take reversals 
		and	   isnull(v.ItemKey, 0) = b.EntityKey
		and    (
					(b.Entity = 'tService' and Type = @kTypeLabor)
					or
					(b.Entity = 'tItem' and Type <> @kTypeLabor) 			
		       )
		
	end


if @TabIndex not in ( @kTabTransferred, @kTabTransferredAdj)
begin
	if not exists (select 1 from #tProcWIPSummary)
	begin
		insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
		select @ProjectKey, Entity, EntityKey, @Action,0, 0, 0, 0
		from   #tProcWIPTransaction

		update #tProcWIPKeys
		set    #tProcWIPKeys.InvoiceLineKey = v.InvoiceLineKey
		       ,#tProcWIPKeys.WIPPostingInKey = v.WIPPostingInKey
			   ,#tProcWIPKeys.WIPPostingOutKey = v.WIPPostingOutKey
		from   vProjectCosts v
		where  #tProcWIPKeys.EntityType = v.Type collate database_default  
		and    #tProcWIPKeys.EntityKey = v.TranKey collate database_default  
	    and    #tProcWIPKeys.EntityType <> @kTypeLabor
		and    v.ProjectKey = @ProjectKey -- added for 227184
	
		-- separate query for tTime for 227184, seems to help to do a straight query in tTime vs vProjectCosts
		update #tProcWIPKeys
		set    #tProcWIPKeys.InvoiceLineKey = t.InvoiceLineKey
		       ,#tProcWIPKeys.WIPPostingInKey = t.WIPPostingInKey
			   ,#tProcWIPKeys.WIPPostingOutKey = t.WIPPostingOutKey
		from   tTime t (nolock)
		where  #tProcWIPKeys.EntityKey = cast(t.TimeKey as varchar(200)) collate database_default  
	    and    #tProcWIPKeys.EntityType = @kTypeLabor
		and    t.ProjectKey = @ProjectKey-- added for 227184
	
	end


	-- Are they on Billing Worksheet
	update #tProcWIPKeys 
	set    #tProcWIPKeys.BillingID = 0

	if exists (select 1 from #tProcWIPKeys where EntityType = @kTypeLabor)
	begin
	
		update #tProcWIPKeys 
		set    #tProcWIPKeys.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #tProcWIPKeys.EntityType = @kTypeLabor
		and    #tProcWIPKeys.EntityKey = cast(bd.EntityGuid as varchar(200))   
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5

	end

	if exists (select 1 from #tProcWIPKeys where EntityType = @kTypeExpenseReport)
	begin
		update #tProcWIPKeys 
		set    #tProcWIPKeys.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #tProcWIPKeys.EntityType = @kTypeExpenseReport
		and    #tProcWIPKeys.EntityKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tExpenseReceipt'
	end

	if exists (select 1 from #tProcWIPKeys where EntityType = @kTypeMiscCost)
	begin
	
		update #tProcWIPKeys 
		set    #tProcWIPKeys.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #tProcWIPKeys.EntityType = @kTypeMiscCost
		and    #tProcWIPKeys.EntityKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tMiscCost'
	end

	if exists (select 1 from #tProcWIPKeys where EntityType = @kTypeVoucher)
	begin
	
		update #tProcWIPKeys 
		set    #tProcWIPKeys.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #tProcWIPKeys.EntityType = @kTypeVoucher
		and    #tProcWIPKeys.EntityKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tVoucherDetail'
	end

	if exists (select 1 from #tProcWIPKeys where EntityType = @kTypeOrder)
	begin
	
		update #tProcWIPKeys 
		set    #tProcWIPKeys.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #tProcWIPKeys.EntityType = @kTypeOrder
		and    #tProcWIPKeys.EntityKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tPurchaseOrderDetail'

	end
end -- not a transfer tab

else 

begin
	-- transfer tab

	if @TabIndex = @kTabTransferred
	begin
		if not exists (select 1 from #tProcWIPSummary)
		begin
			insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
			select @ProjectKey, Entity, EntityKey, @Action,0, 0, 0, 0
			from   #tProcWIPTransaction t
				inner join vProjectCostsTransfer v on t.Entity = v.Type collate database_default
					and t.EntityKey = v.TranKey collate database_default
			--where v.WIPPostingInKey >= 0 -- take them all in case the user selects 1 reversal
	
		end
	end
	else
	begin
		if not exists (select 1 from #tProcWIPSummary)
		begin
			insert #tProcWIPKeys (ProjectKey, EntityType, EntityKey, Action, InvoiceLineKey, BillingID, WIPPostingInKey, WIPPostingOutKey) 
			select @ProjectKey, Entity, EntityKey, @Action,0, 0, 0, 0
			from   #tProcWIPTransaction t
				inner join vProjectCostsTransferAdj v on t.Entity = v.Type collate database_default
					and t.EntityKey = v.TranKey collate database_default
			--where v.WIPPostingInKey >= 0 -- -- take them all in case the user selects 1 reversal
			
		end
	end

end

	declare @RetVal int
	select @RetVal = 1

	-- If orders only, return orders so that we can close them
	if @Action = @kWIPActionMarkBilled and @OrdersOnly = 1
	begin
		delete #tProcWIPKeys where EntityType <> @kTypeOrder
		return @RetVal
	end

	-- if there are some open orders, we will need to ask the user if he wants to close them
	if @Action = @kWIPActionMarkBilled and exists (
		select 1 
		from #tProcWIPKeys k
		inner join tPurchaseOrderDetail pod (nolock) on k.EntityKey = pod.PurchaseOrderDetailKey  
		where k.EntityType = @kTypeOrder
		and   pod.Closed = 0
		)
		select @RetVal = -1 

	-- Do not do anything if they are on billing worksheet or billed
	 update #tProcWIPKeys
	 set    #tProcWIPKeys.Action = @kWIPActionNone
	 where  #tProcWIPKeys.BillingID >0  
	 or     #tProcWIPKeys.InvoiceLineKey > 0
	 
	 -- for orders, we cannot mark as billed or write off    
	 if @Action in (@kWIPActionMarkBilled, @kWIPActionWriteOff)
		update #tProcWIPKeys
		set    #tProcWIPKeys.Action = @kWIPActionNone
	 	where  #tProcWIPKeys.EntityType = @kTypeOrder


	-- Then change vProjectCosts types to the WIP types
	update #tProcWIPKeys
	set    EntityType = 
		case 
			when EntityType = @kTypeLabor then @kWIPLabor 
			when EntityType = @kTypeExpenseReport then @kWIPExpenseReport
			when EntityType = @kTypeMiscCost then @kWIPMiscCost
			when EntityType = @kTypeVoucher then @kWIPVoucher
			when EntityType = @kTypeOrder then @kWIPOrder
			end

	delete #tProcWIPKeys where Action = @kWIPActionNone

return @RetVal
GO
