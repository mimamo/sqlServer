USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemGLClass_All]    Script Date: 12/21/2015 16:12:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ItemGLClass_All]
	@GLClassID varchar(4)
AS
	SELECT *
	FROM ItemGLClass
	WHERE GLClassID LIKE @GLClassID
	ORDER BY GLClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
