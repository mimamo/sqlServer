USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_Voucher]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [dbo].[vListing_Voucher]
AS

/*
|| When     Who Rel  What
|| 11/29/06 CRG 8.35 Wrapped VoucherTotal with ISNULL
|| 10/10/07 CRG 8.5  Added GLCompany and Office
|| 08/25/10 RLB 10534 (88062) added Vendor Company Type and Client Company Type is from the project.
|| 09/28/10 RLB 10535 (91043) added Opening Transaction
|| 08/22/11 GWG 10547 Added Tax Fields
|| 11/28/11 GHL 10550 Change inner join with tUser (approver) to left join
||                    so that we can recover where approver is null
|| 11/29/11 GHL 10550 Added filter on CreditCard = 0
|| 04/25/12 GHL 10555 Added GLCompanyKey for map/restrict
|| 03/01/13 GHL 10565 (167854) Added Vendor Invoice ID/Unique Auto Number
|| 08/29/13 GWG 10571 Added ProjectKey for filtering
|| 01/03/14 WDF 10576 Added [Created By Name] and [Date Created]
|| 01/27/14 GHL 10576 Added Currency
|| 03/20/14 GHL 10578 Added Exchange Rate
|| 01/27/15 WDF 10588 (Abelson Taylor) Added Division and Product
|| 02/11/15 GHL 10589 Added Company Media info for the new media screens
|| 03/05/15 GWG 10590 Added Credit Card info
|| 04/27/15 WDF 10591 (245447) Added [Paid By Client] and [Billed To Client]
*/

SELECT 
     v.VoucherKey
     ,v.CompanyKey
     ,v.GLCompanyKey
     ,v.VendorKey
     ,v.ProjectKey
	 ,v.CompanyMediaKey
    ,c.CompanyName AS [Vendor Name]
    ,c.VendorID AS [Vendor ID]
    ,c.VendorID + ' - ' + c.CompanyName AS [Vendor Full Name]
    ,v.VoucherID AS [Unique Auto Number]
    ,v.InvoiceDate AS [Invoice Date]
	,v.PostingDate AS [Posting Date]
    ,v.DueDate as [Invoice Due Date]
	,v.DateReceived as [Invoice Date Received]
	,cbk.FirstName + ' ' + cbk.LastName as [Created By Name]
	,v.DateCreated as [Date Created]
	,p.ProjectNumber as [Header Project Number]
	,p.ProjectName as [Header Project Name]
	,p.ProjectNumber + ' ' + p.ProjectName as [Header Full Project Name]
	,cp.CampaignName as [Campaign Name]
	,gl.AccountNumber as [AP Account Number]
	,gl.AccountName as [AP Account Name]
	,cl.ClassID as [Class ID]
	,cl.ClassName as [Class Name]
	,v.TermsPercent as [Terms Percentage Discount]
	,v.TermsDays as [Terms Discount Days]
	,v.TermsNet as [Terms Net Days]
	,v.Description as [Invoice Description]
	,vct.CompanyTypeName as [Vendor Company Type]
	,cct.CompanyTypeName as [Client Company Type]
	,ISNULL(v.VoucherTotal, 0) as [Invoice Amount]
	,ISNULL(v.VoucherTotal, 0) - ISNULL(v.SalesTax1Amount, 0) - ISNULL(v.SalesTax2Amount, 0) as [Invoice Amount No Tax]
	,ISNULL(v.SalesTax1Amount, 0) + ISNULL(v.SalesTax2Amount, 0) as [Invoice Total Tax]
	,ISNULL(v.SalesTax1Amount, 0) as [Invoice Tax 1]
	,ISNULL(v.SalesTax2Amount, 0) as [Invoice Tax 2]
	,v.AmountPaid as [Invoice Amount Paid]
	,v.VoucherTotal - v.AmountPaid as [Invoice Amount Open]
    ,v.InvoiceNumber AS [Invoice Number]
	,u.FirstName + ' ' + u.LastName as [Approver Name]
	,case v.OpeningTransaction when 1 then 'YES' else 'NO' end as [Opening Transaction]
	,case v.Downloaded when 1 then 'YES' else 'NO' end as Downloaded
	,case v.Posted when 1 then 'YES' else 'NO' end as Posted
	,Case v.Status
		When 1 then 'Not Sent For Approval'
		When 2 then 'Sent For Approval'
		When 3 then 'Rejected'
		When 4 then 
			Case v.Posted When 1 then 'Posted' else 'Approved Not Posted' end
		end as [Invoice Status]
	,v.ApprovalComments as [Approval Comments]
	,ISNULL((Select Count(*) from tTransaction (nolock) Where Entity = 'VOUCHER' and EntityKey = v.VoucherKey), 0) as [Posting Count]
	,cli.CompanyName as [Client Name]
	,cli.CustomerID as [Client ID]
	,cli.CompanyName as [Client Full Name]
	,glc.GLCompanyID as [Company ID]
	,glc.GLCompanyName as [Company Name]
	,o.OfficeID as [Office ID]
	,o.OfficeName as [Office Name]
	,v.CurrencyID as [Currency]
	,v.ExchangeRate as [Exchange Rate]
	,cd.DivisionID as [Client Division ID]
    ,cd.DivisionName as [Client Division]
    ,cpr.ProductID as [Client Product ID]
    ,cpr.ProductName as [Client Product]
	,cm.MediaKind
	,case c.CCAccepted when 1 then 'YES' else 'NO' end as [Credit Cards Accepted]
	,glcc.AccountNumber as [Credit Card Used]
	,c.EmailCCToAddress as [Email Card Info To]
	,CASE WHEN (SELECT COUNT(*) 
                  FROM tVoucherDetail vd (nolock)
                 WHERE vd.VoucherKey = v.VoucherKey 
                   AND v.Status = 4 
                   AND vd.DatePaidByClient IS NOT NULL
                ) > 0 
          THEN 'YES' 
          ELSE 'NO' 
     END AS [Paid By Client]
    ,CASE WHEN ((SELECT COUNT(*) 
				   FROM tVoucherDetail vd (nolock)
				  WHERE vd.VoucherKey = v.VoucherKey 
					AND v.Status = 4 
					AND vd.InvoiceLineKey IS NOT NULL
				)
				+ 
				(SELECT COUNT(*) 
				   FROM tVoucherDetail vd (nolock) inner join tPurchaseOrderDetail pod (nolock) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
				  WHERE vd.VoucherKey = v.VoucherKey 
				    AND v.Status = 4 
				    AND pod.InvoiceLineKey IS NOT NULL
				)
			   ) > 0 
		  THEN 'YES' 
		  ELSE 'NO' 
	 END AS [Billed To Client]
From
	tVoucher v (nolock)
	Inner Join tCompany c (nolock) on v.VendorKey = c.CompanyKey
	left join tUser u (nolock) on v.ApprovedByKey = u.UserKey
	left join tUser cbk (nolock) on v.CreatedByKey = cbk.UserKey
	left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	left outer join tGLAccount gl (nolock) on v.APAccountKey = gl.GLAccountKey
	left outer join tClass cl (nolock) on v.ClassKey = cl.ClassKey
	left outer join tCampaign cp (nolock) on p.CampaignKey = cp.CampaignKey
	left outer join tCompany cli (nolock) on p.ClientKey = cli.CompanyKey
	left outer join tGLCompany glc (nolock) on v.GLCompanyKey = glc.GLCompanyKey
	left outer join tOffice o (nolock) on v.OfficeKey = o.OfficeKey
	left outer join tCompanyType vct (nolock) on c.CompanyTypeKey = vct.CompanyTypeKey
	left outer join tCompanyType cct (nolock) on cli.CompanyTypeKey = cct.CompanyTypeKey
	left outer join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
    left outer join tClientProduct cpr (nolock) on p.ClientProductKey  = cpr.ClientProductKey
	left outer join tCompanyMedia cm (nolock) on v.CompanyMediaKey = cm.CompanyMediaKey 
	left outer join tGLAccount glcc (nolock) on c.CCAccountKey = glcc.GLAccountKey
Where ISNULL(v.CreditCard, 0) = 0
GO
