USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BCSetup_all]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BCSetup_all]
	@parm1 varchar( 1 )
AS
	SELECT *
	FROM BCSetup
	WHERE SetupID LIKE @parm1
	ORDER BY SetupID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
