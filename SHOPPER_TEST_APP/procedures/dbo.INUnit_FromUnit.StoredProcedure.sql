USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_FromUnit]    Script Date: 12/21/2015 16:07:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_FromUnit]
	@parm1 varchar( 6 )
AS
	SELECT *
	FROM INUnit
	WHERE FromUnit LIKE @parm1
	ORDER BY FromUnit

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
