USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_SOShipSched]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_SOShipSched]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@ShipperLineRef	varchar(5),
	@OrdNbr		varchar(15),
	@OrdLineRef	varchar(5)
as
	select	OrdSchedRef,
		QtyPick

	from	SOShipSched

	where	CpnyID = @CpnyID
	  and	ShipperID = @ShipperID
	  and	ShipperLineRef = @ShipperLineRef
	  and	OrdNbr = @OrdNbr
	  and	OrdLineRef = @OrdLineRef

	order by
		ReqDate,
		OrdSchedRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
