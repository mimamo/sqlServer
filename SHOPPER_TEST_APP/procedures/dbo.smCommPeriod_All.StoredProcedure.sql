USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCommPeriod_All]    Script Date: 12/21/2015 16:07:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCommPeriod_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smCommPeriod
	WHERE
		CommPeriodID LIKE @parm1
	ORDER BY
		CommPeriodID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
