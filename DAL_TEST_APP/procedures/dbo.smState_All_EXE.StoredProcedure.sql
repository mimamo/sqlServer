USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smState_All_EXE]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smState_All_EXE]
		@parm1	varchar(3)
AS
	SELECT
		*
	FROM
		State
	WHERE
		StateProvId LIKE @parm1
	ORDER BY
		StateProvId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
