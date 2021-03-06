USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CSStatement_all]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSStatement_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 6 )
AS
	SELECT *
	FROM CSStatement
	WHERE CpnyID LIKE @parm1
	   AND SlsperID LIKE @parm2
	   AND CycleID LIKE @parm3
	   AND CommPerNbr LIKE @parm4
	ORDER BY CpnyID,
	   SlsperID,
	   CycleID,
	   CommPerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
