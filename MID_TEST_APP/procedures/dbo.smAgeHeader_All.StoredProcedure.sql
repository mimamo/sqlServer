USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smAgeHeader_All]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smAgeHeader_All]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smAgeHeader
	WHERE
		AgeCode LIKE @parm1
	ORDER BY
		AgeCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
