USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_PlanDemandFloat]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_PlanDemandFloat]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10)
as
	select	*
	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType in ('60', '62', '64', '66') -- Floating Demand types
		-- When Work Orders are included in CPS On, then add '80', '82'

	order by
		PrioritySeq,
		Priority,
		PriorityDate,
		PriorityTime
GO
