USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_LevelNbr_KitID_SiteID_Stat]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Kit_LevelNbr_KitID_SiteID_Stat]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 30 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 1 )
AS
	SELECT *
	FROM Kit
	WHERE LevelNbr BETWEEN @parm1min AND @parm1max
	   AND KitID LIKE @parm2
	   AND SiteID LIKE @parm3
	   AND Status LIKE @parm4
	ORDER BY LevelNbr,
	   KitID,
	   SiteID,
	   Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
