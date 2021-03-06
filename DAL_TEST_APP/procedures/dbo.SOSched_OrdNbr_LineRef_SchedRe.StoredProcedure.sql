USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOSched_OrdNbr_LineRef_SchedRe]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOSched_OrdNbr_LineRef_SchedRe]
	@parm1 varchar( 15 ),
	@parm2 varchar( 5 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM SOSched
	WHERE OrdNbr LIKE @parm1
	   AND LineRef LIKE @parm2
	   AND SchedRef LIKE @parm3
	   AND CpnyID LIKE @parm4
	ORDER BY OrdNbr,
	   LineRef,
	   SchedRef,
	   CpnyID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
