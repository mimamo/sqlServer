USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSkills_All]    Script Date: 12/21/2015 14:17:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSkills_All]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		smSkills
	WHERE
		SkillsId LIKE @parm1
	ORDER BY
		SkillsId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
