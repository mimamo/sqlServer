USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPlan_AvailToDate_PlanDate]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOPlan_AvailToDate_PlanDate]
	@invtid 	varchar(30),
	@siteid 	varchar(10),
	@parm3min smalldatetime, @parm3max smalldatetime,
	@today		smalldatetime
as
	select *
	from	soplan
	where	InvtID like @invtid
	  and	SiteID like @siteid
	  and	(PlanDate BETWEEN @parm3min AND @parm3max or PlanType = '61' and PlanDate > @today)
	ORDER BY InvtID,
	   case when PlanType = '61' and PlanDate > @today then @today else PlanDate end,
	   PlanType,
	   PlanRef
GO
