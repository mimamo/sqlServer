USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadGetBasic]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadGetBasic]
	@UserLeadKey int

AS --Encrypt
/*
  || When     Who Rel    What
  || 06/11/09 MFT 10.500 Created to support OpportunitySnapshot
*/

SET NOCOUNT ON

SELECT
	ul.FirstName + ' ' + ul.LastName AS FullName,
	ul.*,
	ad.AddressName AS CompanyAddressName,
	ad.Address1 AS CompanyAddress1,
	ad.Address2 AS CompanyAddress2,
	ad.Address3 AS CompanyAddress3,
	ad.City AS CompanyCity,
	ad.State AS CompanyState,
	ad.Country AS CompanyCountry,
	ad.PostalCode AS CompanyPostalCode,
	had.AddressName,
	had.Address1,
	had.Address2,
	had.Address3,
	had.City,
	had.State,
	had.Country,
	had.PostalCode,
	o.FirstName + ' ' + o.LastName AS LeadOwnerName,
	ct.CompanyTypeName,
	s.SourceName,
	pt.ProjectTypeName
FROM
	tUserLead ul (nolock)
	LEFT JOIN tAddress ad (nolock)
		ON ul.AddressKey = ad.AddressKey
	LEFT JOIN tAddress had (nolock)
		ON ul.HomeAddressKey = had.AddressKey
	LEFT JOIN tUser o (nolock)
		ON ul.OwnerKey = o.UserKey
	LEFT JOIN tCompanyType ct (nolock)
		ON ul.CompanyTypeKey = ct.CompanyTypeKey
	LEFT JOIN tSource s (nolock)
		ON ul.CompanySourceKey = s.SourceKey
	LEFT JOIN tProjectType pt (nolock)
		ON ul.OppProjectTypeKey = pt.ProjectTypeKey
WHERE
	UserLeadKey = @UserLeadKey

RETURN 1
GO
