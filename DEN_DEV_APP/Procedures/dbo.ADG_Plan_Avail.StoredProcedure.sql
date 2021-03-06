USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_Avail]    Script Date: 12/21/2015 14:05:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_Avail]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10)
as
	select	*
	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType not in ('40', '68', '70', '75') -- QAvail, Supply, Demand only

	order by
		PrioritySeq,
		Priority,
		PriorityDate,
		PriorityTime
GO
