USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[StdCost_Inventory_site_NoKits]    Script Date: 12/21/2015 16:01:21 ******/
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
