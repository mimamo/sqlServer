USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRFiscWrkDays_all]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRFiscWrkDays_all]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM IRFiscWrkDays
	WHERE Period LIKE @parm1
	ORDER BY Period

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
