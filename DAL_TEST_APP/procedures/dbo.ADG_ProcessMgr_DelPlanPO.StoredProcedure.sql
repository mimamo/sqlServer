USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelPlanPO]    Script Date: 12/21/2015 13:56:50 ******/
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
