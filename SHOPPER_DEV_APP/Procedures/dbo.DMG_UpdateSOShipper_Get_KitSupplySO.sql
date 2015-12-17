USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateSOShipper_Get_KitSupplySO]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateSOShipper_Get_KitSupplySO]
	@CpnyID		   varchar(10),
	@OrdNbr   		varchar(15),
	@CancelDate		smalldatetime
as
	select
		h.BuildAvailDate,
		h.BuildQty,
		h.S4Future03,						-- BuildQtyUpdated
		h.BuildInvtID,
		h.BuildSiteID

	from	SOHeader h
	  join	SOType	 t
	  on	h.CpnyID = t.CpnyID
	  and	h.SOTypeID = t.SOTypeID

	where	h.CpnyID = @CpnyID and
	      	h.OrdNbr = @OrdNbr and
	  	h.Status = 'O' and
	  	t.Behavior = 'WO' and
		h.CancelDate > @CancelDate
GO
