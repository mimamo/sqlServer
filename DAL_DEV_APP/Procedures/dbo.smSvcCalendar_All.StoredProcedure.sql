USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSvcCalendar_All]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSvcCalendar_All]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smSvcCalendar
	WHERE
		CalendarCode LIKE @parm1
	ORDER BY
		CalendarCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
