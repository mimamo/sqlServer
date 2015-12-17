USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smEmpSkill_All]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smEmpSkill_All]
	@parm1 varchar(10)
	,@parm2 varchar(10)
AS
SELECT *
FROM smEmpSkill
	left outer join smSkills
		on smempskill.employeeskillskill = smSkills.SkillsID
WHERE EmployeeSkillEmpId = @parm1
	AND EmployeeSkillSkill LIKE @parm2
ORDER BY EmployeeSkillEmpId
	,EmployeeSkillSkill
GO
