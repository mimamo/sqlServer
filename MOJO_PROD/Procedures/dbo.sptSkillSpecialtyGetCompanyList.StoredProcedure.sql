USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillSpecialtyGetCompanyList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillSpecialtyGetCompanyList]
	@CompanyKey int

AS --Encrypt

	SELECT tSkillSpecialty.*
	FROM tSkillSpecialty (NOLOCK) 
		inner join tSkill (NOLOCK) on tSkill.SkillKey = tSkillSpecialty.SkillKey
	WHERE
		tSkill.CompanyKey = @CompanyKey
	ORDER BY
		tSkillSpecialty.SkillKey, SpecialtyName

	RETURN 1
GO
