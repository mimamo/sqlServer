USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Site_CpnyID_SiteId]    Script Date: 12/21/2015 16:01:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Site_CpnyID_SiteId]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM Site
	WHERE CpnyID LIKE @parm1
	   AND SiteId LIKE @parm2
	ORDER BY CpnyID,
	   SiteId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
