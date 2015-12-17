USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PODeptAppr_DeptID]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PODeptAppr_DeptID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM PODeptAppr
	WHERE DeptID LIKE @parm1
	ORDER BY DeptID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
