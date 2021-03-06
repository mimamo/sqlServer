USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_PrevDemand]    Script Date: 12/21/2015 16:00:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_PrevDemand]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10),
	@Priority	smallint
as
	select	PlanDate,
		SOETADate,
		Qty = -Qty,
		CpnyID,
		SOOrdNbr,
		SOLineRef,
		PlanRef

	from	Inventory i (nolock)

	join	SOPlan p
	on	p.InvtID = i.InvtID

	where	p.InvtID = @InvtID
	and	p.SiteID = @SiteID
	and	p.PlanType in ('60', '62', '64','50')	-- Floating demand
        and     p.Priority <= Case when p.Plantype = '50' then 9 Else @Priority End
        and     p.Hold = Case when p.plantype = '50' then 0 Else p.Hold end
	and	i.StkItem = 1
	and	i.InvtID = @InvtID

	order by
		p.PrioritySeq,
		p.Priority,
		p.PriorityDate,
		p.PriorityTime
GO
