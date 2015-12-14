USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppStringGet]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppStringGet]
(
	@ActionID varchar(50),
	@LangID as varchar(10)
)

as


/*
Select @LangID = ISNULL(ISNULL(u.LanguageID, p.LanguageID), 'EN')
From tUser u (nolock)
inner join tPreference p (nolock) on ISNULL(u.OwnerCompanyKey, u.CompanyKey) = p.CompanyKey
Where u.UserKey = @UserKey

*/
Select astr.StringKey, Case @LangID 
	When 'EN' then astr.EN
	When 'FR' then astr.FR
	When 'GM' then astr.GM
	When 'ES' then astr.ES end as Label
from tAppString astr (nolock)
inner join tAppModuleString ams (nolock) on ams.StringKey = astr.StringKey
Where ams.ActionID = @ActionID
GO
