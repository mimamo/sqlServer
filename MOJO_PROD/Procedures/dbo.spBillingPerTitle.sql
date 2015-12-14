USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingPerTitle]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingPerTitle]
	(
	@InvoiceKey int
	,@Type varchar(25) -- 'TitleOnly' or 'TitleService' or 'ServiceTitle'
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@InvoiceByClassKey int
	,@PostSalesUsingDetail tinyint
	,@TopInvoiceLineKey INT = 0 -- by default for mass billing, top = root, for BWS it depends on whether there is a master BWS
	,@isBWS INT = 0
	)
	
AS
	SET NOCOUNT ON

  /*
  || When     Who         Rel    What
  || 11/11/14 GHL         10.586 Creation for Abelson Taylor to support titles
  ||                             This is the core proc to be used by mass billing and billing worksheet
  || 12/15/14 GHL         10.587 Added update of RateLevel and BilledComments in case they are edited on the BWS
  || 01/29/15 GHL         10.588 Added setting of tInvoiceLine.Entity and tInvoiceLine.EntityKey for vReport_Invoice
  || 02/06/15 GHL         10.588 Added total hours and unit amount on the lines
  || 02/25/15 GHL         10.589 Removed setting of Entity and EntityKey, this is a problem when saving the expense
  ||                             if there is no service
  || 03/19/15 GHL         10.591 Place the expenses under a single 'Expenses' line now
  */

  /* Assume done 
  CREATE TABLE #labor (TimeKey uniqueidentifier null
  , ActualRate decimal(24,4) null
  , ActualHours decimal(24,4) null
  , BillAmount money null
  , ServiceKey int null
  , TitleKey int null 
  , RateLevel int null
  , Comments varchar(2000) null

  , GroupEntity varchar(50) null
  , GroupEntityKey int null
  , SubGroupEntity varchar(50) null
  , SubGroupEntityKey int null

  , InvoiceLineKey int null
  )
  
  CREATE TABLE #expense (Entity varchar(25) null
	, EntityKey int null
	, BillAmount money int nuul
	
	, GroupEntity varchar(50) null
	, GroupEntityKey int null
    , SubGroupEntity varchar(50) null
    , SubGroupEntityKey int null

	, InvoiceLineKey int null
  )              
  */

  -- cleanup fields for loops, i.e no NULLs
  update #labor set ServiceKey = isnull(ServiceKey, 0), TitleKey = isnull(TitleKey, 0) 
   
  create table #group (SortKey int identity(1,1)
		,GroupEntity varchar(25) null
		,GroupEntityKey int null
		,GroupName varchar(250) null
		,SummaryLine int null

		,SalesAccountKey int null
		,ClassKey int null
		,WorkTypeKey int null
		,Taxable int null
		,Taxable2 int null
		)

create table #subgroup (SortKey int identity(1,1)
		,GroupEntityKey int null
		,SubGroupEntity varchar(25) null
		,SubGroupEntityKey int null
		,SubGroupName varchar(250) null

		,SalesAccountKey int null
		,ClassKey int null
		,WorkTypeKey int null
		,Taxable int null
		,Taxable2 int null
		)

/*
Step 1: Prepare the groups and subgroups with the GL info
*/

declare @GroupIsSummary int

if @Type = 'TitleOnly'
		-- This is a detail line because transactions will be linked to the title
		select @GroupIsSummary = 0
	else
		-- This is a summary line because there will be a detail line by service under it
		select @GroupIsSummary = 1

if @Type in ('TitleOnly', 'TitleService' )
begin
	insert #group (GroupEntity, GroupEntityKey, GroupName, SummaryLine)
	select distinct 'tTitle', isnull(t.TitleKey,0), isnull(t.TitleName, '[No Title]'), @GroupIsSummary
	from   #labor lab 
	left join tTitle t (nolock) on lab.TitleKey = t.TitleKey
	order by isnull(t.TitleName, '[No Title]')

	update #labor
	set    GroupEntity = 'tTitle'
	      ,GroupEntityKey = TitleKey

	if @Type = 'TitleService' 
	begin
		insert #subgroup (GroupEntityKey, SubGroupEntity, SubGroupEntityKey, SubGroupName)
		select distinct lab.TitleKey, 'tService', isnull(s.ServiceKey,0), isnull(s.Description, '[No Service]')
		from   #labor lab 
		left join tService s (nolock) on lab.ServiceKey = s.ServiceKey
		order by isnull(s.Description, '[No Service]')

		update #labor
		set    SubGroupEntity = 'tService'
			  ,SubGroupEntityKey = ServiceKey
	end
end

if @Type = 'ServiceTitle' 
begin
	insert #group (GroupEntity, GroupEntityKey, GroupName, SummaryLine)
	select distinct 'tService', isnull(s.ServiceKey,0), isnull(s.Description, '[No Service]'), 1 -- always a summary
	from   #labor lab 
	left join tService s (nolock) on lab.ServiceKey = s.ServiceKey
	order by isnull(s.Description, '[No Service]')

	insert #subgroup (GroupEntityKey, SubGroupEntity, SubGroupEntityKey, SubGroupName)
	select distinct lab.ServiceKey, 'tTitle', isnull(t.TitleKey,0),  isnull(t.TitleName, '[No Title]')
	from   #labor lab 
	left join tTitle t (nolock) on lab.TitleKey = t.TitleKey
	order by isnull(t.TitleName, '[No Title]')

	update #labor
	set    GroupEntity = 'tService'
	      ,GroupEntityKey = ServiceKey
		  ,SubGroupEntity = 'tTitle'
	      ,SubGroupEntityKey = TitleKey

end

-- now extract GL info for the groups and subgroups
update #group
set    #group.SalesAccountKey = t.GLAccountKey
      ,#group.WorkTypeKey = t.WorkTypeKey
	  ,#group.Taxable = t.Taxable
	  ,#group.Taxable2 = t.Taxable2
from   tTitle t (nolock)
where  #group.GroupEntity = 'tTitle'
and    #group.GroupEntityKey = t.TitleKey

update #group
set    #group.SalesAccountKey = t.GLAccountKey
      ,#group.ClassKey = t.ClassKey
      ,#group.WorkTypeKey = t.WorkTypeKey
	  ,#group.Taxable = t.Taxable
	  ,#group.Taxable2 = t.Taxable2
from   tService t (nolock)
where  #group.GroupEntity = 'tService'
and    #group.GroupEntityKey = t.ServiceKey

update #subgroup
set    #subgroup.SalesAccountKey = t.GLAccountKey
      ,#subgroup.WorkTypeKey = t.WorkTypeKey
	  ,#subgroup.Taxable = t.Taxable
	  ,#subgroup.Taxable2 = t.Taxable2
from   tTitle t (nolock)
where  #subgroup.SubGroupEntity = 'tTitle'
and    #subgroup.SubGroupEntityKey = t.TitleKey

update #subgroup
set    #subgroup.SalesAccountKey = t.GLAccountKey
      ,#subgroup.ClassKey = t.ClassKey
      ,#subgroup.WorkTypeKey = t.WorkTypeKey
	  ,#subgroup.Taxable = t.Taxable
	  ,#subgroup.Taxable2 = t.Taxable2
from   tService t (nolock)
where  #subgroup.SubGroupEntity = 'tService'
and    #subgroup.SubGroupEntityKey = t.ServiceKey

update #group
set    #group.Taxable = isnull(#group.Taxable, 0)
	  ,#group.Taxable2 = isnull(#group.Taxable2, 0)

update #subgroup
set    #subgroup.Taxable = isnull(#subgroup.Taxable, 0)
	  ,#subgroup.Taxable2 = isnull(#subgroup.Taxable2, 0)

--select * from #labor
--select * from #group
--select * from #subgroup
--return -1

/*
Step 2: Create the invoice lines
*/

-- vars to control the groups
declare @GroupLoopKey int
declare @SubGroupLoopKey int
declare @GroupEntityKey int
declare @SubGroupEntityKey int
declare @GroupEntity varchar(50)
declare @SubGroupEntity varchar(50)
declare @BillAmount money
declare @LaborAmount money
declare @ActualHours decimal(24,4)
declare @UnitAmount money 

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
		  ,@GroupIsSummary = SummaryLine
		  ,@LineSubject = GroupName
		  ,@SalesAccountKey = SalesAccountKey
		  ,@EntityClassKey = ClassKey
		  ,@WorkTypeKey = WorkTypeKey
		  ,@Taxable = Taxable
		  ,@Taxable2 = Taxable2
	from   #group
	where  SortKey = @GroupLoopKey


	if @GroupIsSummary = 1
	begin
		--create summary invoice line for the group, under the Top Invoice Line
		exec @RetVal = sptInvoiceLineInsertMassBilling
					@InvoiceKey					-- Invoice Key
					,@ProjectKey					-- ProjectKey 
					,NULL							-- TaskKey
					,@LineSubject					-- Line Subject
					,NULL                 		-- Line description
					,0		      				-- Bill From 
					,0							-- Quantity
					,0							-- Unit Amount
					,0							-- Line Amount
					,1							-- line type = Summary
					,@TopInvoiceLineKey			-- parent line key
					,null -- @SalesAccountKey	-- Default Sales AccountKey (because displayed on screen)
					,null				        -- Class Key
					,0							-- Taxable
					,0							-- Taxable2
					,null						-- @WorkTypeKey					
					,0							--	@PostSalesUsingDetail
					,NULL							-- Entity
					,NULL							-- EntityKey
					,NULL							-- OfficeKey
					,NULL							-- DepartmentKey
					,@ParentInvoiceLineKey output

		if @RetVal <= 0
		begin
			exec sptInvoiceDelete @InvoiceKey
			return -1
		end

		-- now create invoice lines under it

		select @SubGroupLoopKey = -1
		
		while (1=1)
		begin		
			select @SubGroupLoopKey = min(SortKey)
			from   #subgroup
			where  SortKey > @SubGroupLoopKey
			and    GroupEntityKey = @GroupEntityKey   

			if @SubGroupLoopKey is null
				break

			select @SubGroupEntityKey = SubGroupEntityKey
				  ,@SubGroupEntity = SubGroupEntity

				  ,@LineSubject = SubGroupName
				  ,@SalesAccountKey = SalesAccountKey
				  ,@EntityClassKey = ClassKey
				  ,@WorkTypeKey = WorkTypeKey
				  ,@Taxable = Taxable
				  ,@Taxable2 = Taxable2
			from   #subgroup
			where  SortKey = @SubGroupLoopKey

			select @ActualHours = null
			
			select @LaborAmount = Sum(BillAmount)
			      ,@ActualHours = Sum(ActualHours)
			from   #labor 
			where  GroupEntityKey = @GroupEntityKey
			and    GroupEntity = @GroupEntity
			and    SubGroupEntityKey = @SubGroupEntityKey
			and    SubGroupEntity = @SubGroupEntity

			select @BillAmount = isnull(@LaborAmount, 0)

			if isnull(@ActualHours, 0) <= 0
				select @ActualHours = null, @UnitAmount  = null
			else
				select @UnitAmount = @LaborAmount / @ActualHours

			select @ActualHours = isnull(@ActualHours, 0)
			      ,@UnitAmount = isnull(@UnitAmount, 0)

			if @SalesAccountKey is null
				Select @SalesAccountKey = @DefaultSalesAccountKey

			IF ISNULL(@InvoiceByClassKey, 0) > 0
				SELECT @ClassKey = @InvoiceByClassKey
			ELSE
				IF ISNULL(@EntityClassKey, 0) > 0
					SELECT @ClassKey = @EntityClassKey
				ELSE
					SELECT @ClassKey = @DefaultClassKey

			-- now create a detail invoice line for the subgroup, under the group
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @InvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineSubject					-- Line Subject
						  ,null							-- @WorkTypeDescription   
						  ,2               				-- Bill From 
						  ,@ActualHours					-- Quantity
						  ,@UnitAmount					-- Unit Amount
						  ,@BillAmount					-- Line Amount
						  ,2							-- line type
						  ,@ParentInvoiceLineKey		-- parent line key
						  ,@SalesAccountKey				-- @DefaultSalesAccountKey		
						  ,@ClassKey 					-- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable2					-- Taxable2
						  ,@WorkTypeKey					-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,@SubGroupEntity --'tService'							-- Entity
						  ,@SubGroupEntityKey --@NextServiceKey					-- EntityKey						  
						  ,NULL									-- OfficeKey
						  ,NULL									-- DepartmentKey
						  ,@NewInvoiceLineKey output

			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @InvoiceKey
				return -1					   	
			  end

			-- and update the transactions
			update #labor
			set    InvoiceLineKey = @NewInvoiceLineKey 
			where  GroupEntityKey = @GroupEntityKey
			and    GroupEntity = @GroupEntity
			and    SubGroupEntityKey = @SubGroupEntityKey
			and    SubGroupEntity = @SubGroupEntity

		end


	end -- end processing subgroups
	else
	begin

		select @ActualHours = null

		select @LaborAmount = Sum(BillAmount)
		      ,@ActualHours = Sum(ActualHours)
		from   #labor 
		where  GroupEntityKey = @GroupEntityKey
		and    GroupEntity = @GroupEntity

		select @BillAmount = isnull(@LaborAmount, 0) 

		if isnull(@ActualHours, 0) <= 0
			select @ActualHours = null, @UnitAmount  = null
		else
			select @UnitAmount = @LaborAmount / @ActualHours

		select @ActualHours = isnull(@ActualHours, 0)
			      ,@UnitAmount = isnull(@UnitAmount, 0)

		if @SalesAccountKey is null
			Select @SalesAccountKey = @DefaultSalesAccountKey

		IF ISNULL(@InvoiceByClassKey, 0) > 0
			SELECT @ClassKey = @InvoiceByClassKey
		ELSE
			IF ISNULL(@EntityClassKey, 0) > 0
				SELECT @ClassKey = @EntityClassKey
			ELSE
				SELECT @ClassKey = @DefaultClassKey

		-- now create a detail invoice line for the group under the top invoice line
		exec @RetVal = sptInvoiceLineInsertMassBilling
						   @InvoiceKey				-- Invoice Key
						  ,@ProjectKey					-- ProjectKey
						  ,NULL							-- TaskKey
						  ,@LineSubject				-- Line Subject
						  ,null							-- @WorkTypeDescription   
						  ,2               				-- Bill From 
						  ,@ActualHours 				-- Quantity
						  ,@UnitAmount 					-- Unit Amount
						  ,@BillAmount					-- Line Amount
						  ,2							-- line type
						  ,@TopInvoiceLineKey			-- parent line key
						  ,@SalesAccountKey				-- @DefaultSalesAccountKey		
						  ,@ClassKey 					-- Class Key
						  ,@Taxable						-- Taxable
						  ,@Taxable2					-- Taxable2
						  ,@WorkTypeKey				-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,@GroupEntity --'tService'							-- Entity
						  ,@GroupEntityKey --@NextServiceKey					-- EntityKey						  
						  ,NULL									-- OfficeKey
						  ,NULL									-- DepartmentKey
						  ,@NewInvoiceLineKey output

			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @InvoiceKey
				return -1					   	
			  end

		-- and update the transactions

		update #labor
		set    InvoiceLineKey = @NewInvoiceLineKey 
		where  GroupEntityKey = @GroupEntityKey
		and    GroupEntity = @GroupEntity

	end -- end processing groups without subgroups

		   
end
		 
-- Now enter a single line for the Expenses
if exists (select 1 from #expense) 
begin

	Select @SalesAccountKey = @DefaultSalesAccountKey

	IF ISNULL(@InvoiceByClassKey, 0) > 0
		SELECT @ClassKey = @InvoiceByClassKey
	ELSE
		SELECT @ClassKey = @DefaultClassKey

	select @LineSubject = 'Expenses'
		  ,@Taxable = 0
		  ,@Taxable2 = 0
		  ,@ParentInvoiceLineKey = @TopInvoiceLineKey
		  ,@WorkTypeKey = null
		  
	select @BillAmount = sum(BillAmount) from #expense
			  		
	exec @RetVal = sptInvoiceLineInsertMassBilling
							   @InvoiceKey				-- Invoice Key
							  ,@ProjectKey					-- ProjectKey
							  ,NULL							-- TaskKey
							  ,@LineSubject					-- Line Subject
							  ,null							-- @WorkTypeDescription   
							  ,2               				-- Bill From 
							  ,0					-- Quantity
							  ,0					-- Unit Amount
							  ,@BillAmount					-- Line Amount
							  ,2							-- line type
							  ,@ParentInvoiceLineKey		-- parent line key
							  ,@SalesAccountKey				-- @DefaultSalesAccountKey		
							  ,@ClassKey 					-- Class Key
							  ,@Taxable						-- Taxable
							  ,@Taxable2					-- Taxable2
							  ,@WorkTypeKey					-- Work TypeKey
							  ,@PostSalesUsingDetail
							  ,null --,@SubGroupEntity --'tService'							-- Entity
							  ,null -- @SubGroupEntityKey --@NextServiceKey					-- EntityKey						  
							  ,NULL									-- OfficeKey
							  ,NULL									-- DepartmentKey
							  ,@NewInvoiceLineKey output

		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @InvoiceKey
			return -1					   	
			end

		update #expense
		set    InvoiceLineKey = @NewInvoiceLineKey 

end


 
exec sptInvoiceRecalcAmounts @InvoiceKey 

/*
Step 3: Connect the transactions to the invoice lines
*/

if @isBWS = 0
begin
	update tTime
	set    tTime.InvoiceLineKey = b.InvoiceLineKey
		  ,tTime.BilledService = b.ServiceKey
		  ,tTime.BilledHours = b.ActualHours
		  ,tTime.BilledRate = b.ActualRate
	from #labor b
	where tTime.TimeKey = b.TimeKey				  
  
	if @@ERROR <> 0 
	begin
		exec sptInvoiceDelete @InvoiceKey
		return -1					   	
	end
end
else
begin
	update tTime
	set    tTime.InvoiceLineKey = b.InvoiceLineKey
		  ,tTime.BilledService = b.ServiceKey
		  ,tTime.BilledHours = b.ActualHours
		  ,tTime.BilledRate = b.ActualRate
		  -- update rate level and comments, they might be edited on the BWS
		  ,tTime.RateLevel = b.RateLevel
		  ,tTime.BilledComment = b.Comments
	from #labor b
	where tTime.TimeKey = b.TimeKey				  
  
	if @@ERROR <> 0 
	begin
		exec sptInvoiceDelete @InvoiceKey
		return -1					   	
	end
end

--expenses	   
update tExpenseReceipt
	set tExpenseReceipt.InvoiceLineKey = b.InvoiceLineKey
		,tExpenseReceipt.AmountBilled = b.BillAmount
	from #expense b
	where b.Entity = 'Expense'
	and tExpenseReceipt.ExpenseReceiptKey = b.EntityKey 
if @@ERROR <> 0 
	begin
	exec sptInvoiceDelete @InvoiceKey
	return -1				   	
	end
		 
--misc expenses
update tMiscCost
	set tMiscCost.InvoiceLineKey = b.InvoiceLineKey
		,tMiscCost.AmountBilled = b.BillAmount
	from #expense b
	where b.Entity = 'MiscExpense'
	and tMiscCost.MiscCostKey =b.EntityKey 
if @@ERROR <> 0 
	begin
	exec sptInvoiceDelete @InvoiceKey
	return -1	   	
	end
			  	
--voucher	   
update tVoucherDetail
	set tVoucherDetail.InvoiceLineKey = b.InvoiceLineKey
		,tVoucherDetail.AmountBilled = b.BillAmount
	from #expense b
	where b.Entity = 'Voucher'
	and tVoucherDetail.VoucherDetailKey = b.EntityKey
if @@ERROR <> 0 
	begin
	exec sptInvoiceDelete @InvoiceKey
	return -1
	end
			  
--orders	   
update tPurchaseOrderDetail
	set tPurchaseOrderDetail.InvoiceLineKey = b.InvoiceLineKey
		,tPurchaseOrderDetail.AccruedCost = 
			CASE 
				WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
				ELSE 0
			END
		,tPurchaseOrderDetail.AmountBilled = b.BillAmount
	from #expense b, tPurchaseOrder po (nolock)
	where b.Entity = 'Order'
	and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
	and tPurchaseOrderDetail.PurchaseOrderDetailKey = b.EntityKey
if @@ERROR <> 0 
	begin
	exec sptInvoiceDelete @InvoiceKey
	return -1	   	
	end



	RETURN 1
GO
