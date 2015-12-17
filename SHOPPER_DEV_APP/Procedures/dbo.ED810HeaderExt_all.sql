USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810HeaderExt_all]    Script Date: 12/16/2015 15:55:19 ******/
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
