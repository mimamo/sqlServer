USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillInsert]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillInsert]
	@UserKey int,
	@SkillKey int,
	@Rating int,
	@Description varchar(1000),
	@oIdentity INT OUTPUT
AS --Encrypt

	IF EXISTS(
		SELECT 1 FROM tUserSkill (NOLOCK)
		WHERE 
			UserKey = @UserKey AND
			SkillKey = @SkillKey)
		RETURN -1
		

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
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
