USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smJobConfig_All_EXE]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smJobConfig_All_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smJobConfig
	WHERE
		ConfigCode LIKE @parm1
	ORDER BY
		ConfigCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
