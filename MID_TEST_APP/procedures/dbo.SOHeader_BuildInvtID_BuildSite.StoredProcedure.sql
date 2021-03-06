USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_BuildInvtID_BuildSite]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_BuildInvtID_BuildSite]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 1 )
AS
	SELECT *
	FROM SOHeader
	WHERE BuildInvtID LIKE @parm1
	   AND BuildSiteID LIKE @parm2
	   AND Status LIKE @parm3
	ORDER BY BuildInvtID,
	   BuildSiteID,
	   Status

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
