USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLinePerBillingItemItem]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLinePerBillingItemItem]
	(
	@CompanyKey int	
	,@NewInvoiceKey INT
	,@BillingKey int
	,@BillingMethod int
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@BillingClassKey int
	,@ParentInvoiceLineKey int -- this is the line for the project when billing by client
	,@PostSalesUsingDetail tinyint
	)

AS --Encrypt

  /*
  || When   Who         Rel    What
  || GHL    03/17/09    10.021 (37453) Creation for new requirement
  ||                            Must be able to bill by billing item then item
  ||                            The billing item line is a summary line 
  ||                            If no Billing Item, place at the root at the top
  ||                            Order by alphabetical order
  ||                            Rollup quantity, unit cost, Total at summary line
  ||                            Bill labor by service only (ignore billing item)
  ||
  ||                            Example:
  ||                                     
  ||                            No Item/Service  <-- No Item or Service 
  ||                            Item 0           <-- Item 0 has no Billing Item
  ||                            Billing Item 1   <-- Summary Line
  ||                               Item 1
  ||                               Item 2
  ||                            Service 1 
  ||                            Service 2
  ||                            Billing Item 2   <--- Summary Line
  ||                               Item 3
  ||                               Item 4
  ||                            
  ||                            Taxable/Taxable2 fields defaulted from Item or service 
  ||                            GL account from:
  ||                            1) from item
  ||                            2) if none on item, get from billing item
  ||                            3) if none on item/billing item, get from default
  ||                            Default Class from : 
  ||                            1) Class from project, estimate, client, etc...
  ||                            2) If none on the project, estimate, client, get class from Item
  ||                            3) If none on the project/item, get class from billing item
  ||                            4) If none on the project/item/billing Item use Default Class
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 05/04/09 GHL 10.024 (52065) Setting now transaction BilledComment to tBillingDetail.Comments  
  || 08/13/09 GHL 10.407 (60056) New design: the services also have to be organized under billing items
  || 04/12/10 GHL 10.521 (75825) Invoice line description is now a text field
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  || 11/25/14 GHL 10.586 (236642) Removed line description (for services, it shows as a duplicate of line subject on printout 
  ||                     using templates, not layout) 
  || 01/13/15 GHL 10.587 (242119) Changed name #tran to #tran2 because #tran is already created in spBillingInvoiceBill
  ||                      resulting in naming conflict
  || 03/19/15 GHL 10.591 Added setting of Entity = tService for Abelson Taylor
  */
  
	SET NOCOUNT ON


  CREATE TABLE #tran2(
	Entity varchar(20) null,		-- like in tBillingDetail 
	EntityKey varchar(50) null,
	EntityGuid uniqueidentifier null,
	
	BilledAmount money null,
	Quantity decimal(24,4) null,
	RateLevel int null,
	Rate money null,
	BilledComment varchar(2000),
		
	WorkTypeKey int null,
	ItemKey int null, 
	ServiceKey int null,
	
	WorkTypeName varchar(200) null, 
	ItemName varchar(200) null, -- will come from item or service
	
	InvoiceLineKey int null,
	LineID int null,

	WorkTypeSalesAccountKey int null,
	WorkTypeClassKey int null,
	WorkTypeTaxable int null,
	WorkTypeTaxable2 int null,
	
	ItemSalesAccountKey int null, -- will come from item or service
	ItemClassKey int null,
	ItemTaxable int null,
	ItemTaxable2 int null

	)
	
	CREATE TABLE #line(
	LineID int identity(1,1),
	ParentLineID int null,
	InvoiceLineKey int null,
	ParentLineKey int null,
	
	BilledAmount money null,
	Quantity decimal(24,4) null,
	UnitCost money null,
	
	Subject VARCHAR(200) null,
	Description text null,
	Taxable int null,
	Taxable2 int null,
	ClassKey int null,
	SalesAccountKey int null,
	
	WorkTypeKey int null,
	ItemKey int null, 
	ServiceKey int null,

	)

-- service for labor can be changed, get a good service if not updated
update #tBillingDetail
set    #tBillingDetail.ServiceKey = t.ServiceKey
from   tTime t (nolock)
where  #tBillingDetail.Entity = 'tTime'
and    #tBillingDetail.BillingKey = @BillingKey
and    #tBillingDetail.EntityGuid = t.TimeKey
and    isnull(#tBillingDetail.ServiceKey, 0) = 0   

  INSERT #tran2(Entity, EntityGuid, Quantity, BilledAmount, Rate, RateLevel, WorkTypeKey, ItemKey, ServiceKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityGuid, w.Quantity, w.Total, w.Rate, w.RateLevel
  , isnull(s.WorkTypeKey, 0), 0, isnull(w.ServiceKey, 0), s.Description, w.Comments   
  FROM   #tBillingDetail w
	LEFT OUTER JOIN tService s (NOLOCK) ON w.ServiceKey = s.ServiceKey
  WHERE  w.Entity = 'tTime'
  AND    w.BillingKey = @BillingKey
  
  INSERT #tran2(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, ItemKey, ServiceKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), 0, i.ItemName, w.Comments   
  FROM  #tBillingDetail w
	INNER JOIN tMiscCost t (NOLOCK) ON t.MiscCostKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tMiscCost'
  AND    w.BillingKey = @BillingKey
  
  INSERT #tran2(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, ItemKey, ServiceKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), 0, i.ItemName, w.Comments   
  FROM  #tBillingDetail w
	INNER JOIN tExpenseReceipt t (NOLOCK) ON t.ExpenseReceiptKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tExpenseReceipt'
  AND    w.BillingKey = @BillingKey
  
  INSERT #tran2(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, ItemKey, ServiceKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), 0 , i.ItemName, w.Comments  
  FROM  #tBillingDetail w
	INNER JOIN tVoucherDetail t (NOLOCK) ON t.VoucherDetailKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tVoucherDetail'
  AND    w.BillingKey = @BillingKey
 
  INSERT #tran2(Entity, EntityKey, Quantity, BilledAmount, WorkTypeKey, ItemKey, ServiceKey, ItemName, BilledComment)
  SELECT w.Entity, w.EntityKey, w.Quantity, w.Total
  , isnull(i.WorkTypeKey, 0), isnull(t.ItemKey, 0), 0, i.ItemName, w.Comments   
  FROM  #tBillingDetail w
	INNER JOIN tPurchaseOrderDetail t (NOLOCK) ON t.PurchaseOrderDetailKey = w.EntityKey 
	LEFT OUTER JOIN tItem i (NOLOCK) ON t.ItemKey = i.ItemKey
  WHERE  w.Entity = 'tPurchaseOrderDetail'
  AND    w.BillingKey = @BillingKey
  

  If exists (select 1 from #tran2 where WorkTypeKey = 0 and ItemKey = 0 and ServiceKey = 0)
	begin
		insert #line (ParentLineID, Subject, WorkTypeKey, ItemKey, ServiceKey)
		select 0, 'No Item', 0, 0, 0
	
		update #tran2
		set    LineID = 1
		where WorkTypeKey = 0 and ItemKey = 0 and ServiceKey = 0
	end
	
  -- set the billing item name	 
	update #tran2
	set    #tran2.WorkTypeName = wt.WorkTypeName
	from   tWorkType wt (nolock)
	where  #tran2.WorkTypeKey = wt.WorkTypeKey 	 
	
	-- if no billing item, set it to the item name   
	update #tran2
	set    #tran2.WorkTypeName = #tran2.ItemName
	where  #tran2.WorkTypeKey = 0 	 
	
	-- capture lines under the root
	-- must be done in one shot, because by alphabetical order
	-- Take item or services without billing item
	-- Take billing items 
	
	insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID)
	select distinct WorkTypeName, 0, ItemKey, ServiceKey, 0
	from   #tran2
	where  LineID is null        -- do not take no item/no service lines
	and    WorkTypeKey = 0       -- no billing Item
	and    (ItemKey + ServiceKey) > 0 -- a service OR an item, + = OR
	
	Union  all
	
	select distinct WorkTypeName, WorkTypeKey, 0, 0, 0
	from   #tran2
	where  LineID is null -- do not take no item/no service lines
	and    WorkTypeKey > 0 
	
	order by WorkTypeName
	
	/*
	-- if we want the lines under the root at the top, do it in 2 shots
	insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID)
	select distinct WorkTypeName, 0, ItemKey, ServiceKey, 0
	from   #tran2
	where  LineID is null        -- do not take no item/no service lines
	and    WorkTypeKey = 0       -- no billing Item
	and    (ItemKey + ServiceKey) > 0 -- a service OR an item, + = OR
	order by WorkTypeName
	
	insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey, ParentLineID)
	select distinct WorkTypeName, WorkTypeKey, 0, 0, 0
	from   #tran2
	where  LineID is null -- do not take no item/no service lines
	and    WorkTypeKey > 0 
	order by WorkTypeName
	*/
	
	-- insert the items under  a billing item
	insert #line(Subject, WorkTypeKey, ItemKey, ServiceKey)
	select distinct ItemName, WorkTypeKey, ItemKey, ServiceKey
	from   #tran2
	where  LineID is null
	--and    ItemKey > 0
	and    WorkTypeKey > 0
	order by ItemName

	-- link expense trans to the item
	update #tran2
	set    #tran2.LineID = #line.LineID
	from   #line
	where  #tran2.LineID is null
	and    #tran2.ItemKey = #line.ItemKey
	and    #line.ItemKey > 0
	
	update #tran2
	set    #tran2.LineID = #line.LineID
	from   #line
	where  #tran2.LineID is null
	and    #tran2.ServiceKey = #line.ServiceKey
	and    #line.ServiceKey > 0
	
	--now link the expense lines to the billing item parent
	update #line
	set    #line.ParentLineID = (select min (b.LineID) from #line b where b.WorkTypeKey = #line.WorkTypeKey 
			and b.ItemKey = 0) 
	where  #line.WorkTypeKey > 0
	and    #line.ItemKey > 0
	
	update #line
	set    #line.ParentLineID = (select min (b.LineID) from #line b where b.WorkTypeKey = #line.WorkTypeKey 
			and b.ServiceKey = 0) 
	where  #line.WorkTypeKey > 0
	and    #line.ServiceKey > 0
	
		
  -- now get the accounting info from billing item, item and service in the transactions table	
  UPDATE   #tran2
	SET    #tran2.WorkTypeSalesAccountKey = ISNULL(wt.GLAccountKey, 0)
		   ,#tran2.WorkTypeClassKey = ISNULL(wt.ClassKey, 0)
		   ,#tran2.WorkTypeTaxable = ISNULL(wt.Taxable, 0)
		   ,#tran2.WorkTypeTaxable2 = ISNULL(wt.Taxable2, 0)
	FROM   tWorkType wt (NOLOCK) 
	WHERE  #tran2.WorkTypeKey = wt.WorkTypeKey
	AND    #tran2.WorkTypeKey > 0
	
	
	UPDATE #tran2
	SET    #tran2.ItemSalesAccountKey = ISNULL(i.SalesAccountKey, 0)
		   ,#tran2.ItemClassKey = ISNULL(i.ClassKey, 0)
		   ,#tran2.ItemTaxable = ISNULL(i.Taxable, 0)
		   ,#tran2.ItemTaxable2 = ISNULL(i.Taxable2, 0)
	FROM   tItem i (NOLOCK)
	WHERE  #tran2.ItemKey = i.ItemKey
  	AND    #tran2.ItemKey > 0
  	
  	UPDATE #tran2
	SET    #tran2.ItemSalesAccountKey = ISNULL(s.GLAccountKey, 0)
		   ,#tran2.ItemClassKey = ISNULL(s.ClassKey, 0)
		   ,#tran2.ItemTaxable = ISNULL(s.Taxable, 0)
		   ,#tran2.ItemTaxable2 = ISNULL(s.Taxable2, 0)
	FROM   tService s (NOLOCK)
	WHERE  #tran2.ServiceKey = s.ServiceKey
  	AND    #tran2.ServiceKey > 0
  	
	-- prepare accounting info for the line
    UPDATE #line
    SET    Taxable = 0,Taxable2 = 0,ClassKey = 0,SalesAccountKey = 0
          ,Quantity = 0, BilledAmount=0, UnitCost=0
          
	-- get the Taxable/taxable2 fields from Item or Service
	UPDATE #line
	SET    #line.Taxable = #tran2.ItemTaxable
		  ,#line.Taxable2 = #tran2.ItemTaxable2
	FROM   #tran2 
	WHERE  #line.ItemKey = #tran2.ItemKey
	AND    #line.ItemKey > 0
	
	UPDATE #line
	SET    #line.Taxable = #tran2.ItemTaxable
		  ,#line.Taxable2 = #tran2.ItemTaxable2
	FROM   #tran2 
	WHERE  #line.ServiceKey = #tran2.ServiceKey
	AND    #line.ServiceKey > 0
	
   -- GL account from:
   -- 1) from item
   -- 2) if none on item, get from billing item
   -- 3) if none on item/billing item, get from default
    UPDATE #line
	SET    #line.SalesAccountKey = #tran2.ItemSalesAccountKey
	FROM   #tran2 
	WHERE  #line.ServiceKey = #tran2.ServiceKey
	AND    #line.ServiceKey > 0
	
	UPDATE #line
	SET    #line.SalesAccountKey = #tran2.ItemSalesAccountKey
	FROM   #tran2 
	WHERE  #line.ItemKey = #tran2.ItemKey
	AND    #line.ItemKey > 0
	
	UPDATE #line
	SET    #line.SalesAccountKey = #tran2.WorkTypeSalesAccountKey
	FROM   #tran2 
	WHERE  #line.ItemKey = #tran2.ItemKey
	AND    #line.WorkTypeKey > 0
	AND    #line.ItemKey > 0
	AND    ISNULL(#line.SalesAccountKey, 0) = 0

	UPDATE #line
	SET    #line.SalesAccountKey = #tran2.WorkTypeSalesAccountKey
	FROM   #tran2 
	WHERE  #line.ServiceKey = #tran2.ServiceKey
	AND    #line.WorkTypeKey > 0
	AND    #line.ServiceKey > 0
	AND    ISNULL(#line.SalesAccountKey, 0) = 0
	
	UPDATE #line
	SET    #line.SalesAccountKey = @DefaultSalesAccountKey
	WHERE   ISNULL(#line.SalesAccountKey, 0) = 0
	
	-- Default Class from : 
    -- 1) Class from project, estimate, client, etc...
    -- 2) If none on the project, estimate, client, get class from Item
    -- 3) If none on the project/item, get class from billing item
    -- 4) If none on the project/item/billing Item use Default Class
	IF ISNULL(@BillingClassKey, 0) > 0
		UPDATE #line
		SET    #line.ClassKey = @BillingClassKey
	ELSE
	BEGIN
		UPDATE #line
		SET    #line.ClassKey = #tran2.ItemClassKey
		FROM   #tran2 
		WHERE  #line.ServiceKey = #tran2.ServiceKey
		AND    #line.ServiceKey > 0
		
		UPDATE #line
		SET    #line.ClassKey = #tran2.ItemClassKey
		FROM   #tran2 
		WHERE  #line.ItemKey = #tran2.ItemKey
		AND    #line.ItemKey > 0
		
		UPDATE #line
		SET    #line.ClassKey = #tran2.WorkTypeClassKey
		FROM   #tran2 
		WHERE  #line.ItemKey = #tran2.ItemKey
		AND    #line.WorkTypeKey > 0
		AND    #line.ItemKey > 0
		AND    ISNULL(#line.ClassKey, 0) = 0

		UPDATE #line
		SET    #line.ClassKey = #tran2.WorkTypeClassKey
		FROM   #tran2 
		WHERE  #line.ServiceKey = #tran2.ServiceKey
		AND    #line.WorkTypeKey > 0
		AND    #line.ServiceKey > 0
		AND    ISNULL(#line.ClassKey, 0) = 0
		
		UPDATE #line
		SET    #line.ClassKey = @DefaultClassKey
		WHERE  ISNULL(#line.ClassKey, 0) = 0
	
	END
	
	UPDATE #line
    SET    #line.Description = wt.Description
    FROM   tWorkType wt (nolock)
    WHERE  #line.WorkTypeKey = wt.WorkTypeKey
    AND    #line.WorkTypeKey > 0
    AND    #line.ItemKey = 0
    AND    #line.ServiceKey = 0
  
	UPDATE #line
    SET    #line.Description = s.Description
    FROM   tService s (nolock)
    WHERE  #line.ServiceKey = s.ServiceKey
    AND    #line.WorkTypeKey = 0
    AND    #line.ItemKey = 0
    AND    #line.ServiceKey > 0
  
	UPDATE #line
    SET    #line.Description = i.StandardDescription
    FROM   tItem i (nolock)
    WHERE  #line.ItemKey = i.ItemKey
    AND    #line.ItemKey > 0
    AND    #line.ServiceKey = 0
    --AND    #line.ParentLineID > 0
  
  
   UPDATE  #line
   SET     #line.BilledAmount = ISNULL((
			SELECT SUM(#tran2.BilledAmount)
			FROM   #tran2
			WHERE  #tran2.LineID = #line.LineID
			),0)
  
  -- on items or services only
   UPDATE  #line
   SET     #line.Quantity = ISNULL((
			SELECT SUM(#tran2.Quantity)
			FROM   #tran2
			WHERE  #tran2.LineID = #line.LineID
			),0)
	WHERE   (ItemKey + ServiceKey) > 0						       
	
	UPDATE  #line
	SET     #line.UnitCost = CASE WHEN #line.Quantity = 0 THEN #line.BilledAmount
							      ELSE #line.BilledAmount / #line.Quantity END
	WHERE   (ItemKey + ServiceKey) > 0						       
 
Declare @RetVal int
Declare @LineID int	
Declare @ParentLineID int
Declare @NewInvoiceLineKey int
Declare @ParentLineKey int

Declare @LineSubject varchar(100)	
Declare @BilledAmount money
Declare @Quantity decimal(24,4)
Declare @UnitCost money
Declare @SalesAccountKey int 
Declare @ClassKey int
Declare @Taxable tinyint
Declare @Taxable2 tinyint											
Declare	@WorkTypeKey int 
Declare	@ItemKey int 
Declare	@ServiceKey int 
Declare @LineEntity varchar(50)
Declare @LineEntityKey int
		
Declare @IsSummary int
	
	-- Process the lines under the root first, or under @ParentInvoiceLineKey 
	select  @LineID = -1

	while (1=1)
	begin
		select @LineID = min(LineID)
		from   #line
		where  LineID > @LineID
		and    ParentLineID = 0  -- under root
	
		if @LineID is null
			break
		
		-- unpack line info
		select @LineSubject = Subject
			  ,@WorkTypeKey = WorkTypeKey
		      ,@ItemKey = ItemKey
		      ,@ServiceKey = ServiceKey
		      ,@BilledAmount = BilledAmount
		      ,@Taxable = Taxable
		      ,@Taxable2 = Taxable2
		      ,@ClassKey = ClassKey
		      ,@SalesAccountKey = SalesAccountKey
			  ,@Quantity = Quantity
			  ,@UnitCost = UnitCost	
		from #line 
		where LineID = @LineID
			
		select @IsSummary = 0
		if exists (select 1 from #line where ParentLineID = @LineID)
			 select @IsSummary = 1
		      	 
		if @IsSummary = 1 
		begin	
			-- insert summary invoice line for the work type/ billing item
			exec @RetVal = sptInvoiceLineInsertMassBilling
							@NewInvoiceKey				-- Invoice Key
							,NULL						-- ProjectKey 
							,NULL						-- TaskKey
							,@LineSubject 			    -- Line Subject
							,NULL                 		-- Line description (updated at the end)
							,0		      				-- Bill From 
							,0							-- Quantity
							,0							-- Unit Amount
							,0							-- Line Amount
							,1							-- line type = Summary
							,@ParentInvoiceLineKey		-- parent line key
							,NULL --@DefaultSalesAccountKey	-- Default Sales AccountKey (because it is displayed on screen)
							,@DefaultClassKey           -- Class Key
							,0							-- Taxable
							,0							-- Taxable2
							,@WorkTypeKey				-- Work TypeKey
							,@PostSalesUsingDetail
							,NULL							-- Entity
							,NULL							-- EntityKey
							,NULL							-- OfficeKey
							,NULL							-- DepartmentKey
							,@NewInvoiceLineKey output
			
			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end			           	
			if @RetVal <> 1 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end
							
			-- save the keys in #line 	
			update #line
			set    ParentLineKey = 0
			      ,InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID

			-- and save the parent info
			update #line
			set    ParentLineKey = @NewInvoiceLineKey
			where  ParentLineID = @LineID
				
		end -- summary line
		else
		begin
			-- regular line for the No Item line, items w/o billing item and, services
	
			-- insert invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						@NewInvoiceKey					-- Invoice Key
						,@ProjectKey					-- ProjectKey
						,NULL							-- TaskKey
						,@LineSubject					-- Line Subject
						,NULL                           -- Line description -- text, cannot be held in a var
						,2               				-- Bill From = 2, Use Transaction 
						,@Quantity						-- Quantity
						,@UnitCost						-- Unit Amount
						,@BilledAmount					-- Line Amount
						,2								-- line type = detail
						,@ParentInvoiceLineKey			-- parent line key
						,@SalesAccountKey				-- Default Sales AccountKey
						,@ClassKey						-- Class Key
						,@Taxable						-- Taxable
						,@Taxable2						-- Taxable2
						,@WorkTypeKey					-- Work TypeKey
						,@PostSalesUsingDetail
						,NULL							-- Entity
						,NULL							-- EntityKey
						,NULL							-- OfficeKey
						,NULL							-- DepartmentKey						  						  
						,@NewInvoiceLineKey output
			
			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end			           	
			if @RetVal <> 1 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end

			-- save the keys in #line 	
			update #line
			set    ParentLineKey = 0
			      ,InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID
			
			-- and save the keys in #tran2 to tie back to the actual transactions 
			update #tran2
			set    InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID
										 
		end	
			
	end
	
	-- now process the detail lines under a summary line	
	select  @LineID = -1

	while (1=1)
	begin
		select @LineID = min(LineID)
		from   #line
		where  LineID > @LineID
		and    ParentLineID > 0  -- under a summary line
	
		if @LineID is null
			break
		
		-- unpack line info
		select @LineSubject = Subject
		      ,@WorkTypeKey = WorkTypeKey
		      ,@ItemKey = ItemKey
		      ,@ServiceKey = ServiceKey
		      ,@BilledAmount = BilledAmount
		      ,@Taxable = Taxable
		      ,@Taxable2 = Taxable2
		      ,@ClassKey = ClassKey
		      ,@SalesAccountKey = SalesAccountKey
		      ,@Quantity = Quantity
			  ,@UnitCost = UnitCost	

		      ,@ParentLineKey = ParentLineKey -- we need this now
		from #line 
		where LineID = @LineID
			
		if isnull(@ServiceKey, 0) > 0
			select @LineEntity = 'tService'
			      ,@LineEntityKey = @ServiceKey
		else
			select @LineEntity = null
			      ,@LineEntityKey = null

		-- insert invoice line
		exec @RetVal = sptInvoiceLineInsertMassBilling
					@NewInvoiceKey					-- Invoice Key
					,@ProjectKey					-- ProjectKey
					,NULL							-- TaskKey
					,@LineSubject					-- Line Subject
					,NULL                	        -- Line description...text cannot be held in a var
					,2               				-- Bill From = 2, Use Transaction 
					,@Quantity						-- Quantity
					,@UnitCost						-- Unit Amount
					,@BilledAmount					-- Line Amount
					,2								-- line type = detail
					,@ParentLineKey					-- parent line key
					,@SalesAccountKey				-- Default Sales AccountKey
					,@ClassKey						-- Class Key
					,@Taxable						-- Taxable
					,@Taxable2						-- Taxable2
					,@WorkTypeKey					-- Work TypeKey
					,@PostSalesUsingDetail
					,@LineEntity							-- Entity
					,@LineEntityKey							-- EntityKey
					,NULL							-- OfficeKey
					,NULL							-- DepartmentKey						  						  
					,@NewInvoiceLineKey output
		
			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end			           	
			if @RetVal <> 1 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end

			-- save the keys in #line 	
			update #line
			set    InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID
			
			-- and save the keys in #tran2 to tie back to the actual transactions 
			update #tran2
			set    InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID															
							
	end
	

		-- now update the actual transactions with the InvoiceLineKey
		update tTime
		   set InvoiceLineKey = #tran2.InvoiceLineKey
			  ,BilledService = #tran2.ServiceKey
			  ,RateLevel = ISNULL(#tran2.RateLevel, tTime.RateLevel)					  
			  ,BilledHours = #tran2.Quantity
			  ,BilledRate = #tran2.Rate
			  ,BilledComment = #tran2.BilledComment
		  from #tran2
		   where #tran2.Entity = 'tTime'
		   and   #tran2.EntityGuid = tTime.TimeKey 
	       and   tTime.InvoiceLineKey is NULL
		   and   #tran2.InvoiceLineKey IS NOT NULL
		   	
		if @@ERROR <> 0 
		 begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
		  end
			  	  
		update tExpenseReceipt
		set InvoiceLineKey = #tran2.InvoiceLineKey
			,AmountBilled = #tran2.BilledAmount
			,BilledComment = #tran2.BilledComment
		from #tran2
		where #tran2.Entity = 'tExpenseReceipt'
		and tExpenseReceipt.ExpenseReceiptKey = #tran2.EntityKey
		and tExpenseReceipt.InvoiceLineKey is NULL
		and   #tran2.InvoiceLineKey IS NOT NULL
		   	
		if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
		end
			  	  
		update tMiscCost
		set InvoiceLineKey = #tran2.InvoiceLineKey
			,AmountBilled = #tran2.BilledAmount
			,BilledComment = #tran2.BilledComment
		from #tran2
		where #tran2.Entity = 'tMiscCost'
		and tMiscCost.MiscCostKey = #tran2.EntityKey
		and tMiscCost.InvoiceLineKey is NULL
		and   #tran2.InvoiceLineKey IS NOT NULL
		
		if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
		end
		
		update tVoucherDetail
		set InvoiceLineKey = #tran2.InvoiceLineKey
			,AmountBilled = #tran2.BilledAmount
			,BilledComment = #tran2.BilledComment
		from #tran2
		where #tran2.Entity = 'tVoucherDetail'
		and tVoucherDetail.VoucherDetailKey = #tran2.EntityKey
		and tVoucherDetail.InvoiceLineKey is NULL
		and   #tran2.InvoiceLineKey IS NOT NULL
		
		if @@ERROR <> 0 
		begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
		end

		update tPurchaseOrderDetail
		   set InvoiceLineKey = #tran2.InvoiceLineKey
			  ,tPurchaseOrderDetail.AccruedCost = 
			   CASE 
					WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
					ELSE 0
				END
			  ,AmountBilled = #tran2.BilledAmount
			  ,BilledComment = #tran2.BilledComment
		  from #tran2
				,tPurchaseOrder po (nolock)
		 where #tran2.Entity = 'tPurchaseOrderDetail'
		   and tPurchaseOrderDetail.PurchaseOrderDetailKey = #tran2.EntityKey
			and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey 
			and tPurchaseOrderDetail.InvoiceLineKey is NULL
			and #tran2.InvoiceLineKey IS NOT NULL	   
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8				   	
		  end

	-- LineDescription is a text field and cannot be held in a variable during the processing of the loops	
	/* 
	update tInvoiceLine 
	set    tInvoiceLine.LineDescription = #line.Description 
	from   #line
	where  tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey
	*/
	RETURN 1
GO
