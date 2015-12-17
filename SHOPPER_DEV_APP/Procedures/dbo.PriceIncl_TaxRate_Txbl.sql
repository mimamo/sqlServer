USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_TaxRate_Txbl]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceIncl_TaxRate_Txbl] @TaxID VarChar(10), @TaxCat VarChar(10)
AS

SELECT PrcTaxincl,TaxId,TaxRate,TaxType,  
       CASE WHEN CatFlg = 'A'
            THEN CASE WHEN CatExcept00 = @TaxCat 
                        OR CatExcept01 = @TaxCat
                        OR CatExcept02 = @TaxCat
                        OR CatExcept03 = @TaxCat
                        OR CatExcept04 = @TaxCat
                        OR CatExcept05 = @TaxCat
                      THEN 'N'
                      ELSE 'Y'
                       END
			ELSE CASE WHEN CatExcept00 = @TaxCat 
                        OR CatExcept01 = @TaxCat
                        OR CatExcept02 = @TaxCat
                        OR CatExcept03 = @TaxCat
                        OR CatExcept04 = @TaxCat
                        OR CatExcept05 = @TaxCat
                      THEN 'Y'
                      ELSE 'N'
                       END
             END
  FROM SalesTax WITH (NOLOCK)
 WHERE Taxid = @TaxID
GO
