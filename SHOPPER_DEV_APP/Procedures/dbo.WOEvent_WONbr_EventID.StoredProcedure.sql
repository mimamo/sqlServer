USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOEvent_WONbr_EventID]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOEvent_WONbr_EventID]
	@parm1 varchar( 16 ),
	@parm2min int, @parm2max int
AS
	SELECT *
	FROM WOEvent
	WHERE WONbr LIKE @parm1
	   AND EventID BETWEEN @parm2min AND @parm2max
	ORDER BY WONbr,
	   EventID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
