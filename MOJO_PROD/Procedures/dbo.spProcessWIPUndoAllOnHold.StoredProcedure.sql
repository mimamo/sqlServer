USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPUndoAllOnHold]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProcessWIPUndoAllOnHold]
	(
		@ProjectKey INT
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 01/08/08 GHL 8.5   (18638) Reset OnHold flag for the project not the company
  */
  
	SET NOCOUNT ON

	IF ISNULL(@ProjectKey, 0) = 0
		RETURN 1
		 	
		--time
	update tTime
	   set tTime.OnHold = 0
	where  tTime.ProjectKey = @ProjectKey
	   and tTime.OnHold = 1
	   	   
	--expenses	   
	update tExpenseReceipt
	   set tExpenseReceipt.OnHold = 0
	 where tExpenseReceipt.ProjectKey = @ProjectKey
	  and  tExpenseReceipt.OnHold = 1
	  
	--misc expenses
	update tMiscCost
	   set tMiscCost.OnHold = 0
	 where tMiscCost.ProjectKey = @ProjectKey 
	   and tMiscCost.OnHold = 1
	  	
	--voucher	   
	update tVoucherDetail
	   set tVoucherDetail.OnHold = 0
	 where tVoucherDetail.ProjectKey = @ProjectKey
	   and tVoucherDetail.OnHold = 1
		
	--voucher	   
	update tPurchaseOrderDetail
	   set tPurchaseOrderDetail.OnHold = 0
	 where tPurchaseOrderDetail.ProjectKey = @ProjectKey
	   and tPurchaseOrderDetail.OnHold = 1

	RETURN 1
GO
