USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_ReqCntr]    Script Date: 12/21/2015 15:55:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_ReqCntr]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM POReqDet
	WHERE ReqCntr LIKE @parm1
	ORDER BY ReqCntr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
