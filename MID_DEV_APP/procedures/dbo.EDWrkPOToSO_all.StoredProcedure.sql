USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_all]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDWrkPOToSO_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 30 ),
	@parm5 varchar( 6 )
AS
	SELECT *
	FROM EDWrkPOToSO
	WHERE AccessNbr BETWEEN @parm1min AND @parm1max
	   AND CpnyID LIKE @parm2
	   AND EDIPOID LIKE @parm3
	   AND InvtID LIKE @parm4
	   AND POUOM LIKE @parm5
	ORDER BY AccessNbr,
	   CpnyID,
	   EDIPOID,
	   InvtID,
	   POUOM

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
