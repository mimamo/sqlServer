USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOKitObsolete]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SOKitObsolete]
	@CpnyID		varchar(10),
	@SOOrdNbr	varchar(15)
as
	select	p.InvtID,
		p.SiteID

	from	SOPlan p

	join	SOHeader h
	on	h.CpnyID = p.CpnyID
	and	h.OrdNbr = p.SOOrdNbr

	where	p.CpnyID = @CpnyID
	and	p.SOOrdNbr = @SOOrdNbr
	and	p.PlanType = '25'
	and	((p.InvtID <> h.BuildInvtID) or (p.SiteID <> h.BuildSiteID))
GO
