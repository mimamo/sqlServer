USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Campaign]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Campaign]
AS

/*
|| When      Who Rel     What
|| 02/04/08 GHL 8.5     (20216)  At Mike's request:
||                                                Removed Media Net, Media Gross 
||                                                Added Open Orders Net, Open Orders Gross
||                                                Calculating  existing fields which are 0 in tables
|| 02/21/11 RLB 10.541  (104257) Now pulling Campaign Budget Net and Gross from the Campaign
|| 05/24/11 GHL 10.544  Added Bill By field
|| 06/24/11 RLB 10.545  (114867) Added Campaign Budget Hours, Labor and Expense
|| 07/21/11 RLB 10.546  (96065) Added Primary Contact 
|| 09/14/11 RLB 10.548  (121333) change to pull primary contact from campaign instead of company
|| 02/07/12 MFT 10.552  (131577) Added Client ID
|| 04/26/12 GHL 10.555  Added GLCompanyKey for map/restrict + GL company info
|| 10/08/13 GHL 10.573  Added Currency ID to support multiple currencies
|| 10/17/14 GAR 10.585  Added client product name and client division name to list.
*/

SELECT
	 ca.AEKey
	,ca.ClientKey
	,ca.CampaignKey 
	,ca.CompanyKey 
	,ca.GLCompanyKey
	,ca.CustomFieldKey
	,ca.CampaignName AS [Name]     
	,ca.EndDate AS [End Date]
	,ca.StartDate AS [Start Date]
	,ca.Objective AS [Objective]
	,ca.Description AS [Description]
	,ca.CampaignID AS [ID]
	,c.CompanyName AS [Client Name]
	,c.CustomerID AS [Client ID]
	,glc.GLCompanyName AS [Company Name]
	,glc.GLCompanyID AS [Company ID]
	,u.FirstName + ' ' + u.LastName AS [AE Full Name]
	,pcu.FirstName + ' ' + pcu.LastName AS [Primary Contact]
	,case when ca.BillBy = 2 then 'Campaign' else 'Project' end as [Bill By]
	,case when ca.MultipleSegments = 1 then 'YES' else 'NO' end as [Use Segments]
	, ISNULL(ca.BudgetLabor, 0) + ISNULL(ca.BudgetExpenses, 0) + ISNULL(ca.ApprovedCOBudgetLabor, 0) + ISNULL(ca.ApprovedCOBudgetExp, 0 ) AS [Campaign Budget Net]
	, ISNULL(ca.EstLabor, 0) + ISNULL(ca.EstExpenses, 0) + ISNULL(ca.ApprovedCOLabor, 0) + ISNULL(ca.ApprovedCOExpense, 0) AS [Campaign Budget Gross]
	, ISNULL(ca.EstHours, 0) + ISNULL(ca.ApprovedCOHours, 0) as [Campaign Budget Hours]
	, ISNULL(ca.EstLabor, 0) + ISNULL(ca.ApprovedCOLabor, 0) as [Campaign Budget Labor Gross]
	, ISNULL(ca.BudgetLabor, 0) + ISNULL(ca.ApprovedCOBudgetLabor, 0) as [Campaign Budget Labor Net]
	, ISNULL(ca.EstExpenses, 0) + ISNULL(ca.ApprovedCOExpense, 0) as [Campaign Budget Expense Gross]
	, ISNULL(ca.BudgetExpenses, 0) + ISNULL(ca.ApprovedCOBudgetExp, 0) as [Campaign Budget Expense Net]	
	,case when ca.Active = 1 then 'YES' else 'NO' end AS [Active] 
	, ca.CurrencyID as [Currency]
	,ISNULL((
		SELECT SUM(bud.Qty)
		FROM    tCampaignBudget bud (NOLOCK)		
		WHERE bud.CampaignKey = ca.CampaignKey
	 ),0)  AS [Campaign Budget Qty]
	,ISNULL((
		SELECT SUM(roll.VoucherNet)
		FROM    tProjectRollup roll (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey		
		WHERE p.CampaignKey = ca.CampaignKey
	 ),0)  AS [Outside Expense Net]
	,ISNULL((
		SELECT SUM(roll.VoucherGross)
		FROM    tProjectRollup roll (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey		
		WHERE p.CampaignKey = ca.CampaignKey
	 ),0)  AS [Outside Expense Gross]
	
	,ISNULL((
		SELECT SUM(roll.OpenOrderNet)
		FROM    tProjectRollup roll (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey		
		WHERE p.CampaignKey = ca.CampaignKey
	 ),0)  AS [Open Orders Net]
	,ISNULL((
		SELECT SUM(roll.OpenOrderGross)
		FROM    tProjectRollup roll (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey		
		WHERE p.CampaignKey = ca.CampaignKey
	 ),0)  AS [Open Orders Gross]

	,ISNULL((
		SELECT ISNULL(SUM(p.EstHours), 0) + ISNULL(SUM(p.ApprovedCOHours), 0)
		FROM tProject p (NOLOCK)
		WHERE p.CampaignKey = ca.CampaignKey
	),0)  AS [Budget Labor Hours]
	
	,ISNULL((
		SELECT ISNULL(SUM(p.EstLabor), 0) + ISNULL(SUM(p.ApprovedCOLabor), 0)
		FROM tProject p (NOLOCK)
		WHERE p.CampaignKey = ca.CampaignKey
	),0)  AS [Labor Budget]
	,ISNULL((
		SELECT SUM(roll.LaborGross)
		FROM    tProjectRollup roll (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey		
		WHERE p.CampaignKey = ca.CampaignKey
	 ),0)  AS [Labor Gross]
	,ISNULL((
		SELECT SUM(roll.Hours)
		FROM    tProjectRollup roll (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON roll.ProjectKey = p.ProjectKey		
		WHERE p.CampaignKey = ca.CampaignKey
	 ),0)  AS [Labor Hours]
	 ,clp.ProductName AS [Client Product Name]
	 ,cld.DivisionName AS [Client Division Name]


FROM         
	tCampaign ca 
	LEFT OUTER JOIN tCompany c (nolock) ON ca.ClientKey = c.CompanyKey 
	LEFT OUTER JOIN tUser u (nolock) ON ca.AEKey = u.UserKey
	LEFT OUTER JOIN tUser pcu (nolock) ON ca.ContactKey = pcu.UserKey
	LEFT OUTER JOIN tGLCompany glc (nolock) on ca.GLCompanyKey = glc.GLCompanyKey
	LEFT OUTER JOIN tClientProduct clp (nolock) on ca.ClientProductKey = clp.ClientProductKey
	LEFT OUTER JOIN tClientDivision cld (nolock) on ca.ClientDivisionKey = cld.ClientDivisionKey
GO
