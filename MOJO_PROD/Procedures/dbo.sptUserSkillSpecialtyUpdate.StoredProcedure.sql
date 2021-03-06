USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillSpecialtyUpdate]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillSpecialtyUpdate]
	@UserKey int,
	@SkillSpecialtyKey int,
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
		SELECT 1 FROM tUserSkillSpecialty (NOLOCK)
		WHERE
			UserKey = @UserKey AND SkillSpecialtyKey = @SkillSpecialtyKey )

		UPDATE
			tUserSkillSpecialty
		SET
			Rating = @Rating,
			Description = @Description
		WHERE
			UserKey = @UserKey and SkillSpecialtyKey = @SkillSpecialtyKey

	ELSE

		INSERT tUserSkillSpecialty
			(
			UserKey,
			SkillSpecialtyKey,
			Rating,
			Description
			)

		VALUES
			(
			@UserKey,
			@SkillSpecialtyKey,
			@Rating,
			@Description
			)

END
ELSE
BEGIN
	DELETE tUserSkillSpecialty WHERE UserKey = @UserKey and SkillSpecialtyKey = @SkillSpecialtyKey

END
GO
