USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_UserID]    Script Date: 12/21/2015 14:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHist_UserID]
	@parm1 varchar( 47 )
AS
	SELECT *
	FROM POReqHist
	WHERE UserID LIKE @parm1
	ORDER BY UserID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
