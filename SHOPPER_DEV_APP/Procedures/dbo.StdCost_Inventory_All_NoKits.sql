USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StdCost_Inventory_All_NoKits]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[StdCost_Inventory_All_NoKits] @parm1 varchar ( 30)
AS

SELECT i.*
  FROM Inventory i LEFT OUTER JOIN Kit k
                   ON i.InvtID = k.KitID
 WHERE i.InvtId like @parm1
   AND k.KitID IS NULL
   AND TranStatusCode <> 'IN'
 ORDER by i.InvtID
GO
