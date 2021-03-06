USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceOneLine]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceOneLine]
	(
		@NewInvoiceKey INT
		,@BillingKey INT
		,@BillingMethod INT 
		,@ProjectKey INT
		,@LineDescription VARCHAR(500)
		,@DefaultSalesAccountKey INT
		,@DefaultClassKey INT
		,@WorkTypeKey INT
		,@ParentInvoiceLineKey INT
		,@PostSalesUsingDetail INT
		,@EstimateKey INT
		,@CampaignSegmentKey INT = NULL
	)
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/09/07 GHL 8.5   Added logic for office/dept (revisited 8/9/07)
  || 09/29/08 GHL 10.009 (34706) Changed Quantity to 1 and set UnitCost, this is better for javascripts
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 05/04/09 GHL 10.024 (52065) Setting now transaction BilledComment to tBillingDetail.Comments
  || 05/12/10 GHL 10.523 Added segment param for FF billing
  || 12/17/10 GHL 10.539 (97621) Removed amount recalcs to improve performance 
  || 05/21/12 GHL 10.556 Since the sp creates only 1 line, return now @NewInvoiceLineKey instead of 1 
  ||                     This allows to modify the invoice line afterwards (see Etna customization)
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */
  
	SET NOCOUNT ON
	
declare @TotLabor money
declare @TotExpense money
declare @NewInvoiceLineKey int
declare @RetVal int
declare @LineSubject VARCHAR(100)
declare @BillFrom int
declare @OfficeKey int
declare @DepartmentKey int


		SELECT @LineSubject = LEFT(@LineDescription, 100)
		SELECT @BillFrom = 2
		
		IF @BillingMethod <> 2
		BEGIN
			-- Not FF
			IF (select count(*) from #tBillingDetail
				where BillingKey = @BillingKey) = 0
				RETURN 1
			
			--get total hours/labor
			select @TotLabor = isnull(sum(round(isnull(Quantity,0)*isnull(Rate,0), 2)), 0)
			from #tBillingDetail
			where BillingKey = @BillingKey
			and Entity = 'tTime'
			   					   
			--get expense 
			select @TotExpense = isnull(sum(isnull(Total,0)),0)
			from #tBillingDetail
			where BillingKey = @BillingKey
			and Entity <> 'tTime'
			   
			--calc total expenses
			select @TotExpense = round((@TotLabor+@TotExpense),2)	
		END
		ELSE
		BEGIN
			-- FF
			SELECT @TotExpense = isnull(sum(isnull(Amount,0)),0)
			FROM   tBillingFixedFee (NOLOCK)
			WHERE  BillingKey = @BillingKey
			
			-- Like sptInvoiceLineInsertProject, used by regular FF
			SELECT @BillFrom = 1 
				   ,@PostSalesUsingDetail = 0	
		
			SELECT @OfficeKey = OfficeKey
			FROM   tBilling (NOLOCK)
			WHERE  BillingKey = @BillingKey  	
		
			SELECT @DepartmentKey = DepartmentKey
			FROM   tBillingFixedFee (NOLOCK)
			WHERE  BillingKey = @BillingKey
			
		END
				
		--create single invoice line
		exec @RetVal = sptInvoiceLineInsertMassBilling
					   @NewInvoiceKey				-- Invoice Key
					  ,@ProjectKey					-- ProjectKey
					  ,NULL							-- TaskKey
					  ,@LineSubject					-- Line Subject
					  ,NULL				            -- Line description
					  ,@BillFrom                    -- Bill From 
					  ,1							-- Quantity
					  ,@TotExpense					-- Unit Amount
					  ,@TotExpense					-- Line Amount
					  ,2							-- line type
					  ,@ParentInvoiceLineKey		-- parent line key
					  ,@DefaultSalesAccountKey		-- Default Sales AccountKey
					  ,@DefaultClassKey             -- Class Key
					  ,0							-- Taxable
					  ,0							-- Taxable2
					  ,@WorkTypeKey					-- Work TypeKey
					  ,@PostSalesUsingDetail
					  ,NULL							-- Entity
					  ,NULL							-- EntityKey
					  ,@OfficeKey					-- Needed for FF case
					  ,@DepartmentKey				-- Needed for FF case
					  ,@NewInvoiceLineKey output
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -6					   	
		  end					  
		if @RetVal <> 1 
		  begin
		    exec sptInvoiceDelete @NewInvoiceKey
			return -6					   	
		  end
 		
 		IF ISNULL(@EstimateKey, 0) > 0
 			UPDATE tInvoiceLine
 			SET    EstimateKey = @EstimateKey
 			WHERE  InvoiceLineKey = @NewInvoiceLineKey
 		
 		IF ISNULL(@CampaignSegmentKey, 0) > 0
 			UPDATE tInvoiceLine
 			SET    CampaignSegmentKey = @CampaignSegmentKey
 			WHERE  InvoiceLineKey = @NewInvoiceLineKey
 			
 		--exec sptInvoiceRecalcAmounts @NewInvoiceKey 
	
		-- If FF, we are done
		IF @BillingMethod = 2
			RETURN 1
			
  		--associate time to invoice line
		--time
		update tTime
		   set InvoiceLineKey = @NewInvoiceLineKey
			  ,BilledService = ISNULL(#tBillingDetail.ServiceKey, tTime.ServiceKey)
			  ,RateLevel = ISNULL(#tBillingDetail.RateLevel, tTime.RateLevel)
			  ,BilledHours = Quantity
			  ,BilledRate = Rate
			  ,BilledComment = #tBillingDetail.Comments
		  from #tBillingDetail
		 where #tBillingDetail.BillingKey = @BillingKey
		   and #tBillingDetail.Entity = 'tTime'
		   and tTime.TimeKey = #tBillingDetail.EntityGuid	
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -7					   	
		  end
		  	   
		--expenses	   
		update tExpenseReceipt
		   set InvoiceLineKey = @NewInvoiceLineKey
			  ,AmountBilled = Total
			  ,BilledComment = #tBillingDetail.Comments
		  from #tBillingDetail
		 where #tBillingDetail.BillingKey = @BillingKey
		   and #tBillingDetail.Entity = 'tExpenseReceipt'
		   and tExpenseReceipt.ExpenseReceiptKey = #tBillingDetail.EntityKey
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -8					   	
		  end
	
	 
		--misc expenses
		update tMiscCost
		   set InvoiceLineKey = @NewInvoiceLineKey
			  ,AmountBilled = Total
			  ,BilledComment = #tBillingDetail.Comments
		  from #tBillingDetail
		 where #tBillingDetail.BillingKey = @BillingKey
		   and #tBillingDetail.Entity = 'tMiscCost'
		   and tMiscCost.MiscCostKey = #tBillingDetail.EntityKey
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -9					   	
		  end

		--voucher	   
		update tVoucherDetail
		   set InvoiceLineKey = @NewInvoiceLineKey
			  ,AmountBilled = Total
			  ,BilledComment = #tBillingDetail.Comments
		 from #tBillingDetail
		 where #tBillingDetail.BillingKey = @BillingKey
		   and #tBillingDetail.Entity = 'tVoucherDetail'
		   and tVoucherDetail.VoucherDetailKey = #tBillingDetail.EntityKey
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -10				   	
		  end

 		--po
		update tPurchaseOrderDetail
		 set InvoiceLineKey = @NewInvoiceLineKey
			  ,tPurchaseOrderDetail.AccruedCost = 
				CASE 
					WHEN po.BillAt < 2 THEN 
					ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
					ELSE 0
				END
			  ,AmountBilled = Total
			  ,BilledComment = #tBillingDetail.Comments
		 from #tBillingDetail
		     ,tPurchaseOrder po (nolock)
		 where #tBillingDetail.BillingKey = @BillingKey
		   and #tBillingDetail.Entity = 'tPurchaseOrderDetail'
		   and tPurchaseOrderDetail.PurchaseOrderDetailKey = #tBillingDetail.EntityKey
		   and tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey	
		if @@ERROR <> 0 
		  begin
			exec sptInvoiceDelete @NewInvoiceKey
			return -10				   	
		  end	   	
	
	RETURN @NewInvoiceLineKey
GO
