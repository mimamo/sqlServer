USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillGetList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillGetList]
	@UserKey int

AS --Encrypt

	SELECT 
		tUserSkill.UserSkillKey, 
		tSkill.SkillName, 
		tUserSkill.Rating
	FROM 
		tUserSkill (NOLOCK) INNER JOIN tSkill (NOLOCK) ON tUserSkill.SkillKey = tSkill.SkillKey
	WHERE
		UserKey = @UserKey
	ORDER BY 
		tSkill.SkillName

	RETURN 1
GO
