USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipLot]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipLot]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	LotSerNbr,
--		MfgrLotSerNbr,
		convert(char(25), S4Future02),	-- MfgrLotSerNbr
		QtyPick,
		QtyShip,
		StdQtyShip = S4Future04,
		RMADisposition,
--		ShipContCode,
		space(20),			-- ShipContCode
--		SpecificCostID,
		convert(char(25), S4Future01),	-- SpecificCostID
		WhseLoc

	from	SOShipLot

	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	  and	LineRef = @LineRef

	order by
		CpnyID,
		ShipperID,
		LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
