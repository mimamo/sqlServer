USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSNote_all]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSNote_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM EDSNote
	WHERE nID BETWEEN @parm1min AND @parm1max
	ORDER BY nID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
