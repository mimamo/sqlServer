USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POProjAuth_Project]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POProjAuth_Project]
	@parm1 varchar( 16 )
AS
	SELECT *
	FROM POProjAuth
	WHERE Project LIKE @parm1
	ORDER BY Project

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
