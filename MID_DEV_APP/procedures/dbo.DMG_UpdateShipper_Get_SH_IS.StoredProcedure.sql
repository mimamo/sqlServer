USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateShipper_Get_SH_IS]    Script Date: 12/21/2015 14:17:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateShipper_Get_SH_IS]
	@CpnyID		varchar(10),
	@ShipperID   	varchar(15),
	@LineRef	varchar(5),
	@InvtIDParm	varchar(30),
	@SiteIDParm	varchar(10)
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
			and l.InvtID like @InvtIDParm
			and l.SiteID like @SiteIDParm
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
			and l.InvtID like @InvtIDParm
			and l.SiteID like @SiteIDParm
			order by l.invtid, l.siteid, h.shipdateact
GO
