USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_PurchaseOrder]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_PurchaseOrder]
AS

/*
|| 02/27/07 BSH 8.4.0.2    Added Approved By
|| 04/03/07 GWG 8.4.1.1    Changed the custom field key to point to pod
|| 10/11/07 CRG 8.5        Class, Office, Department, GLCompany
|| 11/06/07 CRG 8.5        (11857) Added Client ID and Client Name
|| 08/14/08 GHL 10.0.0.7   (32321) Added protection against null AppliedCost
|| 12/02/08 GWG 10.0.1.3   Added Accrued Cost and Difference
|| 05/21/09 RLB 10.0.2.6   (53189) Status is now pulling "Open Approved"
|| 09/10/09 GHL 10.5.0.0   Added Transferred Out
|| 01/11/10 RLB 10.5.1.6   Added Item Expense Account (71739)
|| 01/19/10 GHL 10.5.1.7   (72527) Added Billing Item info
|| 04/30/10 RLB 10.5.2.2   (63218)Added Parent Company Name
|| 04/07/11 RLB 10.5.4.3   (108045) Removed Project Short Name
|| 03/07/12 GHL 10.5.5.4   (103259) Added [Opportunity Name]
|| 04/24/12 GHL 10.5.5.5   Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1   (156391) Added ProjectKey
|| 01/20/14 GHL 10.5.7.6   (197214) Added Order Description
|| 03/07/14 GHL 10.5.7.8   Added Currency
|| 01/20/15 GWG 10.5.8.8   Added Created By and Email
|| 01/27/15 WDF 10.5.8.8   (Abelson Taylor) Added Division and Product
|| 03/16/15 QMD 10.5.9.0   Added the SUM() to PrebillAmount
*/

SELECT 
	 po.CompanyKey
	,po.GLCompanyKey
	,pod.CustomFieldKey
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
    ,u.FirstName + ' ' + u.LastName AS [Approved By]
    ,u.Email AS [Approved By Email]
    ,cbu.FirstName + ' ' + cbu.LastName AS [Created By]
    ,cbu.Email AS [Created By Email]
    ,Case When po.Closed = 1 then 'Closed' else 
		case po.Status 
			when 1 then 'Not Sent For Approval'
			when 2 then 'Sent for Approval'
			when 3 then 'Rejected'
			when 4 then 'Open Approved' end 
		end as [Status]
    ,case po.Closed when 1 then 'YES' else 'NO' end as [Closed]
    ,case pod.Closed when 1 then 'YES' else 'NO' end as [Line Closed]
    ,case po.Downloaded when 1 then 'YES' else 'NO' end as [Downloaded]
    ,pod.LineNumber AS [Line Number]
    ,p.ProjectName AS [Line Project Name]
    ,p.ProjectNumber AS [Line Project Number]
    ,p.ProjectNumber + ' - ' + p.ProjectName AS [Line Project Full Name]
	,cp.CampaignName as [Campaign Name]
    ,t.TaskID AS [Line Task ID]
    ,t.TaskName AS [Line Task Name]
    ,t.TaskID + ' - ' + t.TaskName AS [Line Task Full Name]
    ,pod.ShortDescription AS [Line Short Description]
    ,pod.LongDescription AS [Line Long Description]
	,i.ItemID as [Line Item ID]
	,i.ItemName as [Line Item Name]
	,gla.AccountNumber + ' - ' + gla.AccountName as [Item Expense Account]
    ,pod.Quantity AS [Line Quantity]
    ,pod.UnitCost AS [Line Unit Cost]
    ,pod.UnitDescription AS [Line Unit Description]
    ,pod.TotalCost AS [Line Total Cost]
	,pod.AccruedCost as [Line Accrued Cost]
	,pod.TotalCost - ISNULL(pod.AccruedCost, 0) as [Line Accrued Cost Difference]
	,pod.DateBilled as [Line Accrual Date]
	,(Select SUM(PrebillAmount) from tVoucherDetail (nolock) Where tVoucherDetail.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey) as [Line Amount Unaccrued]
	
    ,ISNULL(pod.AppliedCost, 0) AS [Applied Invoices]
	,pod.TotalCost - ISNULL(pod.AppliedCost, 0) AS [Remaining PO Amount]
    ,case pod.Billable when 1 then 'YES' else 'NO' end as [Billable]
    ,case pod.Markup when 1 then 'YES' else 'NO' end as [Markup]
    ,pod.BillableCost AS [Line Total Amount Billable]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
    ,client.CustomerID AS [Client ID]
    ,client.CompanyName AS [Client Name]
	,pc.CompanyName as [Parent Company]
	,Case When pod.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out]

    ,case when p.LayoutKey is not null then wt.WorkTypeID 
	      else wti.WorkTypeID 
     end as [Billing Item ID] 
    ,case when p.LayoutKey is not null then isnull(wtcust.Subject, wt.WorkTypeName) 
	      else isnull(wtcusti.Subject, wti.WorkTypeName)  
     end as [Billing Item Name] 
    ,l.Subject as [Opportunity Name]
	,p.ProjectKey
	,po.[Description] as [Order Description]
	,po.CurrencyID as [Currency]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,pcp.ProductID as [Client Product ID]
    ,pcp.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
	INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey
	LEFT OUTER JOIN tUser u (nolock) on po.ApprovedByKey = u.UserKey 
	LEFT OUTER JOIN tUser cbu (nolock) on po.CreatedByKey = cbu.UserKey 
	LEFT OUTER JOIN tTask t (nolock) ON pod.TaskKey = t.TaskKey 
	LEFT OUTER JOIN tProject p (nolock) ON pod.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tItem i (nolock) on pod.ItemKey = i.ItemKey
	Left OUTER JOIN tGLAccount gla (nolock) on i.ExpenseAccountKey = gla.GLAccountKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tClass cl (nolock) on pod.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pod.DepartmentKey = d.DepartmentKey
	LEFT OUTER JOIN tCompany client (nolock) ON p.ClientKey = client.CompanyKey

    left outer join tLayoutBilling lb (nolock) on p.LayoutKey = lb.LayoutKey and lb.Entity = 'tItem' and lb.EntityKey = pod.ItemKey
    left outer join tWorkType wt (nolock) on lb.ParentEntityKey = wt.WorkTypeKey and lb.ParentEntity = 'tWorkType'
    left outer join tWorkTypeCustom wtcust (nolock) on lb.ParentEntityKey = wtcust.WorkTypeKey and wtcust.Entity = 'tProject' and wtcust.EntityKey = p.ProjectKey

	left outer join tWorkType wti (nolock) on i.WorkTypeKey = wti.WorkTypeKey 
	left outer join tWorkTypeCustom wtcusti (nolock) on i.WorkTypeKey = wtcusti.WorkTypeKey and wtcusti.Entity = 'tProject' and wtcusti.EntityKey = p.ProjectKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join tLead l (nolock) on p.LeadKey = l.LeadKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct pcp (nolock) on p.ClientProductKey  = pcp.ClientProductKey
    
Where POKind = 0
GO
