USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_CustID_ShipRegist]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_CustID_ShipRegist]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE CustID LIKE @parm1
	   AND ShipRegisterID LIKE @parm2
	ORDER BY CustID,
	   ShipRegisterID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
