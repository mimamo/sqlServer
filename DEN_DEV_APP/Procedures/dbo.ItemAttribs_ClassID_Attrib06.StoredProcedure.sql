USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemAttribs_ClassID_Attrib06]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemAttribs_ClassID_Attrib06]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM ItemAttribs
	WHERE ClassID LIKE @parm1
	   AND Attrib06 LIKE @parm2
	ORDER BY ClassID,
	   Attrib06

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
