USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPEditUpdate]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessWIPEditUpdate]
	@EntityType VARCHAR(50)
	,@EntityKey VARCHAR(50)
	,@BillableCost money
AS --Encrypt

  	   
	--expenses	   
	if @EntityType = 'EXPRPT'
	update tExpenseReceipt
	   set BillableCost = @BillableCost 
	 where tExpenseReceipt.ExpenseReceiptKey = cast(@EntityKey as integer)
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	else if @EntityType = 'MISCCOST'
	update tMiscCost
	   set BillableCost = @BillableCost 
	where tMiscCost.MiscCostKey = cast(@EntityKey as integer)
	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	else if @EntityType = 'VOUCHER'
	update tVoucherDetail
	   set BillableCost = @BillableCost 
	 where tVoucherDetail.VoucherDetailKey = cast(@EntityKey as integer)
	if @@ERROR <> 0 
	  begin
		return -4					   	
	  end
	  	
	
	return 1
GO
