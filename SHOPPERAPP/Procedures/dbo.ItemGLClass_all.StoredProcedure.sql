USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemGLClass_all]    Script Date: 12/21/2015 16:13:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemGLClass_all]
	@parm1 varchar( 4 )
AS
	SELECT *
	FROM ItemGLClass
	WHERE GLClassID LIKE @parm1
	ORDER BY GLClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
