USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcErrLog_all]    Script Date: 12/16/2015 15:55:30 ******/
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
