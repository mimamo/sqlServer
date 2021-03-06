USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_Group_TaxRate]    Script Date: 12/21/2015 13:45:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceIncl_Group_TaxRate] @GroupID varchar( 10 )
AS

SELECT Min(s.PrcTaxIncl), Min(g.GroupID), Min(s.Taxtype), SUM(ROUND(s.TaxRate,6))
  FROM SalesTax s WITH (NOLOCK) JOIN SlsTaxGrp g WITH (NOLOCK)
                    ON s.TaxID = g.TaxID
                   AND s.TaxType = 'T'
 WHERE g.GroupID = @GroupID
 GROUP BY g.GroupID
GO
