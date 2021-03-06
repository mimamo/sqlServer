USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_InsertionOrder]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_InsertionOrder]
AS

/*
|| When      Who Rel      What
|| 10/11/07  CRG 8.5      Added Class, Office, Department, GLCompany
|| 7/21/08   CRG 10.0.0.5 (30572) Wrapped TotalCost and AppliedCost with ISNULL.
|| 08/14/08  GHL 10.007  (32321) Added protection against null AppliedCost
|| 12/2/08   GWG 10.013  Added Accrued Cost and Difference
|| 12/4/08   GHL 10.014  (41626) Getting now client info based on preferences
|| 05/21/09  RLB 10026   (53189) Status is now pulling "Open Approved"
|| 09/10/09  GHL 10.5    Added Transferred Out
|| 01/11/10  RLB 10.516  Added Item Expense Account (71739)
|| 04/24/12  GHL 10.555  Added GLCompanyKey in order to map/restrict
|| 10/29/12 CRG 10.5.6.1 (156391) Added ProjectKey
|| 01/20/14 GHL 10.576 (197214) Added Order Description
|| 03/07/14 GHL 10.578   Added Currency
|| 12/29/14 GHL 10.587 (240381) When calculating AmountBilled, check that InvoiceLineKey > 0
|| 01/27/15 WDF 10.588 (Abelson Taylor) Added Division and Product
*/

SELECT 
	 po.CompanyKey
	,po.GLCompanyKey
	,pod.CustomFieldKey
    ,po.PurchaseOrderNumber AS [Order Number]
    ,c.VendorID AS [Vendor ID]
    ,c.CompanyName AS [Vendor Name]
    ,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
	,st.StationID as [Publication ID]
	,st.Name as [Publication Name]
	,st.StationID + ' - ' + st.Name as [Publication Full Name]
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
    ,po.OrderedBy AS [Ordered By]
    ,po.SpecialInstructions AS [Special Instructions]
    ,po.DeliveryInstructions AS [Traffic Instructions]
    ,po.Revision AS [Revision Number]
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
	,me.EstimateID as [Media Estimate ID]
	,me.EstimateName as [Media Estimate Name]
	,me.EstimateID + ' - ' + me.EstimateName as [Media Estimate Full Name]
    ,pod.LineNumber AS [Line Number]
    ,p.ProjectName AS [Project Name]
    ,p.ProjectNumber AS [Project Number]
    ,p.ProjectNumber + ' - ' + p.ProjectName AS [Project Full Name]
	,cp.CampaignName as [Campaign Name]
    ,t.TaskID AS [Task ID]
    ,t.TaskName AS [Task Name]
    ,t.TaskID + ' - ' + t.TaskName AS [Task Full Name]
    ,pod.ShortDescription AS [Caption]
    ,pod.LongDescription AS [Line Comments]
	,i.ItemID as [Item ID]
	,i.ItemName as [Item Name]
	,gla.AccountNumber + ' - ' + gla.AccountName as [Item Expense Account]
    ,pod.TotalCost AS [Net Amount]
	,pod.AccruedCost as [Line Accrued Cost]
	,pod.TotalCost - ISNULL(pod.AccruedCost, 0) as [Line Accrued Cost Difference]
	,pod.AdjustmentNumber as [Adjustment Number]
	,Case when pod.InvoiceLineKey > 0 then 0 else pod.AmountBilled - pod.BillableCost end as [Billed Difference]
    ,ISNULL((Select Sum(PrebillAmount) from tVoucherDetail (nolock) Where tVoucherDetail.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey), 0) as [Line Amount Unaccrued]
	,ISNULL(pod.AppliedCost, 0) AS [Applied Invoices]
	,ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0) AS [Open Amount]
	,case when pod.InvoiceLineKey > 0 then pod.AmountBilled else 0 end as [Amount Billed]
	,pod.DetailOrderDate as [Insertion Date]
	,pod.Markup as [Markup Percent]
	,case when pod.InvoiceLineKey > 0 then ISNULL(pod.AmountBilled, 0) else 0 end 
	+ ISNULL((Select Sum(ISNULL(AmountBilled, 0)) from tVoucherDetail vd (nolock) Where pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey and vd.InvoiceLineKey > 0), 0) as [Total Billed]
	,case pod.Markup when 1 then 'YES' else 'NO' end as [Commission]
	,(Select Sum(ISNULL(AmountBilled, 0)) from tVoucherDetail vd (nolock) Where pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey and vd.InvoiceLineKey > 0) as [Amount Billed On Vendor Invoices]
    ,pod.BillableCost AS [Gross Amount]
	,pod.UserDate1 as [User Defined Date 1]
	,pod.UserDate2 as [User Defined Date 2]
	,pod.UserDate3 as [User Defined Date 3]
	,pod.UserDate4 as [User Defined Date 4]
	,pod.UserDate5 as [User Defined Date 5]
	,pod.UserDate6 as [User Defined Date 6]
	,case pod.Closed when 1 then 'YES' else 'NO' end as [Line Closed]

	,CASE ISNULL(pref.IOClientLink, 1)
		WHEN 1 THEN cl.CompanyName
		ELSE cl2.CompanyName
	END  as [Client Name]
    ,CASE ISNULL(pref.IOClientLink, 1)
		WHEN 1 THEN cl.CustomerID
		ELSE cl2.CustomerID
	END  as [Client ID]

	,mm.MarketID as [Market ID]
    ,mm.MarketName as [Market Name]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cla.ClassID as [Class ID]
	,cla.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
	,Case When pod.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out]
	,p.ProjectKey
	,po.[Description] as [Order Description]
	,po.CurrencyID as [Currency]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,pc.ProductID as [Client Product ID]
    ,pc.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
	INNER JOIN tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
	INNER JOIN tPreference pref (nolock) ON po.CompanyKey = pref.CompanyKey
    INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey 
	LEFT OUTER JOIN tTask t (nolock) ON pod.TaskKey = t.TaskKey 
	LEFT OUTER JOIN tProject p (nolock) ON pod.ProjectKey = p.ProjectKey
	LEFT OUTER JOIN tCompany cl (nolock) on p.ClientKey = cl.CompanyKey
	LEFT OUTER JOIN tCompanyMedia st (nolock) on po.CompanyMediaKey = st.CompanyMediaKey
	LEFT OUTER JOIN tItem i (nolock) on pod.ItemKey = i.ItemKey
	Left OUTER JOIN tGLAccount gla (nolock) on i.ExpenseAccountKey = gla.GLAccountKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	LEFT OUTER JOIN tCompany cl2 (nolock) on me.ClientKey = cl2.CompanyKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
    left outer join tMediaMarket mm (nolock) on st.MediaMarketKey = mm.MediaMarketKey
	left outer join tClass cla (nolock) on pod.ClassKey = cla.ClassKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pod.DepartmentKey = d.DepartmentKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  pc (nolock) on p.ClientProductKey  = pc.ClientProductKey
Where po.POKind = 1
GO
