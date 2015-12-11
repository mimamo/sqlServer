USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_PurchaseOrder]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_PurchaseOrder]
AS

/*
|| When     Who Rel    What
|| 11/7/06  CRG 8.35   Modified the Amount Invoiced column to use AmountBilled.
|| 10/10/07 CRG 8.5    Added Class and GLCompany
|| 11/26/08 GHL 10.013 (41231) Setting now Amount Open = 0 when the PO is closed
|| 12/29/11 MFT 10.551  (90601) Added Date Updated column
|| 03/15/12 GHL 10554   Added estimate info
|| 04/02/12 MFT 10.555  Added GLCompanyKey in order to map/restrict
|| 05/04/12 RLB 10.555 (142400) Added ClientID and Client Name
|| 04/05/13 GWG 10.566  Changed amount invoiced to the voucher side and added amount billed
|| 01/20/14 GHL 10.576 (197214) Added Order Description
|| 03/04/14 GHL 10.578  Added currency
|| 03/20/14 GHL 10.578  Added Exchange Rate
|| 12/29/14 GHL 10.587 (240381) When calculating AmountBilled, check that InvoiceLineKey > 0
|| 01/27/15 WDF 10.588 (Abelson Taylor) Added Division and Product
|| 04/22/15 WDF 10.591 (254214) Added DownloadDate
*/

SELECT 
	 po.PurchaseOrderKey
	,po.CompanyKey
	,po.CustomFieldKey
	,c.CompanyKey as VendorKey
	,po.PurchaseOrderNumber AS [PO Number]
	,c.VendorID AS [Vendor ID]
	,c.CompanyName AS [Vendor Name]
	,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
	,po.Contact AS [Vendor Contact]
	,po.Address1 AS [Address 1]
	,po.Address2 AS [Address 2]
	,po.Address3 AS [Address 3]
	,po.City AS [Address City]
	,po.State AS [Address State]
	,po.PostalCode AS [Address Postal Code]
	,po.Country AS [Address Country]
	,po.DateCreated AS [Date Created]
	,po.DateUpdated AS [Date Updated]
	,po.PODate AS [PO Date]
	,po.DueDate AS [Due Date]
	,po.OrderedBy AS [Ordered By]
	,po.SpecialInstructions AS [Special Instructions]
	,po.DeliveryInstructions AS [Delivery Instructions]
	,po.DeliverTo1 AS [Deliver To 1]
	,po.DeliverTo2 AS [Deliver To 2]
	,po.DeliverTo3 AS [Deliver To 3]
	,po.DeliverTo4 AS [Deliver To 4]
	,po.Revision AS [PO Revision Number]
	,po.ApprovedDate AS [Approved Date]
	,Case When po.Closed = 1 then 'Closed' else 
		case po.Status 
			when 1 then 'Not Sent For Approval'
			when 2 then 'Sent for Approval'
			when 3 then 'Rejected'
			when 4 then 'Open Approved' end 
		end as [Status]
	,case po.Closed when 1 then 'YES' else 'NO' end as [Closed]
	,case po.Downloaded when 1 then 'YES' else 'NO' end as [Downloaded]
	,po.DownloadDate as [Download Date]
	,Case When pot.PurchaseOrderTypeName is NULL then 'General' else pot.PurchaseOrderTypeName end as [Order Type]
	,case ISNULL(po.Printed, 0) when 1 then 'YES' else 'NO' end as [Printed]
	,pod.TotalCost as [Amount Net]
	,pod.BillableCost as [Amount Gross]
	,pod.AmountBilled as [Amount Billed]
	,pod.AppliedCost as [Amount Invoiced]
	,case po.Closed when 1 then 0 else ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0) end as [Amount Open]
	,u.FirstName + ' ' + u.LastName as [Selected Approver]
	,uc.FirstName + ' ' + uc.LastName as [Created By]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,(SELECT MIN(DetailOrderDate) FROM tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey) as [Detail Order Date]  
	,(SELECT MAX(DetailOrderEndDate) FROM tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey) as [Detail Order End Date]  
	,glc.GLCompanyKey
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,cc.CustomerID AS [Client ID]
    ,cc.CompanyName AS [Client Name]
	
	,e.EstimateName as [Estimate Name]
	,case when e.ProjectKey > 0		then 'Project' 
	     when e.CampaignKey > 0		then 'Campaign'
		 when e.LeadKey > 0			then 'Opportunity'
	end as [Estimate Entity]
	,case when e.ProjectKey > 0		then cast(ep.ProjectNumber + ' - ' + ep.ProjectName as varchar(255))
	     when e.CampaignKey > 0		then cast(ec.CampaignID + ' - ' + ec.CampaignName as varchar(255))
		 when e.LeadKey > 0			then cast(el.Subject as varchar(255))
	end as [Estimate Entity Name]
	,po.[Description] as [Order Description]
	,po.CurrencyID as Currency
	,po.ExchangeRate as [Exchange Rate]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
    INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey 
	left outer join tUser u (nolock) on po.ApprovedByKey = u.UserKey
	left outer join tUser uc (nolock) on po.CreatedByKey = uc.UserKey
	left outer join tProject p (nolock) on po.ProjectKey = p.ProjectKey
	left outer join tPurchaseOrderType pot on po.PurchaseOrderTypeKey = pot.PurchaseOrderTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
	Left outer join 
		(Select PurchaseOrderKey, Sum(TotalCost) as TotalCost, Sum(BillableCost) as BillableCost, sum(AppliedCost) as AppliedCost
		, sum(case when InvoiceLineKey > 0 then AmountBilled else 0 end) as AmountBilled
			From tPurchaseOrderDetail (nolock)
			Group By PurchaseOrderKey) as pod on pod.PurchaseOrderKey = po.PurchaseOrderKey
	left outer join tClass cl (nolock) on po.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join
	(
		select MAX(e.EstimateKey) as EstimateKey, po2.PurchaseOrderKey, po2.CompanyKey
		from tEstimate e (nolock)
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
		inner join tPurchaseOrderDetail pod2 (nolock) on ete.PurchaseOrderDetailKey = pod2.PurchaseOrderDetailKey
		inner join tPurchaseOrder po2 (nolock) on pod2.PurchaseOrderKey = po2.PurchaseOrderKey
		group by po2.PurchaseOrderKey, po2.CompanyKey 
	)  est on po.PurchaseOrderKey = est.PurchaseOrderKey and po.CompanyKey = est.CompanyKey 
	left outer join tEstimate e (nolock) on est.EstimateKey = e.EstimateKey
	left outer join tProject ep (nolock) on ep.ProjectKey = e.ProjectKey
	left outer join tCampaign ec (nolock) on ec.CampaignKey = e.CampaignKey
	left outer join tLead el (nolock) on el.LeadKey = e.LeadKey
	left outer join tCompany cc (nolock) on p.ClientKey = cc.CompanyKey

Where POKind = 0
GO
