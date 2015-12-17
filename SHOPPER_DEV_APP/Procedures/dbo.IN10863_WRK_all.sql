USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10863_WRK_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10863_WRK_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 30 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM IN10863_WRK
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND InvtID LIKE @parm2
	   AND SiteID LIKE @parm3
	ORDER BY RI_ID,
	   InvtID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
