USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Lead]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE            VIEW [dbo].[vReport_Lead]
AS


/*
  || When     Who Rel      What
  || 10/13/06 WES 8.3567   Added Custom Fields Key
  || 03/27/07 BSH 8.4.0.4  Added Contact Phone and Email.
  || 03/11/09 MAS 10.5.0.0 Added Last and Next Activity columns, renamed columns, removed user_defined columns.
  || 05/18/09 MAS 10.5.0.0 Changed Stage to Left Outer join
  || 08/15/09 GWG 10.5.0.7 Added Lead custom field for access to the user defined fields
  || 11/30/09 GWG 10.5.1.4 Modified view to get owner correctly and removed sales person
  || 12/29/09 GWG 10.5.1.5 Added Sales Person back
  || 03/10/10 RLB 10.5.2.0 Added Production, Media and AGI to Data set
  || 09/30/10 QMD 10.5.3.5 Added Date Modified enhancement 
  || 07/15/11 GWG 10.5.4.6 Added Converted to Type and Converted To (project name or campaign)
  || 09/20/12 GWG 10.5.6.0 Added the sale amount to the view
  || 08/16/13 RLB 10.5.7.1 (181394) Added Contact Title
  || 10/02/13 MAS 10.5.7.3 (179034) Added ClientDivisionKey & ClientProductKey  
  */
  
  
SELECT 
	l.CompanyKey, 
	c.CustomFieldKey,
	l.CustomFieldKey as LeadCustomFieldKey,
	l.Subject AS [Opportunity Name], 
	c.CompanyName AS [Company Name], 
	c.CustomerID as [Company Client ID],
	ad.Address1 AS [Company Address1],   
	ad.Address2 AS [Company Address2],   
	ad.Address3 AS [Company Address3],   
	ad.City AS [Company City],   
	ad.State AS [Company State],   
	ad.PostalCode AS [Company Postal Code],   
	ad.Country AS [Company Country],
	c.Phone AS [Company Main Phone], 
	c.Fax AS [Company Main Fax], 
	CASE when c.BillableClient = 1 then 'YES' else 'NO' end AS [Billable Client],
	ct.CompanyTypeName as [Company Type],
	u.FirstName + ' ' + u.LastName AS [Primary Contact],
	u.Phone1 [Contact Phone],
	u.Email as [Contact Email],
	u.Title as [Contact Title],
	uAM.FirstName + ' ' + uAM.LastName AS [Account Manager],
	ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName, '') AS [User Full Name],
	pt.ProjectTypeName AS [Project Type], 
	lst.LeadStatusName AS [Lead Status], 
	case when lst.Active = 1 then 'YES' else 'NO' end as [Lead Status Active],
	lst.DisplayOrder AS [Lead Status Display Order], 
	lsg.LeadStageName AS [Lead Stage], 
	lsg.DisplayOrder AS [Lead Stage Display Order], 
	lo.Outcome AS Outcome, 
	l.CurrentStatus AS [Next Steps], 
	l.OutcomeComment AS [Outcome Comment], 
	l.Probability AS Probability, 
	l.Labor as [Labor Amount],
	l.SaleAmount AS [Sale Amount],
	l.OutsideCostsGross AS [Production],
	l.MediaGross AS [Media],
	l.AGI AS [AGI],
	l.SaleAmount * l.Probability / 100 AS [Weighted Sale Amount],
	l.Margin AS Margin, 
	l.SaleAmount * l.Margin / 100 AS [Margin Amount],
	case when l.Bid = 1 then 'YES' else 'NO' end AS [Bid Lead], 
	l.BidDate AS [Bid Due Date], 
	l.StartDate AS [Lead Start Date], 
	l.EstCloseDate AS [Close Date Est], 
	l.ActualCloseDate AS [Close Date Actual], 
	l.Comments AS [Description],
	l.DateConverted as [Date Converted],
	l.EstCloseDate as [Forecasted Close Date],
	DATEPART("YYYY", l.EstCloseDate) AS [Forecasted Close Year],
	DATEPART("mm", l.EstCloseDate) AS [Forecasted Close Month],
	l.SaleAmount * l.Probability / 100 AS [Forecasted Sale Amount],
	-- WWP
	CASE l.WWPCurrentLevel 
		WHEN 2 THEN '2 - Contemplating'
		WHEN 3 THEN '3 - Planning'
		WHEN 4 THEN '4 - Action'
		ELSE '1 - Unaware' 
	END AS [WWP Current Level],
--	,tLead.WWPLevelDate AS [WWP Level Date] ,
	l.WWPNeedSupply AS [WWP Needs = Supply], 
	l.WWPNeedSupplyComment AS [WWP Needs = Supply Comment],
	l.WWPTimeline AS [WWP Timeline], 
	l.WWPTimelineComment AS [WWP Timeline Comment], 
	l.WWPDecisionMakers AS [WWP Decision Makers],
	l.WWPDecisionMakersComment AS [WWP Decision Makers Comment],
	l.WWPBudget AS [WWP Budget],
	l.WWPBudgetComment AS [WWP Budget Comment],
	ISNULL(owner.FirstName,'') + ' ' + ISNULL(owner.LastName,'') as [Company Owner],
	ISNULL(sales.FirstName,'') + ' ' + ISNULL(sales.LastName,'') AS [Sales Person],
	lo.Outcome AS [Positive Outcome Indicator], 
	l.Competitors AS [Competitors], 
	h.HistoryDate AS [Stage Date], 
	ISNULL(contact.FirstName,'') + ' ' + ISNULL(contact.LastName, '') AS [Opportunity Owner Name],
	c.SourceKey AS [Source ID],
	folder.FolderName AS [Folder],

	lastActivity.ActivityDate AS [Last Activity Date],
	lastActivity.Subject AS [Last Activity Subject],
	ISNULL(lau.FirstName,'') + ' ' + ISNULL(lau.LastName,'') AS [Last Activity Assigned To],

	nextActivity.ActivityDate AS [Next Activity Date],
	nextActivity.Subject AS [Next Activity Subject],
	ISNULL(nau.FirstName,'') + ' ' + ISNULL(nau.LastName,'') AS [Next Activity Assigned To],
	l.DateUpdated AS [Date Modified],
	 CASE
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 90 THEN '90 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 60 THEN '60 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 30 THEN '30 Days'
		WHEN DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) > 7 THEN '7 Days'
		ELSE NULL
	  END AS [No Activity Since]
	 ,CASE 
		WHEN ConvertEntity = 'tProject' THEN 'Project'
		WHEN ConvertEntity = 'tCampaign' THEN 'Campaign'
		ELSE NULL
	  END as [Converted To Type]
	 ,CASE 
		WHEN ConvertEntity = 'tProject' THEN (Select ProjectNumber + ' - ' + ProjectName from tProject (nolock) Where ProjectKey = ConvertEntityKey)
		WHEN ConvertEntity = 'tCampaign' THEN (Select CampaignID + ' - ' + CampaignName from tCampaign (nolock) Where CampaignKey = ConvertEntityKey)
		ELSE NULL
	  END as [Converted To],
	 cd.ClientDivisionKey
    ,cd.DivisionName as [Division Name]
    ,cp.ClientProductKey
    ,cp.ProductName as [Product Name]

FROM 
	tLead l (nolock)
	INNER JOIN tLeadStatus lst (nolock) ON l.LeadStatusKey = lst.LeadStatusKey 
	LEFT OUTER JOIN tLeadStage lsg (nolock) ON l.LeadStageKey = lsg.LeadStageKey 
	INNER JOIN tCompany c (nolock) ON l.ContactCompanyKey = c.CompanyKey 
	INNER JOIN tUser uAM (nolock) ON l.AccountManagerKey = uAM.UserKey 
	LEFT OUTER JOIN tUser u (nolock) ON l.ContactKey = u.UserKey 
	LEFT OUTER JOIN tLeadOutcome lo (nolock) ON l.LeadOutcomeKey = lo.LeadOutcomeKey
    LEFT OUTER JOIN tProjectType pt (nolock) ON l.ProjectTypeKey = pt.ProjectTypeKey
	LEFT OUTER JOIN tCompanyType ct on c.CompanyTypeKey = ct.CompanyTypeKey
	Left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	LEFT OUTER JOIN tActivity lastActivity (NOLOCK) on l.LastActivityKey = lastActivity.ActivityKey
	LEFT OUTER JOIN tUser lau (NOLOCK) ON lastActivity.AssignedUserKey = lau.UserKey
	LEFT OUTER JOIN tActivity nextActivity (NOLOCK) on l.NextActivityKey = nextActivity.ActivityKey
	LEFT OUTER JOIN tUser nau (NOLOCK) ON nextActivity.AssignedUserKey = nau.UserKey
	LEFT OUTER JOIN tUser contact (NOLOCK) ON l.AccountManagerKey = contact.UserKey
	LEFT OUTER JOIN tUser owner (NOLOCK) ON c.ContactOwnerKey = owner.UserKey
	LEFT OUTER JOIN tUser sales (NOLOCK) ON c.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tCMFolder folder (NOLOCK) on c.CMFolderKey = folder.CMFolderKey
	LEFT OUTER JOIN tLeadStageHistory h (NOLOCK) on l.LeadStageKey = h.LeadStageHistoryKey
	LEFT OUTER JOIN tClientDivision cd(NOLOCK) ON l.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct cp(NOLOCK) ON l.ClientProductKey = cp.ClientProductKey
GO
