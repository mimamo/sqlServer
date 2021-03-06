USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateShipper_QueueInvt_CPSOff]    Script Date: 12/21/2015 14:17:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateShipper_QueueInvt_CPSOff]
	@CpnyID		varchar(10),
	@ShipperID   	varchar(15)
as
	select
		h.BuildInvtID,
		h.SiteID,
		l.InvtID,
		l.SiteID

	from	SOShipLine	l

  	  join	SOShipHeader	h
	  on	h.CpnyID = l.CpnyID
	  and	h.ShipperID = l.ShipperID

	where	l.CpnyID = @CpnyID and
		l.ShipperID = @ShipperID

	order by l.invtid, l.siteid

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
