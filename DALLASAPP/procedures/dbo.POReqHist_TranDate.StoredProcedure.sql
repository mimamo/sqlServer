USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHist_TranDate]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHist_TranDate]
	@parm1min smalldatetime, @parm1max smalldatetime
AS
	SELECT *
	FROM POReqHist
	WHERE TranDate BETWEEN @parm1min AND @parm1max
	ORDER BY TranDate

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
