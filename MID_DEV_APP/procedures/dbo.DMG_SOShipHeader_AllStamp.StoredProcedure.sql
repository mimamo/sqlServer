USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_AllStamp]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_SOShipHeader_AllStamp]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	*,
		convert(int, tstamp)
	from	SOShipHeader
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
