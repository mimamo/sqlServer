USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smFlatSubCategory_Cat]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smFlatSubCategory_Cat]
		@parm1 varchar(10)
		,@parm2 varchar(10)
AS
	SELECT
		*
	FROM
		smFlatSubCategory
	WHERE
		FlatSubCategoryCatId = @parm1
			AND
		FlatSubCategoryId LIKE @parm2
	ORDER BY
	FlatSubCategoryCatId
	,FlatSubCategoryId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
