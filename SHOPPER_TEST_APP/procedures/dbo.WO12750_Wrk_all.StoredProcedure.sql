USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WO12750_Wrk_all]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WO12750_Wrk_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 16 ),
	@parm3 varchar( 32 ),
	@parm4min smallint, @parm4max smallint
AS
	SELECT *
	FROM WO12750_Wrk
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND WONbr LIKE @parm2
	   AND Task LIKE @parm3
	   AND LineNbr BETWEEN @parm4min AND @parm4max
	ORDER BY RI_ID,
	   WONbr,
	   Task,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
