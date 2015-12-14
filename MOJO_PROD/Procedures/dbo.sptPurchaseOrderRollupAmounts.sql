USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderRollupAmounts]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderRollupAmounts]
	(
	@PurchaseOrderKey int
	,@UpdateDate int = 1
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel   What
  || 07/01/11 GHL 10.546 (111482) Creation to handle PO detail sales tax amounts
  */
  
	DECLARE @PurchaseOrderTotal MONEY
	        ,@SalesTaxAmount MONEY --= @SalesTax1Amount + @SalesTax2Amount + other taxes 
			,@SalesTax1Amount MONEY
			,@SalesTax2Amount MONEY
	             
	select @PurchaseOrderTotal = Sum(TotalCost) 
	      ,@SalesTaxAmount = Sum(SalesTaxAmount)
	      ,@SalesTax1Amount = Sum(SalesTax1Amount)
	      ,@SalesTax2Amount = Sum(SalesTax2Amount)	      
	from tPurchaseOrderDetail (nolock) Where PurchaseOrderKey = @PurchaseOrderKey
	
	select @PurchaseOrderTotal = ISNULL(@PurchaseOrderTotal, 0) + ISNULL(@SalesTaxAmount, 0)
	
	if @UpdateDate = 1
		UPDATE tPurchaseOrder
		SET    PurchaseOrderTotal = @PurchaseOrderTotal
				,SalesTaxAmount = ISNULL(@SalesTaxAmount, 0)
				,SalesTax1Amount = ISNULL(@SalesTax1Amount, 0)
				,SalesTax2Amount = ISNULL(@SalesTax2Amount, 0)	
				,DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)  		
		WHERE  PurchaseOrderKey = @PurchaseOrderKey
	ELSE
		UPDATE tPurchaseOrder
		SET    PurchaseOrderTotal = @PurchaseOrderTotal
				,SalesTaxAmount = ISNULL(@SalesTaxAmount, 0)
				,SalesTax1Amount = ISNULL(@SalesTax1Amount, 0)
				,SalesTax2Amount = ISNULL(@SalesTax2Amount, 0)			
		WHERE  PurchaseOrderKey = @PurchaseOrderKey


	RETURN 1
GO
