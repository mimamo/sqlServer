USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_LineRef]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHist_LineRef]
	@parm1 varchar( 5 )
AS
	SELECT *
	FROM POReqHist
	WHERE LineRef LIKE @parm1
	ORDER BY LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
