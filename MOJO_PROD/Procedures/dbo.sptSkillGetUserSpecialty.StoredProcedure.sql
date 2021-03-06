USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillGetUserSpecialty]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSkillGetUserSpecialty]

	(
		@UserKey int
	)

AS --Encrypt

SELECT 
	tSkillSpecialty.SkillSpecialtyKey, 
	tSkillSpecialty.SkillKey,
    tSkillSpecialty.SpecialtyName, 
    tUserSkillSpecialty.Rating, 
    tUserSkillSpecialty.Description
FROM tSkillSpecialty (NOLOCK) INNER JOIN tUserSkillSpecialty (NOLOCK) ON 
    tSkillSpecialty.SkillSpecialtyKey = tUserSkillSpecialty.SkillSpecialtyKey
WHERE 
	tUserSkillSpecialty.UserKey = @UserKey
ORDER BY 
	tUserSkillSpecialty.Rating DESC, 
    tSkillSpecialty.SpecialtyName
GO
