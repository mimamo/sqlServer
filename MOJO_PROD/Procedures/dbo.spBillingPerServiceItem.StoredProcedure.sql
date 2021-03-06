USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingPerServiceItem]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingPerServiceItem]
	(
	@InvoiceKey int
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@InvoiceByClassKey int
	,@PostSalesUsingDetail tinyint
	,@TopInvoiceLineKey INT = 0 -- by default for mass billing, top = root, for BWS it depends on whether there is a master BWS
	)
	
AS
	SET NOCOUNT ON

  /*
  || When     Who  Rel    What
  || 12/02/14 GHL  10.587 (237117) Creation for an enhancement for the Grey Matter Group
  ||                       Transactions will be grouped by service and item
  ||                       - Services first by alphabetical order
  ||                       - Followed by Items by alphabetical order
  || 03/19/15 GHL  10.591 Added setting of Entity=tService for Abelson Taylor
  */

  /* Assume done
  
  this table will be populated by:
		- spProcessWIPWorksheetGetTrans
		- spBillingLinesGetTrans
		 
	CREATE TABLE #tran(
		Entity varchar(20) null,		-- like in tBillingDetail, tMiscCost, tTime, etc.... 
		EntityKey varchar(50) null,     -- transaction key
		EntityGuid uniqueidentifier null,
		
		BilledAmount money null,
		Quantity decimal(24,4) null,
		RateLevel int null,
		Rate money null,
		BilledComment varchar(2000),
		
		LayoutEntityKey int null,       -- backward compatibility with spBillingLinesGetTrans: ItemKey or ServiceKey 	
		WorkTypeKey int null,           -- backward compatibility with spBillingLinesGetTrans: because i use the same get function, not used here
		ItemName varchar(200) null,     -- backward compatibility with spBillingLinesGetTrans: will come from item or service
		
		GroupEntity varchar(25) null,
		GroupEntityKey int null,
		GroupName varchar(250) null,

		InvoiceLineKey int null,
		UpdateFlag int null
		)

  */
  
  -- cleanup fields for loops, i.e no NULLs
  update #tran 
  set  GroupEntityKey = isnull(LayoutEntityKey, 0)
      ,GroupEntity = case when Entity = 'tTime' then 'tService' else 'tItem' end
	  ,GroupName = ItemName

	update #tran
	set GroupName = '[No Service]'
	where GroupEntity = 'tService'
	and   GroupEntityKey = 0

	update #tran
	set GroupName = '[No Item]'
	where GroupEntity = 'tItem'
	and   GroupEntityKey = 0

  create table #group (SortKey int identity(1,1)
		,GroupEntity varchar(25) null
		,GroupEntityKey int null
		,GroupName varchar(250) null
	
		,SalesAccountKey int null
		,ClassKey int null
		,WorkTypeKey int null
		,Taxable int null
		,Taxable2 int null
		)

/*
Step 1: Prepare the groups with the GL info
*/

-- services first
insert #group (GroupEntity, GroupEntityKey, GroupName)
select distinct GroupEntity, GroupEntityKey, GroupName
from   #tran
where GroupEntity = 'tService'
order by GroupName

-- then items 
insert #group (GroupEntity, GroupEntityKey, GroupName)
select distinct GroupEntity, GroupEntityKey, GroupName
from   #tran
where GroupEntity = 'tItem'
order by GroupName



-- now extract GL info for the groups and subgroups
update #group
set    #group.SalesAccountKey = s.GLAccountKey
      ,#group.ClassKey = s.ClassKey
      ,#group.WorkTypeKey = s.WorkTypeKey
	  ,#group.Taxable = s.Taxable
	  ,#group.Taxable2 = s.Taxable2
from   tService s (nolock)
where  #group.GroupEntity = 'tService'
and    #group.GroupEntityKey = s.ServiceKey


update #group
set    #group.SalesAccountKey = i.SalesAccountKey
      ,#group.ClassKey = i.ClassKey
      ,#group.WorkTypeKey = i.WorkTypeKey
	  ,#group.Taxable = i.Taxable
	  ,#group.Taxable2 = i.Taxable2
from   tItem i (nolock)
where  #group.GroupEntity = 'tItem'
and    #group.GroupEntityKey = i.ItemKey

update #group
set    #group.Taxable = isnull(#group.Taxable, 0)
	  ,#group.Taxable2 = isnull(#group.Taxable2, 0)

--select * from #labor
--select * from #group
--select * from #subgroup
--return -1

/*
Step 2: Create the invoice lines
*/

-- vars to control the groups
declare @GroupLoopKey int
declare @GroupEntityKey int
declare @GroupEntity varchar(50)
declare @BillAmount money

-- vars for the invoice lines
declare @ParentInvoiceLineKey int 
declare @NewInvoiceLineKey int
declare @RetVal int
declare @LineSubject varchar(500)
declare @SalesAccountKey int
declare @EntityClassKey int
declare @ClassKey int
declare @WorkTypeKey int
declare @Taxable int
declare @Taxable2 int
declare @LineEntity varchar(50)
declare @LineEntityKey int 

select @GroupLoopKey = -1
while (1=1)
begin
	select @GroupLoopKey = min(SortKey)
	from   #group
	where  SortKey > @GroupLoopKey
		
	if @GroupLoopKey is null
		break

	select @GroupEntityKey = GroupEntityKey
		  ,@GroupEntity = GroupEntity
		  ,@LineSubject = GroupName
		  ,@SalesAccountKey = SalesAccountKey
		  ,@EntityClassKey = ClassKey
		  ,@WorkTypeKey = WorkTypeKey
		  ,@Taxable = Taxable
		  ,@Taxable2 = Taxable2
	from   #group
	where  SortKey = @GroupLoopKey


	select @BillAmount = Sum(BilledAmount)
	from   #tran
	where  GroupEntityKey = @GroupEntityKey
	and    GroupEntity = @GroupEntity
		
	select @BillAmount = isnull(@BillAmount, 0) 

	if @SalesAccountKey is null
		Select @SalesAccountKey = @DefaultSalesAccountKey

	IF ISNULL(@InvoiceByClassKey, 0) > 0
		SELECT @ClassKey = @InvoiceByClassKey
	ELSE
		IF ISNULL(@EntityClassKey, 0) > 0
			SELECT @ClassKey = @EntityClassKey
		ELSE
			SELECT @ClassKey = @DefaultClassKey

	if @GroupEntity = 'tService'
		select @LineEntity = @GroupEntity
		      ,@LineEntityKey = @GroupEntityKey
	else
		-- T&M lines do not have tItem entity, so leave them null
		select @LineEntity = null
		      ,@LineEntityKey = null
	

	-- now create a detail invoice line for the group under the top invoice line
	exec @RetVal = sptInvoiceLineInsertMassBilling
						@InvoiceKey				-- Invoice Key
						,@ProjectKey					-- ProjectKey
						,NULL							-- TaskKey
						,@LineSubject				-- Line Subject
						,null							-- @WorkTypeDescription   
						,2               				-- Bill From 
						,0							-- Quantity
						,0							-- Unit Amount
						,@BillAmount					-- Line Amount
						,2							-- line type detail
						,@TopInvoiceLineKey			-- parent line key
						,@SalesAccountKey				-- @DefaultSalesAccountKey		
						,@ClassKey 					-- Class Key
						,@Taxable						-- Taxable
						,@Taxable2					-- Taxable2
						,@WorkTypeKey				-- Work TypeKey
						,@PostSalesUsingDetail
						,@LineEntity --'tService'							-- Entity
						,@LineEntityKey --@NextServiceKey						-- EntityKey						  
						,NULL									-- OfficeKey
						,NULL									-- DepartmentKey
						,@NewInvoiceLineKey output

		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @InvoiceKey
			return -1					   	
			end

	-- and update the transactions

	update #tran
	set    InvoiceLineKey = @NewInvoiceLineKey 
	where  GroupEntityKey = @GroupEntityKey
	and    GroupEntity = @GroupEntity
		   
end
		 
exec sptInvoiceRecalcAmounts @InvoiceKey 

/*
Step 3: Connect the transactions to the invoice lines
*/
		-- now update the actual transactions with the InvoiceLineKey
		update tTime
		   set InvoiceLineKey = #tran.InvoiceLineKey
			  ,BilledService = #tran.LayoutEntityKey
			  ,RateLevel = ISNULL(#tran.RateLevel, tTime.RateLevel)					  
			  ,BilledHours = #tran.Quantity
			  ,BilledRate = #tran.Rate
			  ,BilledComment = ISNULL(#tran.BilledComment, tTime.BilledComment)
		  from #tran
		   where #tran.Entity = 'tTime'
		   and   #tran.EntityGuid = tTime.TimeKey 
	       and   tTime.InvoiceLineKey is NULL
		   and   #tran.InvoiceLineKey IS NOT NULL
		   	
		if @@ERROR <> 0 
		 begin
			exec sptInvoiceDelete @InvoiceKey
			return -1					   	
		  end
			  	  
		update tExpenseReceipt
		set InvoiceLineKey = #tran.InvoiceLineKey
			,AmountBilled = #tran.BilledAmount
			,BilledComment = #tran.BilledComment
		from #tran
		where #tran.Entity = 'tExpenseReceipt'
		and tExpenseReceipt.ExpenseReceiptKey = #tran.EntityKey
		and tExpenseReceipt.InvoiceLineKey is NULL
		and   #tran.InvoiceLineKey IS NOT NULL
		   	
		if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @InvoiceKey
			return -1					   	
		end
			  	  
		update tMiscCost
		set InvoiceLineKey = #tran.InvoiceLineKey
			,AmountBilled = #tran.BilledAmount
			,BilledComment = #tran.BilledComment
		from #tran
		where #tran.Entity = 'tMiscCost'
		and tMiscCost.MiscCostKey = #tran.EntityKey
		and tMiscCost.InvoiceLineKey is NULL
		and   #tran.InvoiceLineKey IS NOT NULL
		
		if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @InvoiceKey
			return -1					   	
		end
		
		update tVoucherDetail
		set InvoiceLineKey = #tran.InvoiceLineKey
			,AmountBilled = #tran.BilledAmount
			,BilledComment = #tran.BilledComment
		from #tran
		where #tran.Entity = 'tVoucherDetail'
		and tVoucherDetail.VoucherDetailKey = #tran.EntityKey
		and tVoucherDetail.InvoiceLineKey is NULL
		and   #tran.InvoiceLineKey IS NOT NULL
		
		if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @InvoiceKey
			return -1					   	
		end

		update tPurchaseOrderDetail
		   set InvoiceLineKey = #tran.InvoiceLineKey
			  ,tPurchaseOrderDetail.AccruedCost = 
			   CASE 
					WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
					ELSE 0
				END
			  ,AmountBilled = #tran.BilledAmount
			  ,BilledComment = #tran.BilledComment
		  from #tran
				,tPurchaseOrder po (nolock)
		 where #tran.Entity = 'tPurchaseOrderDetail'
		   and tPurchaseOrderDetail.PurchaseOrderDetailKey = #tran.EntityKey
			and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey 
			and tPurchaseOrderDetail.InvoiceLineKey is NULL
			and #tran.InvoiceLineKey IS NOT NULL	   
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @InvoiceKey
			return -1				   	
		  end

	RETURN 1
GO
