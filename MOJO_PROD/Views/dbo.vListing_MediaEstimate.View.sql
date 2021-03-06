USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_MediaEstimate]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[vListing_MediaEstimate]
AS

/*
|| When      Who Rel     What
|| 10/10/07  CRG 8.5     Added Class, GLCompany, Office
|| 09/18/09  GHL 10.51   (62044) Added Amount Billed on pos and vouchers
|| 04/02/12  MFT 10.555  Added GLCompanyKey in order to map/restrict
|| 01/27/15  WDF 10.588  (Abelson Taylor) Added Division and Product
*/

Select
	me.MediaEstimateKey
	,me.CompanyKey
	,me.ClientKey
	,me.EstimateID as [Estimate ID]
	,me.EstimateName as [Estimate Name]
	,c.CustomerID as [Client ID]
	,c.CompanyName as [Client Name]
	,p.ProjectNumber as [Project Number]
	,p.ProjectName as [Project Name]
	,p.ProjectNumber + ' - ' + p.ProjectName as [Project Full Name]
	,ta.TaskID as [Task ID]
	,ta.TaskName as [Task Name]
	,ta.TaskID + ' - ' + ta.TaskName as [Task Full Name]
	,cp.ProductName as [Product Name]
	,me.Description
	,me.FlightStartDate as [Flight Start Date]
	,me.FlightEndDate as [Flight End Date]
	,Case me.Active When 1 then 'YES' Else 'NO' end as Active
	,glc.GLCompanyKey
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,isnull(pods.AmountBilled, 0) + isnull(vds.AmountBilled, 0) AS [Amount Billed] 
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cpr.ProductID as [Client Product ID]
    ,cpr.ProductName as [Client Product]
From 
	tMediaEstimate me (nolock)
	inner join tCompany c (nolock) on me.ClientKey = c.CompanyKey
	Left outer join tProject p (nolock) on me.ProjectKey = p.ProjectKey
	Left outer join tTask ta (nolock) on me.TaskKey = ta.TaskKey
	left outer join tClientProduct cp (nolock) on me.ClientProductKey = cp.ClientProductKey
	left outer join tClass cl (nolock) on me.ClassKey = cl.ClassKey
	left outer join tGLCompany glc (nolock) on me.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on me.OfficeKey = o.OfficeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct cpr (nolock) on p.ClientProductKey  = cpr.ClientProductKey
    left outer join (
		select po.MediaEstimateKey, sum(pod.AmountBilled) AS AmountBilled 
		from tPurchaseOrder po (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		where i.AdvanceBill = 0
		group by po.MediaEstimateKey
	) as pods on me.MediaEstimateKey = pods.MediaEstimateKey  	
	left outer join (
		select po.MediaEstimateKey, sum(vd.AmountBilled) AS AmountBilled 
		from tPurchaseOrder po (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on po.PurchaseOrderKey = pod.PurchaseOrderKey
		inner join tVoucherDetail vd (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
		inner join tInvoiceLine il (nolock) on vd.InvoiceLineKey = il.InvoiceLineKey
		inner join tInvoice i (nolock) on il.InvoiceKey = i.InvoiceKey
		where i.AdvanceBill = 0
		group by po.MediaEstimateKey
	) as vds on me.MediaEstimateKey = vds.MediaEstimateKey
GO
