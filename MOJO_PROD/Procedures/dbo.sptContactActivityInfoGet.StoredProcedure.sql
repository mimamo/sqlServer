USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptContactActivityInfoGet]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptContactActivityInfoGet]
	@ContactActivityKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/26/08 BSH WMJ1.0 Created SP. 
  || 03/03/08 CRG 1.0   Added CompanyDateAdded, CompanyDateUpdated, OutcomeText, and LeadStatusName
  || 03/04/08 CRG 1.0   Removed Parent Company join.  Added StatusText, LeadContactName, and LeadContactPhone. Also added Company Address columns.
  */

	SELECT 
		ca.*,
		c.CompanyName,
		c.CompanyKey,
		c.Phone,
		c.Fax,
		c.WebSite,
		ad.AddressName,
		ad.Address1,
		ad.Address2,
		ad.Address3,
		ad.City,
		ad.State,
		ad.Country,
		ad.PostalCode,
		u.FirstName + ' ' + u.LastName as ContactName,
		u.Phone1,
		u.Phone2,
		u.Cell,
		u.Pager,
		u.Fax,
		u.Email,
		ISNULL(uam.FirstName, '') + ' ' + ISNULL(uam.LastName, '') AS AccountManager,
		l.Subject as OpportunitySubject,
		l.StartDate, 
		l.SaleAmount, 
		l.Comments, 
		l.CurrentStatus, 
		l.Probability, 
		l.OutcomeComment, 
		ISNULL(l.SaleAmount, 0) * ISNULL(l.Probability, 0) AS ForecastAmount,
		ls.LeadStageName as LeadStageName,
		ISNULL(cou.FirstName, '') + ' ' + ISNULL(cou.LastName, '') AS ContactOwnerName,
	    c.DateAdded as CompanyDateAdded,
	    c.DateUpdated as CompanyDateUpdated,
	    CASE ca.Outcome
			WHEN 1 THEN 'Successful'
			WHEN 2 THEN 'Unsuccessful'
			ELSE ''
		END AS OutcomeText,
		lstat.LeadStatusName,
	    CASE ca.Status
			WHEN 1 THEN 'Open'
			WHEN 2 THEN 'Completed'
			ELSE ''
		END AS StatusText,
		ISNULL(lc.FirstName, '') + ' ' + ISNULL(lc.LastName, '') AS LeadContactName,
		lc.Phone1 as LeadContactPhone,
		cad.AddressName AS CompanyAddressName,
		cad.Address1 AS CompanyAddress1,
		cad.Address2 AS CompanyAddress2,
		cad.Address3 AS CompanyAddress3,
		cad.City AS CompanyCity,
		cad.State AS CompanyState,
		cad.Country AS CompanyCountry,
		cad.PostalCode AS CompanyPostalCode
	FROM 
		tContactActivity ca (nolock)
		INNER JOIN tCompany c (nolock) ON ca.ContactCompanyKey = c.CompanyKey
		left outer join tUser cou (nolock) on c.ContactOwnerKey = cou.UserKey
		left outer join tUser u (nolock) ON ca.ContactKey = u.UserKey
		left outer join tLead l (nolock) on ca.LeadKey = l.LeadKey
		left outer join tUser lc (nolock) on l.ContactKey = lc.UserKey
		left outer join tUser uam (nolock) on l.AccountManagerKey = uam.UserKey
		left outer join tAddress ad (nolock) on ISNULL(u.AddressKey, c.DefaultAddressKey) = ad.AddressKey
		left outer join tAddress cad (nolock) on c.DefaultAddressKey = cad.AddressKey
		left outer join tLeadStage ls (nolock) on l.LeadStageKey = ls.LeadStageKey
		left outer join tLeadStatus lstat (nolock) on l.LeadStatusKey = lstat.LeadStatusKey
	WHERE
		ContactActivityKey = @ContactActivityKey

	RETURN 1
GO
