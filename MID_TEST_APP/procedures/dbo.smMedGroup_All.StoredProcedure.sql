USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smMedGroup_All]    Script Date: 12/21/2015 15:49:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smMedGroup_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		smMedGroup
	WHERE
		MediaGroupId LIKE @parm1
	ORDER BY
		MediaGroupId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
