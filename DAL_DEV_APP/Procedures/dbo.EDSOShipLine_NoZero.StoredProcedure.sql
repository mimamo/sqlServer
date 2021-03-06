USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOShipLine_NoZero]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOShipLine_NoZero] @CpnyId varchar(10), @ShipperId varchar(15) As
Select A.*, C.SiteId, C.CurySlsPriceOrig, D.Name From SOShipLine A Inner Join SOShipHeader B On A.CpnyId =
B.CpnyId And A.ShipperId = B.ShipperId Left Outer Join SOLine C On B.CpnyId = C.CpnyId And
B.OrdNbr = C.OrdNbr And A.OrdLineRef = C.LineRef Left Outer Join SalesPerson D On B.SlsPerId =
D.SlsPerId Where A.CpnyId = @CpnyId And A.ShipperId = @ShipperId And A.QtyShip <> 0
Order By A.CpnyId, A.ShipperId, A.LineRef
GO
