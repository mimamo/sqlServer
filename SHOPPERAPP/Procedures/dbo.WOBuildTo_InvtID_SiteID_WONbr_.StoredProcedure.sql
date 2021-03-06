USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOBuildTo_InvtID_SiteID_WONbr_]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOBuildTo_InvtID_SiteID_WONbr_]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 16 ),
	@parm4 varchar( 1 )
AS
	SELECT *
	FROM WOBuildTo
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND WONbr LIKE @parm3
	   AND Status LIKE @parm4
	ORDER BY InvtID,
	   SiteID,
	   WONbr,
	   Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
