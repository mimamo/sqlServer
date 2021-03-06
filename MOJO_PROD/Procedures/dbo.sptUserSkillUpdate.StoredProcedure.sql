USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillUpdate]
	@UserKey int,
	@SkillKey int,
	@Rating int,
	@Description varchar(1000),
	@Selected tinyint = 1

AS --Encrypt


/*
|| When     Who Rel       What
|| 12/11/09 GWG 10.5.1.5  Defaulted @Selected = 1 for compatibility with old routine
*/

if @Selected = 1
BEGIN
	IF EXISTS(
		SELECT 1 FROM tUserSkill (NOLOCK)
		WHERE UserKey = @UserKey AND SkillKey = @SkillKey)

		UPDATE
			tUserSkill
		SET
			Rating = @Rating,
			Description = @Description
		WHERE
			UserKey = @UserKey and
			SkillKey = @SkillKey
	ELSE
		INSERT tUserSkill
			(
			UserKey,
			SkillKey,
			Rating,
			Description
			)

		VALUES
			(
			@UserKey,
			@SkillKey,
			@Rating,
			@Description
			)
END
ELSE
BEGIN
	DELETE tUserSkillSpecialty Where UserKey = @UserKey and SkillSpecialtyKey in (Select SkillSpecialtyKey from tSkillSpecialty (nolock) Where SkillKey = @SkillKey)
	DELETE tUserSkill WHERE UserKey = @UserKey  AND SkillKey = @SkillKey

END

RETURN 1
GO
