USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smArea_All_EXE]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smArea_All_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smArea
	WHERE
		AreaId LIKE @parm1
	ORDER BY
		AreaId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
