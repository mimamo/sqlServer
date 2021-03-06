USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CSStatement_Count]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_CSStatement_Count]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 6 )
AS
	SELECT	convert(integer,count(*)) as Cnt
	FROM	CSStatement
	WHERE	CpnyID LIKE @parm1
	  AND	SlsperID LIKE @parm2
	  AND	CycleID LIKE @parm3
	  AND	CommPerNbr LIKE @parm4

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
