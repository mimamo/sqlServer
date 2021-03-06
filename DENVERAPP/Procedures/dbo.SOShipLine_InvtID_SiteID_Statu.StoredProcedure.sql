USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipLine_InvtID_SiteID_Statu]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipLine_InvtID_SiteID_Statu]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 )
AS
	SELECT *
	FROM SOShipLine
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND Status LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
