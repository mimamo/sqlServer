USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipLineSplit_All0]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipLineSplit_All0]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5),
	@SlsperID	varchar(10)
AS
	SELECT	*
	FROM	SOShipLineSplit
	WHERE	CpnyID = @CpnyID
	  AND	ShipperID = @ShipperID
	  AND	LineRef = @LineRef
	  AND	SlsperID = @SlsperID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
