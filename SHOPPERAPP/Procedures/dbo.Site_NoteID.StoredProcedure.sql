USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Site_NoteID]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Site_NoteID]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM Site
	WHERE NoteID BETWEEN @parm1min AND @parm1max
	ORDER BY NoteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
