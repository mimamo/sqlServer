USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SerialNumber_Check]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SerialNumber_Check]
	@InvtID		varchar(30),
	@SiteID 	varchar(10),
	@LotSerNbr	varchar(25),
	@ShipperID	varchar(15),
	@OrdNbr		varchar(15)
AS
	select	count(*)
	from	SOShipLot
	join	SOShipHeader ON SOShipHeader.CpnyID = SOShipLot.CpnyID and SOShipHeader.ShipperID = SOShipLot.ShipperID
	where	SOShipLot.InvtID = @InvtID
	and	SOShipHeader.SiteID = @SiteID
	and	SOShipLot.LotSerNbr = @LotSerNbr
	and	SOShipHeader.Status = 'O'
	and	SOShipLot.ShipperID <> @ShipperID
	UNION
	(Select Count(*)
		FROM SOLot JOIN SOLine
		ON SOLot.CpnyID = SOLine.CpnyID
		AND SOLot.OrdNbr = SOLine.OrdNbr

		WHERE SOLine.InvtID = @InvtID
		AND SOLine.SiteID = @SiteID
		AND SOLot.LotSerNbr = @LotSerNbr
		AND SOLot.Status = 'O'
		AND SOLot.OrdNbr <> @OrdNbr
	)
	ORDER BY 1 DESC	-- Make sure nonzero values float to top of query.
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
