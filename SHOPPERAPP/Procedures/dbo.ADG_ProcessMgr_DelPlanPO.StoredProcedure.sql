USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelPlanPO]    Script Date: 12/21/2015 16:12:59 ******/
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
