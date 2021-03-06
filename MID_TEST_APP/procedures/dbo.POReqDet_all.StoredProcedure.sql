USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_all]    Script Date: 12/21/2015 15:49:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 2 ),
	@parm3min smallint, @parm3max smallint
AS
	SELECT *
	FROM POReqDet
	WHERE ReqNbr LIKE @parm1
	   AND ReqCntr LIKE @parm2
	   AND LineNbr BETWEEN @parm3min AND @parm3max
	ORDER BY ReqNbr,
	   ReqCntr,
	   LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
