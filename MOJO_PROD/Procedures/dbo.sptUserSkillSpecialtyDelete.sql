USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillSpecialtyDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserSkillSpecialtyDelete]
	@UserSkillSpecialtyKey int

AS --Encrypt

	DELETE
	FROM tUserSkillSpecialty
	WHERE
		UserSkillSpecialtyKey = @UserSkillSpecialtyKey 

	RETURN 1
GO
