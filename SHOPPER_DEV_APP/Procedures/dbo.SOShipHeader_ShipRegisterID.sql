USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_ShipRegisterID]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_ShipRegisterID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE ShipRegisterID LIKE @parm1
	ORDER BY ShipRegisterID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
