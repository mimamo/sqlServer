USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetRetainer]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetRetainer]
	(
	@NewInvoiceKey INT
	,@DefaultSalesAccountKey INT
	,@DefaultClassKey INT
	,@WorkTypeKey INT
	,@PostSalesUsingDetail INT
	)

AS --Encrypt

  /*
  || When   Who         Rel    What
  || GHL    06/29/07    8.5    Added new fields OfficeKey, DepartmentKey
  || GHL    07/31/07    8.5    Removed refs to expense types
  || GHL    08/30/07    8434   Bug 12318. Changed conditions for setting InvoiceLineKey on expenses
  || GHL    09/20/07    8437   Bug 13169. Added retainer description, this is a new field  
  || GHL    09/21/07    8437   Complete rewrite for Enh 13169
  ||                           must be able to invoice retainers by client (see pseudocode below) 
  || GHL    11/02/07    8440  (15376) Use TranCount > 0 rather than Amount Billed <> 0 to
  ||                           determine if an invoice line must be created (because +750 - 750 = 0
  ||                           causing invoice line to be missing)  
  || GHL    09/03/09    10.509 (60144) Include OfficeKey from the retainer   
  || 01/22/10 GHL 10.517 (69011) Changed retainer amount logic since we can have amounts <0  
  || 10/04/13 GHL 10.573 Using now PTotalCost for multi currency
  */

/*
for each #tProcWIPKeys
	if EntityType = 'Retainer' and AmountBilled > 0
		insert invoice line
end for

create 1 invoice line for all #tProcWIPKeys where LineFormat = 1

for each ProjectKey in #tProcWIPKeys where LineFormat = 2
	create 1 invoice line
end for

*/

	SET NOCOUNT ON
	
Declare @RetainerKey INT
Declare @NewInvoiceLineKey int
Declare @RetVal int
Declare @ProjectName varchar(100)
Declare @ProjectKey int
Declare @InvoiceDate datetime
Declare @Title VARCHAR(100)
Declare @Description VARCHAR(1500)
Declare @ExtraTitle VARCHAR(100) -- this is the title for the extra expenses where LineFormat = 1
Declare @SalesAccountKey int
Declare @AmountBilled money
Declare @TranCount money
Declare @ProjectClassKey int
Declare @ClassKey int
Declare @OfficeKey int
Declare @ProjectCount int
	
	SELECT @InvoiceDate = InvoiceDate
	FROM   tInvoice (NOLOCK)
	WHERE  InvoiceKey = @NewInvoiceKey
	
	-- Can only set the line subject to the retainer's title if we have a single retainer
	IF (SELECT COUNT(DISTINCT RetainerKey) FROM #tProcWIPKeys WHERE EntityType = 'Retainer') = 1
		SELECT @ExtraTitle = r.Title + ' - Extra expenses'
		FROM   tRetainer r (NOLOCK)
			INNER JOIN #tProcWIPKeys k ON r.RetainerKey = k.RetainerKey 
		WHERE k.EntityType = 'Retainer'
	ELSE
		SELECT @ExtraTitle = ' Extra expenses'

	
	-- First process all the true retainer amounts
	SELECT @RetainerKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @RetainerKey = MIN(RetainerKey)
		FROM   #tProcWIPKeys
		WHERE  EntityType = 'Retainer'
		--AND    AmountBilled > 0 -- because now the retainer amounts can be <0, =0, >0
		AND    RetainerKey > @RetainerKey
		
		IF @RetainerKey IS NULL
			BREAK
			
		SELECT 	@AmountBilled = AmountBilled -- that would be the retainer amount		
		FROM    #tProcWIPKeys
		WHERE   EntityType = 'Retainer'
		AND     RetainerKey = @RetainerKey  -- EntityKey would work too 
		
		SELECT @Title			= Title 
			  ,@Description		= Description
			  ,@SalesAccountKey = SalesAccountKey
		      ,@OfficeKey       = OfficeKey
		      ,@ClassKey        = ClassKey
		FROM   tRetainer (NOLOCK)
		WHERE  RetainerKey = @RetainerKey 
			
		IF ISNULL(@SalesAccountKey, 0) = 0
			SELECT @SalesAccountKey = @DefaultSalesAccountKey

		IF ISNULL(@ClassKey, 0) = 0
			SELECT @ClassKey = @DefaultClassKey
			
		SELECT @ProjectCount = COUNT(*) FROM tProject (NOLOCK) WHERE RetainerKey = @RetainerKey
		
		IF @ProjectCount = 1
			SELECT @ProjectKey = ProjectKey FROM tProject (NOLOCK) WHERE RetainerKey = @RetainerKey
		ELSE
			SELECT @ProjectKey = NULL
				
		-- One line for the retainer amount
		exec @RetVal = sptInvoiceLineInsert
				@NewInvoiceKey				-- Invoice Key
				,@ProjectKey						-- ProjectKey
				,NULL						-- TaskKey
				,@Title						-- Line Subject
				,@Description    			-- Line description
				,1               			-- Bill From: Important to distinguish Retainer Amount from extra 
				,0							-- Quantity
				,0							-- Unit Amount
				,@AmountBilled				-- Line Amount
				,2							-- line type
				,0							-- parent line key
				,@SalesAccountKey			-- Default Sales AccountKey
				,@ClassKey           -- Class Key
				,0							-- Taxable
				,0							-- Taxable2
				,@WorkTypeKey				-- Work TypeKey
   				,0							-- always 0 as the amount is on the line
				,NULL						-- Entity
				,NULL						-- EntityKey	
				,@OfficeKey						-- OfficeKey
				,NULL						-- DepartmentKey	  						  
				,@NewInvoiceLineKey output

		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end
		if @@ERROR <> 0 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end			           		   		
		
		Update tInvoiceLine Set RetainerKey = @RetainerKey Where InvoiceLineKey = @NewInvoiceLineKey
		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end
	
	END
	
	-- Now the transactions where the line format = 1 (one invoice line only)
	SELECT @AmountBilled = ISNULL(SUM(AmountBilled), 0)
			,@TranCount = COUNT(*)
	FROM   #tProcWIPKeys 
	WHERE  Action = 1 AND LineFormat = 1 
	
	--IF @AmountBilled <> 0
	IF @TranCount > 0
	BEGIN
	
		-- if we only have ONE project put on the line
		IF (SELECT COUNT(DISTINCT ProjectKey) FROM #tProcWIPKeys 
			WHERE Action = 1 AND LineFormat = 1) = 1	
				SELECT @ProjectKey = ProjectKey FROM #tProcWIPKeys 
				WHERE Action = 1 AND LineFormat = 1
		ELSE
				SELECT @ProjectKey = NULL
					
		exec @RetVal = sptInvoiceLineInsert
					  @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@ExtraTitle					-- Line Subject
					  ,null    						-- Line description
					  ,2               				-- Bill From: Important to distinguish between extra and retainer 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@AmountBilled				-- Line Amount
					  ,2							-- line type
					  ,0							-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@DefaultClassKey             -- Class Key
					  ,0							-- Taxable
					  ,0							-- Taxable2
					  ,@WorkTypeKey					-- Work TypeKey
   					  ,@PostSalesUsingDetail
					  ,NULL							-- Entity
					  ,NULL							-- EntityKey						  						  
    				  ,NULL							-- OfficeKey
					  ,NULL							-- DepartmentKey	  						  
					  ,@NewInvoiceLineKey output

		if @RetVal <> 1 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end
		if @@ERROR <> 0 
			begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -17					   	
			end			           		   		

		UPDATE #tProcWIPKeys
		SET    InvoiceLineKey = @NewInvoiceLineKey
		WHERE  Action = 1
		AND    LineFormat = 1			
	END
	  
	
	-- Now process the transactions where the line format = 2 (one invoice line per project)
	SELECT @ProjectKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tProcWIPKeys
		WHERE  Action = 1
		AND    LineFormat = 2 
		AND    ProjectKey > @ProjectKey
	
		IF @ProjectKey IS NULL
			BREAK
	
		SELECT @AmountBilled = ISNULL(SUM(AmountBilled), 0) 
			  ,@TranCount = COUNT(*)			
		FROM #tProcWIPKeys WHERE Action = 1 
		AND LineFormat = 2
		AND ProjectKey = @ProjectKey
		
		--IF @AmountBilled <> 0
		IF @TranCount > 0
		BEGIN
		
			SELECT @ProjectName = ProjectName + ' - Extra expenses'
				   ,@ProjectClassKey = ClassKey
				   ,@OfficeKey = OfficeKey	
			FROM   tProject (NOLOCK)
			WHERE  ProjectKey = @ProjectKey
			
			IF ISNULL(@ProjectClassKey, 0) > 0
				SELECT @ClassKey = @ProjectClassKey
			ELSE
				SELECT @ClassKey = @DefaultClassKey
			 
			exec @RetVal = sptInvoiceLineInsert
						@NewInvoiceKey				-- Invoice Key
						,@ProjectKey				-- ProjectKey
						,NULL						-- TaskKey
						,@ProjectName				-- Line Subject
						,null    					-- Line description
						,2               			-- Bill From: Important to distinguish between extra and retainer 
						,0							-- Quantity
						,0							-- Unit Amount
						,@AmountBilled				-- Line Amount
						,2							-- line type
						,0							-- parent line key
						,@DefaultSalesAccountKey	-- Default Sales AccountKey
						,@ClassKey					-- Class Key
						,0							-- Taxable
						,0							-- Taxable2
						,@WorkTypeKey				-- Work TypeKey
   						,@PostSalesUsingDetail
						,NULL						-- Entity
						,NULL						-- EntityKey						  						  
    					,@OfficeKey						-- OfficeKey
						,NULL						-- DepartmentKey	  						  
						,@NewInvoiceLineKey output

			if @RetVal <> 1 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end
			if @@ERROR <> 0 
				begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -17					   	
				end			           		   		

			UPDATE #tProcWIPKeys
			SET    InvoiceLineKey = @NewInvoiceLineKey
			WHERE  Action = 1
			AND    LineFormat = 2
			AND    ProjectKey = @ProjectKey
					
		END		
		
	END
	
	/*
	|| All transactions must be marked as billed with proper InvoiceLineKey
	*/
			
	update tTime
		set InvoiceLineKey = w.InvoiceLineKey
			,BilledService = tTime.ServiceKey
			,BilledHours = tTime.ActualHours
			,BilledRate = tTime.ActualRate
			,DateBilled = @InvoiceDate
		from #tProcWIPKeys w 
		where w.EntityType = 'Time'
		and tTime.TimeKey = cast(w.EntityKey as uniqueidentifier)					  
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -8					   	
		end

	update tExpenseReceipt
		set InvoiceLineKey = w.InvoiceLineKey
			,AmountBilled = BillableCost
			,DateBilled = @InvoiceDate
		from #tProcWIPKeys w
		where w.EntityType = 'Expense'
		and tExpenseReceipt.ExpenseReceiptKey = cast(w.EntityKey as integer)
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -8					   	
		end
	
	--misc expenses
	update tMiscCost
		set InvoiceLineKey = w.InvoiceLineKey
			,AmountBilled = BillableCost
			,DateBilled = @InvoiceDate
		from #tProcWIPKeys w
		where w.EntityType = 'MiscExpense'
		and tMiscCost.MiscCostKey = cast(w.EntityKey as integer)
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -9					 	
		end
		
	--voucher	   
	update tVoucherDetail
		set InvoiceLineKey = w.InvoiceLineKey
			,AmountBilled = BillableCost
			,DateBilled = @InvoiceDate
		from #tProcWIPKeys w
		where w.EntityType = 'Voucher'
		and tVoucherDetail.VoucherDetailKey = cast(w.EntityKey as integer)
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -10				   	
		end
		
	--Order	   
	update tPurchaseOrderDetail
		set InvoiceLineKey = w.InvoiceLineKey
			,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) end ,0)
			,DateBilled = @InvoiceDate
		from #tProcWIPKeys w, tPurchaseOrder po
		where w.EntityType = 'Order'
		and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
		and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
	if @@ERROR <> 0 
		begin
		exec sptInvoiceDelete @NewInvoiceKey
		return -10				   	
		end
	
	UPDATE tRetainer
	SET    tRetainer.LastBillingDate = @InvoiceDate
	FROM   #tProcWIPKeys
	WHERE  tRetainer.RetainerKey = #tProcWIPKeys.RetainerKey
	--AND    #tProcWIPKeys.AmountBilled > 0 (because can be <0,=0, >0)
	AND    #tProcWIPKeys.EntityType = 'Retainer'
	
	RETURN 1
GO
