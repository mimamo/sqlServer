USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyGetMobile]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCompanyGetMobile]
	(
	@CompanyKey int
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 02/11/10 QMD 10.5.4.1 Created for mobile company edit
  */
  
	SET NOCOUNT ON
	
	SELECT	c.CompanyKey
			,c.Phone
			,c.Fax
			,c.WebSite
			,c.CompanyName
			,c.SalesPersonKey			 		 
			,sp.FirstName + ' ' + sp.LastName AS SalesPersonName
			,c.PrimaryContact
			,con.FirstName + ' ' + con.LastName AS ContactName
			,c.AccountManagerKey
			,am.UserName AS AccountManagerName
			,c.SourceKey
			,so.SourceName
			,c.PrimaryContact
			,pct.FirstName + ' ' + pct.LastName AS PrimaryContactName
			,c.ContactOwnerKey
			,owner.FirstName + ' ' + owner.LastName AS ContactOwnerName
			,c.CMFolderKey
			,folder.FolderName
			,c.CompanyTypeKey
			,ct.CompanyTypeName
			,c.DefaultAddressKey
			,a.Address1
			,a.Address2
			,a.Address3
			,a.City
			,a.State
			,a.PostalCode		    
	FROM	tCompany c (NOLOCK)
			LEFT OUTER JOIN tAddress a (NOLOCK) ON c.DefaultAddressKey = a.AddressKey
			LEFT OUTER JOIN tUser con (NOLOCK) ON c.PrimaryContact = con.UserKey
			LEFT OUTER JOIN tUser sp (NOLOCK) ON c.SalesPersonKey = sp.UserKey	
			LEFT OUTER JOIN vUserName am (NOLOCK) ON c.AccountManagerKey = am.UserKey
			LEFT OUTER JOIN tSource so (NOLOCK) ON c.SourceKey = so.SourceKey  
			LEFT OUTER JOIN tUser pct (NOLOCK) ON c.PrimaryContact = pct.UserKey    
			LEFT OUTER JOIN tUser owner (NOLOCK) ON c.ContactOwnerKey = owner.UserKey    
			LEFT OUTER JOIN tCMFolder folder (NOLOCK) ON c.CMFolderKey = folder.CMFolderKey 
			LEFT OUTER JOIN tCompanyType ct (NOLOCK) ON c.CompanyTypeKey = ct.CompanyTypeKey    
	WHERE	c.CompanyKey = @CompanyKey
	
	RETURN 1
GO
