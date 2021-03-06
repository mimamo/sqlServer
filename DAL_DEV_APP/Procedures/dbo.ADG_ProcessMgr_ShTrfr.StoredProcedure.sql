USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShTrfr]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShTrfr]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	l.InvtID,
		h.ShipSiteID

	from	SOShipLine l

	join	SOShipHeader h
	on	h.CpnyID = l.CpnyID
	and	h.ShipperID = l.ShipperID

	where	l.CpnyID = @CpnyID
	and	l.ShipperID = @ShipperID
	and	l.LineRef like @LineRef

	group by
		l.InvtID,
		h.ShipSiteID
GO
