USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INUnit_InvtId]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INUnit_InvtId]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM INUnit
	WHERE InvtId LIKE @parm1
	ORDER BY InvtId

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
