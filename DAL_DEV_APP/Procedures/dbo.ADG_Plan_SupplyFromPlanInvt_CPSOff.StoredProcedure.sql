USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyFromPlanInvt_CPSOff]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyFromPlanInvt_CPSOff]
	@InvtID		varchar(30),
	@SiteID 	varchar(10)
as
	select	'QtyAvail' = (Qty)

	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType = '10'
GO
