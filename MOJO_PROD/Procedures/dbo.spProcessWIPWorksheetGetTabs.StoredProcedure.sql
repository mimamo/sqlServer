USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetGetTabs]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetGetTabs]
	(
	@ProjectKey int
	,@GroupBy int = 0					-- 0: Group by Task, 1: Group by Item
	,@StartDate smalldatetime = null
	,@EndDate smalldatetime = null
	)
	
AS --Encrypt

/*
|| When     Who Rel    What
|| 03/29/13 GHL 10.566 Creation to support the tabs on the new billing screen in project central
||                     The queries for each grouping are fundamentally different:
||
||                     1) If we group by Task, the data will be displayed using a Hierachical Data structure
||                     we must first insert into the #tab table a copy of the task structure for each tab 
||                     then update the data fields. If there are no transactions, the grids will show the tasks with 0s.
||
||                     2) If we group by Item, the data will be displayed using a grouping collection
||                     insert directly into the #tab table, If there are no transactions, the grids will be blank
||
||04/17/13  GHL 10.567 Added calculations of Actual Gross, Order Gross, BWS Gross
||05/16/14  GHL 10.679 (216421) Added Project Key to where clause when querying tProjEstByItem
||07/11/14  RLB 10.582 (220914) Added all unbilled transactions
||09/16/14  GHL 10.584 (229804) Added substring(field, 1, len) when inserting strings
||10/29/14  GAR 10.585 Changed unitCost to UnitCost in temp table creation.
||11/14/14  RLB 10.586 (233489) changed for enhancement
||11/17/14  RLB 10.586 (233489) more changes for enhancement
||11/20/14  GHL 10.586 Allowing now time entries posted to wip, to be edited on the Unbilled screen
||11/21/14  GHL 10.586 Setting Hours distinctively from Quantity based on Type, for Items and Services
||02/18/15  RLB 10.589 only pull unbilled detail transactions that are not on a Billing Worksheet
||02/26/15  GHL 10.589 Added transferred adjustments for new tab (users must be able to change transfer dates)
||04/14/15  RLB 10.592 Removed any unbilled lines on a billing worksheet when grouping by Item
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
	
	declare @kGroupByTask int							select @kGroupByTask = 0
	declare @kGroupByItem int							select @kGroupByItem = 1

	if @StartDate is null
		select @StartDate = '01/01/1900'
	if @EndDate is null
		select @EndDate = '01/01/2070'

    declare @CompanyKey int
	select @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ProjectKey

	declare @LayoutKey int
	select @LayoutKey = isnull(LayoutKey, 0) from tProject (nolock) where ProjectKey = @ProjectKey

	create table #transaction (
		Type varchar(8) null
		,TypeName varchar(15) null
		,TranKey varchar(200) null
		,ProjectKey int  null
		,TaskKey int null
		,TaskID varchar(30) null
		,TaskName varchar(500) null
		,TaskFullName varchar(533) null
		,ItemName varchar(200) null
		,ItemID varchar(50) null
		,ItemFullName varchar(253)
		,Entity varchar(20) null 
		,EntityKey int null -- ItemKey or ServiceKey
		,DateBilled smalldatetime null
		,TransferInDate smalldatetime null
		,Quantity decimal(24,4) null
		,Hours decimal(24,4) null
		,UnitCost money null
		,TotalCost money null
		,BillableCost money null
		,AmountBilled money null
		,Description varchar(2500) null
		,Description2 varchar(2500) null
		,PersonItem varchar(201) null
		,TransactionDate smalldatetime null
		,TransactionDate2 smalldatetime null
		,BillingInvoiceNumber varchar(35) null
		,BillingStatus varchar(20) null
		,WIPPostingInKey int null
		,WIPPostingOutKey int null
		,WriteOff int null
		,InvoiceLineKey int null
		,WorkTypeKey int null
		,OnHold int null
		,Status int null
		,TransferComment varchar(500) null
        ,Comments varchar(2000) null
        ,TransactionComments varchar(2000) null 

		-- for billing ID logic
	    ,BillingID int null
		,UnitRate money null
		,DepartmentKey int null
		,ClassKey int null
		,SalesAccountKey int
		,CanEdit int null
		,CanSelect int null
		)

	-- capture the transactions
	-- take isnull(TaskKey,-1) because the SummaryTaskKey = 0 means the root 
	-- TaskKey = -1 means [No Task]

	insert #transaction (Type, TypeName, TranKey, ProjectKey, TaskKey, TaskID, TaskName, TaskFullName, ItemID, ItemName, ItemFullName, EntityKey
	    ,TransferInDate, DateBilled, Quantity, UnitCost, TotalCost, BillableCost, AmountBilled, Description, Description2, PersonItem, TransactionDate
		,TransactionDate2, BillingInvoiceNumber, BillingStatus, WIPPostingInKey, WIPPostingOutKey, WriteOff, InvoiceLineKey, OnHold, Status, TransferComment
		,Comments, TransactionComments)
	select Type, TypeName, TranKey,  ProjectKey, isnull(TaskKey,-1), TaskID, TaskName, TaskFullName, ItemID, ItemName, ItemFullName, isnull(ItemKey,0)
	    ,TransferInDate, DateBilled, Quantity, UnitCost, TotalCost, BillableCost, AmountBilled, substring(Description,1,2500), substring(Description2,1,2500), PersonItem, TransactionDate
		,TransactionDate2, BillingInvoiceNumber, BillingStatus, WIPPostingInKey, WIPPostingOutKey, WriteOff, InvoiceLineKey, OnHold, Status, substring(TransferComment, 1, 500)
		,substring(Comments,1,2000),  substring(TransactionComments, 1, 2000) 
	from vProjectCosts
	where ProjectKey = @ProjectKey 
	and   TransactionDate >= @StartDate 
	and   TransactionDate <= @EndDate
	and   LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
	 
	update #transaction
	set    #transaction.DepartmentKey = i.DepartmentKey
	      ,#transaction.SalesAccountKey = i.SalesAccountKey
		  ,#transaction.ClassKey = i.ClassKey
	from   tItem i (nolock)
	where  #transaction.EntityKey = i.ItemKey
	and    #transaction.Type <> @kTypeLabor

	update #transaction
	set    #transaction.DepartmentKey = s.DepartmentKey
	      ,#transaction.SalesAccountKey = s.GLAccountKey
		  ,#transaction.ClassKey = s.ClassKey
	from   tService s (nolock)
	where  #transaction.EntityKey = s.ServiceKey
	and    #transaction.Type <> @kTypeLabor

	update #transaction 
	set    #transaction.BillingID = null

	if exists (select 1 from #transaction where Type = @kTypeLabor)
	begin
	    update #transaction 
		set    #transaction.UnitRate = t.ActualRate
		from   tTime t (nolock)
		where  #transaction.TranKey = cast(t.TimeKey as varchar(200))
		and    #transaction.Type = @kTypeLabor
		and    t.ProjectKey = @ProjectKey

		update #transaction 
		set    #transaction.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #transaction.Type = @kTypeLabor
		and    #transaction.TranKey = cast(bd.EntityGuid as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5

	end

	if exists (select 1 from #transaction where Type = @kTypeExpenseReport)
	begin
	    update #transaction 
		set    #transaction.UnitRate = t.ActualCost
		from   tExpenseReceipt t (nolock)
		where  #transaction.TranKey = cast(t.ExpenseReceiptKey as varchar(200))
		and    #transaction.Type = @kTypeExpenseReport

		update #transaction 
		set    #transaction.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #transaction.Type = @kTypeExpenseReport
		and    #transaction.TranKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tExpenseReceipt'
	end

	if exists (select 1 from #transaction where Type = @kTypeMiscCost)
	begin
	    update #transaction 
		set    #transaction.UnitRate = t.UnitRate
			  ,#transaction.DepartmentKey = t.DepartmentKey 
 		from   tMiscCost t (nolock)
		where  #transaction.TranKey = cast(t.MiscCostKey as varchar(200))
		and    #transaction.Type = @kTypeMiscCost

		update #transaction 
		set    #transaction.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #transaction.Type = @kTypeMiscCost
		and    #transaction.TranKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tMiscCost'
	end

	if exists (select 1 from #transaction where Type = @kTypeVoucher)
	begin
	    update #transaction 
		set    #transaction.UnitRate = t.UnitRate
			  ,#transaction.DepartmentKey = t.DepartmentKey
			  ,#transaction.ClassKey = t.ClassKey 
 		from   tVoucherDetail t (nolock)
		where  #transaction.TranKey = cast(t.VoucherDetailKey as varchar(200))
		and    #transaction.Type = @kTypeVoucher

		update #transaction 
		set    #transaction.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #transaction.Type = @kTypeVoucher
		and    #transaction.TranKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tVoucherDetail'
	end

	if exists (select 1 from #transaction where Type = @kTypeOrder)
	begin
	    update #transaction 
		set    #transaction.UnitRate = t.UnitRate
			  ,#transaction.DepartmentKey = t.DepartmentKey
			  ,#transaction.ClassKey = t.ClassKey 
 		from   tPurchaseOrderDetail t (nolock)
		where  #transaction.TranKey = cast(t.PurchaseOrderDetailKey as varchar(200))
		and    #transaction.Type = @kTypeOrder

		update #transaction 
		set    #transaction.BillingID = b.BillingID
		from   tBilling b (nolock)
		inner  join tBillingDetail bd (nolock) on b.BillingKey = bd.BillingKey
		where  #transaction.Type = @kTypeOrder
		and    #transaction.TranKey = cast(bd.EntityKey as varchar(200))  
		AND    b.CompanyKey = @CompanyKey
		AND    b.Status < 5
		AND    bd.Entity = 'tPurchaseOrderDetail'
	end

	-- get transferred data and set the billing status to transferred (fake status)
	insert #transaction (Type, TranKey, TaskKey, EntityKey, Quantity, TotalCost, BillableCost, AmountBilled
		,BillingStatus, WriteOff, InvoiceLineKey, OnHold, Status)
	select Type, TranKey, isnull(TaskKey,-1), isnull(ItemKey,0), Quantity, TotalCost, BillableCost, AmountBilled
		,@kBillingStatusTransferred, WriteOff, InvoiceLineKey, OnHold, Status
	from vProjectCostsTransfer
	where ProjectKey = @ProjectKey 
	and   WIPPostingInKey <> -99 -- do not take reversals otherwise the sum (Gross) = 0 on the top grid
	and   TransactionDate >= @StartDate 
	and   TransactionDate <= @EndDate
	and   LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI

	-- get transferred data and set the billing status to transferred (fake status)
	insert #transaction (Type, TranKey, TaskKey, EntityKey, Quantity, TotalCost, BillableCost, AmountBilled
		,BillingStatus, WriteOff, InvoiceLineKey, OnHold, Status)
	select Type, TranKey, isnull(TaskKey,-1), isnull(ItemKey,0), Quantity, TotalCost, BillableCost, AmountBilled
		,@kBillingStatusTransferredAdj, WriteOff, InvoiceLineKey, OnHold, Status
	from vProjectCostsTransferAdj
	where ProjectKey = @ProjectKey 
	and   WIPPostingInKey <> -99 -- do not take reversals otherwise the sum (Gross) = 0 on the top grid
	and   TransactionDate >= @StartDate 
	and   TransactionDate <= @EndDate
	and   LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
	
    -- this makes it easier for grouping later
	update #transaction
	set    Entity = case when Type = @kTypeLabor then 'tService' else 'tItem' end



	IF @LayoutKey = 0
	begin
		update #transaction
		set    #transaction.WorkTypeKey = isnull(i.WorkTypeKey, 0)
		from   tItem i (nolock)
		where  #transaction.Entity = 'tItem'
		and    #transaction.EntityKey = i.ItemKey
     
		update #transaction
		set    #transaction.WorkTypeKey = isnull(s.WorkTypeKey, 0)
		from   tService s (nolock)
		where  #transaction.Entity = 'tService'
		and    #transaction.EntityKey = s.ServiceKey
	end
	ELSE
	begin
		update #transaction
		set    #transaction.WorkTypeKey = lb.ParentEntityKey
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #transaction.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #transaction.EntityKey = lb.EntityKey     				
	    and    lb.ParentEntity = 'tWorkType'

	end
	
 
	-- patch for 0 tasks, convert them to -1 [No Task]
	update #transaction
	set    TaskKey = case when TaskKey = 0 then -1 else TaskKey end

	update #transaction
	set CanEdit = 0

	-- allow editing of time entries even if posted to WIP
	update #transaction
	set    CanEdit = 1
	--where  Type <> @kTypeOrder and WIPPostingInKey = 0 and WIPPostingOutKey = 0
	where  Type = @kTypeLabor-- If posted to WIP we will do a transfer
	and    BillingID is null -- but make sure they are not on a BWS

	update #transaction
	set    CanEdit = 1
	where  Type = @kTypeLabor and WIPPostingInKey = 0 and WIPPostingOutKey = 0
	-- if not posted to WIP, we are not going to do a transfer, so do not check the BillingID

	update #transaction
	set    CanEdit = 1
	where  Type not in ( @kTypeOrder, @kTypeLabor) 
	and    WIPPostingInKey = 0 and WIPPostingOutKey = 0

	update #transaction
		set CanSelect = 1
 
	 create table #tab(
		TabIndex int null 
		,TaskKey int null
		,Entity varchar(20) null
		,EntityKey int null
		-- these fields are common to each tab
		,Quantity decimal(24,4) null
		,Net money null
		,Gross money null

		-- for unbilled case only
		,ActualGross money null -- on other expenses
		,OrderGross money null -- on orders
		,BWSGross money null  -- on billing worksheet

		-- now we need this for the Unbilled
		,CurrentBudgetQuantity decimal(24,4) null -- By task, hours, By item hours or quantity
		,CurrentTotalBudget money null
		,AmountBilled money null
		,Selected tinyint null
		,SelectedToBill money null
		,ToBillRemaining money null	-- CurrentTotalBudget - AmountBilled
		,GrossRemaining	money null	-- CurrentTotalBudget - Gross

		-- for billing item and item groupings
		,ItemID varchar(50) null      -- ItemID or ServiceCode
		,ItemName varchar(200) null   -- ItemName or Description
		,WorkTypeKey int null
		,WorkTypeID varchar(100) null
		,WorkTypeName varchar(200) null		
		,WorkTypeDisplayOrder int null

		-- for task grouping
		,SummaryTaskKey int null
		,ProjectOrder int null
		,TaskName varchar(250) null
		,BudgetTaskType int null
		)

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
*/

	-- now group the data for each tab

	if @GroupBy = @kGroupByTask
	begin
		-- we must capture all the tasks for the HD (do this once per tab)

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		values (@kTabUnbilled, -1, 0, '[No Task]', -1, 2)

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder, BudgetTaskType)
		select @kTabUnbilled, t.TaskKey, t.SummaryTaskKey, ISNULL(t.TaskID + ' - ', '') + t.TaskName, t.ProjectOrder
		 ,case when TaskType = 1 and isnull(TrackBudget,0) = 0 then 1 else 2 end
		from tTask t (nolock)
		where t.ProjectKey = @ProjectKey
		AND   MoneyTask = 1	

		-- now copy the tasks from the Unbilled tab to the other tabs
		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabUnapproved, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabBilled , TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabMarkedAsBilled , TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabWriteOff , TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabOnHold , TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabTransferred , TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		insert #tab (TabIndex, TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType)
		select @kTabTransferredAdj , TaskKey, SummaryTaskKey, TaskName, ProjectOrder,BudgetTaskType
		from #tab where TabIndex = @kTabUnbilled

		-- now update the actual fields
		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0 and t.BillingID is null
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0 and t.BillingID is null
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0 and t.BillingID is null
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabUnbilled

		-- Just for the Unbilled Tab
		-- now split the gross in 3 buckets: Actual, Order, BWS
		-- section not used any more
		/*update #tab
		set    #tab.ActualGross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0
			and   t.TaskKey = #tab.TaskKey
			and   t.BillingID is null
			and   t.Type <> @kTypeOrder
			),0)
			,#tab.OrderGross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0
			and   t.TaskKey = #tab.TaskKey
			and   t.BillingID is null
			and   t.Type = @kTypeOrder
			),0)
			,#tab.BWSGross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0
			and   t.TaskKey = #tab.TaskKey
			and   t.BillingID is not null
			),0)
		where  #tab.TabIndex = @kTabUnbilled */
		
		update #tab
		set #tab.SelectedToBill = 0
		where  #tab.TabIndex = @kTabUnbilled

		update #tab
		set #tab.Selected = 0
		where  #tab.TabIndex = @kTabUnbilled

		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnapproved and t.OnHold = 0
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnapproved and t.OnHold = 0
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusUnapproved and t.OnHold = 0
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabUnapproved

		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusBilled and t.InvoiceLineKey > 0
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusBilled and t.InvoiceLineKey > 0
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusBilled and t.InvoiceLineKey > 0
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabBilled

		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusBilled and t.InvoiceLineKey = 0
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusBilled and t.InvoiceLineKey = 0
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusBilled and t.InvoiceLineKey = 0
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabMarkedAsBilled


		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusWriteOff 
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusWriteOff 
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusWriteOff 
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabWriteOff


		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus <> @kBillingStatusTransferred and t.OnHold = 1   
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus <> @kBillingStatusTransferred and t.OnHold = 1  
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus <> @kBillingStatusTransferred and t.OnHold = 1  
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabOnHold
	
	update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusTransferred   
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusTransferred  
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusTransferred 
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabTransferred

		update #tab
		set    #tab.Quantity = ISNULL((
			select sum(case when t.Entity='tService' then t.Quantity else 0 end)
			from #transaction t
			where t.BillingStatus = @kBillingStatusTransferredAdj   
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Net = ISNULL((
			select sum(TotalCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusTransferredAdj  
			and   t.TaskKey = #tab.TaskKey
			),0)
			,#tab.Gross = ISNULL((
			select sum(BillableCost)
			from #transaction t
			where t.BillingStatus = @kBillingStatusTransferredAdj 
			and   t.TaskKey = #tab.TaskKey
			),0)
		where  #tab.TabIndex = @kTabTransferredAdj

		-- now special queries for the Unbilled case
		update #tab
		set    #tab.CurrentTotalBudget = t.EstLabor + t.EstExpenses + t.ApprovedCOLabor + t.ApprovedCOExpense
		from   tTask t (nolock)
		where  #tab.TaskKey = t.TaskKey
		and    #tab.TabIndex = @kTabUnbilled

		update #tab
		set    #tab.CurrentBudgetQuantity = t.EstHours + t.ApprovedCOHours
		from   tTask t (nolock)
		where  #tab.TaskKey = t.TaskKey
		and    #tab.TabIndex = @kTabUnbilled

		-- case when [No Task]
		-- do it like in spRptTaskSummary
		UPDATE #tab
			SET #tab.CurrentBudgetQuantity = ISNULL((
				Select Sum(etl.Hours) 
				from tEstimateTaskLabor etl (nolock)
					inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey  
				Where e.ProjectKey = @ProjectKey  
				and e.EstType > 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0
				), 0)
				+ ISNULL((Select Sum(et.Hours) 
				from tEstimateTask et (nolock) 
					inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey  
				Where e.ProjectKey = @ProjectKey    
				and e.EstType = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 
				), 0)

				,#tab.CurrentTotalBudget = 
				ISNULL((Select Sum(Round(ISNULL(etl.Hours, 0) * ISNULL(etl.Rate, 0),2)) 
						from tEstimateTaskLabor etl  (nolock) inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
						Where e.ProjectKey = @ProjectKey   
						and e.EstType > 1 and e.Approved = 1 and isnull(etl.TaskKey, 0) = 0 
						), 0)
				+ ISNULL((Select Sum(et.EstLabor)
						from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
						Where e.ProjectKey = @ProjectKey 
						and e.EstType = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0 
						), 0)
		        + ISNULL((
		        Select Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end ) 
				from tEstimateTaskExpense ete  (nolock) inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey   
				and e.EstType > 1 and e.Approved = 1 and isnull(ete.TaskKey, 0) = 0
				), 0)
				+ ISNULL((Select Sum(et.EstExpenses) 
				from tEstimateTask et  (nolock) inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
				Where e.ProjectKey = @ProjectKey   
				and e.EstType = 1 and e.Approved = 1 and isnull(et.TaskKey, 0) = 0
				), 0)
		WHERE  #tab.TaskKey = -1
		and    #tab.TabIndex = @kTabUnbilled

		-- we could also do it like in spRptProjectBudgetAnalysis using tInvoiceSummary
		update #tab
		set    #tab.AmountBilled = isnull((
			select sum(#transaction.AmountBilled)
			from   #transaction
			where  #transaction.TaskKey = #tab.TaskKey
			-- limit to invoices
			and    #transaction.BillingStatus = @kBillingStatusBilled  and #transaction.InvoiceLineKey > 0
		),0)
		where  #tab.TabIndex = @kTabUnbilled

		update #tab
		set    ToBillRemaining = isnull(CurrentTotalBudget, 0) - isnull(AmountBilled, 0)
		      ,GrossRemaining = isnull(CurrentTotalBudget, 0) - isnull(Gross, 0)
		where  #tab.TabIndex = @kTabUnbilled

		-- now after summary is done , update transactions for the detail unbilled rows
		update #transaction
		set    Hours = Quantity 
		where  Type = @kTypeLabor

		update #transaction
		set    Quantity = 0 
		where  Type = @kTypeLabor

		update #transaction
		set    Hours = 0 
		where  Type <> @kTypeLabor

	end 

	
	if @GroupBy = @kGroupByItem
	begin
		
		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabUnbilled, Entity, EntityKey, sum(Quantity), sum(TotalCost), sum(BillableCost) 
		from  #transaction
		where BillingStatus = @kBillingStatusUnbilled and OnHold = 0 and  #transaction.BillingID is null
		group by EntityKey, Entity
		
		-- now split Gross in 3: Actuals, Orders and BWS
		-- no longer used
		/*update #tab
		set    #tab.ActualGross = ISNULL((
			select sum(t.BillableCost)
			from   #transaction t
			where  t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0
			and    t.Entity = #tab.Entity
			and    t.EntityKey = #tab.EntityKey
			and    t.Type <> @kTypeOrder
			and    t.BillingID is null
			),0)
			,#tab.OrderGross = ISNULL((
			select sum(t.BillableCost)
			from   #transaction t
			where  t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0
			and    t.Entity = #tab.Entity
			and    t.EntityKey = #tab.EntityKey
			and    t.Type = @kTypeOrder
			and    t.BillingID is null
			),0)
			,#tab.BWSGross = ISNULL((
			select sum(t.BillableCost)
			from   #transaction t
			where  t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0
			and    t.Entity = #tab.Entity
			and    t.EntityKey = #tab.EntityKey
			and    t.BillingID is not null
			),0) */
		
		update #tab
		set #tab.SelectedToBill = 0
		where  #tab.TabIndex = @kTabUnbilled
		
		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabUnapproved, Entity, EntityKey, sum(Quantity), sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus = @kBillingStatusUnapproved and OnHold = 0
		group by EntityKey, Entity

		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabBilled, Entity, EntityKey, sum(Quantity), sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus = @kBillingStatusBilled  and InvoiceLineKey > 0
		group by EntityKey, Entity

		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabMarkedAsBilled, Entity, EntityKey, sum(Quantity), sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus = @kBillingStatusBilled  and InvoiceLineKey = 0
		group by EntityKey, Entity

		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabWriteOff, Entity, EntityKey, sum(Quantity), sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus = @kBillingStatusWriteOff  
		group by EntityKey, Entity

		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabOnHold, Entity, EntityKey, sum(Quantity), sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus <> @kBillingStatusTransferred and OnHold = 1  
		group by EntityKey, Entity

		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabTransferred, Entity, EntityKey,sum(Quantity),sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus = @kBillingStatusTransferred  
		group by EntityKey, Entity

		insert #tab (TabIndex, Entity, EntityKey, Quantity, Net, Gross)
		select @kTabTransferredAdj, Entity, EntityKey,sum(Quantity),sum(TotalCost), sum(BillableCost) from  #transaction
		where BillingStatus = @kBillingStatusTransferredAdj  
		group by EntityKey, Entity

		-- now special queries for the Unbilled case
		update #tab
		set    #tab.CurrentTotalBudget = p.Gross + p.COGross
		FROM   tProjectEstByItem p (NOLOCK)
		WHERE  #tab.Entity = p.Entity COLLATE DATABASE_DEFAULT 
		AND    ISNULL(#tab.EntityKey, 0) = ISNULL(p.EntityKey, 0)
		and    #tab.TabIndex = @kTabUnbilled
		and    p.ProjectKey = @ProjectKey

		update #tab
		set    #tab.CurrentBudgetQuantity = p.Qty + p.COQty
		FROM   tProjectEstByItem p (NOLOCK)
		WHERE  #tab.Entity = p.Entity COLLATE DATABASE_DEFAULT 
		AND    ISNULL(#tab.EntityKey, 0) = ISNULL(p.EntityKey, 0)
		and    #tab.TabIndex = @kTabUnbilled
		and    p.ProjectKey = @ProjectKey

		update #tab
		set    #tab.CurrentTotalBudget = isnull(#tab.CurrentTotalBudget, 0)
		      ,#tab.CurrentBudgetQuantity = isnull(#tab.CurrentBudgetQuantity, 0)

		-- we could also do it like in spRptProjectBudgetAnalysis using tInvoiceSummary
		update #tab
		set    #tab.AmountBilled = isnull((
			select sum(#transaction.AmountBilled)
			from   #transaction
			where  #transaction.EntityKey = #tab.EntityKey
			and    #transaction.Entity = #tab.Entity COLLATE DATABASE_DEFAULT 
			-- limit to invoices
			and    #transaction.BillingStatus = @kBillingStatusBilled  and #transaction.InvoiceLineKey > 0
		),0)
		where  #tab.TabIndex = @kTabUnbilled

		update #tab
		set    ToBillRemaining = isnull(CurrentTotalBudget, 0) - isnull(AmountBilled, 0)
		      ,GrossRemaining = isnull(CurrentTotalBudget, 0) - isnull(Gross, 0)
		where  #tab.TabIndex = @kTabUnbilled

		
		-- now after summary is done, update transactions for the detail unbilled rows
		update #transaction
		set    Hours = Quantity 
		where  Type = @kTypeLabor

		update #transaction
		set    Quantity = 0 
		where  Type = @kTypeLabor

		update #transaction
		set    Hours = 0 
		where  Type <> @kTypeLabor

	end 
	
if @GroupBy = @kGroupByTask
begin
	
	select 'Unbilled' as UnbilledTab, * from #tab  where TabIndex = @kTabUnbilled order by ProjectOrder
	select 'Unapproved' as UnapprovedTab, * from #tab  where TabIndex = @kTabUnapproved order by ProjectOrder  
	select 'Billed' as BilledTab, * from #tab  where TabIndex = @kTabBilled  order by ProjectOrder
	select 'MarkedAsBilled' as MarkedAsBilledTab, * from #tab  where TabIndex = @kTabMarkedAsBilled  order by ProjectOrder
	select 'WriteOff' as WriteOffTab, * from #tab where TabIndex = @kTabWriteOff  order by ProjectOrder
	select 'OnHold' as OnHoldTab, * from #tab where TabIndex = @kTabOnHold  order by ProjectOrder
	select 'Transferred' as TransferredTab, * from #tab where TabIndex = @kTabTransferred   order by ProjectOrder
	select 'Adjusted' as AdjustedTab, * from #tab where TabIndex = @kTabTransferredAdj   order by ProjectOrder
	
	select t.*
	      ,d.DepartmentName
		  ,isnull(c.ClassID + ' - ', '') + c.ClassName as ClassFullName
		  ,gla.AccountNumber + ' - ' + gla.AccountName as SalesAccountFullName
		  ,wipin.Comment as WIPInBatch
		  ,wipout.Comment as WIPOutBatch
		  ,case when CanEdit = 1 then 'Click to edit' else null end as EditIcon
		  ,0 as Selected
	from   #transaction t (nolock)
	left outer join tDepartment d (nolock) on t.DepartmentKey = d.DepartmentKey
	left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
	left outer join tWIPPosting wipin (nolock) on t.WIPPostingInKey = wipin.WIPPostingKey
	left outer join tWIPPosting wipout (nolock) on t.WIPPostingOutKey = wipout.WIPPostingKey
	left outer join tGLAccount gla (nolock) on t.SalesAccountKey = gla.GLAccountKey
	where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0 and t.BillingID is null

	return 1
end

	update #tab
    set    #tab.ItemID = i.ItemID
          ,#tab.ItemName = i.ItemName
          ,#tab.WorkTypeKey = isnull(i.WorkTypeKey, 0)
    from   tItem i (nolock)
    where  #tab.Entity = 'tItem'
    and    #tab.EntityKey = i.ItemKey
     
	update #tab
    set    #tab.ItemID = s.ServiceCode
          ,#tab.ItemName = s.Description
          ,#tab.WorkTypeKey = isnull(s.WorkTypeKey, 0)
    from   tService s (nolock)
    where  #tab.Entity = 'tService'
    and    #tab.EntityKey = s.ServiceKey

	
	update #tab
    set    #tab.ItemID = ''
          ,#tab.ItemName = '[No Item]'
    where   #tab.Entity = 'tItem'
    and    #tab.EntityKey = 0

	update #tab
    set    #tab.ItemID = ''
          ,#tab.ItemName = '[No Service]'
    where  #tab.Entity = 'tService'
    and    #tab.EntityKey = 0


if @LayoutKey = 0
	begin
		-- no layout, rely on WT display order then Item Name
		update #tab
		set    #tab.WorkTypeID = wt.WorkTypeID
			  ,#tab.WorkTypeName = wt.WorkTypeName
			  ,#tab.WorkTypeDisplayOrder = wt.DisplayOrder
		from   tWorkType wt (nolock)
		where  #tab.WorkTypeKey = wt.WorkTypeKey 

		-- Now update entity specific WorkTypeNames
		UPDATE	#tab
		SET		#tab.WorkTypeName = cust.Subject
		FROM	tWorkTypeCustom cust (nolock)
		WHERE	#tab.WorkTypeKey = cust.WorkTypeKey
		AND		cust.Entity = 'tProject'
		AND		cust.EntityKey = @ProjectKey
	end
	else
	begin
		-- the items have been reorganized on the layout 
		update #tab
		set    #tab.WorkTypeKey = 0
	
		-- get WT key only when parent entity is tWorkType	
		update #tab
		set    #tab.WorkTypeKey = lb.ParentEntityKey
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #tab.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #tab.EntityKey = lb.EntityKey     				
	    and    lb.ParentEntity = 'tWorkType'
	

		update #tab
		set    #tab.WorkTypeID = wt.WorkTypeID
			  ,#tab.WorkTypeName = wt.WorkTypeName
		from   tWorkType wt (nolock)
		where  #tab.WorkTypeKey = wt.WorkTypeKey 
		
		-- Now update entity specific WorkTypeNames
		UPDATE	#tab
		SET		#tab.WorkTypeName = cust.Subject
		FROM	tWorkTypeCustom cust (nolock)
		WHERE	#tab.WorkTypeKey = cust.WorkTypeKey
		AND		cust.Entity = 'tProject'
		AND		cust.EntityKey = @ProjectKey

		-- but always get the Layout Order
		update #tab
		set    #tab.WorkTypeDisplayOrder = lb.LayoutOrder
		from   tLayoutBilling lb (nolock)
		where  lb.LayoutKey = @LayoutKey
		and    #tab.Entity = lb.Entity COLLATE DATABASE_DEFAULT
		and    #tab.EntityKey = lb.EntityKey     				

	end

	update #tab
	set    WorkTypeID = '[No Billing Item ID]'
	      ,WorkTypeName = '[No Billing Item]'
		  ,#tab.WorkTypeDisplayOrder = 9999 -- at bottom
	where  isnull(#tab.WorkTypeKey, 0) = 0 


	select 'Unbilled' as UnbilledTab, * from #tab  where TabIndex = @kTabUnbilled order by WorkTypeDisplayOrder, WorkTypeID, Entity
	select 'Unapproved' as UnapprovedTab, * from #tab  where TabIndex = @kTabUnapproved order by WorkTypeDisplayOrder, WorkTypeID, Entity  
	select 'Billed' as BilledTab, * from #tab  where TabIndex = @kTabBilled  order by WorkTypeDisplayOrder, WorkTypeID, Entity
	select 'MarkedAsBilled' as MarkedAsBilledTab, * from #tab  where TabIndex = @kTabMarkedAsBilled  order by WorkTypeDisplayOrder, WorkTypeID, Entity
	select 'WriteOff' as WriteOffTab, * from #tab where TabIndex = @kTabWriteOff  order by WorkTypeDisplayOrder, WorkTypeID, Entity
	select 'OnHold' as OnHoldTab, * from #tab where TabIndex = @kTabOnHold order by WorkTypeDisplayOrder, WorkTypeID, Entity
	select 'Transferred' as TransferredTab, * from #tab where TabIndex = @kTabTransferred   order by WorkTypeDisplayOrder, WorkTypeID, Entity
	select 'Adjusted' as AdjustedTab, * from #tab where TabIndex = @kTabTransferredAdj   order by WorkTypeDisplayOrder, WorkTypeID, Entity

		select t.*
	      ,d.DepartmentName
		  ,isnull(c.ClassID + ' - ', '') + c.ClassName as ClassFullName
		  ,gla.AccountNumber + ' - ' + gla.AccountName as SalesAccountFullName
		  ,wipin.Comment as WIPInBatch
		  ,wipout.Comment as WIPOutBatch
		  ,case when CanEdit = 1 then 'Click to edit' else null end as EditIcon
		  ,0 as Selected
	from   #transaction t (nolock)
	left outer join tDepartment d (nolock) on t.DepartmentKey = d.DepartmentKey
	left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
	left outer join tWIPPosting wipin (nolock) on t.WIPPostingInKey = wipin.WIPPostingKey
	left outer join tWIPPosting wipout (nolock) on t.WIPPostingOutKey = wipout.WIPPostingKey
	left outer join tGLAccount gla (nolock) on t.SalesAccountKey = gla.GLAccountKey
	where t.BillingStatus = @kBillingStatusUnbilled and t.OnHold = 0 and t.BillingID is null

	RETURN 1
GO
