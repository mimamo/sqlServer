USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSalesTaxDelete]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSalesTaxDelete]
	@SalesTaxKey int

AS --Encrypt

if exists(select 1 from tInvoice (nolock) Where SalesTaxKey = @SalesTaxKey)
	Return -1
if exists(select 1 from tEstimate (nolock) Where SalesTaxKey = @SalesTaxKey)
	Return -2
	


		DELETE
		FROM tSalesTax
		WHERE
			SalesTaxKey = @SalesTaxKey 


	RETURN 1
GO
