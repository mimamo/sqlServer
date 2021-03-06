USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailUpdateTaxes]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailUpdateTaxes]
	(
	@PurchaseOrderDetailKey INT
	,@PurchaseOrderKey INT
	,@SalesTaxAmount MONEY
	,@SalesTax1Amount MONEY
	,@SalesTax2Amount MONEY
	)	 
AS --Encrypt

/*
|| When     Who Rel     What
|| 07/07/11 GHL 10.5.4.6 (111482) Creation to handle PO detail tax amounts
*/
	SET NOCOUNT ON
	
	DECLARE @Taxable int
	DECLARE @Taxable2 int
	DECLARE @SalesTaxKey int
	DECLARE @SalesTax2Key int
	DECLARE @RecalcTotal int

	SELECT @Taxable = tPurchaseOrderDetail.Taxable
	      ,@Taxable2 = tPurchaseOrderDetail.Taxable2
		  ,@SalesTaxKey = tPurchaseOrder.SalesTaxKey
		  ,@SalesTax2Key = tPurchaseOrder.SalesTax2Key
	FROM   tPurchaseOrderDetail (NOLOCK)
		INNER JOIN tPurchaseOrder (nolock) on tPurchaseOrderDetail.PurchaseOrderKey = tPurchaseOrder.PurchaseOrderKey
	WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	IF isnull(@SalesTaxKey, 0) = 0 And isnull(@Taxable, 0) = 1
		select @Taxable = 0, @SalesTax1Amount = 0, @RecalcTotal = 1

	IF isnull(@SalesTax2Key, 0) = 0 And isnull(@Taxable2, 0) = 1
		select @Taxable2 = 0, @SalesTax2Amount = 0, @RecalcTotal = 1

	if isnull(@RecalcTotal, 0) = 1
	begin
		select @SalesTaxAmount = sum(SalesTaxAmount)
		from   tPurchaseOrderDetailTax (nolock)
		where  PurchaseOrderDetailKey = @PurchaseOrderDetailKey

		select @SalesTaxAmount = isnull(@SalesTaxAmount, 0) +
		isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0)
	end

	UPDATE tPurchaseOrderDetail
	SET    SalesTaxAmount = isnull(@SalesTaxAmount, 0) -- this contains @SalesTax1Amount + @SalesTax2Amount + other taxes
	      ,SalesTax1Amount = isnull(@SalesTax1Amount, 0)
	      ,SalesTax2Amount = isnull(@SalesTax2Amount, 0)
		  ,Taxable = isnull(@Taxable, 0)
		  ,Taxable2 = isnull(@Taxable2, 0)
	WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
	EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey
	
	RETURN 1
GO
