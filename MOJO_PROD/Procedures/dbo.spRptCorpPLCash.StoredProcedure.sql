USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCorpPLCash]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCorpPLCash]
	@CompanyKey int,
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@CashBasisLegacy int = 1,
	@UserKey int = null,
	@TranCountOnly tinyint = 0
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/21/07   CRG 8.5      Created for Flex Corporate P&L
|| 04/01/09  GHL 10.022   Added cash basis legacy parameter so that
||                        users have the choice to run the report using old calculations
|| 12/7/09   CRG 10.5.1.5 (46327) Modified to use a temp table for selected ClassKeys
|| 10/13/11  GHL 10.4.5.9 Added new entity CREDITCARD 
|| 11/03/11  GHL 10.4.5.9 Added contribution of credit card payments to real voucher
|| 04/11/12  GHL 10.555   Added UserKey for UserGLCompanyAccess
|| 07/18/12  GHL 10.558   Added support of multiple GL companies and offices and depts
|| 10/26/12  CRG 10.5.6.1 Added TranCountOnly to return the number of transactions so that some columns can be hidden when running "One Column Per"
|| 12/31/13  GHL 10.5.7.5 Using now vHTransaction to pull home currency values
*/

/*

Design for advance bills and credit cards

tTransaction-----tVoucher-----tVoucherCC-----tVoucher-----tPaymentDetail-----tPayment
                  (real)                     (ccard)
2 lines    
100                600          200           2000            1000 
500

real voucher: Posted and StartDate < PostingDate < EndDate
payment: Posted and PostingDate < EndDate

Paid Amount = Debit * (VoucherCC Amount / Real Total Amount) * (Paid Amount / CC Total Amount)
 
line 1 = 100 * (200/ 600) * (1000/2000) = (100 / 3) / 2 = 16.666
line 2 = 500 * (200/ 600) * (1000/2000) = (500 / 3) / 2 = 83.333              
                                            Total         99.999 = 100
*/

	DECLARE @TrackCash INT 
	
	IF @CashBasisLegacy = 0
	BEGIN
		EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, NULL
		IF @TrackCash = 1
		BEGIN
			EXEC spRptCorpPLCashBasis @CompanyKey,@StartDate,@EndDate, @UserKey
			RETURN 1
		END	
	END

	Declare @RestrictToGLCompany int

	Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from   tPreference (nolock) 
	Where  CompanyKey = @CompanyKey

	select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	/* Assume Created in VB
		CREATE TABLE #ClassKeys (ClassKey int NULL)
	*/

	DECLARE	@HasClassKeys int
	SELECT	@HasClassKeys = COUNT(*)
	FROM	#ClassKeys

	DECLARE	@HasGLCompanyKeys int
	SELECT	@HasGLCompanyKeys = COUNT(*)
	FROM	#GLCompanyKeys

	DECLARE	@HasOfficeKeys int
	SELECT	@HasOfficeKeys = COUNT(*)
	FROM	#OfficeKeys

	DECLARE	@HasDepartmentKeys int
	SELECT	@HasDepartmentKeys = COUNT(*)
	FROM	#DepartmentKeys

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
	FROM 	vHTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	WHERE 	t.CompanyKey = @CompanyKey
	--If we pass in 0 for GLCompany, Office, Class, or Department, we want rows where that value is NULL.
	--If we pass in NULL, we want all rows.
	
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)

	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		t.TransactionDate >= @StartDate 
	AND		t.TransactionDate <= @EndDate
	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'GENJRNL'

	-- Second Pass: vouchers with vendor payments
	-- Note: this should be valid because tVoucherCC records will be posted against the AP account
	-- but we could also add to the where clause AND t.Section <> 7 
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, 
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	FROM 	vHTransaction t (nolock) 
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
	--AND		(ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)

	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity IN ('VOUCHER', 'CREDITCARD')

	-- Take in account payments to real vouchers thru credit cards
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * payments.PaidAmount)/ payments.RealTotalAmount, 
			(t.Credit * payments.PaidAmount) / payments.RealTotalAmount 
	FROM 	vHTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	INNER JOIN
			(
			SELECT  vcc.VoucherKey						-- real voucher
					,real_v.VoucherTotal				AS RealTotalAmount
					, SUM(vcc.Amount * cc_payments.PaidAmount / cc_payments.CCTotalAmount) AS PaidAmount
			FROM tVoucherCC vcc (nolock)
			
			-- cc_payments = Paid Amounts against Credit Cards
			INNER JOIN 
				(
				SELECT tVoucher.VoucherKey,				-- Credit Card voucher
						SUM(tPaymentDetail.Amount)		as PaidAmount, 
						tVoucher.VoucherTotal			as CCTotalAmount
				FROM	tPayment (nolock)
				INNER JOIN tPaymentDetail (nolock) ON tPayment.PaymentKey = tPaymentDetail.PaymentKey
				INNER JOIN tVoucher (nolock) ON tPaymentDetail.VoucherKey = tVoucher.VoucherKey
				WHERE	tVoucher.CompanyKey = @CompanyKey 
				AND		tVoucher.CreditCard = 1
				AND 	tPayment.Posted = 1 
				-- take into account any check posted before the end date of the report.
				AND 	tPayment.PostingDate <= @EndDate
				AND		tVoucher.VoucherTotal <> 0
				GROUP BY tVoucher.VoucherKey, tVoucher.VoucherTotal 
				) 
				AS cc_payments ON vcc.VoucherCCKey = cc_payments.VoucherKey
			
			-- real_v = real voucher
			INNER JOIN tVoucher real_v (nolock) on vcc.VoucherKey = real_v.VoucherKey
			
			WHERE real_v.PostingDate >= @StartDate AND real_v.PostingDate <= @EndDate AND real_v.Posted = 1
			GROUP BY vcc.VoucherKey, real_v.VoucherTotal
			) 
			
			AS payments ON t.EntityKey = payments.VoucherKey
			 
	WHERE 	t.CompanyKey = @CompanyKey

	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)
	
	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'VOUCHER' -- Regular Voucher


	-- Third Pass Part A: invoices with client payments (non adv bill)
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	FROM 	vHTransaction t (nolock) 
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
	
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)

	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'INVOICE'

	-- Third Pass Part B: invoices with client payments (adv bill)
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	FROM 	vHTransaction t (nolock) 
	INNER JOIN tGLAccount gl (nolock) ON t.GLAccountKey = gl.GLAccountKey
	INNER JOIN
			(SELECT iab.InvoiceKey, inv.InvoiceTotalAmount AS TotalAmount
			, SUM(iab.Amount * invDet.PaidAmount / invDet.TotalAmount) AS PaidAmount
			FROM tInvoiceAdvanceBill iab (nolock)
			

			-- real invoice
			INNER JOIN tInvoice inv (nolock) on iab.InvoiceKey = inv.InvoiceKey
			
			INNER JOIN 
				-- invDet = Paid Amounts against Advance Bills
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
				GROUP BY tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount ) 
			
				AS invDet ON iab.AdvBillInvoiceKey = invDet.InvoiceKey
			
			WHERE inv.PostingDate >= @StartDate AND inv.PostingDate <= @EndDate AND inv.Posted = 1
			GROUP BY iab.InvoiceKey, inv.InvoiceTotalAmount) 
			
			AS b ON t.EntityKey = b.InvoiceKey
			 
	WHERE 	t.CompanyKey = @CompanyKey

	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(t.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)

	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(t.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND		(ISNULL(t.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(t.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		gl.AccountType in (40, 41, 50, 51, 52)
	AND		t.Entity = 'INVOICE'

	-- Fourth Pass: payments and expense accounts
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	p.CompanyKey, NULL, gl.GLAccountKey, p.PostingDate, 
			round(pd.Amount * p.ExchangeRate, 2), 0 
	FROM	tPayment p (nolock)
	INNER JOIN tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
	INNER JOIN tGLAccount gl (nolock) on pd.GLAccountKey = gl.GLAccountKey
	WHERE	p.CompanyKey = @CompanyKey 
	AND 	p.Posted = 1 
	AND 	p.PostingDate >= @StartDate and p.PostingDate <= @EndDate
	AND		ISNULL(pd.VoucherKey, 0) = 0	
	
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(p.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)

	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(pd.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND		(ISNULL(pd.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(pd.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		gl.AccountType in (40, 41, 50, 51, 52)

	-- Fifth Pass: receipts and expense accounts
	INSERT	#GLTran (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT  co.OwnerCompanyKey, c.ClientKey, gl.GLAccountKey, c.PostingDate, 0, round(cappl.Amount * c.ExchangeRate, 2)
	FROM	tCheck c (nolock)
	INNER JOIN tCompany  co (nolock) ON c.ClientKey = co.CompanyKey 
	INNER JOIN tCheckAppl cappl (nolock) ON c.CheckKey = cappl.CheckKey
	INNER JOIN tGLAccount gl (nolock) ON cappl.SalesAccountKey = gl.GLAccountKey
	WHERE	co.OwnerCompanyKey = @CompanyKey 
	AND 	c.Posted = 1 
	AND 	c.PostingDate >= @StartDate AND c.PostingDate <= @EndDate
	AND		ISNULL(cappl.InvoiceKey, 0) = 0
	--AND		(ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	/*
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(c.GLCompanyKey, 0) = @GLCompanyKey)
			)
	*/
	AND (
		-- All companies
		(
		@HasGLCompanyKeys = 0 AND
			(
			@RestrictToGLCompany = 0 OR 
			(c.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
			)
		)
	-- Or specific companies requested (Is Blank will be 0 in #GLCompanyKeys)
	OR ISNULL(c.GLCompanyKey, 0) IN (SELECT GLCompanyKey FROM #GLCompanyKeys)	
	)

	AND (
		-- All offices
		@HasOfficeKeys = 0 
		-- Or specific offices requested (Is Blank will be 0 in #OfficeKeys)
		OR ISNULL(cappl.OfficeKey, 0) IN (SELECT OfficeKey FROM #OfficeKeys)	
	)

	AND		(ISNULL(cappl.ClassKey, 0) IN (SELECT ClassKey FROM #ClassKeys) OR @HasClassKeys = 0)
	
	AND (
		-- All departments
		@HasDepartmentKeys = 0 
		-- Or specific departments requested (Is Blank will be 0 in #departmentsKeys)
		OR ISNULL(cappl.DepartmentKey, 0) IN (SELECT DepartmentKey FROM #DepartmentKeys)	
	)

	AND		gl.AccountType in (40, 41, 50, 51, 52)

	IF @TranCountOnly = 1
	BEGIN
		SELECT	COUNT(*) AS Amount
		FROM	#GLTran

		RETURN
	END

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
