USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_ToUnit]    Script Date: 12/21/2015 14:34:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_ToUnit]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM INUnit
	WHERE ToUnit LIKE @parm1
	ORDER BY ToUnit

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
