USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_Check_InvtID_SiteID_Wh]    Script Date: 12/21/2015 13:57:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_Check_InvtID_SiteID_Wh]
	@parm1 varchar( 30 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM IN10990_Check
	WHERE InvtID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND WhseLoc LIKE @parm3
	ORDER BY InvtID,
	   SiteID,
	   WhseLoc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
