USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_Nav]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipHeader_Nav]
	@CpnyID varchar(10),
	@ShipperID varchar(15)
AS
	SELECT *
	FROM SOShipHeader
	WHERE CpnyID LIKE @CpnyID
	   AND ShipperID LIKE @ShipperID
	ORDER BY ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
