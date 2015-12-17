USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRSetup_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IRSetup_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM IRSetup
	WHERE SetupID LIKE @parm1
	ORDER BY SetupID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
