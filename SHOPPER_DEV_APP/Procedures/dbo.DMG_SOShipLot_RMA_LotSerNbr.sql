USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipLot_RMA_LotSerNbr]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipLot_RMA_LotSerNbr]
	@CpnyID		varchar (10),
	@ShipperID 	varchar (15),
	@LineRef	varchar (5),
	@LotSerNbr	varchar(25)
	AS
	select 	distinct LotSerNbr, Whseloc, QtyShip
	from 	SOShipLot
	where 	CpnyID = @CpnyID
	and 	ShipperID = @ShipperID
	and 	LineRef = @LineRef
	and	LotSerNbr like @LotSerNbr
	order by LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
