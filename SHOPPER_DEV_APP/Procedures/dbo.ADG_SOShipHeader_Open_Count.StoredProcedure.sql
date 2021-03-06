USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipHeader_Open_Count]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_SOShipHeader_Open_Count]

	@CpnyID varchar(10),
	@OrdNbr varchar(15),
	@ShipperID varchar(15)
as

	select 	count(*)
	from	SOShipHeader
	where	CpnyID like @CpnyID
	  and	OrdNbr like @OrdNbr
	  and 	Status = 'O'
	  and	ShipperID <> @ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
