USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipLotWO_Delete]    Script Date: 12/21/2015 13:35:34 ******/
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
