USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_FrtTaxCat]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_FrtTaxCat]
	@CpnyID		varchar(10),
	@ShipViaID	varchar(15)
as
	select	TaxCat
	from	ShipVia
	where	CpnyID = @CpnyID
	  and	ShipViaID = @ShipViaID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
