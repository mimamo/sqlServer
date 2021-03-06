USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smJobSortOrder_ConfigCode]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smJobSortOrder_ConfigCode]
		@parm1	varchar(10)
		,@parm2beg	smallint
		,@parm2end 	smallint
AS
	SELECT
		*
	FROM
		smJobSortOrder
	WHERE
		ConfigCode = @parm1
			AND
		LineNbr BETWEEN @parm2beg AND @parm2end
	ORDER BY
		ConfigCode
		,LineNbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
