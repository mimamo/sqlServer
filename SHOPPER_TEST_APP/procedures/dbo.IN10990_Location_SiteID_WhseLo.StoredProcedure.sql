USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_Location_SiteID_WhseLo]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_Location_SiteID_WhseLo]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM IN10990_Location
	WHERE SiteID LIKE @parm1
	   AND WhseLoc LIKE @parm2
	ORDER BY SiteID,
	   WhseLoc

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
