USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipMisc]    Script Date: 12/21/2015 16:00:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipMisc]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	MiscChrgID,
		MiscChrgRef,
		MiscAcct,
		MiscSub,
		CuryMiscChrg,
		MiscChrg,
		TaxCat,
		Descr

	from	SOShipMisc
	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	order by
		MiscChrgRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
