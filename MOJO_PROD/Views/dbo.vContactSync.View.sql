USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vContactSync]    Script Date: 12/21/2015 16:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vContactSync]

As
SELECT
u.CompanyKey
,CASE WHEN c.CompanyName IS NULL THEN u.UserCompanyName ELSE c.CompanyName END AS CompanyName
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.Address1 ELSE home.Address1 END AS Address1
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.Address2 ELSE home.Address2 END AS Address2
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.Address3 ELSE home.Address3 END AS Address3
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.City ELSE home.City END AS City
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.State ELSE home.State END AS State
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.PostalCode ELSE home.PostalCode END AS PostalCode
,CASE WHEN u.AddressKey IS NOT NULL THEN biz.Country ELSE home.Country END AS Country
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.Address1 ELSE other.Address1 END AS BAddress1
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.Address2 ELSE other.Address2 END AS BAddress2
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.Address3 ELSE other.Address3 END AS BAddress3
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.City ELSE other.City END AS BCity
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.State ELSE other.State END AS BState
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.PostalCode ELSE other.PostalCode END AS BPostalCode
,CASE WHEN u.HomeAddressKey IS NOT NULL THEN home.Country ELSE other.Country END AS BCountry
,u.Phone1 AS Phone
,u.Fax
,c.WebSite
--,c.UserDefined1
--,c.UserDefined2
--,c.UserDefined3
--,c.UserDefined4
,u.Active
,u.OwnerCompanyKey
,u.DateUpdated
,c.BillableClient
,c.Vendor
,u.OwnerKey AS ContactOwnerKey
,u.Comments 
,u.UserKey
,u.FirstName AS Contact_FirstName
,u.LastName AS Contact_LastName
,u.Salutation AS Contact_Salutation
,u.Phone1 AS Contact_Phone1
,u.Phone2 AS Contact_Phone2
,u.Cell AS Contact_Cell
,u.Fax AS Contact_Fax
,u.Pager AS Contact_Pager
,u.Title AS Contact_Title
,u.Email AS Contact_Email
,u.Active AS Contact_Active
,u.DateUpdated AS Contact_DateUpdated
,u.DateAdded AS Contact_DateAdded
,u.CMFolderKey
FROM tUser u (NOLOCK) 
LEFT OUTER JOIN tCompany c (NOLOCK) ON c.CompanyKey = u.CompanyKey
LEFT OUTER JOIN tAddress biz (NOLOCK) ON u.AddressKey = biz.AddressKey
LEFT OUTER JOIN tAddress home (NOLOCK) ON u.HomeAddressKey = home.AddressKey
LEFT OUTER JOIN tAddress other (NOLOCK) ON u.OtherAddressKey = other.AddressKey

WHERE
	u.Active = 1
GO
