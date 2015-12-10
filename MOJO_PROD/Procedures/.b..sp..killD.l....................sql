USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillDelete]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillDelete]
	@SkillKey int

AS --Encrypt

	IF Exists(Select 1 from tSkillSpecialty (NOLOCK) Where SkillKey = @SkillKey)
		Return -1

	IF Exists(Select 1 from tUserSkill (NOLOCK) Where SkillKey = @SkillKey)
		Return -2

	DELETE
	FROM tSkill
	WHERE
		SkillKey = @SkillKey 

	RETURN 1
GO
