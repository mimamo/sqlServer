USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPUndoMarkOnHold]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessWIPUndoMarkOnHold]
	 @EntityKey VARCHAR(50)
	,@WOType VARCHAR(50)
AS --Encrypt

	--time
	if @WOType = 'LABOR'
	Begin
		update tTime
		   set OnHold = 0
		 where tTime.TimeKey = cast(@EntityKey as uniqueidentifier)
		if @@ERROR <> 0 
		  begin
			return -1					   	
		  end
	end

	--expenses	   
	else if @WOType = 'EXPRPT'
	Begin
		update tExpenseReceipt
		   set OnHold = 0
		 where tExpenseReceipt.ExpenseReceiptKey = cast(@EntityKey as integer)
		if @@ERROR <> 0 
		  begin
			return -2					   	
		  end
	end
		
	--misc expenses
	else if @WOType = 'MISCCOST'
	Begin	
		update tMiscCost
		   set OnHold = 0
		where tMiscCost.MiscCostKey = cast(@EntityKey as integer)
		if @@ERROR <> 0 
		  begin
			return -3					   	
		  end
	end 
	
	--voucher	   
	else if @WOType = 'VOUCHER'
	Begin
		update tVoucherDetail
		   set OnHold = 0
		 where tVoucherDetail.VoucherDetailKey = cast(@EntityKey as integer)
		if @@ERROR <> 0 
		  begin
			return -4					   	
		  end
	  	
	end

	--voucher	   
	else if @WOType = 'ORDER'
	Begin
		update tPurchaseOrderDetail
		   set OnHold = 0
		 where tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(@EntityKey as integer)
		if @@ERROR <> 0 
		  begin
			return -5					   	
		  end
	  	
	end

	return 1
GO
