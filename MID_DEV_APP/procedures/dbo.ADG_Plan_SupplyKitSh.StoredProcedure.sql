USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Plan_SupplyKitSh]    Script Date: 12/21/2015 14:17:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Plan_SupplyKitSh]
	@InvtID		varchar(30),
	@SiteID		varchar(10)
as
	select	h.CpnyID,
		h.ShipperID,
		h.BuildCmpltDate,
		h.BuildQty

	from	SOShipHeader h
	join	SOType	 t
	on	h.CpnyID = t.CpnyID
	and	h.SOTypeID = t.SOTypeID

	where	h.BuildInvtID = @InvtID
	and	h.SiteID = @SiteID
	and	h.Status = 'O'
	and	h.OrdNbr = ''	-- manually-entered shippers only for now
	and	t.Behavior = 'WO'

	order by
		h.BuildCmpltDate
GO
