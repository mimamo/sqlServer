USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipHeader_All0]    Script Date: 12/21/2015 13:56:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipHeader_All0]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
AS
	SELECT	*
	FROM	SOShipHeader
	WHERE	CpnyID = @CpnyID
	  AND	ShipperID = @ShipperID

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
