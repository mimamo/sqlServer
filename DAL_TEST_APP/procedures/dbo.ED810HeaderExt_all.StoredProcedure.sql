USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810HeaderExt_all]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED810HeaderExt_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM ED810HeaderExt
	WHERE CpnyID LIKE @parm1
	   AND EDIInvID LIKE @parm2
	ORDER BY CpnyID,
	   EDIInvID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
