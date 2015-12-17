USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipLotWO_Delete]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipLotWO_Delete]
		@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LotSerRef	varchar(5)
AS
	DELETE FROM SOShipLotWO
	WHERE	CpnyID LIKE @CpnyID AND
		ShipperID LIKE @ShipperID AND
		BuildLotSerRef LIKE @LotSerRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
