USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkComponent_all]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WrkComponent_all]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM WrkComponent
	WHERE CmpnentID LIKE @parm1
	ORDER BY CmpnentID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
