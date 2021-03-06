USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreateShipper_SchedNoPlan]    Script Date: 12/21/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreateShipper_SchedNoPlan]
	@CpnyID		varchar(10),
	@SOOrdNbr	varchar(15)
as
	select	s.LineRef,
		s.SchedRef,
		'Qty' = -(s.QtyOrd - s.QtyShip),
		l.CnvFact,
		l.UnitMultDiv

	from	SOSched	s

	  join	SOLine l
	  on	l.CpnyID = s.CpnyID
	  and	l.OrdNbr = s.OrdNbr
	  and	l.LineRef = s.LineRef

	  left
	  join	SOSchedMark m
	  on	m.CpnyID = s.CpnyID
	  and	m.OrdNbr = s.OrdNbr
	  and	m.LineRef = s.LineRef
	  and	m.SchedRef = s.SchedRef

	where	s.CpnyID = @CpnyID
	  and	s.OrdNbr = @SOOrdNbr
	  and	s.Status = 'O'
	  and	s.QtyOrd <> s.QtyShip
	  and	NOT EXISTS
		(SELECT CpnyID, SOOrdNbr, SOLineRef, SOSchedRef
		FROM 	SOPlan p
		WHERE	p.CpnyID = s.CpnyID
		  AND	p.SOOrdNbr = s.OrdNbr
		  AND	p.SOLineRef = s.LineRef
		  AND	p.SOSchedRef = s.SchedRef)

	-- The order by clause must be the 'schedule group' fields
	-- followed by s.LineRef.
	order by
		s.DropShip,
		s.SiteID,
		s.ShipViaID,
		s.ShiptoType,
		s.ShipCustID,
		s.ShiptoID,
		s.ShipAddrID,
		s.ShipSiteID,
		s.ShipVendID,
		s.WeekendDelivery,
		s.MarkFor,
		m.MarkForType,
		m.CustID,
		m.MarkForID,
		m.AddrID,
		m.SiteID,
		m.VendID,
		s.LineRef,
		s.LotSerialEntered
GO
