USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smEscHeader_All]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smEscHeader_All]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smEscHeader
	WHERE
		EscalationCode LIKE @parm1
	ORDER BY
		EscalationCode

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
