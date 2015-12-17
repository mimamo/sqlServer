USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_ShipperItems]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_ShipperItems]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	InvtID
	from	SOShipLine
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	group by InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
