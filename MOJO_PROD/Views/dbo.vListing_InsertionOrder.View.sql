USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_InsertionOrder]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_InsertionOrder]
AS

/*
|| When     Who Rel     What
|| 10/16/06 WES 8.3567  Added Client ID
|| 10/10/07 CRG 8.5     Added Class and GLCompany
|| 11/12/07 RLB 8.5     Removed Due Date and Detail Order End Date on Mike W. request (fields not used).
|| 12/17/07 CRG 8.5     (17475) Modified to get the client from the Media Estiate if they have selected that option in Preferences
|| 12/04/08 GHL 10.014   Changed BCClientLink to IOClientLink
|| 08/13/10 RLB 10.533  (81529) Added Pub ID and Name
|| 09/27/10 MAS 10.5.3.5(90891) Added Client Costing column
|| 12/29/11 MFT 10.551  (90601) Added Date Updated column
|| 04/02/12 MFT 10.555  Added GLCompanyKey in order to map/restrict
|| 10/10/13 MFT 10.573  Added MediaWorksheetKey
|| 10/15/13 GHL 10.573  Added BillAt description
|| 01/20/14 GHL 10.576 (197214) Added Order Description
|| 04/17/14 GHL 10.579  Added WorkSheet ID 
|| 10/28/14 GHL 10.585  Removed WorkSheet ID at SM'request because new IOs are not
||                      shown on the insertion order listing screen now  
|| 12/29/14 GHL 10.587  (240381) When calculating AmountBilled, check that InvoiceLineKey > 0
|| 01/27/15 WDF 10.588  (Abelson Taylor) Added Division and Product
*/

SELECT 
	po.PurchaseOrderKey
	,po.CompanyKey
	,po.CustomFieldKey
	,po.MediaWorksheetKey
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
	,po.DateUpdated AS [Date Updated]
	,po.PODate AS [Order Date]
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
	,case ISNULL(po.UseClientCosting, 0) when 1 then 'YES' Else 'NO' end AS [Client Costing]
	,pod.TotalCost as [Amount Net]
	,pod.BillableCost as [Amount Gross]
	,pod.AppliedCost as [Amount Invoiced]
	,pod.AppliedCost as [Actual Cost]
	,pod.AmountBilled as [Actual Billed]
	,ISNULL(pod.TotalCost, 0) - ISNULL(pod.AppliedCost, 0) as [Amount Open]
	,u.FirstName + ' ' + u.LastName as [Selected Approver]
	,uc.FirstName + ' ' + uc.LastName as [Created By]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,me.EstimateID as [Media Estimate ID]
	,me.EstimateName as [Media Estimate Name]
	,me.EstimateID + ' - ' + me.EstimateName as [Media Estimate Full Name]
	,mm.MarketID as [Market ID]
	,mm.MarketName as [Market Name]
	,(SELECT MIN(DetailOrderDate) FROM tPurchaseOrderDetail (nolock) where tPurchaseOrderDetail.PurchaseOrderKey = po.PurchaseOrderKey) as [Detail Order Date]  
	,CASE ISNULL(pref.IOClientLink, 1)
		WHEN 1 THEN cc.CompanyName
		ELSE mec.CompanyName
		END  as [Client Name]
	,CASE ISNULL(pref.IOClientLink, 1)
		WHEN 1 THEN cc.CustomerID
		ELSE mec.CustomerID
		END  as [ClientID]
	,glc.GLCompanyKey
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,cm.Name as [Publication Name]
	,cm.StationID as [Publication ID]
	,case when po.BillAt = 0 then 'Gross'
			  when po.BillAt = 1 then 'Net'
			  when po.BillAt = 2 then 'Commission'
			  else ''
		end as [Prebill At]
	,po.Description as [Order Description]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
    INNER JOIN tCompany c (nolock) ON po.VendorKey = c.CompanyKey 
	INNER JOIN tPreference pref (nolock) ON po.CompanyKey = pref.CompanyKey
	left outer join tUser u (nolock) on po.ApprovedByKey = u.UserKey
	left outer join tUser uc (nolock) on po.CreatedByKey = uc.UserKey
	left outer join tProject p (nolock) on po.ProjectKey = p.ProjectKey
	left outer join tMediaEstimate me (nolock) on po.MediaEstimateKey = me.MediaEstimateKey
	Left outer join 
		(Select PurchaseOrderKey
               ,Sum(TotalCost) as TotalCost
               ,Sum(BillableCost) as BillableCost
               ,sum(ISNULL(AppliedCost, 0)) as AppliedCost
			   ,sum(case when InvoiceLineKey > 0 then ISNULL(AmountBilled, 0) else 0 end) as AmountBilled
			From tPurchaseOrderDetail (nolock)
			Group By PurchaseOrderKey) as pod on pod.PurchaseOrderKey = po.PurchaseOrderKey
	left outer join tCompanyMedia cm (nolock) on po.CompanyMediaKey = cm.CompanyMediaKey
	left outer join tMediaMarket mm (nolock) on cm.MediaMarketKey = mm.MediaMarketKey
	left outer join tCompany cc (NOLOCK) on p.ClientKey = cc.CompanyKey
	left outer join tCompany mec (nolock) on me.ClientKey = mec.CompanyKey
	left outer join tClass cl (nolock) on po.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
Where po.POKind = 1
GO
