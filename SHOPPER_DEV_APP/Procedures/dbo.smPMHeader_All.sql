USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smPMHeader_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smPMHeader_All]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smPMHeader
	WHERE
		PMType LIKE @parm1
	ORDER BY
		PMtype

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
