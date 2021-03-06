USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipLine_all]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipLine_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SOShipLine
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND LineRef LIKE @parm3
	ORDER BY CpnyID,
	   ShipperID,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
