USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingLinesInsert]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingLinesInsert]
	(
	@CompanyKey int	
	,@NewInvoiceKey INT
	,@ProjectKey INT
	,@DefaultSalesAccountKey int
	,@DefaultClassKey int
	,@ParentInvoiceLineKey int -- this is the line for the project when billing by client
	,@PostSalesUsingDetail tinyint
	,@CampaignSegmentKey int = null
	)
AS --Encrypt

	SET NOCOUNT ON 
	
/*
|| When     Who Rel    What
|| 03/26/10 GHL 10.521 Creation for new layouts  
|| 04/12/10 GHL 10.521 (75825) Invoice line description is now a text field
|| 05/12/10 GHL 10.522 Added Campaign segment key to put on the lines
|| 11/07/13 GHL 10.574 pod.AccruedCost is in HC
|| 03/20/15 GHL 10.591 Added setting of Entity/EntityKey
*/
	
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
Declare @DisplayOption int		
Declare @IsSummary int
Declare @LineEntity varchar(50)
Declare @LineEntityKey int
	

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
		      ,@DisplayOption = DisplayOption
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
							,NULL --@DefaultSalesAccountKey	-- Default Sales AccountKey because it is displayed on screen
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
						,NULL                			-- Line description (updated at the end)
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
			set    ParentLineKey = 0
			      ,InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID
			
			-- and save the keys in #tran to tie back to the actual transactions 
			update #tran
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
		      ,@DisplayOption = DisplayOption

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
					,NULL               			-- Line description
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
			
			-- and save the keys in #tran to tie back to the actual transactions 
			update #tran
			set    InvoiceLineKey = @NewInvoiceLineKey
			where  LineID = @LineID															
							
	end
	

		-- now update the actual transactions with the InvoiceLineKey
		update tTime
		   set InvoiceLineKey = #tran.InvoiceLineKey
			  ,BilledService = #tran.LayoutEntityKey
			  ,RateLevel = ISNULL(#tran.RateLevel, tTime.RateLevel)					  
			  ,BilledHours = #tran.Quantity
			  ,BilledRate = #tran.Rate
			  ,BilledComment = #tran.BilledComment
		  from #tran
		   where #tran.Entity = 'tTime'
		   and   #tran.EntityGuid = tTime.TimeKey 
	       and   tTime.InvoiceLineKey is NULL
		   and   #tran.InvoiceLineKey IS NOT NULL
		   	
		if @@ERROR <> 0 
		 begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
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
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
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
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
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
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
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
			exec sptInvoiceDelete @NewInvoiceKey
			return -8				   	
		  end

	-- Update these 2 fields here...plus campaign segment key
	-- LineDescription is a text field and cannot be held in a variable during the processing of the loops
	-- DisplayOption because it is not a parm of the insert stored procs  
	 
	update tInvoiceLine 
	set    tInvoiceLine.LineDescription = #line.Description 
	      ,tInvoiceLine.DisplayOption = #line.DisplayOption
	      ,tInvoiceLine.CampaignSegmentKey = @CampaignSegmentKey
	from   #line
	where  tInvoiceLine.InvoiceLineKey = #line.InvoiceLineKey

	RETURN 1
GO
