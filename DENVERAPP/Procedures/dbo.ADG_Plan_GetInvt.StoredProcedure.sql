USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_GetInvt]    Script Date: 12/21/2015 15:42:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_GetInvt]
	@InvtID		varchar(30),
	@SiteID 	varchar(10)

as
	select	*
	from	SOPlan
	where	InvtID = @InvtID
	and	SiteID = @SiteID
	and	PlanType = '10'
GO
