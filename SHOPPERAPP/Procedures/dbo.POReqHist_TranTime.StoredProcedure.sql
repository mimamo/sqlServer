USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_TranTime]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHist_TranTime]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POReqHist
	WHERE TranTime LIKE @parm1
	ORDER BY TranTime

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
