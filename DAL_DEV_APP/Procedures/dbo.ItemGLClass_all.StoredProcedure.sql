USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemGLClass_all]    Script Date: 12/21/2015 13:35:45 ******/
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
