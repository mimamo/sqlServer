USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadInfoGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLeadInfoGet]
	@LeadKey int

AS --Encrypt
/*
  || When     Who Rel    What
  || 02/25/08 BSH WMJ1.0 Created SP.
  || 03/03/08 CRG 1.0    Added CompanyDateAdded, CompanyDateUpdated, Outcome, and LeadStatusName. Also added Company Address columns.
  || 07/20/08 GWG 10.006 Forcast amount was not divided by 100.
  || 12/18/08 GHL 10.015 Added CompanyAddedByName and CompanyUpdatedByName for the Listing/Company Tab
  || 12/19/08 GHL 10.015 Added list of contacts for the company for the Listing/Contacts Tab
  || 01/15/09 GHL 10.015 Using now vListing_Contact for the Listing/Contacts Tab
  || 06/02/09 MFT 10.027 Added ProjectTypeName to support OpportunitySnapshot
*/

		SELECT 
			l.*,
			c.CompanyName,
			ad.AddressName,
			ad.Address1,
			ad.Address2,
			ad.Address3,
			ad.City,
			ad.State,
			ad.Country,
			ad.PostalCode,
			cad.AddressName AS CompanyAddressName,
			cad.Address1 AS CompanyAddress1,
			cad.Address2 AS CompanyAddress2,
			cad.Address3 AS CompanyAddress3,
			cad.City AS CompanyCity,
			cad.State AS CompanyState,
			cad.Country AS CompanyCountry,
			cad.PostalCode AS CompanyPostalCode,
			c.Phone,
			c.Fax,
			c.WebSite,
			pc.CompanyName as ParentCompanyName,
			ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS ContactName,
			u.Phone1 as UserPhone,
			u.Cell as UserCell,
			u.Fax as UserFax,
			u.Email as UserEmail,
			ISNULL(uam.FirstName, '') + ' ' + ISNULL(uam.LastName, '') AS AccountManager,
			ISNULL(l.SaleAmount, 0) * ISNULL(l.Probability, 0) / 100 AS ForecastAmount,
			ls.LeadStageName as LeadStageName,
			ISNULL(cou.FirstName, '') + ' ' + ISNULL(cou.LastName, '') AS ContactOwnerName,
			lstat.LeadStatusName,
			lo.Outcome,
		    c.DateAdded as CompanyDateAdded,
		    c.DateUpdated as CompanyDateUpdated,
		    ISNULL(u_add.FirstName, '') + ' ' + ISNULL(u_add.LastName, '') as CompanyAddedByName,
		    ISNULL(u_update.FirstName, '') + ' ' + ISNULL(u_update.LastName, '') as CompanyUpdatedByName,
		    pt.ProjectTypeName
		FROM 
			tLead l (nolock)
			inner join tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey
			left outer join tCompany pc (nolock) on l.CompanyKey = pc.CompanyKey
			left outer join tUser cou (nolock) on c.ContactOwnerKey = cou.UserKey
			left outer join tUser u (nolock) on l.ContactKey = u.UserKey
			left outer join tUser uam (nolock) on l.AccountManagerKey = uam.UserKey
			left outer join tUser u_add (nolock) on c.CreatedBy = u_add.UserKey
			left outer join tUser u_update (nolock) on c.ModifiedBy = u_update.UserKey
			left outer join tAddress ad (nolock) on ISNULL(u.AddressKey, c.DefaultAddressKey) = ad.AddressKey
			left outer join tAddress cad (nolock) on c.DefaultAddressKey = cad.AddressKey
			left outer join tLeadStage ls (nolock) on l.LeadStageKey = ls.LeadStageKey
			left outer join tLeadStatus lstat (nolock) on l.LeadStatusKey = lstat.LeadStatusKey
			left outer join tLeadOutcome lo (nolock) on l.LeadOutcomeKey = lo.LeadOutcomeKey
			left outer join tProjectType pt (nolock) on l.ProjectTypeKey = pt.ProjectTypeKey
		WHERE
			LeadKey = @LeadKey

		-- These are the contacts for the company to display on the Contacts tab
		Select lu.Role, u.* 
		from tLead l (nolock) 
			inner join tLeadUser lu (nolock) on l.LeadKey = lu.LeadKey
			inner join vListing_Contact u (nolock) on lu.UserKey = u.UserKey  
		Where l.LeadKey = @LeadKey
		Order By [Contact Full Name]

	RETURN 1
GO
