USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipTax]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipTax]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select	TaxID,
		TaxRate,
		TotTax,
		TotTxbl,
		CuryTotTax,
		CuryTotTxbl

	from	SOShipTax

	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
