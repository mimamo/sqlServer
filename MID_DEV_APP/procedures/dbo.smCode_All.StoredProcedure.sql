USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCode_All]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smCode_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smCode
	WHERE
		Fault_Id LIKE @parm1
	ORDER BY
		Fault_Id

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
