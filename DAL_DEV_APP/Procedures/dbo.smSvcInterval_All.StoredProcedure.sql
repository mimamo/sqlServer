USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcInterval_All]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcInterval_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcInterval
	WHERE
		IntervalCode LIKE @parm1
	ORDER BY
		IntervalCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
