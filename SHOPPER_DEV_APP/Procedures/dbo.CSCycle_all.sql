USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CSCycle_all]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSCycle_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM CSCycle
	WHERE CycleID LIKE @parm1
	ORDER BY CycleID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
