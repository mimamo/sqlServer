USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_Group_TaxRate3]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceIncl_Group_TaxRate3] @GroupID varchar( 10 )
AS

SELECT  SUM(ROUND(s.TaxRate,6))
  FROM SalesTax s WITH (NOLOCK) JOIN SlsTaxGrp g WITH (NOLOCK)
                    ON s.TaxID = g.TaxID
                   AND s.TaxType = 'T'
 WHERE g.GroupID = @GroupID
 GROUP BY g.GroupID
GO
