USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SchedToPlan]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SchedToPlan]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@SchedRef	varchar(5)
as
	select	SOType.Behavior,
		SOHeader.BuildAssyTime,
		SOHeader.BuildAvailDate,
		SOLine.CnvFact,
		SOSched.DropShip,
		SOSched.LotSerialEntered,
		SOLine.InvtID,
		SOHeader.Priority,
		SOSched.PriorityDate,
		SOSched.PrioritySeq,
		SOSched.PriorityTime,
		SOSched.PromDate,
		SOSched.QtyOrd,
		SOSched.QtyShip,
		SOSched.ReqDate,
		SOSched.ReqPickDate,
		SOHeader.ShipCmplt,
		SOSched.ShipViaID,
		SOSched.SiteID,
		SOSched.TransitTime,
		SOSched.WeekendDelivery,
		SOLine.UnitMultDiv

	from	SOSched

	join	SOHeader
	on	SOHeader.CpnyID = SOSched.CpnyID
	and	SOHeader.OrdNbr= SOSched.OrdNbr

	join	SOLine
	on	SOLine.CpnyID = SOSched.CpnyID
	and	SOLine.OrdNbr = SOSched.OrdNbr
	and	SOLine.LineRef = SOSched.LineRef

	join	SOType
	on	SOType.CpnyID = SOSched.CpnyID
	and	SOType.SOTypeID = SOHeader.SOTypeID

	where	SOSched.CpnyID = @CpnyID
	and	SOSched.OrdNbr = @OrdNbr
	and	SOSched.LineRef = @LineRef
	and	SOSched.SchedRef = @SchedRef
GO
