USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BOMTran_CmpnentID]    Script Date: 12/21/2015 13:56:54 ******/
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
