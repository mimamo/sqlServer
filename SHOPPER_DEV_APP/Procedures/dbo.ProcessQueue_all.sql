USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcessQueue_all]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProcessQueue_all]
	@parm1min smallint, @parm1max smallint,
	@parm2min int, @parm2max int
AS
	SELECT *
	FROM ProcessQueue
	WHERE ProcessPriority BETWEEN @parm1min AND @parm1max
	   AND ProcessQueueID BETWEEN @parm2min AND @parm2max
	ORDER BY ProcessPriority,
	   ProcessQueueID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
