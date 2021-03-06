USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShObsolete]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShObsolete]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	p.InvtID,
		p.SiteID

	from	SOPlan		p

	join	SOShipLine	l
	on	l.CpnyID = p.CpnyID
	and	l.ShipperID = p.SOShipperID

	where	p.CpnyID = @CpnyID
	and	p.SOShipperID = @ShipperID
	and	p.SOShipperLineRef like @LineRef
	and	((p.InvtID <> l.InvtID) or (p.SiteID <> l.SiteID))

	group by
		p.InvtID,
		p.SiteID
GO
