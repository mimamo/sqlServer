USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_CalcReplenValues]    Script Date: 12/21/2015 15:42:57 ******/
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
