USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TaskSchedule_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TaskSchedule_all]
	@parm1min smallint, @parm1max smallint
AS
	SELECT *
	FROM TaskSchedule
	WHERE LineNbr BETWEEN @parm1min AND @parm1max
	ORDER BY LineNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
