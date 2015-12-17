USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_UpdtShip_GetOrigQtyShip]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_UpdtShip_GetOrigQtyShip]
	@CpnyID			varchar(10),
	@OrigShipperID		varchar(15),
	@OrigShipperLineRef 	varchar(5)
as
	select	QtyShip


	from	SOShipLine

	where	CpnyID = @CpnyID
	  and	ShipperID = @OrigShipperID
	  and 	LineRef = @OrigShipperLineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
