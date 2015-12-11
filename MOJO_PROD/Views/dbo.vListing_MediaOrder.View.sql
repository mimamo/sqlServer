USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_MediaOrder]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE         VIEW [dbo].[vListing_MediaOrder]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added GLCompany and Class
|| 03/15/12  GHL 10554   Added estimate info
|| 04/25/12  GHL 10555   Added GLCompanyKey for map/restrict
|| 01/20/14 GHL 10.576 (197214) Added Order Description
*/

SELECT 
     po.PurchaseOrderKey
    ,po.CompanyKey
    ,po.GLCompanyKey
    ,po.CustomFieldKey
	,po.POKind
	,po.MediaEstimateKey
    ,c.CompanyKey as VendorKey
    ,po.PurchaseOrderNumber AS [Order Number]
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
    ,po.PODate AS [Order Date]
    ,po.DueDate AS [Due Date]
    ,po.OrderedBy AS [Ordered By]
    ,po.SpecialInstructions AS [Special Instructions]
    ,po.DeliveryInstructions AS [Delivery Instructions]
    ,po.DeliverTo1 AS [Deliver To 1]
    ,po.DeliverTo2 AS [Deliver To 2]
    ,po.DeliverTo3 AS [Deliver To 3]
    ,po.DeliverTo4 AS [Deliver To 4]
    ,po.Revision AS [Revision Number]
    ,po.ApprovedDate AS [Approved Date]
	,Case po.POKind When 1 then 'Insertion Order' When 2 then 'Broadcast Order' end as [Order Type]
    ,Case When po.Closed = 1 then 'Closed' else 
		case po.Status 
			when 1 then 'Not Sent For Approval'
			when 2 then 'Sent for Approval'
			when 3 then 'Rejected'
			when 4 then 'Open Approved' end 
		end as [Status]
    ,case po.Closed when 1 then 'YES' else 'NO' end as [Closed]
    ,case po.Downloaded when 1 then 'YES' else 'NO' end as [Downloaded]
	,case po.Printed when 1 then 'YES' else 'NO' end as [Printed]
	,pod.TotalCost as [Amount Net]
	,pod.BillableCost as [Amount Gross]
	,pod.AppliedCost as [Amount Invoiced]
	,ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0) as [Amount Open]
	,u.FirstName + ' ' + u.LastName as [Selected Approver]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,me.EstimateID as [Media Estimate ID]
	,me.EstimateName as [Media Estimate Name]
	,me.EstimateID + ' - ' + me.EstimateName as [Media Estimate Full Name]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	
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
FROM 
	tPurchaseOrder po (nolock)
    INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey 
	left outer join tUser u (nolock) on po.ApprovedByKey = u.UserKey
	left outer join tProject p (nolock) on po.ProjectKey = p.ProjectKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	Left outer join 
		(Select PurchaseOrderKey, Sum(TotalCost) as TotalCost, Sum(BillableCost) as BillableCost, sum(ISNULL(AppliedCost, 0)) as AppliedCost
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
		group by po2.PurchaseOrderKey , po2.CompanyKey
	)  est on po.PurchaseOrderKey = est.PurchaseOrderKey and po.CompanyKey = est.CompanyKey
	left outer join tEstimate e (nolock) on est.EstimateKey = e.EstimateKey
	left outer join tProject ep (nolock) on ep.ProjectKey = e.ProjectKey
	left outer join tCampaign ec (nolock) on ec.CampaignKey = e.CampaignKey
	left outer join tLead el (nolock) on el.LeadKey = e.LeadKey
	
Where POKind > 0
GO
