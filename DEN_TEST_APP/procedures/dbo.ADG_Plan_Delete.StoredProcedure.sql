USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_Delete]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_Delete]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10)
as
	delete	SOPlan
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType <> '61'
GO
