USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_all]    Script Date: 12/21/2015 16:01:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHist_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 ),
	@parm3min smalldatetime, @parm3max smalldatetime,
	@parm4 varchar( 10 ),
	@parm5 varchar( 47 ),
	@parm6 varchar( 1 )
AS
	SELECT *
	FROM POReqHist
	WHERE ReqNbr LIKE @parm1
	   AND LineRef LIKE @parm2
	   AND TranDate BETWEEN @parm3min AND @parm3max
	   AND TranTime LIKE @parm4
	   AND UserID LIKE @parm5
	   AND ApprPath LIKE @parm6
	ORDER BY ReqNbr,
	   LineRef,
	   TranDate,
	   TranTime,
	   UserID,
	   ApprPath

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
