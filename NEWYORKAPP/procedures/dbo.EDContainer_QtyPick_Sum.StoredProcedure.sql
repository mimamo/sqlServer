USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_QtyPick_Sum]    Script Date: 12/21/2015 16:00:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_QtyPick_Sum] @CpnyID varchar(10), @ShipperID varchar(15) AS
	Select A.LineRef, A.QtyPick 'OrigPickQty',
			(CASE min(A.UnitMultDiv)
                          WHEN 'D' THEN A.QtyPick - (Sum(Coalesce(B.QtyShipped,0) * A.CnvFact))
                          WHEN 'M' THEN A.QtyPick - (Sum(Coalesce(B.QtyShipped,0) / A.CnvFact))
                          ELSE  A.QtyPick - Sum(Coalesce(B.QtyShipped,0))
                         END)
  'PickQty',
  Sum(Coalesce(B.QtyShipped,0)) 'ShipQty', A.InvtId, A.UnitDesc
  From SOShipLine A Left Outer Join EDContainerDet B On A.CpnyId = B.CpnyId And A.ShipperId = B.ShipperId And
  A.LineRef = B.LineRef Where A.CpnyId = @CpnyID And A.ShipperId = @ShipperID
  Group By A.LineRef, A.QtyPick, A.InvtId, A.UnitDesc Order By A.LineRef
GO
