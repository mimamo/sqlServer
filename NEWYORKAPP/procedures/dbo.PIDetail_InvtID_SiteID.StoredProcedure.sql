USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_InvtID_SiteID]    Script Date: 12/21/2015 16:01:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIDetail_InvtID_SiteID]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM PIDetail
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY InvtID,
	   SiteID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
