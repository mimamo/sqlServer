USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LocTable_all]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LocTable_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM LocTable
	WHERE SiteID LIKE @parm1
	   AND WhseLoc LIKE @parm2
	ORDER BY SiteID,
	   WhseLoc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
