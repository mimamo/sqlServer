USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSkillGetList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSkillGetList]
	@CompanyKey int

AS --Encrypt

	SELECT *
	FROM tSkill (NOLOCK) 
	WHERE
		CompanyKey = @CompanyKey
	ORDER BY
		SkillName
	RETURN 1
GO
