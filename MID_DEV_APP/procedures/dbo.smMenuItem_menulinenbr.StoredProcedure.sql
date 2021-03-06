USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smMenuItem_menulinenbr]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smMenuItem_menulinenbr]
		@parm1	smallint
		,@parm2beg	smallint
		,@parm2end	smallint
AS
	SELECT
		*
	FROM
		smMenuItem
	WHERE
		menulinenbr = @parm1
	   		AND
	   	linenbr BETWEEN @parm2beg AND @parm2end
	ORDER BY
		menulinenbr
		,linenbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
