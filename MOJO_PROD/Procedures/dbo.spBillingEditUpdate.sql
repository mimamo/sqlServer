USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingEditUpdate]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spBillingEditUpdate]
	@BillingKey INT
	,@EntityType VARCHAR(50)
	,@EntityKey VARCHAR(50)
	,@BillableCost money
	,@UserKey int
	,@EditComments varchar(2000)
	
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/26/07 GHL 8.5 Added BillingKey parameter to restrict the Billing Detail record.
*/
  	   
	--expenses	   
	if @EntityType = 'tExpenseReceipt'
	update tBillingDetail
	   set Total = @BillableCost
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey 
	 where EntityKey = cast(@EntityKey as integer)
	   and Entity = @EntityType
	   and BillingKey = @BillingKey
	    	
	if @@ERROR <> 0 
	  begin
		return -2					   	
	  end
	  
	--misc expenses
	else if @EntityType = 'tMiscCost'
	update tBillingDetail
	   set Total = @BillableCost 
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey 
	 where EntityKey = cast(@EntityKey as integer)
	   and Entity = @EntityType
	   and BillingKey = @BillingKey

	if @@ERROR <> 0 
	  begin
		return -3					   	
	  end
	  	
	--voucher	   
	else if @EntityType = 'tVoucherDetail'
	update tBillingDetail
	   set Total = @BillableCost
	      ,EditComments = @EditComments
	      ,EditorKey = @UserKey 
	 where EntityKey = cast(@EntityKey as integer)
	   and Entity = @EntityType
	   and BillingKey = @BillingKey

	if @@ERROR <> 0 
	  begin
		return -4					   	
	  end
	  	
	exec sptBillingRecalcTotals @BillingKey
	
	return 1
GO
