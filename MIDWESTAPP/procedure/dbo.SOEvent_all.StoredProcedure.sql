USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOEvent_all]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOEvent_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 15 ),
	@parm4min int, @parm4max int
AS
	SELECT *
	FROM SOEvent
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	   AND ShipperID LIKE @parm3
	   AND EventID BETWEEN @parm4min AND @parm4max
	ORDER BY CpnyID,
	   OrdNbr,
	   ShipperID,
	   EventID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
