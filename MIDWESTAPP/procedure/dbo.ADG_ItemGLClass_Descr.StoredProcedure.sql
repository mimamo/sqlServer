USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ItemGLClass_Descr]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ItemGLClass_Descr]
	@GLClassID varchar(4)
AS
	SELECT Descr
	FROM ItemGLClass
	WHERE GLClassID LIKE @GLClassID
	ORDER BY GLClassID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
