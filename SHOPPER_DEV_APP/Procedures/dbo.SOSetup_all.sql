USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOSetup_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOSetup_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM SOSetup
	WHERE SetupID LIKE @parm1
	ORDER BY SetupID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
