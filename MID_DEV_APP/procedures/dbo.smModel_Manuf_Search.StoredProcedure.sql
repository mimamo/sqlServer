USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smModel_Manuf_Search]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smModel_Manuf_Search]
		@parm1	varchar(10)
		,@parm2 varchar(40)
AS
	SELECT
		*
	FROM
		smModel
	WHERE
		ManufId  LIKE @parm1
			AND
		ModelID LIKE @parm2
	ORDER BY
		ManufId
		,ModelID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
