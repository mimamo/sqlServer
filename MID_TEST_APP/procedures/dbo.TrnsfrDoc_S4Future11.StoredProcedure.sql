USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_S4Future11]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TrnsfrDoc_S4Future11]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM TrnsfrDoc
	WHERE S4Future11 LIKE @parm1
	ORDER BY S4Future11

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
