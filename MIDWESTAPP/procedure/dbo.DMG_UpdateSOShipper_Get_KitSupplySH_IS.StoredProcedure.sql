USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateSOShipper_Get_KitSupplySH_IS]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateSOShipper_Get_KitSupplySH_IS]
	@CpnyID		varchar(10),
	@ShipperID   	varchar(15),
	@InvtIDParm	varchar(30),
	@SiteIDParm	varchar(10)

as
	select
		h.BuildCmpltDate,
		h.BuildQty,
		h.BuildInvtID,
		h.SiteID

	from	SOShipHeader h
	  join	SOType	 t
	  on	h.CpnyID = t.CpnyID
	  and	h.SOTypeID = t.SOTypeID

	where	h.CpnyID = @CpnyID and
	      	h.ShipperID = @ShipperID and
	  	h.Status = 'O' and
	  	h.OrdNbr = '' and 			-- manually-entered shippers only for now
	  	t.Behavior = 'WO'
		and h.BuildInvtID like @InvtIDParm
		and h.SiteID like @SiteIDParm
GO
