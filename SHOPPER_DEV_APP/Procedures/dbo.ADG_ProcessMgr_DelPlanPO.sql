USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelPlanPO]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelPlanPO]
	@PONbr		varchar(10),
	@LineRef	varchar(5)
as
	delete	SOPlan
	where	PONbr = @PONbr
	and	POLineRef like @LineRef
GO
