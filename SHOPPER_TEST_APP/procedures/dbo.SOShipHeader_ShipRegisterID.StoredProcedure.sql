USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_ShipRegisterID]    Script Date: 12/21/2015 16:07:21 ******/
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
