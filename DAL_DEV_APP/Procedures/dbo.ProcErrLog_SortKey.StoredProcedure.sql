USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcErrLog_SortKey]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProcErrLog_SortKey]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM ProcErrLog
	WHERE SortKey BETWEEN @parm1min AND @parm1max
	ORDER BY SortKey

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
