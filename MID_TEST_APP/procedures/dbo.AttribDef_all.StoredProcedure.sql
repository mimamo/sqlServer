USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[AttribDef_all]    Script Date: 12/21/2015 15:49:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[AttribDef_all]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM AttribDef
	WHERE ClassID LIKE @parm1
	ORDER BY ClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
