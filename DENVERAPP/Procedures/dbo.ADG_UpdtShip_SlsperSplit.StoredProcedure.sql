USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SlsperSplit]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SlsperSplit]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	'CreditPct' = S4Future03,
		SlsperID

	from	SOShipLineSplit
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	  and	LineRef = @LineRef
	order by CreditPct

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
