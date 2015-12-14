USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillGet]
	@SkillKey int

AS --Encrypt

	SELECT *
	FROM tSkill (NOLOCK) 
	WHERE
		SkillKey = @SkillKey

	RETURN 1
GO
