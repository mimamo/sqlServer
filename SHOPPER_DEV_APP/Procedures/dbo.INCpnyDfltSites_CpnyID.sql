USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INCpnyDfltSites_CpnyID]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INCpnyDfltSites_CpnyID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM INCpnyDfltSites
	WHERE CpnyID LIKE @parm1
	ORDER BY CpnyID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
