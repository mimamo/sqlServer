USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PODeptAppr_DeptID]    Script Date: 12/21/2015 15:55:39 ******/
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
