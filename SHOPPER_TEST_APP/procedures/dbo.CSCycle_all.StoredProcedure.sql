USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CSCycle_all]    Script Date: 12/21/2015 16:06:59 ******/
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
