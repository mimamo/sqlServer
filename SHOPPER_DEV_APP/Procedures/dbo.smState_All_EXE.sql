USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smState_All_EXE]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smState_All_EXE]
		@parm1	varchar(3)
AS
	SELECT
		*
	FROM
		State
	WHERE
		StateProvId LIKE @parm1
	ORDER BY
		StateProvId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
