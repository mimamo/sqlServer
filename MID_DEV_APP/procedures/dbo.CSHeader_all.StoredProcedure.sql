USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CSHeader_all]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CSHeader_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 5 )
AS
	SELECT *
	FROM CSHeader
	WHERE StmntID LIKE @parm1
	   AND TranRef LIKE @parm2
	ORDER BY StmntID,
	   TranRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
