USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheetOneLinePerClient]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPWorksheetOneLinePerClient]
	(
	 @NewInvoiceKey INT
	,@DefaultSalesAccountKey INT
	,@DefaultClassKey INT
	,@WorkTypeKey INT
	,@PostSalesUsingDetail INT
	)

AS -- Encrypt
	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 06/29/07 GHL 8.5   Added new parm OfficeKey, DepartmentKey
  || 04/22/09 GHL 10.024 Setting now AccruedCost only if po.BillAt in (0,1)
  || 10/04/13 GHL 10.573 Using now PTotalCost for multi currency
  || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
  */
	
declare @NewInvoiceLineKey int
declare @RetVal int
declare @TotVoucher money
declare @TotPO money
declare @TotExpense money
Declare @ClientName varchar(100)
Declare @CurrClientKey int
		
		Select @CurrClientKey = -1
		While 1=1
		begin

			Select @CurrClientKey = MIN(t.ClientKey)
			from  (Select Distinct ClientKey
					From #tProcWIPKeys
				   ) As t
			Where t.ClientKey > @CurrClientKey
			
			if @CurrClientKey is null
				break
		
			Select @ClientName = CustomerID
			From   tCompany (NOLOCK)
			Where  CompanyKey =	@CurrClientKey

			--get vouchers
			select @TotVoucher = isnull(sum(isnull(BillableCost,0)),0)
			  from tVoucherDetail t (nolock),#tProcWIPKeys w
			 where w.EntityType = 'Voucher'
			   and t.VoucherDetailKey = cast(w.EntityKey as integer)		   
			   and w.ClientKey = @CurrClientKey

			--get po's
			select @TotPO = isnull(sum(Case ISNULL(po.BillAt, 0) 
			When 0 then isnull(BillableCost,0)
			When 1 then  isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) -  isnull(PTotalCost,isnull(TotalCost,0)) end ),0)
			  from tPurchaseOrderDetail pod (nolock), tPurchaseOrder po (nolock)
				   ,#tProcWIPKeys w
			 where w.EntityType = 'Order'
			   and pod.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
			   and po.PurchaseOrderKey = pod.PurchaseOrderKey
			   and w.ClientKey = @CurrClientKey
			   
			--calc total expenses
			select @TotExpense = round((@TotVoucher+@TotPO),2)
		
			if @TotExpense <> 0
			BEGIN

				exec @RetVal = sptInvoiceLineInsert
					  @NewInvoiceKey				-- Invoice Key
					  ,null				            -- ProjectKey
					  ,NULL							-- TaskKey
					  ,@ClientName			        -- Line Subject
					  ,null    						-- Line description
					  ,2               				-- Bill From 
					  ,0							-- Quantity
					  ,0							-- Unit Amount
					  ,@TotExpense					-- Line Amount
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

				exec sptInvoiceRecalcAmounts @NewInvoiceKey 

				--voucher	   
				update tVoucherDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
					  ,AmountBilled = BillableCost
				  from #tProcWIPKeys w
				 where w.EntityType = 'Voucher'
				   and tVoucherDetail.VoucherDetailKey = cast(w.EntityKey as integer)
				   and w.ClientKey = @CurrClientKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				  end
				  
				--Order	   
				update tPurchaseOrderDetail
				   set InvoiceLineKey = @NewInvoiceLineKey
				   	,tPurchaseOrderDetail.AccruedCost = 
				   		CASE 
							WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
							ELSE 0
						END
					  ,AmountBilled = isnull(Case ISNULL(po.BillAt, 0) 
						When 0 then isnull(BillableCost,0)
						When 1 then  isnull(PTotalCost,isnull(TotalCost,0))
						When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0))  end ,0)
				  from #tProcWIPKeys w, tPurchaseOrder po (nolock)
				 where w.EntityType = 'Order'
				   and tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(w.EntityKey as integer)
				   and po.PurchaseOrderKey = tPurchaseOrderDetail.PurchaseOrderKey
				   and w.ClientKey = @CurrClientKey
				if @@ERROR <> 0 
				  begin
					exec sptInvoiceDelete @NewInvoiceKey
					return -10				   	
				 end
				 
			end  -- end of insert line
		end  -- Loop for clients
				   
				 
	
	RETURN 1
GO
