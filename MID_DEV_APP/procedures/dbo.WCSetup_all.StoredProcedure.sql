USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WCSetup_all]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WCSetup_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM WCSetup
	WHERE CpnyID LIKE @parm1
	ORDER BY CpnyID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
