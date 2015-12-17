USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSkills_All]    Script Date: 12/16/2015 15:55:35 ******/
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
