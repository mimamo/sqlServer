USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Component_CmpnentID_KitStatus]    Script Date: 12/21/2015 16:06:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Component_CmpnentID_KitStatus]
	@parm1 varchar( 30 ),
	@parm2 varchar( 1 )
AS
	SELECT *
	FROM Component
	WHERE CmpnentID LIKE @parm1
	   AND KitStatus LIKE @parm2
	ORDER BY CmpnentID,
	   KitStatus

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
