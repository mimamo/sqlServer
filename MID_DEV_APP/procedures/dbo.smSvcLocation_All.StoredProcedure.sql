USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcLocation_All]    Script Date: 12/21/2015 14:17:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcLocation_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcLocation
	WHERE
		LocationCode LIKE @parm1
	ORDER BY
		LocationCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
