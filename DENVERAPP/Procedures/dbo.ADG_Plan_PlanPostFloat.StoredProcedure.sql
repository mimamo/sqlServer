USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_PlanPostFloat]    Script Date: 12/21/2015 15:42:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_PlanPostFloat]
	@InvtID 	varchar(30),
	@SiteID 	varchar(10)
as
	select	*
	from	SOPlan

	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType in ('30', '32', '34', '40', '68', '70', '75')

	order by
		PlanDate
GO
