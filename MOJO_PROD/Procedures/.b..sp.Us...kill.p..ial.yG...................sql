USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillSpecialtyGet]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillSpecialtyGet]
	@UserSkillSpecialtyKey int

AS --Encrypt

	SELECT *
	FROM tUserSkillSpecialty (NOLOCK)
	WHERE
		UserSkillSpecialtyKey = @UserSkillSpecialtyKey

	RETURN 1
GO
