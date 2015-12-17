USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCLimHeader_PlanID]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCLimHeader_PlanID]
		@parm1	varchar(10)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smCLimHeader
	WHERE
		CommPlanID = @parm1
	   		AND
	   	CommTypeID LIKE @parm2
	ORDER BY
		CommPlanID
		,CommTypeID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
