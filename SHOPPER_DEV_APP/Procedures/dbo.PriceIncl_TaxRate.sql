USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_TaxRate]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceIncl_TaxRate] @TaxID varchar( 10 )
AS 

SELECT PrcTaxIncl,TaxId,TaxType,TaxRate 
  FROM SalesTax WITH (NOLOCK)
 WHERE TaxID = @TaxID
GO
