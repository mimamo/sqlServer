USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_TaxRate]    Script Date: 12/21/2015 15:37:05 ******/
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
