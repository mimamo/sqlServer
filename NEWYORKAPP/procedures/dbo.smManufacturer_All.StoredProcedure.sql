USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smManufacturer_All]    Script Date: 12/21/2015 16:01:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smManufacturer_All]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smManufacturer
	WHERE
		ManufId LIKE @parm1
	ORDER BY
		ManufId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
