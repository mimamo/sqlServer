USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateShipper_SupplyTransferSh]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateShipper_SupplyTransferSh]
	@CpnyID			varchar(10),
	@ShipperID		varchar(15)
as
	select
		l.LineRef,
		l.QtyShip,
		h.TransitTime,
		h.WeekendDelivery,
		l.CnvFact,
		l.UnitMultDiv,
		h.ShipDateAct,
		h.ShipDatePlan,
		l.OrdNbr,
		l.OrdLineRef,
		h.ShipViaID,
		l.invtid,
		h.ShipSiteID

	from	SOShipLine  l

	  join	SOShipHeader  h (NOLOCK)
	  on	h.CpnyID = l.CpnyID
	  and	h.ShipperID = l.ShipperID

	  join	SOType  t
	  on	h.CpnyID = t.CpnyID
	  and	h.SOTypeID = t.SOTypeID

	  left
	  join	TrnsfrDoc  td
	  on	td.CpnyID = l.CpnyID
	  and	td.BatNbr = h.INBatNbr

	where	l.CpnyID = @CpnyID and
		l.ShipperID = @ShipperID and
	  	((l.Status = 'O') or (td.Status is null) or (td.Status <> 'R')) and
	  	l.QtyShip > 0 and
	  	t.Behavior = 'TR' and
	  	h.DropShip = 0 and
	  	h.Cancelled = 0
GO
