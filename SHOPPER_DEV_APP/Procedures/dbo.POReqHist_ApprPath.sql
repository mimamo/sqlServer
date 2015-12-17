USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_ApprPath]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHist_ApprPath]
	@parm1 varchar( 1 )
AS
	SELECT *
	FROM POReqHist
	WHERE ApprPath LIKE @parm1
	ORDER BY ApprPath

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
