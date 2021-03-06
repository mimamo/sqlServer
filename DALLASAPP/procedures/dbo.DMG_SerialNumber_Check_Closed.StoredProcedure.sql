USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SerialNumber_Check_Closed]    Script Date: 12/21/2015 13:44:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SerialNumber_Check_Closed]
	@InvtID		varchar(30),
	@LotSerNbr	varchar(25),
	@ShipperID	varchar(15)
AS
	select	IsNull(Sum(SOShipLot.QtyShip), 0)
	from	SOShipLot
	join	SOShipHeader ON SOShipHeader.CpnyID = SOShipLot.CpnyID and SOShipHeader.ShipperID = SOShipLot.ShipperID
	where	SOShipLot.InvtID = @InvtID
	and	SOShipLot.LotSerNbr = @LotSerNbr
	and	SOShipHeader.Status = 'C'
	and	SOShipHeader.Cancelled <> 1
	and	SOShipLot.ShipperID <> @ShipperID
	ORDER BY 1 DESC -- Make sure nonzero values float to top of query.
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
