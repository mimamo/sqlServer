USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smCodeSkill_All]    Script Date: 12/21/2015 16:07:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smCodeSkill_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smCodeSkills
	left outer join smSkills
		on smCodeSkills.FaultSkillsSkillID = smSkills.SkillsID
WHERE FaultSkillsId = @parm1
	AND FaultSkillsSkillID LIKE @parm2
ORDER BY FaultSkillsId, FaultSkillsSkillId
GO
