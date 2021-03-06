USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_MediaTrafficIO]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE           View [dbo].[vListing_MediaTrafficIO]
AS

  /*
  || When     Who Rel   What
  || 09/25/06 RTC 8.35  Changed inner join to outer from PO to Project.  POs linking through media
  ||                    estimates were not shown.
  || 10/16/06 WES 8.356 Added Client Name and ID fields
  || 09/13/07 GHL 8.436 Fixed Client Name and ID fields
  || 10/10/07 CRG 8.5   Added Class, GLCompany, Office, and Department
  || 01/21/10 RLB 10517 (72879) Added POLine Custom fields
  || 12/12/11 RLB 10551 (119167) Added Line Comments
  || 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
  || 03/22/13 WDF 10566 (172559) Added Transferred Out
  || 01/20/14 GHL 10576 Added Order Description
  || 11/07/14 WDF 10586 (234091) Added Special and Traffic Instructions
  || 01/27/15 WDF 10588 (Abelson Taylor) Added Division and Product
  || 02/18/15 GHL 10588 (246235) Rolled back 243930. Greg, did you mean media worksheets instead of media estimates? 
 */

Select
     po.PurchaseOrderKey
	,pod.PurchaseOrderDetailKey
    ,po.CompanyKey
    ,po.GLCompanyKey
    ,po.CustomFieldKey
	,pod.CustomFieldKey as POLineCustomFieldKey
	,po.POKind
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
    ,po.OrderedBy AS [Ordered By]
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
	,case po.Printed when 1 then 'YES' else 'NO' end as [Printed]
	,u.FirstName + ' ' + u.LastName as [Selected Approver]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,me.EstimateID as [Media Estimate ID]
	,me.EstimateName as [Media Estimate Name]
	,me.EstimateID + ' - ' + me.EstimateName as [Media Estimate Full Name]
	,cm.StationID as [Publication ID]
	,cm.Name as [Publication Name]
	,cm.StationID + ' - ' + cm.Name as [Publication Full Name]
	,pod.LineNumber AS [Line Number]
	,pod.ShortDescription AS [Caption]
	,pod.DetailOrderDate as [Insertion Date]
    ,pod.LongDescription AS [Line Long Description]
    ,pod.LongDescription AS [Line Comments]
    ,pod.TotalCost AS [Net]
    ,pod.AppliedCost AS [Applied Invoices]
	,pod.TotalCost - ISNULL(pod.AppliedCost, 0) AS [Open Amount]
    ,pod.Markup as [Commission]
    ,pod.BillableCost AS [Gross]
	,pod.UserDate1 as [User Defined Date 1]
	,pod.UserDate2 as [User Defined Date 2]
	,pod.UserDate3 as [User Defined Date 3]
	,pod.UserDate4 as [User Defined Date 4]
	,pod.UserDate5 as [User Defined Date 5]
	,pod.UserDate6 as [User Defined Date 6]
	,Case When pod.TransferToKey IS NULL Then 'NO' else 'YES' end as [Transferred Out]
	,i.ItemID as [Item ID]
	,i.ItemName as [Item Name]
	,mm.MarketID as [Market ID]  
    ,mm.MarketName as [Market Name]
	,case when isnull(pref.IOClientLink, 1) = 1 then pc.CompanyName else mc.CompanyName end as [Client Name] 
	,case when isnull(pref.IOClientLink, 1) = 1 then pc.CustomerID else mc.CustomerID end as [Client ID] 
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,d.DepartmentName as Department
	,po.[Description] as [Order Description] 
	,po.SpecialInstructions as [Special Instructions]
	,po.DeliveryInstructions as [Traffic Instructions]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
	INNER JOIN tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
	INNER JOIN tPreference pref (nolock) on po.CompanyKey = pref.CompanyKey	
    INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey 
	left outer join tProject p (nolock) on po.ProjectKey = p.ProjectKey
	left outer join tProject pline (nolock) on pod.ProjectKey = pline.ProjectKey
	left outer join tItem i (nolock) on pod.ItemKey = i.ItemKey
	left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
	left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	left outer join tUser u (nolock) on po.ApprovedByKey = u.UserKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	left outer join tCompany pc (nolock) on pline.ClientKey = pc.CompanyKey
	left outer join tCompany mc (nolock) on me.ClientKey = mc.CompanyKey
	left outer join tClass cl (nolock) on pod.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on pod.OfficeKey = o.OfficeKey
	left outer join tDepartment d (nolock) on pod.DepartmentKey = d.DepartmentKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
Where po.POKind = 1 -- and isnull(po.MediaEstimateKey, 0) = 0
GO
