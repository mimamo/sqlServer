USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smArea_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smArea_All]
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
