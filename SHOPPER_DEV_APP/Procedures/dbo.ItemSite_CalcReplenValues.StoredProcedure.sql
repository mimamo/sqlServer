USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_CalcReplenValues]    Script Date: 12/21/2015 14:34:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ItemSite_CalcReplenValues] AS

SELECT i.*,y.InvtID, y.LastCost
  FROM ItemSite i JOIN Inventory y
                    ON i.Invtid = y.InvtID
 WHERE y.StkItem = 1 AND y.transtatuscode NOT IN ('IN','NP')
GO
