USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_ReqTotal_ReqNbr_ReqCn]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_ReqTotal_ReqNbr_ReqCn]
	@parm1min float, @parm1max float,
	@parm2 varchar( 10 ),
	@parm3 varchar( 2 )
AS
	SELECT *
	FROM POReqHdr
	WHERE ReqTotal BETWEEN @parm1min AND @parm1max
	   AND ReqNbr LIKE @parm2
	   AND ReqCntr LIKE @parm3
	ORDER BY ReqTotal,
	   ReqNbr,
	   ReqCntr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
