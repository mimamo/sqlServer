USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSCQConfig_All_EXE]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSCQConfig_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smSCQConfig
	WHERE
		ConfigCode LIKE @parm1
	ORDER BY
		ConfigCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
