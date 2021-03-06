USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_DelPlanSOSchedOrphans]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_DelPlanSOSchedOrphans]
 	@CpnyID		varchar(10),
 	@OrdNbr		varchar(15),
 	@LineRef	varchar(5),
 	@SchedRef	varchar(5)
as
	delete	SOPlan

	from 	SOPlan

	left join SOSched
	on	SOPlan.CpnyID = SOSched.CpnyID
	and	SOPlan.SOOrdNbr = SOSched.OrdNbr
	and	SOPlan.SOLineRef = SOSched.LineRef
	and	SOPlan.SOSchedRef = SOSched.SchedRef

	where 	SOPlan.CpnyID = @CpnyID
	and	SOPlan.SOOrdNbr = @OrdNbr
	and 	SOPlan.SOLineRef like @LineRef
	and	SOPlan.SOSchedRef like @SchedRef
	and 	SOPlan.SOShipperID = ''
	and	SOPlan.SOLineRef <> ''
	and 	(SOSched.LineRef is null or SOSched.SchedRef is null)
GO
