USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyFromPlanKitAssy]    Script Date: 12/21/2015 15:42:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyFromPlanKitAssy]
	@InvtID		varchar(30),
	@SiteID 	varchar(10)
as
	select	PlanDate,
		'Qty' = sum(Qty)

	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType in ('25', '26')

	group by
		PlanDate
GO
