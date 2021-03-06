USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_KitID_SiteID_KitStat]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Component_KitID_SiteID_KitStat]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 ),
	@parm4 varchar( 30 ),
	@parm5 varchar( 1 )
AS
	SELECT *
	FROM Component
	WHERE KitID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND KitStatus LIKE @parm3
	   AND CmpnentID LIKE @parm4
	   AND Status LIKE @parm5
	ORDER BY KitID,
	   SiteID,
	   KitStatus,
	   CmpnentID,
	   Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
