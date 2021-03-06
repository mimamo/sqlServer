USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TransitTime_all]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TransitTime_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 3 ),
	@parm4 varchar( 3 )
AS
	SELECT *
	FROM TransitTime
	WHERE ShipViaID LIKE @parm1
	   AND SiteID LIKE @parm2
	   AND Country LIKE @parm3
	   AND Zip LIKE @parm4
	ORDER BY ShipViaID,
	   SiteID,
	   Country,
	   Zip

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
