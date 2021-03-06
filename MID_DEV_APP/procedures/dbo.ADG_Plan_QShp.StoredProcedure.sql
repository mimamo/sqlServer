USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_QShp]    Script Date: 12/21/2015 14:17:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_QShp]
	@InvtID		varchar(30),
	@SiteID		varchar(10),
	@QtyPrec	smallint
as
	select	isnull(sum(	case when l.UnitMultDiv = 'D' then
				case when l.CnvFact <> 0 then
					round(l.QtyShip / l.CnvFact, @QtyPrec)
				else
					0
				end
			else
				round(l.QtyShip * l.CnvFact, @QtyPrec)
			end), 0) QtyShip

	from	SOShipLine l

	join	SOShipHeader h (nolock)	-- Use NOLOCK to eliminate a deadlock problem
	on	l.CpnyID = h.CpnyID
	and	l.ShipperID = h.ShipperID

	join	SOType t
	on	t.CpnyID = l.CpnyID
	and	t.SOTypeID = h.SOTypeID

	where	l.InvtID = @InvtID
	and	l.SiteID = @SiteID
	and	l.Status = 'O'
	and	l.QtyShip > 0
	and	h.DropShip = 0
	and	t.Behavior in ('CS', 'INVC', 'MO', 'RMA', 'RMSH', 'SERV', 'SO', 'TR', 'WC', 'WO')
GO
