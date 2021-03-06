USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillSpecialtyGetList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillSpecialtyGetList]
	@SkillKey int,
	@UserKey int

AS --Encrypt

	SELECT 
		tSkillSpecialty.SpecialtyName, 
		tUserSkillSpecialty.Rating, 
		tSkillSpecialty.SkillKey, 
		tUserSkillSpecialty.UserKey,
		tUserSkillSpecialty.UserSkillSpecialtyKey
	FROM 
		tUserSkillSpecialty (NOLOCK) INNER JOIN tSkillSpecialty (NOLOCK) ON 
		tUserSkillSpecialty.SkillSpecialtyKey = tSkillSpecialty.SkillSpecialtyKey
	WHERE 
		tSkillSpecialty.SkillKey = @SkillKey AND
		tUserSkillSpecialty.UserKey = @UserKey
	ORDER BY tSkillSpecialty.SpecialtyName

	RETURN 1
GO
