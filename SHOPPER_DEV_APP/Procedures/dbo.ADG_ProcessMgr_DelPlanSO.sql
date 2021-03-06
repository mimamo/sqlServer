USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelPlanSO]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelPlanSO]
 	@CpnyID		varchar(10),
 	@OrdNbr		varchar(15),
 	@LineRef	varchar(5),
 	@SchedRef	varchar(5)
as
	delete	SOPlan
 	where	CpnyID = @CpnyID
 	and	SOOrdNbr = @OrdNbr
 	and	SOLineRef like @LineRef
 	and	SOSchedRef like @SchedRef
 	and	SOShipperID = ''
GO
