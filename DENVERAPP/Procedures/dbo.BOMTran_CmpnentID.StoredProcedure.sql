USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_CmpnentID]    Script Date: 12/21/2015 15:42:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BOMTran_CmpnentID]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM BOMTran
	WHERE CmpnentID LIKE @parm1
	ORDER BY CmpnentID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
