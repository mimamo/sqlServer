USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smFlatRate_All_EXE]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smFlatRate_All_EXE]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smFlatRate
	WHERE
		FlatRateId LIKE @parm1
	ORDER BY
		FlatRateId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
