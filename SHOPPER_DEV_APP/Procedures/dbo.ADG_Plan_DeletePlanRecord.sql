USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_DeletePlanRecord]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_DeletePlanRecord]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10),
	@PlanDate	smalldatetime,
	@PlanType	varchar(2),
	@PlanRef	varchar(5)
as
	delete	SOPlan
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanDate = @PlanDate
	and	PlanType = @PlanType
	and	PlanRef = @PlanRef
GO
