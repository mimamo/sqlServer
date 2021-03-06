USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[INUpdateQty_Wrk_all]    Script Date: 12/21/2015 13:44:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUpdateQty_Wrk_all]
	@parm1 varchar( 21 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM INUpdateQty_Wrk
	WHERE ComputerName LIKE @parm1
	   AND InvtID LIKE @parm2
	   AND SiteID LIKE @parm3
	ORDER BY ComputerName,
	   InvtID,
	   SiteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
