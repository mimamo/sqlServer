USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemAttribs_all]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemAttribs_all]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM ItemAttribs
	WHERE InvtID LIKE @parm1
	ORDER BY InvtID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
