USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smCLimHeader_PlanID]    Script Date: 12/21/2015 16:13:25 ******/
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
