USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smPMHeader_All_EXE]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smPMHeader_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smPMHeader
	WHERE
		PMType LIKE @parm1
	ORDER BY
		PMType

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
