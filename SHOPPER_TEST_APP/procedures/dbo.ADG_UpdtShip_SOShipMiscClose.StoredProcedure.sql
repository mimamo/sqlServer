USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipMiscClose]    Script Date: 12/21/2015 16:06:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipMiscClose]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	MiscChrgRef,
		CuryMiscChrg,
		MiscChrg,
		S4Future04,
		S4Future05

	from	SOShipMisc
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
