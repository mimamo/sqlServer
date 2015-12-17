USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SFSetupCury_all]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SFSetupCury_all]
	@parm1 varchar( 2 ),
	@parm2 varchar( 4 )
AS
	SELECT *
	FROM SFSetupCury
	WHERE SetupID LIKE @parm1
	   AND CuryID LIKE @parm2
	ORDER BY SetupID,
	   CuryID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
