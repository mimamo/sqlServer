USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillGetListForGrid]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillGetListForGrid]
	@UserKey int

AS --Encrypt

	SELECT	us.UserSkillKey, s.SkillKey, s.SkillName, Sepcialty.UserSkillSpecialtyKey, Sepcialty.SpecialtyName
	FROM	tUserSkill us (NOLOCK)
	INNER JOIN tSkill s (NOLOCK) ON us.SkillKey = s.SkillKey
	LEFT JOIN 
		(SELECT uss.*, ss.SkillKey, ss.SpecialtyName 
		FROM 	tUserSkillSpecialty uss (NOLOCK)
		INNER JOIN tSkillSpecialty ss (NOLOCK) ON uss.SkillSpecialtyKey = ss.SkillSpecialtyKey
		WHERE uss.UserKey = @UserKey) AS Sepcialty ON us.SkillKey = Sepcialty.SkillKey
	WHERE us.UserKey = @UserKey


	RETURN 1
GO
