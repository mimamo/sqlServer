USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcLocation_All]    Script Date: 12/16/2015 15:55:35 ******/
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
