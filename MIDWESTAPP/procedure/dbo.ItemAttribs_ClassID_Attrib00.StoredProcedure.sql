USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemAttribs_ClassID_Attrib00]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemAttribs_ClassID_Attrib00]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM ItemAttribs
	WHERE ClassID LIKE @parm1
	   AND Attrib00 LIKE @parm2
	ORDER BY ClassID,
	   Attrib00

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
