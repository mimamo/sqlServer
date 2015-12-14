USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillDelete]
	@UserKey int,
	@SkillKey int

AS --Encrypt

	IF EXISTS(
	SELECT 1 FROM tUserSkillSpecialty (NOLOCK) INNER JOIN
    	tSkillSpecialty (NOLOCK) ON tUserSkillSpecialty.SkillSpecialtyKey = tSkillSpecialty.SkillSpecialtyKey
	WHERE 
		tSkillSpecialty.SkillKey = @SkillKey AND
		tUserSkillSpecialty.UserKey = @UserKey)
		RETURN -1

	DELETE
	FROM tUserSkill
	WHERE
		UserKey = @UserKey  AND
		SkillKey = @SkillKey

	RETURN 1
GO
