USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_SetupID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smProServSetup_SetupID]
		@parm1	varchar(10)
AS
	SELECT 	  *
	FROM 	  smProServSetup (NOLOCK)
	WHERE 	  SetupID LIKE @parm1
	ORDER BY  Setupid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
