USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_Function]    Script Date: 12/21/2015 16:13:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_Function]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	NextFunctionID,
		NextFunctionClass
	from	SOShipHeader
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
