USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CSCalendar_all]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSCalendar_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 6 )
AS
	SELECT *
	FROM CSCalendar
	WHERE CycleID LIKE @parm1
	   AND CommPerNbr LIKE @parm2
	ORDER BY CycleID,
	   CommPerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
