USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShKitObsolete]    Script Date: 12/21/2015 13:44:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShKitObsolete]
	@CpnyID		varchar(10),
	@SOShipperID	varchar(15)
as
	select	p.InvtID,
		p.SiteID

	from	SOPlan	p

	join	SOShipHeader h
	on	h.CpnyID = p.CpnyID
	and	h.ShipperID = p.SOShipperID

	where	p.CpnyID = @CpnyID
	and	p.SOShipperID = @SOShipperID
	and	p.PlanType = '26'
	and	((p.InvtID <> h.BuildInvtID) or (p.SiteID <> h.SiteID))
GO
