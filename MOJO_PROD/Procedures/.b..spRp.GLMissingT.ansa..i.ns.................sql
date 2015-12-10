USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptGLMissingTransactions]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptGLMissingTransactions]

	(
		@CompanyKey int,
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@GLCompanyKey int = -1,
		@UserKey int = null
	)

AS --Encrypt

/*
|| When     Who Rel  What
|| 4/15/08  GWG 8.5  Change date to Posting Date
|| 03/31/10 RLB 10.521 Added Payments with no Check number
|| 06/03/10 RLB 10.530 Added GL Company 
|| 10/13/11 GHL 10.549 Added credit card charges
|| 04/30/12 GHL 10.555 Added UserKey for tUserGLCompanyAccess           
|| 07/15/13 WDF 10.570  (176497) Added VoucherID
*/

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

If @StartDate is null
	Select @StartDate = DATEADD(yyyy, -10, GETDATE())
	
If @EndDate is null
	Select @EndDate = DATEADD(yyyy, 10, GETDATE())
	

	Select
		'Vendor Invoices' as Entity
		,c.VendorID as CompanyName
		,v.PostingDate as TranDate
		,v.InvoiceNumber as RefNumber
		,v.VoucherTotal as Amount
		,Case v.Status 
			When 1 Then 'Not Sent For Approval'
			When 2 Then 'Pending Approval'
			When 3 then 'Rejected' END as Status
		,v.VoucherID
		,u.FirstName + ' ' + u.LastName as Approver
	From
		tVoucher v (nolock)
		Inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		inner join tUser u (nolock) on v.ApprovedByKey = u.UserKey
	Where
		v.CompanyKey = @CompanyKey and
		v.PostingDate >= @StartDate and
		v.PostingDate <= @EndDate and
		--(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(v.GLCompanyKey, 0)) ) and
		v.Status < 4 and isnull(v.CreditCard, 0) = 0 

		AND (-- case when @GLCompanyKey = ALL
					(@GLCompanyKey = -1 AND 
						(
						@RestrictToGLCompany = 0 OR 
						(v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
						)
					)
					--case when @GLCompanyKey = X or Blank(0)
					 OR (@GLCompanyKey != -1 AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
				)
	
UNION ALL

	Select
		'Credit Card Charges' as Entity
		,c.VendorID as CompanyName
		,v.PostingDate as TranDate
		,v.InvoiceNumber as RefNumber
		,v.VoucherTotal as Amount
		,Case v.Status 
			When 1 Then 'Not Sent For Approval'
			When 2 Then 'Pending Approval'
			When 3 then 'Rejected' END as Status
		,v.VoucherID
		,u.FirstName + ' ' + u.LastName as Approver
	From
		tVoucher v (nolock)
		Inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		inner join tUser u (nolock) on v.ApprovedByKey = u.UserKey
	Where
		v.CompanyKey = @CompanyKey and
		v.PostingDate >= @StartDate and
		v.PostingDate <= @EndDate and
		--(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(v.GLCompanyKey, 0)) ) and
		v.Status < 4 and isnull(v.CreditCard, 0) = 1 
			
		AND (-- case when @GLCompanyKey = ALL
			(@GLCompanyKey = -1 AND 
				(
				@RestrictToGLCompany = 0 OR 
				(v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
			--case when @GLCompanyKey = X or Blank(0)
				OR (@GLCompanyKey != -1 AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
		)

UNION ALL
				
	Select
		'Client Invoices'
		,c.CustomerID as CompanyName
		,i.PostingDate
		,i.InvoiceNumber
		,i.InvoiceTotalAmount
		,Case i.InvoiceStatus 
			When 1 Then 'Not Sent For Approval'
			When 2 Then 'Pending Approval'
			When 3 then 'Rejected' END
		,null as VoucherID
		,u.FirstName + ' ' + u.LastName
	From
		tInvoice i (nolock)
		Inner join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		inner join tUser u (nolock) on i.ApprovedByKey = u.UserKey
	Where
		i.CompanyKey = @CompanyKey and
		i.PostingDate >= @StartDate and
		i.PostingDate <= @EndDate and
		--(@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0)) ) and
		i.InvoiceStatus < 4
		
		AND (-- case when @GLCompanyKey = ALL
			(@GLCompanyKey = -1 AND 
				(
				@RestrictToGLCompany = 0 OR 
				(i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
				)
			)
			--case when @GLCompanyKey = X or Blank(0)
				OR (@GLCompanyKey != -1 AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
		)

UNION ALL

	select 
		'Payments'
		,c.VendorID as CompanyName
		,p.PostingDate
		,'NONE'
		,p.PaymentAmount
		,'NO CHECK NUMBER'
		,null as VoucherID
		,'NONE'
	from tPayment p (nolock)
	inner join tCompany c (nolock) on p.VendorKey = c.CompanyKey
	where p.CompanyKey = @CompanyKey
	and p.PostingDate >= @StartDate
	and p.PostingDate <= @EndDate
	--and (@GLCompanyKey = -1 Or (ISNULL(@GLCompanyKey, 0) = ISNULL(p.GLCompanyKey, 0)) )
	and p.Posted = 0
	and p.CheckNumber is null

	AND (-- case when @GLCompanyKey = ALL
		(@GLCompanyKey = -1 AND 
			(
			@RestrictToGLCompany = 0 OR 
			(p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
		--case when @GLCompanyKey = X or Blank(0)
			OR (@GLCompanyKey != -1 AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
	)
GO
