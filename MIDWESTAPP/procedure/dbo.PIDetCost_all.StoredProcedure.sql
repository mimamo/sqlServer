USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetCost_all]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIDetCost_all]
	@parm1 varchar( 10 ),
	@parm2min int, @parm2max int,
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM PIDetCost
	WHERE PIID LIKE @parm1
	   AND Number BETWEEN @parm2min AND @parm2max
	   AND LineRef LIKE @parm3
	ORDER BY PIID,
	   Number,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
