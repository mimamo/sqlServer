USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smCommSpecial_All]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCommSpecial_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smCommSpecial
	WHERE
		CommSpecId LIKE @parm1
	ORDER BY
		CommSpecId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
