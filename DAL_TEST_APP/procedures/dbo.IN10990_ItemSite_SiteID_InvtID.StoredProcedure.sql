USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_ItemSite_SiteID_InvtID]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_ItemSite_SiteID_InvtID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM IN10990_ItemSite
	WHERE SiteID LIKE @parm1
	   AND InvtID LIKE @parm2
	ORDER BY SiteID,
	   InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
