USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStringCompanyGetList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStringCompanyGetList]
	@CompanyKey as int,
	@CheckTime smalldatetime = NULL
AS --Encrypt

  /*
  || 11/27/07  GHL 8.5      removed *= join for SQL 2005
  || 02/11/08  CRG 1.0.0.0  Added @CheckTime for the ListManager
  || 11/18/14  WDF 10.5.8.7 Show KeyPersons only if have legacy customization
  */

DECLARE @GroupName varchar(100)
DECLARE @HasLegacy smallint
select @HasLegacy = ISNULL(CHARINDEX('legacykeypeople', Customizations), 0) from tPreference where CompanyKey = @CompanyKey

if @HasLegacy = 0 
   select @GroupName = 'Projects'

IF @CheckTime IS NULL
	OR EXISTS
			(SELECT NULL
			FROM	tStringCompany (nolock) --Only need to check tStringCompany because it's the only table that can be modified
			WHERE	CompanyKey = @CompanyKey
			AND		LastModified > @CheckTime)
		select sg.StringGroupName
			,s.StringID
			,s.DisplayName
			,isnull(s.AllowDD, 0) as AllowDD
			,isnull(sc.StringSingular,s.StringSingular) as StringSingular
			,isnull(sc.StringPlural,s.StringPlural) as StringPlural
			,isnull(sc.StringDropDown, s.DefaultDD) as StringDropDown
		from tString s (nolock)
			INNER JOIN tStringGroup sg (nolock) ON s.StringGroupKey = sg.StringGroupKey
			LEFT OUTER JOIN tStringCompany sc (nolock) ON
				s.StringID = sc.StringID AND sc.CompanyKey = @CompanyKey  
	   where sg.StringGroupName <> @GroupName 
	      or @GroupName is null
		order by sg.DisplayOrder
			,s.DisplayOrder	
	        
		return 1
GO
