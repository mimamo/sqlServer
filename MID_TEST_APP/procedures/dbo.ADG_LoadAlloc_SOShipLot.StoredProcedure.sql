USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LoadAlloc_SOShipLot]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_LoadAlloc_SOShipLot]
	@CpnyID		Varchar(10),
	@ShipperID	Varchar(15)
As

SELECT	LineRef, InvtID, Space(10), WhseLoc, LotSerNbr,
	QtyShip, S4Future03, LEFT(S4Future11,1)
	FROM	SOShipLot (NOLOCK)
	WHERE	CpnyID = @CpnyID
		AND ShipperID = @ShipperID
		AND QtyShip > 0
GO
