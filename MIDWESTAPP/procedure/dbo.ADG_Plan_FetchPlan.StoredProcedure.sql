USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_FetchPlan]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_FetchPlan]
	@InvtID		varchar(30),
	@SiteID 	varchar(10),
	@PlanRef	varchar(5)

as
	select	*
	from	SOPlan
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanRef = @PlanRef
GO
