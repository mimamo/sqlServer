USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipReducedQty_all]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipReducedQty_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM SOShipReducedQty
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	ORDER BY InvtID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
