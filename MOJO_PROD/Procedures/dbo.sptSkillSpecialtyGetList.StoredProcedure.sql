USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillSpecialtyGetList]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillSpecialtyGetList]
	@SkillKey int

AS --Encrypt

	SELECT *
	FROM tSkillSpecialty (NOLOCK) 
	WHERE
		SkillKey = @SkillKey
	ORDER BY
		SpecialtyName

	RETURN 1
GO
