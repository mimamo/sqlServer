USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherDetailTaxGetList]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherDetailTaxGetList]
	(
		@VoucherDetailKey INT
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
		-- regardless of Active status because could be already on a voucher line
	ELSE
	
		SELECT vdt.*
			   ,st.SalesTaxName
			   ,st.TaxRate
			   ,st.PiggyBackTax
		FROM   tVoucherDetailTax vdt (NOLOCK)
			INNER JOIN tSalesTax st (NOLOCK) ON vdt.SalesTaxKey = st.SalesTaxKey
		WHERE vdt.VoucherDetailKey = @VoucherDetailKey
		
	RETURN 1
GO
