USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcErrLog_all]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProcErrLog_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM ProcErrLog
	WHERE RecordID BETWEEN @parm1min AND @parm1max
	ORDER BY RecordID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
