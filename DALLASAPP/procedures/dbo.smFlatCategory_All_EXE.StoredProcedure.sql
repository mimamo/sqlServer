USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smFlatCategory_All_EXE]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smFlatCategory_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smFlatCategory
	WHERE
		FlatCategoryId LIKE @parm1
	ORDER BY
		FlatCategoryId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
