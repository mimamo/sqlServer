USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServSkills_ServCallId]    Script Date: 12/21/2015 14:06:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smServSkills_ServCallId]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smServSkills
	left outer join smSkills
		on smServSkills.SkillsID = smSkills.SkillsID
WHERE ServiceCallId = @parm1
	AND smServSkills.SkillsID LIKE @parm2
ORDER BY smServSkills.ServiceCallId
	,smServSkills.SkillsID
GO
