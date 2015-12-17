USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SHShipPack_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SHShipPack_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SHShipPack
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND BoxRef LIKE @parm3
	ORDER BY CpnyID,
	   ShipperID,
	   BoxRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
