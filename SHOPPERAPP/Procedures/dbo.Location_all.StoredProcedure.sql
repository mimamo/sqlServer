USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Location_all]    Script Date: 12/21/2015 16:13:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Location_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM Location
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND WhseLoc LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   WhseLoc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
