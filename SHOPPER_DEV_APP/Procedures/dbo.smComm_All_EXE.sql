USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smComm_All_EXE]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smComm_All_EXE]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smComm
	WHERE
		CommId LIKE @parm1
	ORDER BY
		CommId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
