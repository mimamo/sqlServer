USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemAttribs_ClassID_Attrib08]    Script Date: 12/21/2015 16:07:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ItemAttribs_ClassID_Attrib08]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM ItemAttribs
	WHERE ClassID LIKE @parm1
	   AND Attrib08 LIKE @parm2
	ORDER BY ClassID,
	   Attrib08

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
