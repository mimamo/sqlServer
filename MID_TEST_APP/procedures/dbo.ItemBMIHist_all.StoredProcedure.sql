USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemBMIHist_all]    Script Date: 12/21/2015 15:49:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemBMIHist_all]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 4 )
AS
	SELECT *
	FROM ItemBMIHist
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND FiscYr LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   FiscYr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
