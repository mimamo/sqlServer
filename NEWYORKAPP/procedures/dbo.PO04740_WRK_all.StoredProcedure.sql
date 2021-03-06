USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PO04740_WRK_all]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PO04740_WRK_all]
	@parm1min smallint, @parm1max smallint,
	@parm2 varchar( 30 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM PO04740_WRK
	WHERE RI_ID BETWEEN @parm1min AND @parm1max
	   AND InvtID LIKE @parm2
	   AND SiteID LIKE @parm3
	ORDER BY RI_ID,
	   InvtID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
