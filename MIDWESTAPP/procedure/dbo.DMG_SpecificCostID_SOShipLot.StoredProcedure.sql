USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SpecificCostID_SOShipLot]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[DMG_SpecificCostID_SOShipLot]
	@CpnyID	varchar(10),
	@ShipperID varchar(15),
	@LineRef varchar(5),
	@SpecificCostID varchar(25)
as
	select	distinct *
	from	SOShipLot
	where	CpnyID like @CpnyID
	and	ShipperID like @ShipperID
	and	LineRef like @LineRef
	and	S4Future01 like @SpecificCostID
	order by S4Future01

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
