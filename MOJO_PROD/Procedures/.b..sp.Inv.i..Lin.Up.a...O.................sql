USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptInvoiceLineUpdatePO]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptInvoiceLineUpdatePO]
 @PurchaseOrderDetailKey int,
 @AmountBilled money,
 @InvoiceLineKey int
 
AS --Encrypt
  
    /*
    || 11/07/13 GHL 10.574 pod.AccruedCost is in HC
	*/

 If @InvoiceLineKey is null
 BEGIN
 
 	-- You can not delete an invoice if it has a prebilled order and that order has a voucher applied to it. This would cause the prebill accruals to go out of whack
	IF EXISTS(SELECT 1 FROM tVoucherDetail vd (nolock) Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey) 
		RETURN -1
		
	UPDATE tPurchaseOrderDetail
	SET		AmountBilled = @AmountBilled,
			AccruedCost = NULL,
			InvoiceLineKey = @InvoiceLineKey
	WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
END
else
	UPDATE tPurchaseOrderDetail
	SET		AmountBilled = @AmountBilled,
			AccruedCost = CASE 
							WHEN po.BillAt < 2 THEN ROUND(tPurchaseOrderDetail.TotalCost * isnull(po.ExchangeRate, 1), 2)
							ELSE 0
						END,
			InvoiceLineKey = @InvoiceLineKey
	FROM tPurchaseOrder po (nolock) 		
	WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	AND    tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey
	
 RETURN 1
GO
