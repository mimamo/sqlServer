USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateShipper_Get_SH]    Script Date: 12/21/2015 16:13:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateShipper_Get_SH]
	@CpnyID		   varchar(10),
	@ShipperID   	varchar(15),
	@LineRef			varchar(5)
as
	IF PATINDEX('%[%]%', @LineRef) > 0
		select
			l.LineRef,
			h.OrdNbr,
			l.OrdLineRef,
			l.CnvFact,
			l.UnitMultDiv,
			h.ShipDateAct,
			h.ShipDatePlan,
			l.QtyShip,
			h.Priority,
			h.ShipViaID,
			h.TransitTime,
			h.WeekendDelivery,
			h.DropShip,
			t.Behavior,
			l.invtid,
			l.siteid
			from	SOShipLine	l
	  		  join	SOShipHeader	h
		  on	h.CpnyID = l.CpnyID
		  and	h.ShipperID = l.ShipperID
			  join	SOType		t
		  on	t.CpnyID = l.CpnyID
		  and	t.SOTypeID = h.SOTypeID
			where	l.CpnyID = @CpnyID and
			l.ShipperID = @ShipperID and
			l.LineRef + '' LIKE @LineRef and
		  	l.Status = 'O' and
		  	l.QtyShip > 0 and
		  	t.Behavior in ( 'CS', 'INVC', 'MO', 'RMA', 'RMSH', 'SERV', 'SO', 'TR', 'WC', 'WO')
		   	order by l.invtid, l.siteid, h.shipdateact
	ELSE
		select
			l.LineRef,
			h.OrdNbr,
			l.OrdLineRef,
			l.CnvFact,
			l.UnitMultDiv,
			h.ShipDateAct,
			h.ShipDatePlan,
			l.QtyShip,
			h.Priority,
			h.ShipViaID,
			h.TransitTime,
			h.WeekendDelivery,
			h.DropShip,
			t.Behavior,
			l.invtid,
			l.siteid
			from	SOShipLine	l
	  		  join	SOShipHeader	h
		  on	h.CpnyID = l.CpnyID
		  and	h.ShipperID = l.ShipperID
			  join	SOType		t
		  on	t.CpnyID = l.CpnyID
		  and	t.SOTypeID = h.SOTypeID
			where	l.CpnyID = @CpnyID and
			l.ShipperID = @ShipperID and
			l.LineRef = @LineRef and
		  	l.Status = 'O' and
		  	l.QtyShip > 0 and
		  	t.Behavior in ( 'CS', 'INVC', 'MO', 'RMA', 'RMSH', 'SERV', 'SO', 'TR', 'WC', 'WO')
			order by l.invtid, l.siteid, h.shipdateact
GO
