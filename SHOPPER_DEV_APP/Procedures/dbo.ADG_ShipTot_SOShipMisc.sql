USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ShipTot_SOShipMisc]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ShipTot_SOShipMisc]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select		CuryMiscChrg,
			MiscChrg,
			Taxable,
			TaxCat

	from		SOShipMisc
	where		CpnyID = @CpnyID
	  and		ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
