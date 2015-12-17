USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIHeader_NoteID]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIHeader_NoteID]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM PIHeader
	WHERE NoteID BETWEEN @parm1min AND @parm1max
	ORDER BY NoteID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
