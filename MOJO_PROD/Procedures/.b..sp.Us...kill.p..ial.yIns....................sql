USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillSpecialtyInsert]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillSpecialtyInsert]
	@UserKey int,
	@SkillSpecialtyKey int,
	@Rating int,
	@Description varchar(1000),
	@oIdentity INT OUTPUT
AS --Encrypt

	IF EXISTS(
		SELECT 1 FROM tUserSkillSpecialty (NOLOCK)
		WHERE
			UserKey = @UserKey AND
			SkillSpecialtyKey = @SkillSpecialtyKey)
		RETURN -1

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
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
