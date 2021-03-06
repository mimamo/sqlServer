USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCompanyAddrBookSearch]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCompanyAddrBookSearch]
 @CompanyKey int,
 @CompanyName varchar(200),
 @SearchType int,
 @CompanyTypeKey int
 
AS --Encrypt

IF @SearchType = 1
	if @CompanyTypeKey = 0
		select c.CompanyName, c.ContactOwnerKey, c.ParentCompany
		, a.Address1, c.CompanyKey, c.Phone as Phone, u.UserKey, isnull(u.FirstName, '') + ' ' + isnull(u.LastName,'') as ContactName
		FROM 
			tCompany c (nolock)
			LEFT OUTER JOIN tAddress a (NOLOCK) ON c.DefaultAddressKey = a.AddressKey  
			LEFT OUTER JOIN tUser u (nolock) ON c.PrimaryContact = u.UserKey
		where
			c.OwnerCompanyKey = @CompanyKey and
			UPPER(c.CompanyName) LIKE UPPER(ISNULL(@CompanyName,'')) + '%'
		order by c.CompanyName
	else
		select c.CompanyName, c.ContactOwnerKey, c.ParentCompany
		, a.Address1, c.CompanyKey, c.Phone as Phone, u.UserKey, isnull(u.FirstName, '') + ' ' + isnull(u.LastName,'') as ContactName
		FROM 
			tCompany c (nolock) 
			LEFT OUTER JOIN tAddress a (NOLOCK) ON c.DefaultAddressKey = a.AddressKey
			LEFT OUTER JOIN tUser u (nolock) ON c.PrimaryContact = u.UserKey
		where
			c.OwnerCompanyKey = @CompanyKey and
			UPPER(c.CompanyName) LIKE UPPER(ISNULL(@CompanyName,'')) + '%' and
			c.CompanyTypeKey = @CompanyTypeKey
		order by c.CompanyName
 else
 	if @CompanyTypeKey = 0
		select c.CompanyName, c.ContactOwnerKey, c.ParentCompany
		, a.Address1, c.CompanyKey, u.Phone1 as Phone, u.UserKey, isnull(u.FirstName, '') + ' ' + isnull(u.LastName,'') as ContactName
		FROM 
			tCompany c (nolock)
			LEFT OUTER JOIN tAddress a (NOLOCK) ON c.DefaultAddressKey = a.AddressKey 
			INNER JOIN tUser u (nolock) ON c.CompanyKey = u.CompanyKey
		where
			c.OwnerCompanyKey = @CompanyKey and
			UPPER(u.LastName) LIKE UPPER(ISNULL(@CompanyName,'')) + '%'
		order by u.LastName, u.FirstName
	
	else
		select c.CompanyName, c.ContactOwnerKey, c.ParentCompany
		, a.Address1, c.CompanyKey, u.Phone1 as Phone, u.UserKey, isnull(u.FirstName, '') + ' ' + isnull(u.LastName,'') as ContactName
		FROM 
			tCompany c (nolock)
			LEFT OUTER JOIN tAddress a (NOLOCK) ON c.DefaultAddressKey = a.AddressKey 
			INNER JOIN tUser u (nolock) ON c.CompanyKey = u.CompanyKey
		where
			c.OwnerCompanyKey = @CompanyKey and
			UPPER(u.LastName) LIKE UPPER(ISNULL(@CompanyName,'')) + '%' and
			c.CompanyTypeKey = @CompanyTypeKey
		order by u.LastName, u.FirstName
 RETURN 1
GO
