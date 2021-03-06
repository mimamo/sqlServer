USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserSkillGetCompanyList]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserSkillGetCompanyList]

	(
		@CompanyKey int
	)

AS --Encrypt

Select 
	us.UserKey,
	us.SkillKey
from tUserSkill us (nolock)
Inner Join tSkill s (nolock) on us.SkillKey = s.SkillKey
Where
	s.CompanyKey = @CompanyKey
GO
