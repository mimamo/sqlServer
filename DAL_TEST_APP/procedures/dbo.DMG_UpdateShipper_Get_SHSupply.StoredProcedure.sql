USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateShipper_Get_SHSupply]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateShipper_Get_SHSupply]
	@CpnyID		varchar(10),
	@ShipperID   	varchar(15)

as
	select
		h.OrdNbr,
		t.Behavior

	from	SOShipHeader	h

	  join	SOType		t
	  on	t.CpnyID = h.CpnyID
	  and	t.SOTypeID = h.SOTypeID

	where	h.CpnyID = @CpnyID
		and h.ShipperID = @ShipperID
	  	and t.Behavior in ('TR', 'WO')
GO
