USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipLine_All2]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipLine_All2]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
AS
	SELECT	*
	FROM	SOShipLine
	WHERE	CpnyID = @CpnyID
	  AND	ShipperID = @ShipperID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
