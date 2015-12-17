USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_ShBehavior]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_ShBehavior]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select		t.Behavior
	from		SOShipHeader h

	join		SOType t
	on		t.CpnyID = @CpnyID
	and		t.SOTypeID = h.SOTypeID

	where		h.CpnyID = @CpnyID
	and		h.ShipperID = @ShipperID
GO
