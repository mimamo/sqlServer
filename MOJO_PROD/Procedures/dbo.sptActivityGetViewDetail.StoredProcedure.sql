USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetViewDetail]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetViewDetail]
	(
		@ActivityKey int
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 05/18/09 MAS 10.5.0.0 Changed Stage to Left Outer join
|| 03/18/11 GHL 10.5.4.3 Added missing where clause on tCompany
|| 03/23/11 GHL 10.5.4.3 Added FolderName + ActivityTypeName + emails for mobile 
*/

Declare @ContactKey int, @ContactCompanyKey int, @UserLeadKey int, @LeadKey int, @RootKey int

Select @ContactKey = ContactKey, @ContactCompanyKey = ContactCompanyKey, @UserLeadKey = UserLeadKey, @LeadKey = LeadKey, @RootKey = RootActivityKey
	From tActivity (nolock) Where ActivityKey = @ActivityKey
	
Select a.*,
	au.FirstName + ' ' + au.LastName as AssignedUserName,
	p.ProjectNumber, 
	p.ProjectName, 
	p.ProjectNumber + ' ' + p.ProjectName as ProjectFullName,
	cmf.FolderName,
	aty.TypeName as ActivityTypeName
	From tActivity a (nolock) 
	left outer join tUser au (nolock) on a.AssignedUserKey = au.UserKey
	left outer join tProject p (nolock) on a.ProjectKey = p.ProjectKey
	left outer join tCMFolder cmf (nolock) on a.CMFolderKey = cmf.CMFolderKey
	left outer join tActivityType aty (nolock) on a.ActivityTypeKey = aty.ActivityTypeKey 
Where ActivityKey = @ActivityKey

Select 
	c.CompanyName,
	c.Phone,
	c.Fax,
	c.WebSite,
	ad.Address1,		
	ad.Address2,		
	ad.Address3,		
	ad.City, 				
	ad.State, 				
	ad.PostalCode, 	
	ad.Country,		
	co.FirstName + ' ' + co.LastName as CompanyOwnerName,
	c.DateAdded as CompanyDateAdded,
	c.DateUpdated as CompanyDateUpdated
From
	tCompany c (nolock)
	left outer join tUser co (nolock) on c.AccountManagerKey = co.UserKey
	left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
Where c.CompanyKey = @ContactCompanyKey
	
Select
	con.FirstName + ' ' + con.LastName as ContactName,
	con.Phone1,
	con.Cell, 
	con.Fax,
	con.Email,
	uad.Address1,		
	uad.Address2,		
	uad.Address3,		
	uad.City, 				
	uad.State, 				
	uad.PostalCode, 	
	uad.Country,
	cono.FirstName + ' ' + cono.LastName as ContactOwnerName
From tUser con (nolock) 
	left outer join tCompany c (nolock) on con.CompanyKey = c.CompanyKey
	left outer join tAddress uad (nolock) on ISNULL(con.AddressKey, c.DefaultAddressKey) = uad.AddressKey
	left outer join tUser cono (nolock) on con.OwnerKey = cono.UserKey
Where con.UserKey = @ContactKey
	
Select 
	ul.FirstName + ' ' + ul.LastName as LeadName,
	ul.CompanyName,
	ul.Phone1,
	ul.Cell,
	ul.Fax, 
	ul.Email,
	ul.CompanyName,
	ulad.Address1,		
	ulad.Address2,		
	ulad.Address3,		
	ulad.City, 				
	ulad.State, 				
	ulad.PostalCode, 	
	ulad.Country,
	ulo.FirstName + ' ' + ulo.LastName as LeadOwnerName
From tUserLead ul (nolock) 
	left outer join tAddress ulad (nolock) on ul.AddressKey = ulad.AddressKey
	left outer join tUser ulo (nolock) on ul.OwnerKey = ulo.UserKey
Where UserLeadKey = @UserLeadKey



SELECT	tLead.LeadKey,
		tLead.Subject, 
		tCompany.CompanyName, 
		tLead.Comments,
		tUser.FirstName + ' ' + tUser.LastName AS PrimaryContactName, 
		tUser1.FirstName + ' ' + tUser1.LastName AS AccountManagerName, 
		tLeadStage.LeadStageName AS LeadStageName, 
		tLeadStatus.LeadStatusName AS LeadStatusName, 
		tLead.WWPCurrentLevel,
		tLead.Probability,
		tLead.SaleAmount, 
		tLead.StartDate,
		tLead.EstCloseDate 
                         
FROM tLead (nolock)
	INNER JOIN tLeadStatus (nolock) ON tLead.LeadStatusKey = tLeadStatus.LeadStatusKey 
	LEFT OUTER JOIN tLeadStage (nolock) ON tLead.LeadStageKey = tLeadStage.LeadStageKey 
	INNER JOIN tCompany (nolock) ON tLead.ContactCompanyKey = tCompany.CompanyKey 
	INNER JOIN tUser AS tUser1 (nolock) ON tLead.AccountManagerKey = tUser1.UserKey 
	LEFT OUTER JOIN tUser (nolock) ON tLead.ContactKey = tUser.UserKey 
	LEFT OUTER JOIN tLeadOutcome (nolock) ON tLead.LeadOutcomeKey = tLeadOutcome.LeadOutcomeKey 
	LEFT OUTER JOIN tProjectType (nolock) ON tLead.ProjectTypeKey = tProjectType.ProjectTypeKey 
	LEFT OUTER JOIN tCompanyType (nolock) ON tCompany.CompanyTypeKey = tCompanyType.CompanyTypeKey
Where tLead.LeadKey = @LeadKey


Select * from tActivity (nolock) Where RootActivityKey = @RootKey Order By DateUpdated

-- Email List
Select u.UserKey, RTRIM(LTRIM(isnull(u.FirstName, '') + ' ' + isnull(u.LastName, ''))) as UserName
	, isnull(u.Email, '') as Email, u.ClientVendorLogin, TimeZoneIndex
	from tActivityEmail ae (nolock)
	inner join tUser u (nolock) on ae.UserKey = u.UserKey
	Where ActivityKey = @ActivityKey
GO
