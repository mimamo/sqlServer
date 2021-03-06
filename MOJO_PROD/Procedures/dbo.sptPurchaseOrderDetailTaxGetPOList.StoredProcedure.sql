USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailTaxGetPOList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailTaxGetPOList]
	(
		@PurchaseOrderKey INT
	)
AS	-- Encrypt

/*
|| When     Who Rel    What
|| 07/08/11 GHL 10.546 (111482) Creation for PO detail tax records  
*/
	SET NOCOUNT ON
	
	SELECT podt.*
			,podt.PurchaseOrderDetailKey As LineKey -- generic line key so that the TaxManager can work with vouchers/POs
			,st.SalesTaxName
			,st.TaxRate
			,st.PiggyBackTax
	FROM   tPurchaseOrderDetail pod (NOLOCK)
		INNER JOIN tPurchaseOrderDetailTax podt (NOLOCK) ON pod.PurchaseOrderDetailKey = podt.PurchaseOrderDetailKey
		INNER JOIN tSalesTax st (NOLOCK) ON podt.SalesTaxKey = st.SalesTaxKey
	WHERE pod.PurchaseOrderKey = @PurchaseOrderKey
		
	RETURN 1
GO
