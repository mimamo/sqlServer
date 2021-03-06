USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillGet]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillGet]
	@UserSkillKey int

AS --Encrypt

	SELECT tUserSkill.*, tSkill.SkillName
	FROM tUserSkill (NOLOCK)
		INNER JOIN tSkill (NOLOCK) on tUserSkill.SkillKey = tSkill.SkillKey
	WHERE
		UserSkillKey = @UserSkillKey

	RETURN 1
GO
