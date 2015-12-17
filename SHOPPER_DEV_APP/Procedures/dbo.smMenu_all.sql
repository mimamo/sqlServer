USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smMenu_all]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smMenu_all]
		@parm1beg	smallint
		,@parm1end	smallint
AS
	SELECT
		*
	FROM
		smMenu
	WHERE
		linenbr BETWEEN @parm1beg AND @parm1end
	ORDER BY
		linenbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
