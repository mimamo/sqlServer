USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CSDetail_all]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSDetail_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM CSDetail
	WHERE StmntID LIKE @parm1
	   AND TranRef LIKE @parm2
	   AND LineRef LIKE @parm3
	ORDER BY StmntID,
	   TranRef,
	   LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
