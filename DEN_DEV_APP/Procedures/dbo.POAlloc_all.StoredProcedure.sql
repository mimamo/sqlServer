USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAlloc_all]    Script Date: 12/21/2015 14:06:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POAlloc_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 5 )
AS
	SELECT *
	FROM POAlloc
	WHERE CpnyID LIKE @parm1
	   AND PONbr LIKE @parm2
	   AND POLineRef LIKE @parm3
	   AND AllocRef LIKE @parm4
	ORDER BY CpnyID,
	   PONbr,
	   POLineRef,
	   AllocRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
