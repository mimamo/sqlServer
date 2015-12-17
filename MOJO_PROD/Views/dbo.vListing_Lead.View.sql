USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Lead]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Lead]
AS

/*
  || When     Who Rel      What
  || 10/13/06 WES 8.3567   Added Custom Fields Key
  || 02/09/09 GWG 10.5	   Made cmfolderkey force to 0 so that a no folder check can be made.
  || 03/11/09 MAS 10.5	   Added Last and Next Activity columns, renamed columns, removed user_defined columns.
  || 04/03/09 GWG 10.5     Minor fixes to views
  || 04/30/09 CRG 10.5.0.0 Added Next/Last Activity Types, Days Since Last Activity, and No Activity Since.
  ||                       Removed = from column aliases because it caused problems in listings.
  || 05/18/09 MAS 10.5.0.0 Changed Stage to Left Outer join
  || 08/05/09 GWG 10.5.0.6 Fixed the Owner Name to come from the correct place
  || 08/15/09 GWG 10.5.0.7 Added Lead custom field for access to the user defined fields
  || 09/30/09 GWG 10.5.1.1 Fixed join out to tCMFolder to be based on Lead, not company
  || 10/09/09 GHL 10.5.1.2 (59665) Added DateAdded
  || 02/08/09 GWG 10.5.1.8 Fixed joins out to non required tables (status, stage, acct mgr)
  || 03/08/10 RLB 10.5.1.9 (76113)Account Manager is pulled from lead Company Keys Account Manager
  || 03/10/10 RLB 10.5.2.0 Add padding to Forecasted and Actual close month 
  || 06/11/10 RLB 10.5.3.1 (67960) Added Date Modified enhancement
  || 04/22 11 RLB 10.5.4.3 (109575) Fixed join on tLeadStageHistory 
  || 05/9/11  GWG 10.5.4.3 Fixed the fix to the join on tLeadStageHistory
  || 07/15/11 GWG 10.5.4.6 Added Converted to Type and Converted To (project name or campaign)
  || 11/07/11 RLB 10.5.5.0 (125619) Added for protection
  || 12/08/11 RLB 10.5.5.1 (113208) Added Primary Contact email
  || 02/14/12 MFT 10.5.5.2 (99506) Added ParentCompany
  || 06/21/12 GHL 10.5.5.7 Added GL Company info
  || 09/20/12 GWG 10.5.6.0 Added the sale amount to the view
  || 01/28/13 WDF 10.5.6.4 (165956) Modified Date Created
  || 10/02/13 MAS 10.5.7.3 (179034) Added ClientDivisionKey & ClientProductKey
  || 04/15/15 RLB 10.5.9.1 Added companies contactownerkey it is used in Plat for opp count
*/

SELECT 
	 tLead.CompanyKey
	,tLead.GLCompanyKey
	,ISNULL(tLead.CMFolderKey, 0) as CMFolderKey
	,tCompany.CustomFieldKey
	,tLead.CustomFieldKey as LeadCustomFieldKey
	,tLead.LeadKey
	,tLead.ContactCompanyKey
	,tLead.ContactKey
	,tLead.AccountManagerKey
	,tLead.Subject
	,tUser.FirstName + ' ' + tUser.LastName as ContactName
	,tCompany.CompanyName
	,tLead.Subject AS [Opportunity Name]
	,tCompany.CompanyName as [Company Name]
	,tCompany.CustomerID as [Company Client ID]
	,CASE when tCompany.BillableClient = 1 then 'YES' else 'NO' end AS [Billable Client]
	,tUser.FirstName + ' ' + tUser.LastName AS [Primary Contact Name]
	,tUser.Email AS [Primary Contact Email]
	,am.FirstName + ' ' + am.LastName AS [Account Manager Name]
	,ISNULL(tUser.FirstName,'') + ' ' + ISNULL(tUser.LastName, '') AS [User Full Name]
	,tProjectType.ProjectTypeName AS [Project Type Name]
	,CASE when tLeadStatus.Active = 1 then 'YES' else 'NO' end AS [Active]
	,cast(tLeadStage.DisplayOrder as varchar) + ' - ' + tLeadStage.LeadStageName AS [Stage Name]
	,tLeadStage.DisplayOrder AS [Stage Display Order]
	,tLeadOutcome.Outcome AS [Outcome]
	,tLeadStatus.LeadStatusName AS [Status]
	,tCompanyType.CompanyTypeName as [Company Type]
	,tLead.OutcomeComment AS [Outcome Comment]
	,tLead.CurrentStatus as [Next Steps]
	,tLead.Probability AS [Probability]
	,tLead.Labor as [Labor Amount]
	,tLead.SaleAmount as [Sale Amount]
	,tLead.SaleAmount * tLead.Probability / 100 AS [Forecasted Sale Amount]
	,tLead.OutsideCostsGross AS [Production Gross]
	,tLead.OutsideCostsPerc as [Production Margin]
	,tLead.MediaGross as [Media Gross]
	,tLead.MediaPerc as [Media Margin]
	,tLead.OutsideCostsGross * OutsideCostsPerc / 100 as [Production Net]
	,tLead.MediaGross * MediaPerc / 100 as [Media Net]
	,tLead.AGI as [AGI]
	,tLead.DateUpdated as [Date Modified]
	,tLead.StartDate as [Start Date]
	,tLead.DateAdded as [Date Created]
	,tLead.EstCloseDate as [Forecasted Close Date]
	,tLead.BidDate as [Estimate Due Date]
	,tLead.DateConverted as [Date Converted]
	,DATEPART("YYYY", tLead.EstCloseDate) AS [Forecasted Close Year]
	,RIGHT('0' + CAST(DATEPART(Month, tLead.EstCloseDate) AS VARCHAR(2)), 2) AS [Forecasted Close Month]
	,tLead.ActualCloseDate AS [Actual Close Date]
	,DATEPART("YYYY", tLead.ActualCloseDate) AS [Actual Close Year]
	,RIGHT('0' + CAST(DATEPART(Month, tLead.ActualCloseDate) AS VARCHAR(2)), 2) AS [Actual Close Month]
	,CAST(tLead.Comments AS VARCHAR(8000)) AS [Description]
	-- WWP
	,CASE tLead.WWPCurrentLevel
		WHEN 2 THEN '2 - Contemplating'
		WHEN 3 THEN '3 - Planning'
		WHEN 4 THEN '4 - Action'
		ELSE '1 - Unaware'
	END AS [WWP Current Level w Name]
	, tLead.WWPCurrentLevel as [WWP Current Level]
	,CASE WHEN tLead.WWPNeedSupply = 1 THEN 'YES' ELSE 'NO' END AS [WWP Needs Equals Supply]
	,tLead.WWPNeedSupplyComment AS [WWP Needs Equals Supply Comment]
	,CASE WHEN tLead.WWPTimeline = 1 THEN 'YES' ELSE 'NO' END AS [WWP Timeline]
	,tLead.WWPTimelineComment AS [WWP Timeline Comment]
	,CASE WHEN tLead.WWPDecisionMakers = 1 THEN 'YES' ELSE 'NO' END AS [WWP Decision Makers]
	,tLead.WWPDecisionMakersComment AS [WWP Decision Makers Comment]
	,CASE WHEN tLead.WWPBudget = 1 THEN 'YES' ELSE 'NO' END AS [WWP Budget]
	,tLead.WWPBudgetComment AS [WWP Budget Comment]
	,ISNULL(owner.FirstName,'') + ' ' + ISNULL(owner.LastName,'') as [Company Owner]
	,ISNULL(sales.FirstName,'') + ' ' + ISNULL(sales.LastName,'') AS [Sales Person]
	,CASE WHEN lo.PositiveOutcome = 1 THEN 'YES' ELSE 'NO' END AS [Positive Outcome Indicator]
	,tLead.Competitors AS [Competitors]
	,(Select Max(HistoryDate) from tLeadStageHistory (NOLOCK) Where tLead.LeadKey = tLeadStageHistory.LeadKey)  AS [Stage Date]
	,ISNULL(tUser1.FirstName,'') + ' ' + ISNULL(tUser1.LastName, '') AS [Opportunity Owner Name]
	,so.SourceName AS [Company Source]
	,folder.FolderName AS [Folder]

	,lastActivity.ActivityDate AS [Last Activity Date]
	,lastActivity.Subject AS [Last Activity Subject]
	,ISNULL(lau.FirstName,'') + ' ' + ISNULL(lau.LastName,'') AS [Last Activity Assigned To]

	,nextActivity.ActivityDate AS [Next Activity Date]
	,nextActivity.Subject AS [Next Activity Subject]
	,ISNULL(nau.FirstName,'') + ' ' + ISNULL(nau.LastName,'') AS [Next Activity Assigned To]
	 ,atNext.TypeName AS [Next Activity Type]
	 ,atLast.TypeName AS [Last Activity Type]
	 ,DATEDIFF(day, lastActivity.ActivityDate, GETDATE()) AS [Days Since Last Activity]
	 ,CASE
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
	  END as [Converted To]
	,pc.CompanyName as [Parent Company Name]
	,pc.ContactOwnerKey
    ,glc.GLCompanyID as [GL Company ID]
    ,glc.GLCompanyName as [GL Company Name]
    ,cd.ClientDivisionKey
    ,cd.DivisionName as [Division Name]
    ,cp.ClientProductKey
    ,cp.ProductName as [Product Name]
FROM tLead
	INNER JOIN tCompany (nolock) ON tLead.ContactCompanyKey = tCompany.CompanyKey
	LEFT OUTER JOIN	tCompany pc (nolock) ON tCompany.ParentCompany = pc.CompanyKey
	LEFT OUTER JOIN tLeadStatus (nolock) ON tLead.LeadStatusKey = tLeadStatus.LeadStatusKey
	LEFT OUTER JOIN tLeadStage (nolock) ON tLead.LeadStageKey = tLeadStage.LeadStageKey
	LEFT OUTER JOIN tUser tUser1 (nolock) ON tLead.AccountManagerKey = tUser1.UserKey
	LEFT OUTER JOIN tUser (nolock) ON tLead.ContactKey = tUser.UserKey
	Left OUTER JOIN tUser am (nolock) ON tCompany.AccountManagerKey = am.UserKey
	LEFT OUTER JOIN tLeadOutcome (nolock) ON tLead.LeadOutcomeKey = tLeadOutcome.LeadOutcomeKey
	LEFT OUTER JOIN tProjectType (nolock) ON tLead.ProjectTypeKey = tProjectType.ProjectTypeKey
	LEFT OUTER JOIN tCompanyType (nolock) on tCompany.CompanyTypeKey = tCompanyType.CompanyTypeKey
	LEFT OUTER JOIN tActivity lastActivity (NOLOCK) on tLead.LastActivityKey = lastActivity.ActivityKey
	LEFT OUTER JOIN tUser lau (NOLOCK) ON lastActivity.AssignedUserKey = lau.UserKey
	LEFT OUTER JOIN tActivity nextActivity (NOLOCK) on tLead.NextActivityKey = nextActivity.ActivityKey
	LEFT OUTER JOIN tUser nau (NOLOCK) ON nextActivity.AssignedUserKey = nau.UserKey
	LEFT OUTER JOIN tUser sales (NOLOCK) ON tCompany.SalesPersonKey = sales.UserKey
	LEFT OUTER JOIN tLeadOutcome lo (NOLOCK) ON tLead.LeadOutcomeKey = lo.LeadOutcomeKey
	LEFT OUTER JOIN tUser owner (NOLOCK) ON tCompany.ContactOwnerKey = owner.UserKey
	LEFT OUTER JOIN tCMFolder folder (NOLOCK) on tLead.CMFolderKey = folder.CMFolderKey
	LEFT OUTER JOIN	tSource so (NOLOCK) on tCompany.SourceKey = so.SourceKey
	LEFT OUTER JOIN tActivityType atNext (NOLOCK) ON nextActivity.ActivityTypeKey = atNext.ActivityTypeKey
	LEFT OUTER JOIN tActivityType atLast (NOLOCK) ON lastActivity.ActivityTypeKey = atLast.ActivityTypeKey
	LEFT OUTER JOIN tGLCompany glc (NOLOCK) ON tLead.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tClientDivision cd(NOLOCK) ON tLead.ClientDivisionKey = cd.ClientDivisionKey
	LEFT OUTER JOIN tClientProduct cp(NOLOCK) ON tLead.ClientProductKey = cp.ClientProductKey
GO
