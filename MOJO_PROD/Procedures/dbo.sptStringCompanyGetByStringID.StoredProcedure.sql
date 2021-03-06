USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStringCompanyGetByStringID]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptStringCompanyGetByStringID]
	@CompanyKey int,
	@StringID varchar(50)
AS --Encrypt

  select s.StringID
        ,s.DisplayName
        ,isnull(s.AllowDD, 0) as AllowDD
        ,isnull(sc.StringSingular,s.StringSingular) as StringSingular
        ,isnull(sc.StringPlural,s.StringPlural) as StringPlural
        ,isnull(sc.StringDropDown, s.DefaultDD) as StringDropDown
    from tStringCompany sc (nolock)
        ,tString s (nolock)
   where s.StringID = sc.StringID
     and sc.CompanyKey = @CompanyKey
     and sc.StringID = @StringID
        
	return 1
GO
