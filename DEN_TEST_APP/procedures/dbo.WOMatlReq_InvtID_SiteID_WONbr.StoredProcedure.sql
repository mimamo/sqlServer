USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOMatlReq_InvtID_SiteID_WONbr]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOMatlReq_InvtID_SiteID_WONbr]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 16 )
AS
	SELECT *
	FROM WOMatlReq
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND WONbr LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   WONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
