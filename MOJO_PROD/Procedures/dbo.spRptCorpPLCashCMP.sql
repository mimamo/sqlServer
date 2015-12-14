USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLCashCMP]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLCashCMP]
	@CompanyKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@ClassKey int,
	@DepartmentKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@CashBasisLegacy int = 1
AS --Encrypt

/*
|| When      Who Rel      What
|| 12/7/09   CRG 10.5.1.5 (46327) Created so that the old SP can be modified for WMJ, but the CMP logic can remain the same
*/

	DECLARE @TrackCash INT 
	
	IF @CashBasisLegacy = 0
	BEGIN
		EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, NULL
		IF @TrackCash = 1
		BEGIN
			EXEC spRptCorpPLCashBasisCMP @CompanyKey,@GLCompanyKey,@OfficeKey,@ClassKey,@DepartmentKey,@StartDate,@EndDate
			RETURN 1
		END	
	END

	--Create the Temp Table
	IF Object_Id('tempdb..#GLTran') IS NOT NULL
		DROP TABLE #GLTran
		
	CREATE TABLE #GLTran(
		CompanyKey int,
		GLAccountKey int,
		ClientKey int,
		TransactionDate smalldatetime,
		Debit money,
		Credit money)
	
	-- First pass: Journal entries
	INSERT  #GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, t.Debit, t.Credit 
	FROM 	tTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	WHERE 	t.CompanyKey = @CompanyKey
	--If we pass in 0 for GLCompany, Office, Class, or Department, we want rows where that value is NULL.
	--If we pass in NULL, we want all rows.
	AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		(ISNULL(t.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
	AND		(ISNULL(t.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
	AND		(ISNULL(t.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
	AND		t.TransactionDate >= @StartDate 
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'GENJRNL'

	-- Second Pass: vouchers with vendor payments
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, 
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	FROM 	tTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	INNER JOIN
			(SELECT tVoucher.VoucherKey,
					SUM(tPaymentDetail.Amount) as PaidAmount, 
					tVoucher.VoucherTotal as TotalAmount
			FROM	tVoucher (nolock)
			INNER JOIN tPaymentDetail (nolock) ON tVoucher.VoucherKey = tPaymentDetail.VoucherKey
			INNER JOIN tPayment (nolock) ON tPaymentDetail.PaymentKey = tPayment.PaymentKey
			WHERE	tVoucher.CompanyKey = @CompanyKey 
			AND		tPayment.Posted = 1
			AND     tPayment.PostingDate >= @StartDate AND tPayment.PostingDate <= @EndDate
			AND		tVoucher.VoucherTotal <> 0
			GROUP BY tVoucher.VoucherKey, tVoucher.VoucherTotal) AS b ON t.EntityKey = b.VoucherKey 
	WHERE 	t.CompanyKey = @CompanyKey
	AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		(ISNULL(t.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
	AND		(ISNULL(t.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
	AND		(ISNULL(t.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'VOUCHER'

	-- Third Pass Part A: invoices with client payments (non adv bill)
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	FROM 	tTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	INNER JOIN
			(SELECT tInvoice.InvoiceKey,
					SUM(tCheckAppl.Amount) AS PaidAmount, 
					tInvoice.InvoiceTotalAmount AS TotalAmount
			FROM	tCheck (nolock)
			INNER JOIN tCheckAppl (nolock) ON tCheck.CheckKey = tCheckAppl.CheckKey
			INNER JOIN tInvoice (nolock) ON tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
			WHERE	tInvoice.CompanyKey = @CompanyKey 
			AND		tInvoice.AdvanceBill = 0
			AND 	tCheck.Posted = 1 
			AND 	tCheck.PostingDate >= @StartDate AND tCheck.PostingDate <= @EndDate
			AND		tInvoice.InvoiceTotalAmount <> 0
			GROUP BY tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount) AS b ON t.EntityKey = b.InvoiceKey 
	WHERE 	t.CompanyKey = @CompanyKey
	AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		(ISNULL(t.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
	AND		(ISNULL(t.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
	AND		(ISNULL(t.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'INVOICE'

	-- Third Pass Part B: invoices with client payments (adv bill)
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	FROM 	tTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	INNER JOIN
			(SELECT iab.InvoiceKey, inv.InvoiceTotalAmount AS TotalAmount, SUM(iab.Amount * invDet.PaidAmount / invDet.TotalAmount) AS PaidAmount
			FROM tInvoiceAdvanceBill iab (nolock)
			INNER JOIN tInvoice inv (nolock) on iab.InvoiceKey = inv.InvoiceKey
			INNER JOIN 
				(SELECT tInvoice.InvoiceKey,
						SUM(tCheckAppl.Amount) as PaidAmount, 
						tInvoice.InvoiceTotalAmount as TotalAmount
				FROM	tCheck (nolock)
				INNER JOIN tCheckAppl (nolock) ON tCheck.CheckKey = tCheckAppl.CheckKey
				INNER JOIN tInvoice (nolock) ON tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
				WHERE	tInvoice.CompanyKey = @CompanyKey 
				AND		tInvoice.AdvanceBill = 1
				AND 	tCheck.Posted = 1 
				-- take into account any check posted before the end date of the report.
				AND 	tCheck.PostingDate <= @EndDate
				AND		tInvoice.InvoiceTotalAmount <> 0
				GROUP BY tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount ) AS invDet ON iab.AdvBillInvoiceKey = invDet.InvoiceKey
			WHERE inv.PostingDate >= @StartDate AND inv.PostingDate <= @EndDate AND inv.Posted = 1
			GROUP BY iab.InvoiceKey, inv.InvoiceTotalAmount) AS b ON t.EntityKey = b.InvoiceKey 
	WHERE 	t.CompanyKey = @CompanyKey
	AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		(ISNULL(t.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
	AND		(ISNULL(t.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
	AND		(ISNULL(t.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'INVOICE'

	-- Fourth Pass: payments and expense accounts
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	p.CompanyKey, NULL, gl.GLAccountKey, p.PostingDate, 
			pd.Amount, 0 
	FROM	tPayment p (nolock)
	INNER JOIN tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
	INNER JOIN tGLAccount gl (nolock) on pd.GLAccountKey = gl.GLAccountKey
	WHERE	p.CompanyKey = @CompanyKey 
	AND 	p.Posted = 1 
	AND 	p.PostingDate >= @StartDate and p.PostingDate <= @EndDate
	AND		ISNULL(pd.VoucherKey, 0) = 0	
	AND		(ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		(ISNULL(pd.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
	AND		(ISNULL(pd.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
	AND		(ISNULL(pd.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
	AND		gl.AccountType in (40, 41, 50, 51, 52)

	-- Fifth Pass: receipts and expense accounts
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT  co.OwnerCompanyKey, c.ClientKey, gl.GLAccountKey, c.PostingDate, 0, cappl.Amount
	FROM	tCheck c (nolock)
	INNER JOIN tCompany  co (nolock) ON c.ClientKey = co.CompanyKey 
	INNER JOIN tCheckAppl cappl (nolock) ON c.CheckKey = cappl.CheckKey
	INNER JOIN tGLAccount gl (nolock) ON cappl.SalesAccountKey = gl.GLAccountKey
	WHERE	co.OwnerCompanyKey = @CompanyKey 
	AND 	c.Posted = 1 
	AND 	c.PostingDate >= @StartDate AND c.PostingDate <= @EndDate
	AND		ISNULL(cappl.InvoiceKey, 0) = 0
	AND		(ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND		(ISNULL(cappl.OfficeKey, 0) = @OfficeKey OR @OfficeKey IS NULL)
	AND		(ISNULL(cappl.ClassKey, 0) = @ClassKey OR @ClassKey IS NULL)
	AND		(ISNULL(cappl.DepartmentKey, 0) = @DepartmentKey OR @DepartmentKey IS NULL)
	AND		gl.AccountType in (40, 41, 50, 51, 52)

	SELECT	GLAccountKey,
			ISNULL(ParentAccountKey, 0) as ParentAccountKey,
			DisplayOrder,
			DisplayLevel,
			Rollup,
			CASE gl.AccountType
				WHEN 40 THEN 1
				WHEN 50 THEN 2
				WHEN 51 THEN 3
				WHEN 41 THEN 4
				WHEN 52 THEN 5 
			END AS MinorGroup,
			ISNULL(
				CASE
					WHEN AccountType IN (40, 41) THEN
						(SELECT	SUM(Credit - Debit)
						FROM	#GLTran t
						WHERE	t.GLAccountKey = gl.GLAccountKey)
					ELSE
						(SELECT	SUM(Debit - Credit)
						FROM	#GLTran t
						WHERE	t.GLAccountKey = gl.GLAccountKey)
				END
			, 0) AS Amount
	FROM	tGLAccount gl (nolock)
	WHERE	CompanyKey = @CompanyKey
	AND		AccountType IN (40, 41, 50, 51, 52)			
	ORDER BY MinorGroup, DisplayOrder
GO
