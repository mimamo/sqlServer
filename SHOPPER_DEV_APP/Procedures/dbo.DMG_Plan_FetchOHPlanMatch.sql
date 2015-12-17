USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_FetchOHPlanMatch]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_Plan_FetchOHPlanMatch]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select		*
	from		SOPlan
	where		InvtID = @InvtID and
	  		SiteID = @SiteID and
	  		PlanType = '10'
GO
