USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyFromPlanTransfer]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyFromPlanTransfer]
	@InvtID		varchar(30),
	@SiteID 	varchar(10)
as
	select	PlanDate,
		'Qty' = sum(Qty)

	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType in ('28', '29')

	group by
		PlanDate
GO
