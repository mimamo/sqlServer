USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcessLogCPSOff_all]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProcessLogCPSOff_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM ProcessLogCPSOff
	WHERE ProcessLogID BETWEEN @parm1min AND @parm1max
	ORDER BY ProcessLogID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
