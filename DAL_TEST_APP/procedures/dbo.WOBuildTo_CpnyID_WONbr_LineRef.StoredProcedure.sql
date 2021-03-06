USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_CpnyID_WONbr_LineRef]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_CpnyID_WONbr_LineRef]
	@parm1 varchar( 10 ),
	@parm2 varchar( 16 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM WOBuildTo
	WHERE CpnyID LIKE @parm1
	   AND WONbr LIKE @parm2
	   AND LineRef LIKE @parm3
	ORDER BY CpnyID,
	   WONbr,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
