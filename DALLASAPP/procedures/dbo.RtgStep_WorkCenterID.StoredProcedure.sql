USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[RtgStep_WorkCenterID]    Script Date: 12/21/2015 13:45:05 ******/
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
