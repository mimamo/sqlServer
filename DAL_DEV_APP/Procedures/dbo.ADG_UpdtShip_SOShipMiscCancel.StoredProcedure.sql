USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipMiscCancel]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipMiscCancel]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	MiscChrgRef,
		CuryMiscChrg,
		MiscChrg

	from	SOShipMisc
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
