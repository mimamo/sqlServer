USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INCpnyDfltSites_all]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INCpnyDfltSites_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM INCpnyDfltSites (NOLOCK)
	WHERE CpnyID LIKE @parm1
	ORDER BY CpnyID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
