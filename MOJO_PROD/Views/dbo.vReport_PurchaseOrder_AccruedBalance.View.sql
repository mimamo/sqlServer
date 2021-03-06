USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vReport_PurchaseOrder_AccruedBalance]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vReport_PurchaseOrder_AccruedBalance]
AS

/*
|| 04/01/14 WDF 10.5.7.9 (202462)created for this issue
|| 01/27/15 WDF 10.5.8.8 (Abelson Taylor) Added Division and Product
*/

SELECT 
	 po.CompanyKey
	,po.GLCompanyKey
	,pod.CustomFieldKey
	,p.ProjectKey
    ,po.PurchaseOrderNumber AS [PO Number]
    ,c.VendorID AS [Vendor ID]
    ,c.CompanyName AS [Vendor Name]
    ,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
    ,po.DateCreated AS [Date Created]
    ,pod.LineNumber AS [Line Number]
    ,pod.AdjustmentNumber AS [Line Adjustment Number]
    ,p.ProjectName AS [Line Project Name]
    ,p.ProjectNumber AS [Line Project Number]
    ,p.ProjectNumber + ' - ' + p.ProjectName AS [Line Project Full Name]
    ,pod.ShortDescription AS [Line Short Description]
    ,pod.UnitDescription AS [Line Unit Description]
    ,pod.TotalCost AS [Line Total Cost]
    ,case pod.Billable when 1 then 'YES' else 'NO' end as [Billable]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
    ,client.CustomerID AS [Client ID]
    ,client.CompanyName AS [Client Name]
	,pc.CompanyName as [Parent Company]
    ,CASE WHEN toa.Entity = 'INVOICE' THEN inv.InvoiceNumber ELSE v.InvoiceNumber END as [Invoice Number]
    ,v.VoucherTotal as [Vendor Invoice Total]
    ,vd.TotalCost as [Vendor Invoice Line Total Cost]
    ,v.InvoiceDate as [Vendor Invoice Date]
    ,vd.ShortDescription as [Vendor Line Short Description]
    ,inv.PostingDate as [Date Accrued]
    ,Month(inv.PostingDate) as [Month Accrued]
    ,Year(inv.PostingDate) as [Year Accrued]
    ,inv.InvoiceNumber as [Invoice Billed On]
    ,inv.PostingDate as [Order Invoice Date Posted]
    ,v.PostingDate as [Date Unaccrued]
    ,Month(v.PostingDate) as [Month Unaccrued]
    ,Year(v.PostingDate) as [Year Unaccrued]
	,toa.AccrualAmount - toa.UnaccrualAmount AS [Accrued Amount]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cp.ProductID as [Client Product ID]
    ,cp.ProductName as [Client Product]
FROM 
	tPurchaseOrder po (nolock)
	inner join tPurchaseOrderDetail pod (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
    inner join tTransactionOrderAccrual toa (NOLOCK) ON pod.PurchaseOrderDetailKey = toa.PurchaseOrderDetailKey
	inner join tCompany c (nolock) ON po.VendorKey = c.CompanyKey
	left outer join tProject p (nolock) ON pod.ProjectKey = p.ProjectKey
	left outer join tGLCompany glc (nolock) on po.GLCompanyKey = glc.GLCompanyKey
	left outer join tCompany client (nolock) ON p.ClientKey = client.CompanyKey
	left outer join tCompany pc (nolock) on c.ParentCompanyKey = pc.CompanyKey
	left outer join tVoucherDetail vd (nolock) on toa.VoucherDetailKey = vd.VoucherDetailKey
	left outer join tVoucher v (nolock) on vd.VoucherKey = v.VoucherKey
	left outer join tInvoice inv (NOLOCK) ON toa.EntityKey = inv.InvoiceKey AND 
                                             toa.Entity = 'INVOICE'
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct  cp (nolock) on p.ClientProductKey  = cp.ClientProductKey
GO
