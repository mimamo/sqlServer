USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PIHeader_Status]    Script Date: 12/21/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIHeader_Status]
	@parm1 varchar( 1 )
AS
	SELECT *
	FROM PIHeader
	WHERE Status LIKE @parm1
	ORDER BY Status

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
