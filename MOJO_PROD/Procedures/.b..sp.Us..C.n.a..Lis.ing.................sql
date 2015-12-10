USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserContactListing]    Script Date: 12/10/2015 10:54:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserContactListing]
	@CompanyKey int,
	@Search varchar(100),
	@UserKey int,
	@ViewOtherContacts tinyint,
	@IsFavorite tinyint,
	@IsRecent tinyint

AS

/*
  || When     Who Rel       What
  || 05/30/14 MFT 10.5.8.0  Created
  || 06/09/14 MFT 10.5.8.0  Added tAppFavorite join
  || 06/11/14 MFT 10.5.8.0  Added tAppHistory join and changed param signature (removed client/vendor search)
  || 07/02/14 MFT 10.5.8.1  Removed OwnerKey restriction, added restriction to filter out Employee data
  || 07/23/14 MFT 10.5.8.2  Revised tAppFavorite and tAppHistory ActionID strings
  || 07/28/14 MFT 10.5.8.2  Corrected tAppHistory ORDER BY
  || 07/31/14 MFT 10.5.8.2  Added @ViewOtherContacts param to check rights on get
  || 08/12/14 MFT 10.5.8.3  Added CMFolder and GLCompany restrictions
  || 08/22/14 MFT 10.5.8.3  Added RecentSort
  || 10/07/14 RLB 10.5.8.5  changed GL Restict check
  || 01/28/15 MFT 10.5.8.7  Fixed recent ActionID
  || 02/03/15 QMD 10.5.8.9  Fixed the folder logic
  || 03/04/15 RLB 10.5.9.0  Fixed restrict user logic it was not using correct field
  || 03/06/15 MAS 10.5.9.1  Added search from combined first/last names
  || 04/29/15 QMD 10.5.9.1  API - Added api fields to select
*/

DECLARE @GLCompanyRestrict tinyint
SELECT @GLCompanyRestrict = ISNULL(RestrictToGLCompany, 0) FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

SELECT
	u.UserKey,
	CASE
		WHEN LEN(ISNULL(u.FirstName, '') + ISNULL(u.LastName, '')) > 0 THEN
			ISNULL(u.FirstName, '') + CASE WHEN LEN(ISNULL(u.FirstName, '')) > 0 THEN ' ' ELSE '' END + ISNULL(u.LastName, '')
		ELSE ISNULL(u.UserCompanyName, ISNULL(c.CompanyName, ''))
		END AS ContactFullName,
	u.Phone1,
	u.Phone2,
	u.Cell,
	u.Email,
	c.Phone AS CompanyMainPhone,
	c.CompanyName,
	u.UserCompanyName,
	--PersonalWorkAddress
	u.AddressKey,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address1 ELSE a_dc.Address1 END AS PersonalWorkAddress1,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address2 ELSE a_dc.Address2 END AS PersonalWorkAddress2,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Address3 ELSE a_dc.Address3 END AS PersonalWorkAddress3,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.City ELSE a_dc.City END AS PersonalWorkCity,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.State ELSE a_dc.State END AS PersonalWorkState,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.PostalCode ELSE a_dc.PostalCode END AS PersonalWorkPostalCode,
	CASE WHEN u.AddressKey IS NOT NULL THEN a_u.Country ELSE a_dc.Country END AS PersonalWorkCountry,
	--HomeAddress1
	u.HomeAddressKey,
	a_h.Address1 AS HomeAddress1,
	a_h.Address2 AS HomeAddress2,
	a_h.Address3 AS HomeAddress3,
	a_h.City AS HomeCity,
	a_h.State AS HomeState,
	a_h.PostalCode AS HomePostalCode,
	a_h.Country AS HomeCountry,
	--CompanyAddress
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address1 ELSE a_dc.Address1 END AS CompanyAddress1,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address2 ELSE a_dc.Address2 END AS CompanyAddress2,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Address3 ELSE a_dc.Address3 END AS CompanyAddress3,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.City ELSE a_dc.City END AS CompanyCity,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.State ELSE a_dc.State END AS CompanyState,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.PostalCode ELSE a_dc.PostalCode END AS CompanyPostalCode,
	CASE WHEN c.BillingAddressKey IS NOT NULL THEN a_bc.Country ELSE a_dc.Country END AS CompanyCountry,
	--OtherAddress
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Address1 ELSE a_dc.Address1 END AS OtherAddress1,
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Address2 ELSE a_dc.Address2 END AS OtherAddress2,
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Address3 ELSE a_dc.Address3 END AS OtherAddress3,
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.City ELSE a_dc.City END AS OtherCity,
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.State ELSE a_dc.State END AS OtherState,
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.PostalCode ELSE a_dc.PostalCode END AS OtherPostalCode,
	CASE WHEN u.OtherAddressKey IS NOT NULL THEN a_o.Country ELSE a_dc.Country END AS OtherCountry,
	CASE WHEN ISNULL(af.ActionKey, 0) > 0 THEN 1 ELSE 0 END AS IsFavorite,
	af.DisplayOrder AS FavoriteDisplayOrder,
	CASE WHEN ISNULL(ah.ActionKey, 0) > 0 THEN 1 ELSE 0 END AS IsRecent,
	ah.DateAdded AS RecentSort,
	
	--API
	u.FirstName,
	u.LastName,
	u.Title,
	c.CompanyKey,
	u.LinkedInURL,
	u.TwitterID,
	u.Contractor,
	u.DoNotCall,
	u.DoNotFax,
	u.DoNotEmail,
	u.DoNotMail,
	u.LastModified,
	u.DateAdded,
	u.DateUpdated,
	u.AddedByKey,
	u.UpdatedByKey,
	u.Active
FROM
	tUser u (nolock)
	LEFT JOIN tCompany c (nolock) ON u.CompanyKey = c.CompanyKey
	LEFT JOIN tAddress a_u (nolock) ON u.AddressKey = a_u.AddressKey
	LEFT JOIN tAddress a_h (nolock) ON u.HomeAddressKey = a_h.AddressKey
	LEFT JOIN tAddress a_o (nolock) ON u.OtherAddressKey = a_o.AddressKey
	LEFT JOIN tAddress a_dc (nolock) ON c.DefaultAddressKey = a_dc.AddressKey
	LEFT JOIN tAddress a_bc (nolock) ON c.BillingAddressKey = a_bc.AddressKey
	LEFT JOIN tAppFavorite af (nolock) ON u.UserKey = af.ActionKey AND af.ActionID = 'cm.contacts' AND af.UserKey = @UserKey
	LEFT JOIN (
		SELECT TOP 10 ActionKey, DateAdded
		FROM tAppHistory ah (nolock)
		WHERE
			ActionID = 'cm.contacts.edit' AND
			UserKey = @UserKey
		ORDER BY DateAdded DESC
	) ah ON u.UserKey = ah.ActionKey
WHERE
	u.OwnerCompanyKey = @CompanyKey AND
	--Folder restriction
	(
		ISNULL(u.CMFolderKey, 0) = 0 OR
		u.CMFolderKey IN (
			SELECT CMFolderKey
			FROM tCMFolderSecurity (nolock)
			WHERE
				(
					CanView = 1 AND
					Entity = 'tUser' AND
					EntityKey = @UserKey
				) OR
				(
					CanView = 1 AND
					Entity = 'tSecurityGroup' AND
					EntityKey IN (SELECT SecurityGroupKey FROM tUser (nolock) WHERE UserKey = @UserKey)
				)
		)OR
		EXISTS (
				SELECT	CMFolderKey
				FROM	tCMFolder c (NOLOCK)
				WHERE	c.CMFolderKey = u.CMFolderKey
						AND c.UserKey = @UserKey
						AND Entity = 'tUser'
				) 
	) AND
	--GL Company restriction
	(
		@GLCompanyRestrict = 0 OR
		u.UserKey  IN (
			SELECT DISTINCT(EntityKey) from tGLCompanyAccess glca(nolock) where  glca.Entity = 'tUser' and glca.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey)
		)
	) AND
	--Search criteria
	(
		LOWER(ISNULL(u.FirstName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(u.LastName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(u.FirstName, '')) + ' ' + LOWER(ISNULL(u.LastName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(c.CompanyName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(u.UserCompanyName, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(c.VendorID, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(c.CustomerID, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%' OR
		LOWER(ISNULL(u.Email, '')) LIKE '%' + LOWER(ISNULL(@Search, '')) + '%'
	) AND
	--Rights restriction
	CASE WHEN @ViewOtherContacts = 1 THEN @UserKey ELSE u.OwnerKey END = @UserKey AND
	--Favorite/Recent restriction
	CASE WHEN ISNULL(af.ActionKey, 0) > 0 THEN 1 ELSE 0 END = ISNULL(@IsFavorite, CASE WHEN ISNULL(af.ActionKey, 0) > 0 THEN 1 ELSE 0 END) AND
	CASE WHEN ISNULL(ah.ActionKey, 0) > 0 THEN 1 ELSE 0 END = ISNULL(@IsRecent, CASE WHEN ISNULL(ah.ActionKey, 0) > 0 THEN 1 ELSE 0 END)
ORDER BY
	u.FirstName,
	u.LastName
GO
