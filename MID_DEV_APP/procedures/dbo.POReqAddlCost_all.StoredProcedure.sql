USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqAddlCost_all]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqAddlCost_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 2 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM POReqAddlCost
	WHERE ReqNbr LIKE @parm1
	   AND ReqCntr LIKE @parm2
	   AND LineRef LIKE @parm3
	ORDER BY ReqNbr,
	   ReqCntr,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
