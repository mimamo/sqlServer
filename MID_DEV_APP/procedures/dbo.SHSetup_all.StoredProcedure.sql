USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SHSetup_all]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SHSetup_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM SHSetup
	WHERE SetupID LIKE @parm1
	ORDER BY SetupID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
