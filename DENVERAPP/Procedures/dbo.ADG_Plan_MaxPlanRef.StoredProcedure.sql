USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_MaxPlanRef]    Script Date: 12/21/2015 15:42:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_MaxPlanRef]
	@InvtID		varchar(30),
	@SiteID 	varchar(10)
as
	select		convert(int, max(PlanRef))
	from		SOPlan

	where		InvtID = @InvtID
	and		SiteID = @SiteID
GO
