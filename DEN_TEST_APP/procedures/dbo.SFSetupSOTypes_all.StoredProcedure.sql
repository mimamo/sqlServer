USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SFSetupSOTypes_all]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SFSetupSOTypes_all]
	@parm1 varchar( 2 ),
	@parm2 varchar( 4 )
AS
	SELECT *
	FROM SFSetupSOTypes
	WHERE SetupID LIKE @parm1
	   AND SOTypeID LIKE @parm2
	ORDER BY SetupID,
	   SOTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
