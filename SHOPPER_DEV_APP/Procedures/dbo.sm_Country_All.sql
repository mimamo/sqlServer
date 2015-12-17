USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Country_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Country_All]
		@parm1 	varchar(3)
AS
	SELECT
		*
	FROM
		Country
	WHERE
		CountryId LIKE @parm1
	ORDER BY
		CountryId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
