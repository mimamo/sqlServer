USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderGetVoucherList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderGetVoucherList]
	(
		@PurchaseOrderKey int
	)

AS

/*
|| When      Who Rel      What
|| 09/16/10  MFT 10.5.3.5 Added fields and joins to support customizable grid in new flex interface
|| 11/9/11   RLB 10.5.0.0 Made change because of error when clicking on HTML page
*/

Select
	v.VoucherKey
	,v.InvoiceNumber
	,v.InvoiceDate
	,v.DueDate
	,v.PostingDate
	,v.VoucherTotal
	,v.ApprovalComments
	,v.AmountPaid
	,v.Downloaded
	,v.DateReceived
	,CAST(v.Description as VARCHAR(8000)) as Description
	,v.Posted
	,Case v.Status
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case v.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as InvoiceStatus
	,v.TermsPercent
	,v.TermsDays
	,v.TermsNet
	,c.CompanyName
	,c.VendorID
	,gl.AccountNumber
	,gl.AccountName
	,u.FirstName + ' ' + u.LastName as Approver
	,cp.CampaignName
	,cl.ClassID
	,cl.ClassName
	,cli.CompanyName as ClientName
	,cli.CustomerID as ClientID
	,glc.GLCompanyID as CompanyID
	,glc.GLCompanyName as CompanyName
	,p.ProjectNumber
	,p.ProjectName
	,o.OfficeID
	,o.OfficeName
	,Sum(vd.TotalCost) as AppliedAmount
From
	tVoucher v (nolock)
	inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	inner join tVoucherDetail vd (nolock) on v.VoucherKey = vd.VoucherKey
	inner join tPurchaseOrderDetail pd (nolock) on vd.PurchaseOrderDetailKey = pd.PurchaseOrderDetailKey
	inner join tUser u (nolock) on v.ApprovedByKey = u.UserKey
	left join tGLAccount gl (nolock) on v.APAccountKey = gl.GLAccountKey
	left join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	left join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left join tClass cl (nolock) on v.ClassKey = cl.ClassKey
	left join tCompany cli (nolock) on p.ClientKey = cli.CompanyKey
	left join tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	left join tOffice o (nolock) on v.OfficeKey = o.OfficeKey
Where
	pd.PurchaseOrderKey = @PurchaseOrderKey
Group By
	v.VoucherKey
	,v.InvoiceNumber
	,v.InvoiceDate
	,v.DueDate
	,v.PostingDate
	,v.VoucherTotal
	,v.ApprovalComments
	,v.AmountPaid
	,v.Downloaded
	,v.DateReceived
	,CAST(v.Description as VARCHAR(8000))
	,v.Posted
	,v.Status
	,v.TermsPercent
	,v.TermsDays
	,v.TermsNet
	,c.CompanyName
	,c.VendorID
	,gl.AccountNumber
	,gl.AccountName
	,u.FirstName + ' ' + u.LastName
	,cp.CampaignName
	,cl.ClassID
	,cl.ClassName
	,cli.CompanyName
	,cli.CustomerID
	,glc.GLCompanyID
	,glc.GLCompanyName
	,p.ProjectNumber
	,p.ProjectName
	,o.OfficeID
	,o.OfficeName
Order By
	InvoiceDate
GO
