USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailTaxGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailTaxGetList]
	(
		@PurchaseOrderDetailKey INT
		,@CompanyKey INT
		,@FromSalesTaxTable INT = 0
	)
AS	-- Encrypt

	SET NOCOUNT ON
	
	IF @FromSalesTaxTable = 1
		-- this will be done when we come from the other sales tax popup
		SELECT st.SalesTaxKey 
			   ,st.SalesTaxName
			   ,st.TaxRate
			   ,st.PiggyBackTax
			   ,0 AS SalesTaxAmount
		FROM   tSalesTax st (NOLOCK)	
		WHERE  st.CompanyKey = @CompanyKey
		-- regardless of Active status because could be already on a PurchaseOrder line
	ELSE
	
		SELECT vdt.*
			   ,st.SalesTaxName
			   ,st.TaxRate
			   ,st.PiggyBackTax
		FROM   tPurchaseOrderDetailTax vdt (NOLOCK)
			INNER JOIN tSalesTax st (NOLOCK) ON vdt.SalesTaxKey = st.SalesTaxKey
		WHERE vdt.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		
	RETURN 1
GO
