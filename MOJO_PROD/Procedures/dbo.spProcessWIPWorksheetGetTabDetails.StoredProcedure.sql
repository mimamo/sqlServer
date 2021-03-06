USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetGetTabDetails]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetGetTabDetails]
	(
	@ProjectKey int
	,@GroupBy int = 0					-- 0: Group by Task, 1: Group by Item
	,@StartDate smalldatetime = null
	,@EndDate smalldatetime = null
	,@TabIndex int
	,@TaskKey int
	,@Entity varchar(20)
	,@EntityKey int
	)
	
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/02/13 GHL 10.566 Creation to support the tabs on the new billing screen in project central
|| 12/05/13 RLB 10.575 (197891) will pull data for a summary task now
|| 04/09/14 GHL 10.578 (212425) Added ProjectKey when querying tTime for ActualRate 
|| 04/25/14 GHL 10.579 (214165) If WIPPostingOutKey <> 0, you cannot select trans marked as billed or written off
|| 05/08/14 GHL 10.579 (215631) Fixed problem with summary task. If TaskKey = 0 all tasks under the root were queried
|| 09/16/14 GHL 10.584 (229804) Added substring(field, 1, len) when inserting strings
|| 11/20/14 GHL 10.586 Allowing now time entries posted to wip, to be edited on the Unbilled screen
|| 11/21/14 GHL 10.586 Setting Hours distinctively from Quantity based on Type
|| 01/06/15 GHL 10.588 Taking in account preference UndoWOAfterWIP (enhancement Abelson Taylor)
||                     here we can select (and undo WO) if UndoWOAfterWIP = 1
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

	declare @ProjectClassKey int, @CompanyKey int
	select @ProjectClassKey = ClassKey, @CompanyKey = CompanyKey from tProject (nolock) where ProjectKey = @ProjectKey

	declare @UndoWOAfterWIP int
	select @UndoWOAfterWIP = UndoWOAfterWIP from tPreference (nolock) where CompanyKey = @CompanyKey 
	select @UndoWOAfterWIP = isnull(@UndoWOAfterWIP, 0)

	create table #transaction (
		-- Copy of vProjectCosts
	  [Type] varchar(8) null
      ,[TypeName] varchar(15) null
      ,[TranKey] varchar(200) null
      ,[ProjectKey] int null
      ,[TaskKey] int null
      ,[TransferInDate] smalldatetime null
      ,[DateBilled] smalldatetime null
      ,[TaskID] varchar(30) null
      ,[TaskName] varchar(500) null
      ,[TaskFullName] varchar(533) null
      ,[ItemID] varchar(50) null
      ,[ItemName] varchar(200) null
      ,[ItemFullName] varchar(253) null
      ,[ItemKey] int null
      ,[Quantity] decimal(24,4) null
	  ,[Hours] decimal(24,4) null
      ,[UnitCost] money null
      ,[TotalCost] decimal(38,6) null
      ,[BillableCost] decimal(38,6) null
      ,[AmountBilled] decimal(38,6) null
      ,[Description] varchar(2500) null
      ,[Description2] varchar(2500) null
      ,[PersonItem] varchar(201) null
      ,[TransactionDate] smalldatetime null
      ,[TransactionDate2] smalldatetime null
      ,[InvoiceLineKey] int null
      ,[BillingInvoiceNumber] varchar(35) null
      ,[BillingStatus] varchar(10) null
      ,[WIPPostingInKey] int null
      ,[WIPPostingOutKey] int null
      ,[WriteOff] int null
      ,[Status] int null
      ,[TransferComment] varchar(500) null
      ,[Comments] varchar(2000) null
      ,[TransactionComments] varchar(2000) null -- truncate from 6000 to 2000
      ,[OnHold] tinyint null

	  -- these are not part of vProjectCosts and will need extra queries
	  ,UnitRate money null
	  ,DepartmentKey int null
	  ,ClassKey int null
	  ,SalesAccountKey int null
	  ,BillingID int null
	  ,CanEdit int null
	  ,CanSelect int null
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
            |
CanEdit     |If WIK = 0     If Not Order  No           No               No        No            No
            |And WOK = 0
			|And Not Order
*/

	-- handle [No Task] case
	if @TaskKey = -1
		select @TaskKey = 0
			 
	if @TabIndex = @kTabUnbilled
		insert #transaction (
		   [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] 
			)
		select 
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1,2000) 
		  ,substring(TransactionComments, 1, 2000) 
		  ,[OnHold]  
		from   vProjectCosts
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    BillingStatus = @kBillingStatusUnbilled and OnHold = 0
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabUnapproved
		insert #transaction (
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select 
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCosts
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    BillingStatus = @kBillingStatusUnapproved and OnHold = 0
		and		(    
				(@GroupBy = @kGroupByTask and
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				 )
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabBilled
		insert #transaction (
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select   
			[Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCosts
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    BillingStatus = @kBillingStatusBilled and InvoiceLineKey > 0
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabMarkedAsBilled
		insert #transaction (
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select 
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCosts
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    BillingStatus = @kBillingStatusBilled and InvoiceLineKey = 0
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabWriteOff
		insert #transaction (
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select 
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCosts
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    BillingStatus = @kBillingStatusWriteOff
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabOnHold
		insert #transaction (
			  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select 
		  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCosts
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and    OnHold = 1
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabTransferred
		insert #transaction (
			  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select 
			  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCostsTransfer
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

	else if @TabIndex = @kTabTransferredAdj
		insert #transaction (
			  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,[Description] 
		  ,[Description2] 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,[TransferComment] 
		  ,[Comments] 
		  ,[TransactionComments] 
		  ,[OnHold] )
		select 
			  [Type] 
		  ,[TypeName] 
		  ,[TranKey]
		  ,[ProjectKey]
		  ,[TaskKey] 
		  ,[TransferInDate] 
		  ,[DateBilled] 
		  ,[TaskID] 
		  ,[TaskName] 
		  ,[TaskFullName] 
		  ,[ItemID] 
		  ,[ItemName] 
		  ,[ItemFullName] 
		  ,[ItemKey] 
		  ,[Quantity] 
		  ,[UnitCost]
		  ,[TotalCost]
		  ,[BillableCost] 
		  ,[AmountBilled] 
		  ,substring([Description], 1, 2500) 
		  ,substring([Description2], 1, 2500) 
		  ,[PersonItem] 
		  ,[TransactionDate] 
		  ,[TransactionDate2] 
		  ,[InvoiceLineKey] 
		  ,[BillingInvoiceNumber] 
		  ,[BillingStatus] 
		  ,[WIPPostingInKey]
		  ,[WIPPostingOutKey] 
		  ,[WriteOff] 
		  ,[Status] 
		  ,substring([TransferComment], 1, 500) 
		  ,substring([Comments], 1, 2000) 
		  ,substring(TransactionComments, 1, 2000)
		  ,[OnHold]  
		from   vProjectCostsTransferAdj
		where  ProjectKey = @ProjectKey
		and    TransactionDate >= @StartDate
		and    TransactionDate <= @EndDate
		and    LinkVoucherDetailKey IS NULL -- Remove ERs linked to VI
		and		(    
				(@GroupBy = @kGroupByTask and 
					(isnull(TaskKey, 0) = @TaskKey or (@TaskKey <> 0 And isnull(SummaryTaskKey, 0) = @TaskKey ))
				)
				or	(@GroupBy = @kGroupByItem and 
						(
						(@Entity = 'tService' and Type = @kTypeLabor and isnull(ItemKey, 0) = @EntityKey)
						or
						(@Entity = 'tItem' and Type <> @kTypeLabor and isnull(ItemKey, 0) = @EntityKey) 			
						)
					)
				)

    -- get some defaults from item and services
	update #transaction
	set    #transaction.DepartmentKey = i.DepartmentKey
	      ,#transaction.SalesAccountKey = i.SalesAccountKey
		  ,#transaction.ClassKey = i.ClassKey
	from   tItem i (nolock)
	where  #transaction.ItemKey = i.ItemKey
	and    #transaction.Type <> @kTypeLabor

	update #transaction
	set    #transaction.DepartmentKey = s.DepartmentKey
	      ,#transaction.SalesAccountKey = s.GLAccountKey
		  ,#transaction.ClassKey = s.ClassKey
	from   tService s (nolock)
	where  #transaction.ItemKey = s.ServiceKey
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

	-- Split the quantities and hours
	update #transaction
	set    Hours = Quantity 
	where  Type = @kTypeLabor

	update #transaction
	set    Quantity = 0 
	where  Type = @kTypeLabor

	update #transaction
	set    Hours = 0 
	where  Type <> @kTypeLabor	
	
	update #transaction
	set CanEdit = 0

	if @TabIndex =@kTabUnapproved
		update #transaction
		set    CanEdit = 1
		where  Type <> @kTypeOrder

	if @TabIndex =@kTabUnbilled
	begin
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
	end

	update #transaction
		set CanSelect = 1

	if @TabIndex =@kTabMarkedAsBilled 
		update #transaction
		set    CanSelect = 0
		where  WIPPostingOutKey <> 0

	if @TabIndex =@kTabWriteOff And @UndoWOAfterWIP = 0 
		update #transaction
		set    CanSelect = 0
		where  WIPPostingOutKey <> 0

	if @TabIndex in ( @kTabTransferred, @kTabTransferredAdj)
	begin
		-- do not allow the selection of reversals because the Change Transfer Date function works off the original trans only
		update #transaction
		set    CanSelect = 0
		where  WIPPostingInKey = -99
	end
	 
	select t.*
	      ,d.DepartmentName
		  ,isnull(c.ClassID + ' - ', '') + c.ClassName as ClassFullName
		  ,gla.AccountNumber + ' - ' + gla.AccountName as SalesAccountFullName
		  ,wipin.Comment as WIPInBatch
		  ,wipout.Comment as WIPOutBatch
		  ,case when CanEdit = 1 then 'Click to edit' else null end as EditIcon
	from   #transaction t (nolock)
	left outer join tDepartment d (nolock) on t.DepartmentKey = d.DepartmentKey
	left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
	left outer join tWIPPosting wipin (nolock) on t.WIPPostingInKey = wipin.WIPPostingKey
	left outer join tWIPPosting wipout (nolock) on t.WIPPostingOutKey = wipout.WIPPostingKey
	left outer join tGLAccount gla (nolock) on t.SalesAccountKey = gla.GLAccountKey



return 1
GO
