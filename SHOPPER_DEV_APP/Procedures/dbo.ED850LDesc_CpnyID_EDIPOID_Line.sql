USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_CpnyID_EDIPOID_Line]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LDesc_CpnyID_EDIPOID_Line]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3min int, @parm3max int
AS
	SELECT *
	FROM ED850LDesc
	WHERE CpnyID LIKE @parm1
	   AND EDIPOID LIKE @parm2
	   AND LineID BETWEEN @parm3min AND @parm3max
	ORDER BY CpnyID,
	   EDIPOID,
	   LineID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
