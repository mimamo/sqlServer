USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillGetListForGrid]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillGetListForGrid]
	@CompanyKey int

AS --Encrypt

	SELECT	s.SkillKey, s.SkillName, ss.SkillSpecialtyKey, ss.SpecialtyName
	FROM	tSkill s (NOLOCK) 
	LEFT JOIN tSkillSpecialty ss (NOLOCK) ON s.SkillKey = ss.SkillKey
	WHERE s.CompanyKey = @CompanyKey
	order by SkillName

	RETURN 1
GO
