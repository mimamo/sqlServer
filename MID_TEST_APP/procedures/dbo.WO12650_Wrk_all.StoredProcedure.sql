USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WO12650_Wrk_all]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WO12650_Wrk_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 16 ),
	@parm3 varchar( 32 ),
	@parm4 varchar( 1 ),
	@parm5min smallint, @parm5max smallint
AS
	SELECT *
	FROM WO12650_Wrk
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND WONbr LIKE @parm2
	   AND Task LIKE @parm3
	   AND MatlRouting LIKE @parm4
	   AND LineNbr BETWEEN @parm5min AND @parm5max
	ORDER BY RI_ID,
	   WONbr,
	   Task,
	   MatlRouting,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
