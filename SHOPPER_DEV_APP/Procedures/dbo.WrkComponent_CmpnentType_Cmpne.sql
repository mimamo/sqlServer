USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkComponent_CmpnentType_Cmpne]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WrkComponent_CmpnentType_Cmpne]
	@parm1 varchar( 1 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM WrkComponent
	WHERE CmpnentType LIKE @parm1
	   AND CmpnentID LIKE @parm2
	ORDER BY CmpnentType,
	   CmpnentID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
