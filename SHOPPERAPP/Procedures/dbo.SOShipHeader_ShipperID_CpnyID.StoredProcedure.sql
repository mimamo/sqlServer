USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_ShipperID_CpnyID]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_ShipperID_CpnyID]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM SOShipHeader
	WHERE ShipperID LIKE @parm1
	   AND CpnyID LIKE @parm2
	ORDER BY ShipperID,
	   CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
