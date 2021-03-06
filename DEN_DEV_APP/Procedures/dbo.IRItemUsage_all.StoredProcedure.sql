USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRItemUsage_all]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRItemUsage_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 6 )
AS
	SELECT *
	FROM IRItemUsage
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND Period LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   Period

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
