USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smJobBoard_ServiceCallId]    Script Date: 12/21/2015 14:17:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smJobBoard_ServiceCallId]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smJobBoard
	WHERE
		ServiceCallID LIKE @parm1
	ORDER BY
		ServiceCallID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
