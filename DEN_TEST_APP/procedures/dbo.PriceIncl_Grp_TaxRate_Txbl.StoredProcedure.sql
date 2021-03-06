USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_Grp_TaxRate_Txbl]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceIncl_Grp_TaxRate_Txbl] @GroupID VarChar(10), @TaxCat VarChar(10)
AS

SELECT s.PrcTaxincl,s.TaxId,s.TaxRate, s.TaxType,  
       CASE WHEN s.CatFlg = 'A'
            THEN CASE WHEN s.CatExcept00 = @TaxCat 
                        OR s.CatExcept01 = @TaxCat
                        OR s.CatExcept02 = @TaxCat
                        OR s.CatExcept03 = @TaxCat
                        OR s.CatExcept04 = @TaxCat
                        OR s.CatExcept05 = @TaxCat
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
  FROM SalesTax s WITH (NOLOCK) JOIN SlsTaxGrp g WITH (NOLOCK)
                    ON s.TaxID = g.TaxID
                   AND s.TaxType = 'T'
 WHERE g.GroupID = @GroupID
GO
