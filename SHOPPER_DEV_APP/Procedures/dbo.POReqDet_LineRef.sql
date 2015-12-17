USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_LineRef]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_LineRef]
	@parm1 varchar( 5 )
AS
	SELECT *
	FROM POReqDet
	WHERE LineRef LIKE @parm1
	ORDER BY LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
