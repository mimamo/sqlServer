USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spPurchaseOrderDetailGetInvoiceData]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPurchaseOrderDetailGetInvoiceData]
	(
		@PurchaseOrderDetailKey INT
		,@VoucherDetailKey INT
	)
AS --Encrypt

	DECLARE 
		@VoucherCost SMALLMONEY	
	   ,@VoucherQty decimal(9,3)
	   ,@PODetailCost SMALLMONEY
	   ,@PODetailQty decimal(9,3)
	   ,@OpenAmount  SMALLMONEY 
	   ,@OpenQty decimal(9,3)
	
	SELECT 
		@VoucherCost = SUM(TotalCost),
		@VoucherQty = SUM(Quantity)
	FROM   tVoucherDetail (NOLOCK)
	WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	AND    VoucherDetailKey      <> @VoucherDetailKey
	
	IF @VoucherCost IS NULL
		SELECT @VoucherCost = 0
	
	IF @VoucherQty IS NULL
		SELECT @VoucherQty = 0
		
	SELECT 
		@PODetailCost = pod.TotalCost,
		@PODetailQty = pod.Quantity
	FROM   tPurchaseOrderDetail pod (NOLOCK)
	WHERE  pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	IF @PODetailCost IS NULL
		SELECT @PODetailCost = 0
		
	IF @PODetailQty IS NULL
		SELECT @PODetailQty = 0
	
	SELECT @OpenAmount = @PODetailCost - @VoucherCost
	SELECT @OpenQty = @PODetailQty - @VoucherQty

	IF @OpenAmount < 0
		SELECT @OpenAmount = 0
		
	IF @OpenQty < 0
		SELECT @OpenQty = 0
		
	SELECT pod.*
	      ,@OpenAmount AS OpenAmount 
	      ,@OpenQty AS OpenQuantity
	      ,p.ProjectNumber
	      ,t.TaskID
	      ,cl.ClassID
	FROM   tPurchaseOrderDetail pod (NOLOCK)
		LEFT OUTER JOIN tTask t (nolock) ON pod.TaskKey = t.TaskKey
		Left Outer Join tProject p (nolock) on pod.ProjectKey = p.ProjectKey
		Left Outer Join tClass cl (nolock) on pod.ClassKey = cl.ClassKey
	WHERE  pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
	
	/* set nocount on */
	return 1
GO
