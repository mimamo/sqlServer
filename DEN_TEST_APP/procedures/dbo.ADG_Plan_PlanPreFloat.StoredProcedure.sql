USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_PlanPreFloat]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_PlanPreFloat]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10)
as
	select	*
	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType in ('10', '20', '21', '25', '26', '28', '29', '50', '52')
		-- All Supply and Demand, up to Floating Demand
		-- When Work Orders are included in CPS On, then add '15', '16', '17', '18', '54'

	order by
		PlanDate
GO
