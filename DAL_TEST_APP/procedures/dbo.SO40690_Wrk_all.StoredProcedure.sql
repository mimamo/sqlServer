USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SO40690_Wrk_all]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SO40690_Wrk_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 10 ),
	@parm3 varchar( 15 )
AS
	SELECT *
	FROM SO40690_Wrk
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND CpnyID LIKE @parm2
	   AND ShipperID LIKE @parm3
	ORDER BY RI_ID,
	   CpnyID,
	   ShipperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
