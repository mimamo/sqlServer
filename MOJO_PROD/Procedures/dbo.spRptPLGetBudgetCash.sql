USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptPLGetBudgetCash]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptPLGetBudgetCash]

	(
		@CompanyKey int,
		@StartDate1 smalldatetime,
		@EndDate1 smalldatetime,
		@StartDate2 smalldatetime,
		@EndDate2 smalldatetime,
		@GLBudgetKey int,
		@BudgetMonth int,
		@NullClassKeyOnly int,		-- User wants Null ClassKey only
		@ClassKeys varchar(8000),	-- Comma Delimited Keys
		@OfficeKey int,
		@DepartmentKey int,
		@ClientKey int,
		@ProjectKey int	
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 04/19/07 GWG 8.42  Included revenue for advance billing invoices
|| 03/26/10 RLB 10.520 (77088) updated for GLBudget having -1 for all
|| 10/18/11 GHL 10.549 Added CREDITCARD entity
|| 11/03/11 GHL 10.459 Added contribution of credit card payments to real voucher
||                     See logic in spRptCorpPLCash
*/

Declare @BudgetType int
Select @BudgetType = BudgetType from tGLBudget (nolock) Where GLBudgetKey = @GLBudgetKey

If ISNULL(@ProjectKey, 0) > 0
	begin
		Select @ClientKey = ClientKey From tProject (nolock) Where ProjectKey = @ProjectKey
		Select @ClientKey = isnull(@ClientKey, 0)
	end


Create table #GLTran1
(
	CompanyKey int,
	GLAccountKey int,
	ClientKey int,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)

Create table #GLTran2
(
	CompanyKey int,
	GLAccountKey int,
	ClientKey int,
	TransactionDate smalldatetime,
	Debit money,
	Credit money
)
Create table #GLBudget
(
	GLAccountKey int,
	Month1 money,
	Month2 money,
	Month3 money,
	Month4 money,
	Month5 money,
	Month6 money,
	Month7 money,
	Month8 money,
	Month9 money,
	Month10 money,
	Month11 money,
	Month12 money,
	YearTotal money
)

Create table #tClass (ClassKey int null)

declare @KeyChar varchar(100)
declare @KeyInt int
declare @Pos int

IF LEN(@ClassKeys) > 0 
BEGIN
	-- Extract classes if any and store in temp table
	WHILE (1 = 1)
	BEGIN
		SELECT @Pos = CHARINDEX (',', @ClassKeys, 1) 
		IF @Pos = 0 
			SELECT @KeyChar = @ClassKeys
		ELSE
			SELECT @KeyChar = LEFT(@ClassKeys, @Pos -1)

		IF LEN(@KeyChar) > 0
		BEGIN
			SELECT @KeyInt = CONVERT(Int, @KeyChar)
			INSERT #tClass (ClassKey) SELECT @KeyInt 
		END

		IF @Pos = 0 
			BREAK
	
		SELECT @ClassKeys = SUBSTRING(@ClassKeys, @Pos + 1, LEN(@ClassKeys)) 
	END
END
ELSE
BEGIN
	-- No classes passed

	IF @OfficeKey = 0 AND @DepartmentKey = 0
	BEGIN
		-- If no classes passed, no office, no department 
		-- then we will capture tGLBudgetDetail.ClassKey = -1 (it is never null) 
		INSERT #tClass (ClassKey) VALUES (-1)

		INSERT #tClass (ClassKey) 
		SELECT ClassKey
		FROM   tClass (NOLOCK)
		WHERE  CompanyKey = @CompanyKey

	END
	
	ELSE
		-- Check for classes in office or department
		INSERT #tClass (ClassKey) 
		SELECT ClassKey 
		FROM   tClass (NOLOCK) 
		WHERE  CompanyKey = @CompanyKey
		AND    (@OfficeKey = 0 Or ISNULL(OfficeKey, 0) = @OfficeKey)
		AND    (@DepartmentKey = 0 Or ISNULL(DepartmentKey, 0) = @DepartmentKey)

END

Insert Into #GLBudget(GLAccountKey, Month1, Month2, Month3, Month4, Month5, Month6, Month7, Month8, Month9, Month10, Month11,  Month12)
Select GLAccountKey, Sum(Month1), Sum(Month2), Sum(Month3), Sum(Month4), Sum(Month5), Sum(Month6), Sum(Month7), Sum(Month8), Sum(Month9), Sum(Month10), Sum(Month11), Sum(Month12)
from   tGLBudgetDetail (nolock) Where GLBudgetKey = @GLBudgetKey
And    ClassKey In (Select ClassKey From #tClass)
And	   (ISNULL(@ClientKey, 0) = 0 Or ClientKey = @ClientKey)
Group By GLAccountKey
			
	-- Perform 2 series of 5 queries
	-- The first one is for the date range @StartDate to @BalanceDate (in #GLTran1)
	-- The second one is for the date range @BeginningDate to @BalanceDate (in #GLTran2)
	
	-- First series
	
	-- First pass: Journal entries
	Insert Into #GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, t.Debit, t.Credit 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )

	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And	t.TransactionDate >= @StartDate1 
	And t.TransactionDate <= @EndDate1
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'GENJRNL'
	And	(@ProjectKey = 0 Or isnull(t.ProjectKey, 0) = @ProjectKey)

	-- Second Pass: vouchers with vendor payments
	Insert Into #GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, 
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join
			(  
			Select 	tVoucher.VoucherKey,
				Sum(tPaymentDetail.Amount) as PaidAmount, 
				tVoucher.VoucherTotal as TotalAmount
			From	tVoucher (nolock)
				inner join tPaymentDetail (nolock) on tVoucher.VoucherKey = tPaymentDetail.VoucherKey
				inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
			Where	tVoucher.CompanyKey = @CompanyKey 
			and		tPayment.Posted = 1
			and     tPayment.PostingDate >= @StartDate1 and tPayment.PostingDate <= @EndDate1
			and		tVoucher.VoucherTotal <> 0
			Group By  
				tVoucher.VoucherKey, 
				tVoucher.VoucherTotal 
			) As b ON t.EntityKey = b.VoucherKey 
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity IN ('VOUCHER', 'CREDITCARD')
	And	(@ProjectKey = 0 Or isnull(t.ProjectKey, 0) = @ProjectKey)

		-- Take in account payments to real vouchers thru credit cards
	INSERT	#GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * payments.PaidAmount)/ payments.RealTotalAmount, 
			(t.Credit * payments.PaidAmount) / payments.RealTotalAmount 
	FROM 	tTransaction t (nolock) 
	left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
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
				and     tPayment.PostingDate >= @StartDate1 AND tPayment.PostingDate <= @EndDate1
				AND		tVoucher.VoucherTotal <> 0
				GROUP BY tVoucher.VoucherKey, tVoucher.VoucherTotal 
				) 
				AS cc_payments ON vcc.VoucherCCKey = cc_payments.VoucherKey
			
			-- real_v = real voucher
			INNER JOIN tVoucher real_v (nolock) on vcc.VoucherKey = real_v.VoucherKey
			
			--WHERE real_v.PostingDate >= @StartDate AND real_v.PostingDate <= @BalanceDate AND real_v.Posted = 1
			GROUP BY vcc.VoucherKey, real_v.VoucherTotal
			) 
			
			AS payments ON t.EntityKey = payments.VoucherKey
			 
	WHERE 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, 0) = 0) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, 0) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'VOUCHER' -- Regular Voucher only
	And	(@ProjectKey = 0	Or isnull(t.ProjectKey, 0) = @ProjectKey)


	-- Third Pass Part A: invoices with client payments (non adv bill)
	Insert Into #GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join
			(  
			Select tInvoice.InvoiceKey,
				Sum(tCheckAppl.Amount) as PaidAmount, 
				tInvoice.InvoiceTotalAmount as TotalAmount
			From	tCheck (nolock)
				inner join tCheckAppl (nolock) on tCheck.CheckKey = tCheckAppl.CheckKey
				inner join tInvoice (nolock) on tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
			Where	tInvoice.CompanyKey = @CompanyKey 
			and		tInvoice.AdvanceBill = 0
			and 	tCheck.Posted = 1 
			and 	tCheck.PostingDate >= @StartDate1 and tCheck.PostingDate <= @EndDate1
			and		tInvoice.InvoiceTotalAmount <> 0
			Group By tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount
			) As b ON t.EntityKey = b.InvoiceKey 
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	-- Take out the account type restriction to get invoices posted to no income accounts.
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'INVOICE'
	And	(@ProjectKey = 0	Or isnull(t.ProjectKey, 0) = @ProjectKey)


	-- Third Pass Part B: invoices with client payments (adv bill)
	Insert Into #GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join
			(  
			Select iab.InvoiceKey, inv.InvoiceTotalAmount as TotalAmount, Sum(iab.Amount * invDet.PaidAmount / invDet.TotalAmount) as PaidAmount
			From tInvoiceAdvanceBill iab (nolock)
			inner join tInvoice inv (nolock) on iab.InvoiceKey = inv.InvoiceKey
			inner join (
				Select tInvoice.InvoiceKey,
					Sum(tCheckAppl.Amount) as PaidAmount, 
					tInvoice.InvoiceTotalAmount as TotalAmount
				From	tCheck (nolock)
					inner join tCheckAppl (nolock) on tCheck.CheckKey = tCheckAppl.CheckKey
					inner join tInvoice (nolock) on tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
				Where	tInvoice.CompanyKey = @CompanyKey 
				and		tInvoice.AdvanceBill = 1
				and 	tCheck.Posted = 1 
				-- take into account any check posted before the end date of the report.
				and 	tCheck.PostingDate <= @EndDate1
				and		tInvoice.InvoiceTotalAmount <> 0
				Group By tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount ) as invDet on iab.AdvBillInvoiceKey = invDet.InvoiceKey
			Where inv.PostingDate >= @StartDate1 and inv.PostingDate <= @EndDate1 and inv.Posted = 1
			Group By iab.InvoiceKey, inv.InvoiceTotalAmount
			
			) As b ON t.EntityKey = b.InvoiceKey 
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	-- Take out the account type restriction to get invoices posted to no income accounts.
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'INVOICE'
	And	(@ProjectKey = 0	Or isnull(t.ProjectKey, 0) = @ProjectKey)

	-- Fourth Pass: payments and expense accounts
	Insert Into #GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	p.CompanyKey, NULL, gl.GLAccountKey, p.PostingDate, 
			pd.Amount, 0 
	From	tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
		left outer join tClass c (nolock) on pd.ClassKey = c.ClassKey	
		inner join tGLAccount gl (nolock) on pd.GLAccountKey = gl.GLAccountKey
	Where	p.CompanyKey = @CompanyKey 
	And 	p.Posted = 1 
	And 	p.PostingDate >= @StartDate1 and p.PostingDate <= @EndDate1
	And		isnull(pd.VoucherKey, 0) = 0	
	And	(
		 (@NullClassKeyOnly = 1 And isnull(pd.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(pd.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	-- No need to check the client key here
	And		(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And		(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And		gl.AccountType in (40, 41, 50, 51, 52)
	And      @ClientKey = 0
	And      @ProjectKey = 0
		
	-- Fifth Pass: receipts and expense accounts
	Insert Into #GLTran1 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select  co.OwnerCompanyKey, c.ClientKey, gl.GLAccountKey, c.PostingDate, 
			0, cappl.Amount
	From	tCheck c (nolock)
		inner join tCompany  co (nolock) on c.ClientKey = co.CompanyKey 
		inner join tCheckAppl cappl (nolock) on c.CheckKey = cappl.CheckKey
		left outer join tClass cl (nolock) on cappl.ClassKey = cl.ClassKey
		inner join tGLAccount gl (nolock) on cappl.SalesAccountKey = gl.GLAccountKey
	Where	co.OwnerCompanyKey = @CompanyKey 
	and 	c.Posted = 1 
	and 	c.PostingDate >= @StartDate1 and c.PostingDate <= @EndDate1
	and		isnull(cappl.InvoiceKey, 0) = 0
	And	(
		 (@NullClassKeyOnly = 1 And isnull(cappl.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(cappl.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And		(@ClientKey = 0 Or isnull(c.ClientKey, 0) = @ClientKey)
	And		(@DepartmentKey = 0 Or isnull(cl.DepartmentKey, 0) = @DepartmentKey)
	And		(@OfficeKey = 0 Or isnull(cl.OfficeKey, 0) = @OfficeKey)
	And		gl.AccountType in (40, 41, 50, 51, 52)
	And     @ProjectKey = 0
	
	-- Second series
	
	-- First pass: Journal entries
	Insert Into #GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, t.Debit, t.Credit 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And	t.TransactionDate >= @StartDate2 
	And t.TransactionDate <= @EndDate2
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'GENJRNL'
	And	(@ProjectKey = 0 Or isnull(t.ProjectKey, 0) = @ProjectKey)


	-- Second Pass: vouchers with vendor payments
	Insert Into #GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate, 
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join
			(  
			Select 	tVoucher.VoucherKey,
				Sum(tPaymentDetail.Amount) as PaidAmount, 
				tVoucher.VoucherTotal as TotalAmount
			From	tVoucher (nolock)
				inner join tPaymentDetail (nolock) on tVoucher.VoucherKey = tPaymentDetail.VoucherKey
				inner join tPayment (nolock) on tPaymentDetail.PaymentKey = tPayment.PaymentKey
			Where	tVoucher.CompanyKey = @CompanyKey 
			and		tPayment.Posted = 1
			and     tPayment.PostingDate >= @StartDate2 and tPayment.PostingDate <= @EndDate2
			and		tVoucher.VoucherTotal <> 0
			Group By  
				tVoucher.VoucherKey, 
				tVoucher.VoucherTotal 
			) As b ON t.EntityKey = b.VoucherKey 
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'VOUCHER'
	And	(@ProjectKey = 0 Or isnull(t.ProjectKey, 0) = @ProjectKey)

		-- Take in account payments to real vouchers thru credit cards
	INSERT	#GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	SELECT 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * payments.PaidAmount)/ payments.RealTotalAmount, 
			(t.Credit * payments.PaidAmount) / payments.RealTotalAmount 
	FROM 	tTransaction t (nolock) 
	left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
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
				and     tPayment.PostingDate >= @StartDate2 and  tPayment.PostingDate <= @EndDate2
				AND		tVoucher.VoucherTotal <> 0
				GROUP BY tVoucher.VoucherKey, tVoucher.VoucherTotal 
				) 
				AS cc_payments ON vcc.VoucherCCKey = cc_payments.VoucherKey
			
			-- real_v = real voucher
			INNER JOIN tVoucher real_v (nolock) on vcc.VoucherKey = real_v.VoucherKey
			
			--WHERE real_v.PostingDate >= @BeginningDate AND real_v.PostingDate <= @BalanceDate AND real_v.Posted = 1
			GROUP BY vcc.VoucherKey, real_v.VoucherTotal
			) 
			
			AS payments ON t.EntityKey = payments.VoucherKey
			 
	WHERE 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, 0) = 0) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, 0) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'VOUCHER' -- Regular Voucher only
	And	(@ProjectKey = 0	Or isnull(t.ProjectKey, 0) = @ProjectKey)



	-- Third Pass Part A: invoices with client payments (non adv bill)
	Insert Into #GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join
			(  
			Select tInvoice.InvoiceKey,
				Sum(tCheckAppl.Amount) as PaidAmount, 
				tInvoice.InvoiceTotalAmount as TotalAmount
			From	tCheck (nolock)
				inner join tCheckAppl (nolock) on tCheck.CheckKey = tCheckAppl.CheckKey
				inner join tInvoice (nolock) on tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
			Where	tInvoice.CompanyKey = @CompanyKey 
			and		tInvoice.AdvanceBill = 0
			and 	tCheck.Posted = 1 
			and 	tCheck.PostingDate >= @StartDate2 and tCheck.PostingDate <= @EndDate2
			and		tInvoice.InvoiceTotalAmount <> 0
			Group By tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount
			) As b ON t.EntityKey = b.InvoiceKey 
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	-- Take out the account type restriction to get invoices posted to no income accounts.
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'INVOICE'
	And	(@ProjectKey = 0	Or isnull(t.ProjectKey, 0) = @ProjectKey)

	-- Third Pass Part B: invoices with client payments (adv bill)
	Insert Into #GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	t.CompanyKey, t.ClientKey, t.GLAccountKey, t.TransactionDate,
			(t.Debit * b.PaidAmount)/ b.TotalAmount, 
			(t.Credit * b.PaidAmount) / b.TotalAmount 
	From 	tTransaction t (nolock) 
		left outer join tClass c (nolock) on t.ClassKey = c.ClassKey
		inner join tGLAccount gl (nolock) on t.GLAccountKey = gl.GLAccountKey
		inner join
			(  
			Select iab.InvoiceKey, inv.InvoiceTotalAmount as TotalAmount, Sum(iab.Amount * invDet.PaidAmount / invDet.TotalAmount) as PaidAmount
			From tInvoiceAdvanceBill iab (nolock)
			inner join tInvoice inv (nolock) on iab.InvoiceKey = inv.InvoiceKey
			inner join (
				Select tInvoice.InvoiceKey,
					Sum(tCheckAppl.Amount) as PaidAmount, 
					tInvoice.InvoiceTotalAmount as TotalAmount
				From	tCheck (nolock)
					inner join tCheckAppl (nolock) on tCheck.CheckKey = tCheckAppl.CheckKey
					inner join tInvoice (nolock) on tCheckAppl.InvoiceKey = tInvoice.InvoiceKey
				Where	tInvoice.CompanyKey = @CompanyKey 
				and		tInvoice.AdvanceBill = 1
				and 	tCheck.Posted = 1 
				-- take into account any check posted before the end date of the report.
				and 	tCheck.PostingDate <= @EndDate2
				and		tInvoice.InvoiceTotalAmount <> 0
				Group By tInvoice.InvoiceKey, tInvoice.InvoiceTotalAmount ) as invDet on iab.AdvBillInvoiceKey = invDet.InvoiceKey
			Where inv.PostingDate >= @StartDate2 and inv.PostingDate <= @EndDate2 and inv.Posted = 1
			Group By iab.InvoiceKey, inv.InvoiceTotalAmount
			
			) As b ON t.EntityKey = b.InvoiceKey 
	Where 	t.CompanyKey = @CompanyKey
	And	(
		 (@NullClassKeyOnly = 1 And isnull(t.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(t.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And	(@ClientKey = 0 Or isnull(t.ClientKey, 0) = @ClientKey)
	And	(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And	(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	-- Take out the account type restriction to get invoices posted to no income accounts.
	And	gl.AccountType in (40, 41, 50, 51, 52)
	And	t.Entity = 'INVOICE'
	And	(@ProjectKey = 0	Or isnull(t.ProjectKey, 0) = @ProjectKey)

	-- Fourth Pass: payments and expense accounts
	Insert Into #GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select 	p.CompanyKey, NULL, gl.GLAccountKey, p.PostingDate, 
			pd.Amount, 0 
	From	tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on pd.PaymentKey = p.PaymentKey
		left outer join tClass c (nolock) on pd.ClassKey = c.ClassKey	
		inner join tGLAccount gl (nolock) on pd.GLAccountKey = gl.GLAccountKey
	Where	p.CompanyKey = @CompanyKey 
	And 	p.Posted = 1 
	And 	p.PostingDate >= @StartDate2 and p.PostingDate <= @EndDate2
	And		isnull(pd.VoucherKey, 0) = 0	
	And	(
		 (@NullClassKeyOnly = 1 And isnull(pd.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(pd.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	-- No need to check the client key here
	And		(@DepartmentKey = 0 Or isnull(c.DepartmentKey, 0) = @DepartmentKey)
	And		(@OfficeKey = 0 Or isnull(c.OfficeKey, 0) = @OfficeKey)
	And		gl.AccountType in (40, 41, 50, 51, 52)
	And     @ClientKey = 0
	And     @ProjectKey = 0
			
	-- Fifth Pass: receipts and expense accounts
	Insert Into #GLTran2 (CompanyKey, ClientKey, GLAccountKey, TransactionDate, Debit, Credit)
	Select  co.OwnerCompanyKey, c.ClientKey, gl.GLAccountKey, c.PostingDate, 
			0, cappl.Amount
	From	tCheck c (nolock)
		inner join tCompany  co (nolock) on c.ClientKey = co.CompanyKey 
		inner join tCheckAppl cappl (nolock) on c.CheckKey = cappl.CheckKey
		left outer join tClass cl (nolock) on cappl.ClassKey = cl.ClassKey
		inner join tGLAccount gl (nolock) on cappl.SalesAccountKey = gl.GLAccountKey
	Where	co.OwnerCompanyKey = @CompanyKey 
	and 	c.Posted = 1 
	and 	c.PostingDate >= @StartDate2 and c.PostingDate <= @EndDate2
	and		isnull(cappl.InvoiceKey, 0) = 0
	And	(
		 (@NullClassKeyOnly = 1 And isnull(cappl.ClassKey, -1) = -1) Or 
		 (@NullClassKeyOnly = 0 And isnull(cappl.ClassKey, -1) In (Select ClassKey From #tClass)   )
		 )
	And		(@ClientKey = 0 Or isnull(c.ClientKey, 0) = @ClientKey)
	And		(@DepartmentKey = 0 Or isnull(cl.DepartmentKey, 0) = @DepartmentKey)
	And		(@OfficeKey = 0 Or isnull(cl.OfficeKey, 0) = @OfficeKey)
	And		gl.AccountType in (40, 41, 50, 51, 52)
	And     @ProjectKey = 0
	
	Select 
		gl.GLAccountKey
		,AccountNumber
		,AccountName
		,AccountType
		,ISNULL(ParentAccountKey, 0) as ParentAccountKey
		,DisplayOrder
		,DisplayLevel
		,Rollup
		,Case When AccountType = 40 then 1
			When AccountType = 50 then 1
			When AccountType = 51 then 2
			When AccountType = 41 then 3
			When AccountType = 52 then 3 end as MajorGroup
		,Case When AccountType = 40 then 1
			When AccountType = 50 then 2
			When AccountType = 51 then 3
			When AccountType = 41 then 4
			When AccountType = 52 then 5 end as MinorGroup
		
		,ISNULL(Case When AccountType in (40, 41) and Rollup = 0 then
				(Select ROUND(Sum(Credit - Debit), 2) from #GLTran1 t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				)
			else
				(Select ROUND(Sum(Debit - Credit), 2) from #GLTran1 t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				) end , 0)
			As MonthAmount
		,ISNULL(Case When AccountType in (40, 41) and Rollup = 0 then
				(Select ROUND(Sum(Credit - Debit), 2) from #GLTran2 t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				)
			else
				(Select ROUND(Sum(Debit - Credit), 2) from #GLTran2 t (nolock) 
				Where	t.GLAccountKey = gl.GLAccountKey
				) end , 0)
			As YearAmount
		,Month1	,Month2	,Month3	,Month4	,Month5	,Month6	,Month7	,Month8	,Month9	,Month10 ,Month11 ,Month12
		,Case @BudgetMonth
			When 1 then ISNULL(bd.Month1, 0)
			When 2 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0)
			When 3 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0)
			When 4 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0)
			When 5 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0)
			When 6 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0)
			When 7 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0)
			When 8 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0)
			When 9 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0)
			When 10 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0)
			When 11 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0)
			When 12 then ISNULL(bd.Month1, 0) + ISNULL(bd.Month2, 0) + ISNULL(bd.Month3, 0) + ISNULL(bd.Month4, 0) + ISNULL(bd.Month5, 0) + ISNULL(bd.Month6, 0) + ISNULL(bd.Month7, 0) + ISNULL(bd.Month8, 0) + ISNULL(bd.Month9, 0) + ISNULL(bd.Month10, 0) + ISNULL(bd.Month11, 0) + ISNULL(bd.Month12, 0)
			end as Month0
	From
		tGLAccount gl (nolock)
		left outer join 
			#GLBudget bd on gl.GLAccountKey = bd.GLAccountKey
	Where
		gl.CompanyKey = @CompanyKey 
	and
		AccountType in (40, 41, 50, 51, 52)
	Order By MajorGroup, MinorGroup, DisplayOrder
GO
