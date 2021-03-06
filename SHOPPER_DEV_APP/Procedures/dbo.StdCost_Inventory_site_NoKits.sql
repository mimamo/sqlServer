USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StdCost_Inventory_site_NoKits]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[StdCost_Inventory_site_NoKits] @parm1 varchar ( 30), @parm2 varchar( 10)
AS

SELECT i.*
  FROM Inventory i Inner JOIN ITEMSITE s
                           on i.InvtID = s.InvtID
                   LEFT OUTER JOIN Kit k
                                ON i.InvtID = k.KitID

 WHERE i.InvtId like @parm1
   AND s.SiteId = @parm2
   AND k.KitID IS NULL
   AND TranStatusCode <> 'IN'
 ORDER by i.InvtID
GO
