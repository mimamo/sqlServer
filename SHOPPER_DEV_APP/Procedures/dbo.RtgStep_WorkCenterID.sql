USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_WorkCenterID]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[RtgStep_WorkCenterID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM RtgStep
	WHERE WorkCenterID LIKE @parm1
	ORDER BY WorkCenterID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
