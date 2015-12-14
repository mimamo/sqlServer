USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillGetUserSkills]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptSkillGetUserSkills]

	(
		@UserKey int
	)

AS --Encrypt

SELECT 
	tSkill.SkillKey, 
	tSkill.SkillName, 
	tUserSkill.Rating, 
    tUserSkill.Description
FROM tSkill (NOLOCK) INNER JOIN
    tUserSkill (NOLOCK) ON tSkill.SkillKey = tUserSkill.SkillKey 
WHERE 
	tUserSkill.UserKey = @UserKey
ORDER BY
	tUserSkill.Rating DESC
GO
