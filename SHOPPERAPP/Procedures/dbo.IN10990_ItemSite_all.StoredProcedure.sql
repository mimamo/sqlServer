USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_ItemSite_all]    Script Date: 12/21/2015 16:13:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_ItemSite_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM IN10990_ItemSite
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY InvtID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
