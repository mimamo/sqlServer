USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_TranTime]    Script Date: 12/16/2015 15:55:29 ******/
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
