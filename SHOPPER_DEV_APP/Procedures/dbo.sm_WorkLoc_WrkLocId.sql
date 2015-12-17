USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_WorkLoc_WrkLocId]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_WorkLoc_WrkLocId]
		@parm1 varchar(6)
AS
	SELECT
		*
	FROM
		WorkLoc
	WHERE
		WrkLocId LIKE @parm1
	ORDER BY
		WrkLocId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
