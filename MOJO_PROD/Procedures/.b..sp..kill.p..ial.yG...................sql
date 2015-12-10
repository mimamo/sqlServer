USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillSpecialtyGet]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillSpecialtyGet]
	@SkillSpecialtyKey int

AS --Encrypt

	SELECT *
	FROM tSkillSpecialty (NOLOCK) 
	WHERE
		SkillSpecialtyKey = @SkillSpecialtyKey

	RETURN 1
GO
