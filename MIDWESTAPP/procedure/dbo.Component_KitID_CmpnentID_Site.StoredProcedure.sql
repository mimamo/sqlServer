USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Component_KitID_CmpnentID_Site]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Component_KitID_CmpnentID_Site]
	@parm1 varchar( 30 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 1 )
AS
	SELECT *
	FROM Component
	WHERE KitID LIKE @parm1
	   AND CmpnentID LIKE @parm2
	   AND SiteID LIKE @parm3
	   AND Status LIKE @parm4
	ORDER BY KitID,
	   CmpnentID,
	   SiteID,
	   Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
