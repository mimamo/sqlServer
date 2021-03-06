USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Estimate]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_Estimate]
AS

/*
|| When     Who Rel     What
|| 10/16/06 WES 8.3567  Added Account Manager
|| 07/10/07 GHL 8.5     Added restriction on ERs
|| 10/10/07 CRG 8.5     Added GLCompany, Office, and Class
|| 01/22/10 MFT 10.517  Added Primary Contact
|| 03/03/10 GHL 10.519  Changed join with tProject
|| 03/15/10 RLB 10.520  Added Estimate User Defined fields
|| 11/23/11 RLB 10.550  (109439) Added Projected Hourly Rate and Projected Hourly Margin
|| 04/02/12 MFT 10.555  Added GLCompanyKey in order to map/restrict
|| 04/12/12 MFT 10.555  Changed the CompanyKey to tEstimate from tProject
|| 04/26/12 GHL 10.555  Added GLCompanyKey to map/restrict, fixed hourly rate margin
|| 06/01/12 GHL 10.556  Added Estimate Types: By Segment and Service/By Project Only
|| 06/22/12 GHL 10.557  For opportunities get GL Company Key from tLead 
||                      because of new field tLead.GLCompanyKey
|| 11/26/12 GHL 10.562  Added Include In Forecast field
|| 02/28/13 GHL 10.565  (169659) Added Actual Net Expense and Project Billing Status
|| 05/01/13 RLB 10.567  (176032) Added Estimate Gross Profit % and Net Profit %
|| 10/22/13 GWG 10.573  Amount Billed is now the amount tied to the specific estimate
|| 10/22/13 GWG 10.573  and of course, 10 min later, someone complained so adding back the project amt billed
|| 08/01/14 WDF 10.583  (224360) Added Entered By Name
|| 10/29/14 WDF 10.585  (234404) Added ClientKey, Client ID and Client Name for Opportunities
|| 01/27/15 WDF 10.588  (Abelson Taylor) Added Division and Product
|| 03/06/15 GHL 10.590  (Abelson Taylor) Added new estimate types by titles
*/

Select
	e.EstimateKey
	,e.CompanyKey
	,p.ProjectKey
	,case when e.ProjectKey > 0 then p.ClientKey 
	      when e.CampaignKey > 0 then cmC.ClientKey
	      when e.LeadKey > 0 then case cld.BillableClient
	                                 when 1 then cld.CompanyKey
	                                 else null end
	      else NULL end as ClientKey      
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,case when e.ProjectKey > 0 then cP.CustomerID 
	      when e.CampaignKey > 0 then cC.CustomerID
	      when e.LeadKey > 0 then case cld.BillableClient
	                                 when 1 then cld.CustomerID
	                                 else null end
	      else NULL end as [Client ID]
	,case when e.ProjectKey > 0 then cP.CompanyName 
	      when e.CampaignKey > 0 then cC.CompanyName
	      when e.LeadKey > 0 then case cld.BillableClient
	                                 when 1 then cld.CompanyName
	                                 else null end
	      else NULL end as [Client Name]
	,Case Closed When 1 then 'YES' else 'NO' end as [Closed Project]
	,Case e.ChangeOrder When 1 then 'YES' else 'NO' end as [Change Order]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
	,p.ClientProjectNumber [Client Project Number]
	,e.EstimateName as [Estimate Name]
	,e.EstimateNumber as [Estimate Number]
	,e.Revision as [Revision]
	,e.DeliveryDate as [Estimated Delivery Date]
	,e.EstimateDate as [Estimate Date]
	,e.DateAdded as [Date Created]
	,ltrim(rtrim( isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '')	))	AS [Entered By Name]
	,case 
	when isnull(e.ExternalApprover, 0) > 0 and e.ExternalStatus = 4 then 'Yes'
	when isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4 then 'Yes'
	else 'No'
	end as Approved
	,Case EstType
		When 1 Then 'By Task'
		When 2 then 'By Task and Service'
		When 3 then 'By Task and Person' 
		When 4 then 'By Service' 
		When 5 then 'By Segment and Service' 
		When 6 then 'By Project Only' 
		When 7 then 'By Title Only' 
		When 8 then 'By Segment and Title' 
		end as [Estimate Type]
	,ia.FirstName + ' ' + ia.LastName as [Internal Approver]
	,case e.InternalStatus When 1 then 'Not Sent For Approval' When 2 Then 'Sent For Approval' When 3 then 'Rejected' When 4 then 'Approved' end as [Internal Approval Status]
	,e.InternalApproval as [Internal Approval Date]
	,ea.FirstName + ' ' + ea.LastName as [External Approver]
	,case e.ExternalStatus When 1 then 'Not Sent For Approval' When 2 Then 'Sent For Approval' When 3 then 'Rejected' When 4 then 'Approved' end as [External Approval Status]
	,e.ExternalApproval as [External Approval Date]
	,e.EstDescription as [Estimate Description]
	,et.TemplateName as [Estimate Template]
	,st.SalesTaxName as [Sales Tax]
	,e.SalesTaxAmount as [Sales Tax Amount]
	,(Select ISNULL(Sum(ActualHours), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Hours]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor]
	,(Select ISNULL(Sum(ROUND(ActualHours * CostRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey) as [Actual Labor Cost]
	,(Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and tExpenseReceipt.VoucherDetailKey is null) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey) as [Actual Billable Expense]
	,(Select ISNULL(Sum(TotalCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey) + 
	 (Select ISNULL(Sum(ActualCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey and tExpenseReceipt.VoucherDetailKey is null) + 
	 (Select ISNULL(Sum(TotalCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey) as [Actual Net Expense]
	,(Select ISNULL(Sum(ROUND(ActualHours * ActualRate, 2)), 0) from tTime (nolock) Where tTime.ProjectKey = p.ProjectKey and WriteOff = 1) +
	 (Select ISNULL(Sum(BillableCost), 0) from tMiscCost (nolock) Where tMiscCost.ProjectKey = p.ProjectKey and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tExpenseReceipt (nolock) Where tExpenseReceipt.ProjectKey = p.ProjectKey  and tExpenseReceipt.VoucherDetailKey is null and WriteOff = 1) + 
	 (Select ISNULL(Sum(BillableCost), 0) from tVoucherDetail (nolock) Where tVoucherDetail.ProjectKey = p.ProjectKey and WriteOff = 1) as [Transaction Writeoff Amount]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) Where tInvoiceLine.EstimateKey = e.EstimateKey) as [Amount Billed]
	,(Select ISNULL(Sum(TotalAmount), 0) from tInvoiceLine (nolock) Where tInvoiceLine.ProjectKey = e.ProjectKey) as [Amount Billed Project Total]
	,e.Hours as [Estimate Hours]
	,e.LaborGross as [Estimate Labor]
	,CASE ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0) 
		WHEN 0 THEN 0
	 ELSE (ISNULL(p.EstLabor, 0) + ISNULL(p.ApprovedCOLabor, 0)) / (ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0))
	 END as [Project Hourly Rate]
	,CASE ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0)
		WHEN 0 THEN 0
	 ELSE ((p.EstLabor + p.ApprovedCOLabor + p.EstExpenses + p.ApprovedCOExpense) - (p.BudgetExpenses + p.ApprovedCOBudgetExp) - (p.BudgetLabor + p.ApprovedCOBudgetLabor)) / (ISNULL(p.EstHours, 0) + ISNULL(p.ApprovedCOHours, 0))
	 END as [Project Hourly Margin]
	,e.LaborNet as [Estimate Net Labor]
	,e.ExpenseNet as [Estimate Net Expenses]
	,e.ExpenseGross as [Estimate Gross Expenses]
	,e.TaxableTotal as [Estimate Tax]
	,e.ContingencyTotal as [Labor Contingency]
	,e.EstimateTotal + e.ContingencyTotal as [Total With Contingecy]
	,e.EstimateTotal + e.TaxableTotal as [Total With Tax]
	,e.EstimateTotal - e.ExpenseNet - e.TaxableTotal as [Estimate Gross Profit]
	,CASE ISNULL(e.EstimateTotal, 0) 
		WHEN 0 THEN 0
	 ELSE ((ISNULL(e.EstimateTotal, 0) - ISNULL(e.ExpenseNet, 0) - ISNULL(e.TaxableTotal, 0)) * 100)/ ISNULL(e.EstimateTotal, 0)
	 END as [Estimate Gross Profit Percent]
	,e.EstimateTotal - e.ExpenseNet - e.LaborNet as [Estimate Net Profit]
	,CASE ISNULL(e.EstimateTotal, 0) 
		WHEN 0 THEN 0
	 ELSE ((ISNULL(e.EstimateTotal, 0) - ISNULL(e.ExpenseNet, 0) - ISNULL(e.LaborNet, 0)) * 100)/ ISNULL(e.EstimateTotal, 0)
	 END as [Estimate Net Profit Percent]
	,e.EstimateTotal as [Estimate Total]
	,cmC.CampaignID as [Campaign ID]
	,cmC.CampaignName as [Campaign Name]
	,cmP.CampaignID as [Project Campaign ID]
	,cmP.CampaignName as [Project Campaign Name]
	,am.FirstName + ' ' + am.LastName AS [Account Manager]
	,pc.FirstName + ' ' + pc.LastName AS [Primary Contact]
	,case when e.ProjectKey > 0 then glcP.GLCompanyID 
	      when e.CampaignKey > 0 then glcC.GLCompanyID
	      when e.LeadKey > 0 then glcO.GLCompanyID
	      else NULL end as [Company ID]
	,case when e.ProjectKey > 0 then glcP.GLCompanyName 
	      when e.CampaignKey > 0 then glcC.GLCompanyName
	      when e.LeadKey > 0 then glcO.GLCompanyName
	      else NULL end as [Company Name]
	,case when e.ProjectKey > 0 then glcP.GLCompanyKey 
	      when e.CampaignKey > 0 then glcC.GLCompanyKey
	      when e.LeadKey > 0 then glcO.GLCompanyKey
	      else NULL end as GLCompanyKey      
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,e.UserDefined1 as [Estimate User Defined 1]
	,e.UserDefined2 as [Estimate User Defined 2]
	,e.UserDefined3 as [Estimate User Defined 3]
	,e.UserDefined4 as [Estimate User Defined 4]
	,e.UserDefined5 as [Estimate User Defined 5]
	,e.UserDefined6 as [Estimate User Defined 6]
	,e.UserDefined7 as [Estimate User Defined 7]
	,e.UserDefined8 as [Estimate User Defined 8]
	,e.UserDefined9 as [Estimate User Defined 9]
	,e.UserDefined10 as [Estimate User Defined 10]
	,case when isnull(e.IncludeInForecast, 0) = 1 then 'Yes' else 'No' end as [Include In Forecast]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cpr.ProductID as [Client Product ID]
    ,cpr.ProductName as [Client Product]
From 
	tEstimate e (nolock)
	left outer join tProject p (nolock) on e.ProjectKey = p.ProjectKey
	left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tCampaign cmP (nolock) on p.CampaignKey = cmP.CampaignKey
	left outer join tCampaign cmC (nolock) on e.CampaignKey = cmC.CampaignKey
	left outer join tLead l (nolock) on e.LeadKey = l.LeadKey
	left outer join tCompany cP (nolock) on p.ClientKey = cP.CompanyKey
	left outer join tCompany cC (nolock) on cmC.ClientKey = cC.CompanyKey
	left outer join tCompany cld (nolock) on l.ContactCompanyKey = cld.CompanyKey
	left outer join tEstimateTemplate et (nolock) on e.EstimateTemplateKey = et.EstimateTemplateKey
	left outer join tSalesTax st (nolock) on e.SalesTaxKey = st.SalesTaxKey
	left outer join tUser u (nolock) on e.EnteredBy = u.UserKey
	left outer join tUser ia (nolock) on e.InternalApprover = ia.UserKey
	left outer join tUser ea (nolock) on e.ExternalApprover = ea.UserKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tUser pc (nolock) on e.PrimaryContactKey = pc.UserKey
	left outer join tClass cl (nolock) on p.ClassKey = cl.ClassKey
	left outer join tLead opp (nolock) on e.LeadKey = opp.LeadKey
	left outer join tGLCompany glcP (nolock) on p.GLCompanyKey = glcP.GLCompanyKey
	left outer join tGLCompany glcC (nolock) on cmC.GLCompanyKey = glcC.GLCompanyKey
	left outer join tGLCompany glcO (nolock) on opp.GLCompanyKey = glcO.GLCompanyKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cpr (nolock) on p.ClientProductKey  = cpr.ClientProductKey
GO
