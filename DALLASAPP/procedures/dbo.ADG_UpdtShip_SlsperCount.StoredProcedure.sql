USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SlsperCount]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SlsperCount]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	count(*)

	from	SOShipLineSplit
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	  and	LineRef = @LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
