USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ANSetup_all]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ANSetup_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM ANSetup
	WHERE SetupID LIKE @parm1
	ORDER BY SetupID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
