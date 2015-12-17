USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POReqHdr_POPrint]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_POReqHdr_POPrint]
	@parm1 varchar( 10 ),
	@parm2 varchar( 2 )
AS
	SELECT *
	FROM POReqHdr
	WHERE ReqNbr LIKE @parm1
	   AND ReqCntr LIKE @parm2
	ORDER BY ReqNbr,
	   convert(integer, ReqCntr) Desc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
