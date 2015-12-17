USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ProcessControl_all]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ProcessControl_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM ProcessControl
	WHERE ControlID LIKE @parm1
	ORDER BY ControlID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
