USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_ReqType_ReqNbr_ReqCnt]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_ReqType_ReqNbr_ReqCnt]
	@parm1 varchar( 2 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 2 )
AS
	SELECT *
	FROM POReqHdr
	WHERE ReqType LIKE @parm1
	   AND ReqNbr LIKE @parm2
	   AND ReqCntr LIKE @parm3
	ORDER BY ReqType,
	   ReqNbr,
	   ReqCntr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
