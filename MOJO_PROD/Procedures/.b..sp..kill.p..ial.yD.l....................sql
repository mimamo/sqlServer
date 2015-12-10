USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillSpecialtyDelete]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillSpecialtyDelete]
	@SkillSpecialtyKey int

AS --Encrypt

	IF Exists(Select 1 from tUserSkillSpecialty (NOLOCK) Where SkillSpecialtyKey = @SkillSpecialtyKey)
		Return -1

	DELETE
	FROM tSkillSpecialty
	WHERE
		SkillSpecialtyKey = @SkillSpecialtyKey 

	RETURN 1
GO
