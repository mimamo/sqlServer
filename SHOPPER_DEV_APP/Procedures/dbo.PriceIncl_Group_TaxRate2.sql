USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceIncl_Group_TaxRate2]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PriceIncl_Group_TaxRate2] @GroupID varchar( 10 )
AS

SELECT g.groupID, SUM(ROUND(s.TaxRate,6))
  FROM SalesTax s WITH (NOLOCK) JOIN SlsTaxGrp g WITH (NOLOCK)
                    ON s.TaxID = g.TaxID
                   AND s.TaxType = 'T'
 WHERE g.GroupID = @GroupID
 GROUP BY g.GroupID
GO
