USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[UserSlsper_all]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[UserSlsper_all]
	@parm1 varchar( 47 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM UserSlsper
	WHERE UserID LIKE @parm1
	   AND SlsperID LIKE @parm2
	ORDER BY UserID,
	   SlsperID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
