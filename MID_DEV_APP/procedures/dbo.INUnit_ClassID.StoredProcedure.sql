USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_ClassID]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_ClassID]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM INUnit
	WHERE ClassID LIKE @parm1
	ORDER BY ClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
