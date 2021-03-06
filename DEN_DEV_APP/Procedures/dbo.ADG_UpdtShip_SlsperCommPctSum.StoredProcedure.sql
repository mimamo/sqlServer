USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SlsperCommPctSum]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SlsperCommPctSum]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	sum(CreditPct)	-- CommPct

	from	SOShipLineSplit
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	  and	LineRef = @LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
