USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smBRZone_Possible_Zone]    Script Date: 12/21/2015 16:01:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smBRZone_Possible_Zone]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smArea
	WHERE
		AreaId not in (SELECT ZoneID FROM smBRZone)
			AND
		AreaId LIKE @parm1
	ORDER BY
		AreaId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
