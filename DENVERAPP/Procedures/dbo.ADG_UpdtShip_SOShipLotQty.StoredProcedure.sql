USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipLotQty]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipLotQty]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	sum(QtyPick),
		sum(QtyShip)

	from	SOShipLot

	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	  and	LineRef = @LineRef

	group by
		CpnyID,
		ShipperID,
		LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
