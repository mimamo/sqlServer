USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_Terms_All]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_Terms_All]
		@parm1	varchar(2)
AS
	SELECT
		*
	FROM
		Terms
	WHERE
		TermsId LIKE @parm1
	ORDER BY
		TermsId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
