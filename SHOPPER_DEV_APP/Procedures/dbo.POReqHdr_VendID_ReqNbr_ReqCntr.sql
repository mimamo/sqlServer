USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_VendID_ReqNbr_ReqCntr]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_VendID_ReqNbr_ReqCntr]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 2 )
AS
	SELECT *
	FROM POReqHdr
	WHERE VendID LIKE @parm1
	   AND ReqNbr LIKE @parm2
	   AND ReqCntr LIKE @parm3
	ORDER BY VendID,
	   ReqNbr,
	   ReqCntr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
