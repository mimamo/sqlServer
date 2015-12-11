USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_Estimate]    Script Date: 12/11/2015 15:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vReport_Estimate]
AS

/*
|| When      Who Rel      What
|| 10/11/07  CRG 8.5      Added GLCompany, Class, and Office
|| 01/07/08  GWG 8.51	  Added Project Desc and Status
|| 08/25/08  RTC 10.0.0.7 (33238) Added CustomFieldKey
|| 10/08/09  GHL 10.512   (55821) Added Project Type
|| 03/03/10  RLB 10.519   (75902) Added Account Manager to the Estimate Data set
|| 03/03/10  GHL 10.519   Changed join with tProject
|| 04/21/10  RLB 10.521   (76613) Added Estimate User Defined fields to Data set
|| 10/26/10  RLB 10.537   (79435) Added Company Type 
|| 04/24/12  GHL 10.555   Added GLCompanyKey in order to map/restrict
|| 04/26/12  GHL 10.555   Get GLCompanyKey from campaign when the estimate is by campaign
||                        Corrected client (from campaign or project)
|| 06/22/12 GHL 10.557    For opportunities get GL Company Key from tLead 
||                        because of new field tLead.GLCompanyKey
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 02/28/13 GHL 10.565    (169659) Added project billing status
|| 08/01/14  WDF 10.5.8.3 (224360) Added Entered By Name
|| 01/27/15  WDF 10.5.8.8 (Abelson Taylor) Added Division and Product

*/

Select
	 e.EstimateKey
	,p.CustomFieldKey
	,e.CompanyKey
	,case when e.ProjectKey > 0 then glcP.GLCompanyKey 
	      when e.CampaignKey > 0 then glcC.GLCompanyKey
	      when e.LeadKey > 0 then glcO.GLCompanyKey
	      else NULL end as GLCompanyKey      
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.Description as [Project Description]
	,ps.ProjectStatus as [Project Status]
	,pbs.ProjectBillingStatus as [Project Billing Status]
    ,pt.ProjectTypeName as [Project Type]
	,case when e.ProjectKey > 0 then clP.CustomerID 
	      when e.CampaignKey > 0 then clC.CustomerID
	      else NULL end as [Client ID]
	,case when e.ProjectKey > 0 then clP.CompanyName 
	      when e.CampaignKey > 0 then clC.CompanyName
	      else NULL end as [Client Name]
	,ct.CompanyTypeName as [Company Type]
	,e.EstimateName as [Estimate Name]
	,e.EstimateNumber as [Estimate Number]
	,e.DeliveryDate as [Estimated Delivery Date]
	,e.EstimateDate as [Estimate Date]
	,e.Revision
	,Case EstType When 1 Then 'Tasks Only' When 2 then 'Task and Service' When 3 then 'Task and Person' When 4 then 'Services Only' end as [Estimate Type]
	,e.EstDescription as [Estimate Description]
	,et.TemplateName as [Template]
	,st1.SalesTaxName as [Sales Tax 1]
	,e.SalesTaxAmount as [Sales Tax 1 Amount]
	,st2.SalesTaxName as [Sales Tax 2]
	,e.SalesTax2Amount as [Sales Tax 2 Amount]
	,Case e.LaborTaxable When 1 Then 'YES' else 'NO' end as [Labor is Taxable]
	,e.Contingency as [Contingency Percentage]
	,Case e.ChangeOrder When 1 Then 'YES' else 'NO' end as [Change Order]
	,Case 
		WHEN	((ISNULL(ExternalApprover, 0) > 0 AND ExternalStatus = 4) 
			Or	 (ISNULL(ExternalApprover, 0) = 0 AND InternalStatus = 4)) THEN 'YES'
		ELSE 'NO' END AS Approved
	,ia.FirstName + ' ' + ia.LastName as [Internal Approver]
	,case e.InternalStatus When 1 then 'Not Sent For Approval' When 2 Then 'Sent For Approval' When 3 then 'Rejected' When 4 then 'Approved' end as [Internal Approval Status]
	,e.InternalApproval as [Internal Approval Date]
	,ea.FirstName + ' ' + ea.LastName as [External Approver]
	,case e.ExternalStatus When 1 then 'Not Sent For Approval' When 2 Then 'Sent For Approval' When 3 then 'Rejected' When 4 then 'Approved' end as [External Approval Status]
	,e.ExternalApproval as [External Approval Date]
	,am.FirstName + ' ' + am.LastName as [Account Manager]
	,ltrim(rtrim( isnull(eb.FirstName, '') + ' ' + isnull(eb.LastName, '')	))	AS [Entered By Name]
	,e.ApprovedQty as [Approved Option]
	,e.Expense1 as [Expense Option 1]
	,e.Expense2 as [Expense Option 2]
	,e.Expense3 as [Expense Option 3]
	,e.Expense4 as [Expense Option 4]
	,e.Expense5 as [Expense Option 5]
	,e.Expense6 as [Expense Option 6]
	,e.InternalComments as [Internal Approval Comments]
	,e.ExternalComments as [External Approval Comments]
	,Case e.MultipleQty When 1 Then 'YES' else 'NO' end as [Multiple Qty Option Estimate]
	,e.SalesTaxAmount as [Sales Tax Amount]
	,e.Hours as [Estimate Hours]
	,e.LaborGross as [Estimate Labor]
	,e.LaborNet as [Estimate Net Labor]
	,e.ExpenseNet as [Estimate Net Expenses]
	,e.ExpenseGross as [Estimate Gross Expenses]
	,e.TaxableTotal as [Estimate Tax]
	,e.ContingencyTotal as [Labor Contingency]
	,e.EstimateTotal + e.ContingencyTotal as [Total With Contingecy]
	,e.EstimateTotal + e.TaxableTotal as [Total With Tax]
	,e.EstimateTotal - e.ExpenseNet - e.TaxableTotal as [Estimate Gross Profit]
	,e.EstimateTotal - e.ExpenseNet - e.LaborNet as [Estimate Net Profit]
	,caC.CampaignID as [Campaign ID]
	,caC.CampaignName as [Campaign Name]
	,caC.Description as [Campaign Description]
	,caP.CampaignID as [Project Campaign ID]
	,caP.CampaignName as [Project Campaign Name]
	,caP.Description as [Project Campaign Description]
	,case when e.ProjectKey > 0 then glcP.GLCompanyID 
	      when e.CampaignKey > 0 then glcC.GLCompanyID
	      when e.LeadKey > 0 then glcO.GLCompanyID
	      else NULL end as [Company ID]
	,case when e.ProjectKey > 0 then glcP.GLCompanyName 
	      when e.CampaignKey > 0 then glcC.GLCompanyName
	      when e.LeadKey > 0 then glcO.GLCompanyName
	      else NULL end as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
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
	,p.ProjectKey
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
From 
	tEstimate e (nolock)
	left outer join tProject p (nolock) on e.ProjectKey = p.ProjectKey
	left outer join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
	left outer join tProjectBillingStatus pbs (nolock) on p.ProjectBillingStatusKey = pbs.ProjectBillingStatusKey
	left outer join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
	left outer join tCampaign caP (nolock) on p.CampaignKey = caP.CampaignKey
	left outer join tCampaign caC (nolock) on e.CampaignKey = caC.CampaignKey
	left outer join tCompany clP (nolock) on p.ClientKey = clP.CompanyKey
	left outer join tCompany clC (nolock) on caC.ClientKey = clC.CompanyKey
	left outer join tEstimateTemplate et (nolock) on e.EstimateTemplateKey = et.EstimateTemplateKey
	left outer join tSalesTax st1 (nolock) on e.SalesTaxKey = st1.SalesTaxKey
	left outer join tSalesTax st2 (nolock) on e.SalesTax2Key = st2.SalesTaxKey
	left outer join tUser ia (nolock) on e.InternalApprover = ia.UserKey
	left outer join tUser ea (nolock) on e.ExternalApprover = ea.UserKey
	left outer join tUser am (nolock) on p.AccountManager = am.UserKey
	left outer join tUser eb (nolock) on e.EnteredBy = eb.UserKey
	left outer join tClass cla (nolock) on p.ClassKey = cla.ClassKey
	left outer join tLead opp (nolock) on e.LeadKey = opp.LeadKey
	left outer join tGLCompany glcP (nolock) on p.GLCompanyKey = glcP.GLCompanyKey
	left outer join tGLCompany glcC (nolock) on caC.GLCompanyKey = glcC.GLCompanyKey
	left outer join tGLCompany glcO (nolock) on opp.GLCompanyKey = glcO.GLCompanyKey
	left outer join tOffice o (nolock) on p.OfficeKey = o.OfficeKey
	left outer join tCompanyType ct (nolock) on clP.CompanyTypeKey = ct.CompanyTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
