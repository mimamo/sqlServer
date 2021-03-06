USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Inventory_Quantities_Total]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[Inventory_Quantities_Total]
	@Parm1 Char(30)
AS
	SELECT SUM(QtyAlloc),           SUM(QtyAvail), SUM(QtyCustOrd),          SUM(QtyInTransit),
	       SUM(QtyNotAvail),        SUM(QtyOnBO),  SUM(QtyOnDP),             SUM(QtyOnHand),
	       SUM(QtyOnKitAssyOrders), SUM(QtyOnPO),  SUM(QtyOnTransferOrders),
	       SUM(QtyShipNotInv),      SUM(TotCost)
	FROM   Itemsite
	WHERE  InvtID = @Parm1
GO
