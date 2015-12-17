USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WCGroupSite_all]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WCGroupSite_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM WCGroupSite
	WHERE UserGroupID LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY UserGroupID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
