USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_NoteID]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_NoteID]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM INUnit
	WHERE NoteID BETWEEN @parm1min AND @parm1max
	ORDER BY NoteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
