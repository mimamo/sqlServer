USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShTrfrObsolete]    Script Date: 12/21/2015 13:56:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShTrfrObsolete]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
as
	select	p.InvtID,
		p.SiteID

	from	SOPlan p

	join	SOShipHeader h
	on	h.CpnyID = p.CpnyID
	and	h.ShipperID = p.SOShipperID

	join	SOShipLine	l
	on	l.CpnyID = p.CpnyID
	and	l.ShipperID = p.SOShipperID

	where	p.CpnyID = @CpnyID
	and	p.SOShipperID = @ShipperID
	and	p.SOShipperLineRef like @LineRef
	and	p.PlanType = '29'
	and	((p.InvtID <> l.InvtID) or (p.SiteID <> h.ShipSiteID))

	group by
		p.InvtID,
		p.SiteID
GO
