USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_DelSH]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_DelSH]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	delete		SHShipPack
	where		CpnyID = @CpnyID
	  and		ShipperID = @ShipperID

	delete		SHShipHeader
	where		CpnyID = @CpnyID
	  and		ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
