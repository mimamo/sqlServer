USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipSplit_all]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipSplit_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM SOShipSplit
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND SlsperID LIKE @parm3
	ORDER BY CpnyID,
	   ShipperID,
	   SlsperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
