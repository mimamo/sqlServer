USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_ReqCntr]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_ReqCntr]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM POReqHdr
	WHERE ReqCntr LIKE @parm1
	ORDER BY ReqCntr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
