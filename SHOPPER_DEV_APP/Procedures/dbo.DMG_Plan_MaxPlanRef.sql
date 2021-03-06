USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_MaxPlanRef]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Plan_MaxPlanRef]
	@InvtID		varchar(30),
	@SiteID 	varchar(10),
	@PlanRef	int OUTPUT
as
	select		@PlanRef = coalesce(convert(int, max(PlanRef)),0)
	from		SOPlan (NOLOCK)
	where		InvtID = @InvtID
	  and		SiteID = @SiteID

	if @@ROWCOUNT = 0 begin
		set @PlanRef = 0
		return 0	-- Failure
	end
	else begin
		return 1	-- Success
	end
GO
