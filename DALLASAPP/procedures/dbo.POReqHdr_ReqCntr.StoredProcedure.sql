USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_ReqCntr]    Script Date: 12/21/2015 13:45:02 ******/
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
