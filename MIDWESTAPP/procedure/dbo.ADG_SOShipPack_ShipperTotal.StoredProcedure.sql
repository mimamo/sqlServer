USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipPack_ShipperTotal]    Script Date: 12/21/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOShipPack_ShipperTotal]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	select		sum(CuryFrtCost),
			sum(CuryFrtInvc),
			sum(FrtCost),
			sum(FrtInvc),
			sum(Wght)

	from		SOShipPack
	where		CpnyID = @CpnyID
	  and		ShipperID = @ShipperID
	group by	CpnyID,
			ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
