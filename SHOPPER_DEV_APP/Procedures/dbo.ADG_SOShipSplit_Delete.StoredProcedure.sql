USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOShipSplit_Delete]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOShipSplit_Delete]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@SlsPerID	varchar(10)
AS
	IF @CpnyID <> '%' and @ShipperID <> '%'
		DELETE	FROM SOShipSplit
		WHERE	CpnyID = @CpnyID AND
			ShipperID = @ShipperID AND
			SlsPerID + '' LIKE @SlsPerID
	ELSE
		DELETE	FROM SOShipSplit
		WHERE	CpnyID LIKE @CpnyID AND
			ShipperID LIKE @ShipperID AND
			SlsPerID LIKE @SlsPerID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
