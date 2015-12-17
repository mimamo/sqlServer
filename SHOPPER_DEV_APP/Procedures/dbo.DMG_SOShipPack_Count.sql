USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipPack_Count]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipPack_Count]
	@CpnyID 	varchar (10),
	@ShipperID 	varchar (15)
AS
	SELECT	count(*)
	FROM 	SOShipPack
	WHERE	CpnyID = @CpnyID
	and 	ShipperID = @ShipperID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
