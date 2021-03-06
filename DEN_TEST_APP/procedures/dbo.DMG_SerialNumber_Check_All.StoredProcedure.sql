USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SerialNumber_Check_All]    Script Date: 12/21/2015 15:36:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SerialNumber_Check_All]
	@InvtID		varchar(30),
	@LotSerNbr	varchar(25),
	@ShipperID	varchar(15),
	@OrdNbr		varchar(15)
AS
	select	IsNull(Sum(SOShipLot.QtyShip), 0)
	from	SOShipLot
	join	SOShipHeader ON SOShipHeader.CpnyID = SOShipLot.CpnyID and SOShipHeader.ShipperID = SOShipLot.ShipperID
	where	SOShipLot.InvtID = @InvtID
	and	SOShipLot.LotSerNbr = @LotSerNbr
	and	SOShipHeader.Cancelled <> 1
	and	SOShipLot.ShipperID <> @ShipperID
	UNION
	(Select IsNull(Sum(SOLot.QtyShip), 0)
		FROM SOLot JOIN SOLine
		ON SOLot.CpnyID = SOLine.CpnyID
		AND SOLot.OrdNbr = SOLine.OrdNbr

		WHERE SOLine.InvtID = @InvtID
		AND SOLot.LotSerNbr = @LotSerNbr
		AND SOLot.Status = 'O'
		AND SOLot.OrdNbr <> @OrdNbr
	)
	ORDER BY 1 DESC -- Make sure nonzero values float to top of query.
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
