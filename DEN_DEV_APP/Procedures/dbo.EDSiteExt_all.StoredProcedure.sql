USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSiteExt_all]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSiteExt_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM EDSiteExt
	WHERE SiteID LIKE @parm1
	ORDER BY SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
