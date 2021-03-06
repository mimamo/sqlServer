USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_CpnyID_JrnlType_Rlsed]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INTran_CpnyID_JrnlType_Rlsed]
	@parm1 varchar( 10 ),
	@parm2 varchar( 3 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM INTran
	WHERE CpnyID LIKE @parm1
	   AND JrnlType LIKE @parm2
	   AND Rlsed BETWEEN @parm3min AND @parm3max
	ORDER BY CpnyID,
	   JrnlType,
	   Rlsed

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
