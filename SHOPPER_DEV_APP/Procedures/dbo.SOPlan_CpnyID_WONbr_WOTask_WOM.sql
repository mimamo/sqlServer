USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPlan_CpnyID_WONbr_WOTask_WOM]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPlan_CpnyID_WONbr_WOTask_WOM]
	@parm1 varchar( 10 ),
	@parm2 varchar( 16 ),
	@parm3 varchar( 32 ),
	@parm4 varchar( 5 ),
	@parm5 varchar( 5 )
AS
	SELECT *
	FROM SOPlan
	WHERE CpnyID LIKE @parm1
	   AND WONbr LIKE @parm2
	   AND WOTask LIKE @parm3
	   AND WOMRLineRef LIKE @parm4
	   AND WOBTLineRef LIKE @parm5
	ORDER BY CpnyID,
	   WONbr,
	   WOTask,
	   WOMRLineRef,
	   WOBTLineRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
