USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerT_TranSrc_RefNbr_InvtID_]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LotSerT_TranSrc_RefNbr_InvtID_]
	@parm1 varchar( 2 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 30 ),
	@parm4min int, @parm4max int
AS
	SELECT *
	FROM LotSerT
	WHERE TranSrc LIKE @parm1
	   AND RefNbr LIKE @parm2
	   AND InvtID LIKE @parm3
	   AND INTranLineID BETWEEN @parm4min AND @parm4max
	ORDER BY TranSrc,
	   RefNbr,
	   InvtID,
	   INTranLineID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
