USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOReducedQty_all]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOReducedQty_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM SOReducedQty
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY InvtID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
