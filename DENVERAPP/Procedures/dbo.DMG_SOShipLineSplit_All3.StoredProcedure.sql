USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOShipLineSplit_All3]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOShipLineSplit_All3]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15),
	@LineRef	varchar(5)
AS
	SELECT	*
	FROM	SOShipLineSplit
	WHERE	CpnyID = @CpnyID
	  AND	ShipperID = @ShipperID
	  AND	LineRef = @LineRef
	order by CreditPct

-- Copyright 1999 by Advanced Distribution Group, Ltd. All rights reserved.
GO
