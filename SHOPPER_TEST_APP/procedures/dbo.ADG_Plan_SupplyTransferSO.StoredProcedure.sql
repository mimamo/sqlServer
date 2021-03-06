USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyTransferSO]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyTransferSO]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@CancelDate	smalldatetime
as
	select	s.CpnyID,
		s.OrdNbr,
		s.LineRef,
		s.SchedRef,
		s.ReqDate,
		s.QtyOrd,
		s.QtyShip,
		s.TransitTime,
		s.WeekendDelivery,
		s.ShipViaID,
		l.CnvFact,
		l.UnitMultDiv

	from	SOSched s

	join	SOHeader h
	on	s.CpnyID = h.CpnyID
	and	s.OrdNbr = h.OrdNbr

	join	SOLine l
	on	s.CpnyID = l.CpnyID
	and	s.OrdNbr = l.OrdNbr
	and	s.LineRef = l.LineRef

	join	SOType t
	on	s.CpnyID = t.CpnyID
	and	h.SOTypeID = t.SOTypeID

	where	s.Status = 'O'
	and	s.ShipSiteID = @SiteID
	and	s.DropShip = 0
	and	s.CancelDate > @CancelDate
	and	s.QtyOrd > 0
	and	l.InvtID = @InvtID
	and	t.Behavior = 'TR'
GO
