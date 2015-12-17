USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smJobConfig_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smJobConfig_All]
		@parm1 	varchar(10)
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
