USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqDet_LineNbr]    Script Date: 12/21/2015 14:17:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqDet_LineNbr]
	@parm1min smallint, @parm1max smallint
AS
	SELECT *
	FROM POReqDet
	WHERE LineNbr BETWEEN @parm1min AND @parm1max
	ORDER BY LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
