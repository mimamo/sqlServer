USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRWrkPeriod_all]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRWrkPeriod_all]
	@parm1 varchar( 6 ),
	@parm2 varchar( 6 )
AS
	SELECT *
	FROM IRWrkPeriod
	WHERE CurrentPeriod LIKE @parm1
	   AND Period LIKE @parm2
	ORDER BY CurrentPeriod,
	   Period

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
