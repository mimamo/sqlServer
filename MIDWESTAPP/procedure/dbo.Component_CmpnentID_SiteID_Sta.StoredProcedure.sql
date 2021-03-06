USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Component_CmpnentID_SiteID_Sta]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Component_CmpnentID_SiteID_Sta]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4 varchar( 1 )
AS
	SELECT *
	FROM Component
	WHERE CmpnentID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND Status LIKE @parm3
	   AND KitStatus LIKE @parm4
	ORDER BY CmpnentID,
	   SiteID,
	   Status,
	   KitStatus

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
