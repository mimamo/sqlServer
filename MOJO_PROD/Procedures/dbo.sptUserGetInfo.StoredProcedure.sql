USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetInfo]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptUserGetInfo]
 (
  @UserKey int
 )
AS --Encrypt

  /*
  || 11/27/07 GHL 8.5		removed *= join for SQL 2005
  || 12/21/07 GHL 8.5		Added comments after logo because Task Manager looks for go+CR
  || 10/1/08  GWG 10.5		Added Client ID and removed the inner join to tCompany
  || 11/08/11 GHL 10.5.5.0	(114741) Added Security Level
  || 11/07/13 RLB 10.5.7.4	(195465) Added CompanyTimeZoneIndex
  || 07/31/14 QMD 10.5.8.2	changed the default action to today.creative
  || 10/20/14 GWG 10.5.8.5	Added company language ID
  || 10/30/14 MAS 10.5.8.5	Removed stand alone p.LanguageID column, Using ISNULL(ISNULL(u.LanguageID, p.LanguageID), 'EN') as LanguageID
  */
  
 Declare @OwnerCompanyKey INT, @ClientLogin tinyint, @DefaultAction varchar(300)
 
 SELECT @OwnerCompanyKey = OwnerCompanyKey, @ClientLogin = ISNULL(ClientVendorLogin, 0)
 FROM tUser
 WHERE UserKey = @UserKey
 
 Select @DefaultAction = 'today.creative'
 
 if @ClientLogin = 1
	Select @DefaultAction = 'someaction'
 
 IF @OwnerCompanyKey IS NULL
 
  SELECT  u.*
         ,c.CompanyName AS CompanyName
         ,c.CustomerID as ClientID
		 ,c.TimeZoneIndex AS CompanyTimeZoneIndex
         ,u.CompanyKey AS LoggedCompanyKey
         ,sg.GroupName    AS SecurityGroupName
		 ,sg.SecurityLevel
         ,p.StyleSheetKey
         ,p.ShowLogo--Trick Task Manager during Installs
         ,c.WebSite
         ,c.CustomLogo--Trick Task Manager during Installs
         ,p.AffiliateKey
         ,p.ReportLogo--Trick Task Manager during Installs
         ,p.SmallLogo--Trick Task Manager during Installs
         ,ISNULL(p.ProductVersion, 'CM') as ProductVersion
         ,ISNULL(ISNULL(u.LanguageID, p.LanguageID), 'EN') as LangID
         ,p.ApplicationName
         ,p.Culture
         ,ISNULL(sg.DefaultActionID, @DefaultAction) as DefaultActionID
  FROM    tUser u (NOLOCK)
          LEFT OUTER JOIN tCompany c (NOLOCK) ON u.CompanyKey = c.CompanyKey
          LEFT OUTER JOIN tSecurityGroup  sg (NOLOCK) ON u.SecurityGroupKey = sg.SecurityGroupKey
          INNER JOIN tPreference p (NOLOCK) ON u.CompanyKey = p.CompanyKey
  WHERE   u.UserKey           = @UserKey
 
 ELSE
 
  SELECT  u.*
         ,c.CompanyName AS CompanyName
         ,c.CustomerID as ClientID
		 ,c.TimeZoneIndex AS CompanyTimeZoneIndex
         ,u.OwnerCompanyKey AS LoggedCompanyKey
         ,sg.GroupName    AS SecurityGroupName
         ,sg.SecurityLevel
         ,p.StyleSheetKey
         ,p.ShowLogo--Trick Task Manager during Installs
         ,c.WebSite
         ,ISNULL(cl.CustomLogo, c.CustomLogo) as CustomLogo--Trick Task Manager during Installs
         ,p.AffiliateKey
         ,p.ReportLogo--Trick Task Manager during Installs
         ,p.SmallLogo--Trick Task Manager during Installs
         ,ISNULL(p.ProductVersion, 'CM') as ProductVersion 
         ,ISNULL(ISNULL(u.LanguageID, p.LanguageID), 'EN') as LangID
         ,p.ApplicationName
         ,p.Culture
         ,ISNULL(sg.DefaultActionID, @DefaultAction) as DefaultActionID
  FROM    tUser u (NOLOCK)
          INNER JOIN tCompany c (NOLOCK) ON u.OwnerCompanyKey = c.CompanyKey
          LEFT OUTER JOIN tCompany cl (NOLOCK) ON u.CompanyKey = cl.CompanyKey
          LEFT OUTER JOIN tSecurityGroup sg (NOLOCK) ON u.SecurityGroupKey = sg.SecurityGroupKey
          INNER JOIN tPreference p  (NOLOCK) ON u.OwnerCompanyKey = p.CompanyKey
  WHERE   u.UserKey = @UserKey
 
 /* set nocount on */
 return 1
GO
