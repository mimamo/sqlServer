USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_Plan_FetchOHPlanMatch]    Script Date: 12/21/2015 13:56:57 ******/
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
