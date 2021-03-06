USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountGetBalanceData]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountGetBalanceData]
	@CompanyKey int,
	@UserKey int,
	@AcctType int,
	@GLAccountKey int = NULL,
	@EndDate datetime = NULL,
	@GLCompanyKey int = NULL -- -1 All, 0 NULL, >0 valid GLCompany
AS

  /*
  || When     Who Rel    What
  || 01/18/13 MFT 10.564 Created
  || 02/25/13 MFT 10.565 Complete overhaul
  || 07/22/14 RLB 10.582 (207281) SP will now work for AP or AR Aging find last balance button
  || 02/05/15 GHL 10.588 (242156) When a payment by credit card is before the vendor invoice, it will not be taken in account
  ||                     So just include it like regular payment in the same situation	
  */
  
CREATE TABLE #Aging
	(	
		GLCompanyKey int null,
		BilledAmount money null,
		AppliedAmount money null	
	)

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

SELECT @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

SELECT @EndDate = ISNULL(@EndDate, GETDATE())


IF @AcctType = 11
BEGIN
	------AR INSERT 1------
	INSERT INTO #Aging
	SELECT 
		i.GLCompanyKey,
		ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.DiscountAmount, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0),
		(
			(
				SELECT ISNULL(SUM(ca.Amount), 0)
				FROM
					tCheckAppl ca (nolock)
					INNER JOIN tCheck ch (nolock) ON ch.CheckKey = ca.CheckKey
				WHERE
					ca.InvoiceKey = i.InvoiceKey AND
					ch.PostingDate <= @EndDate AND
					ch.Posted >= 1
			) +
			(
				SELECT ISNULL(SUM(Amount), 0) 
				FROM
					tInvoiceCredit ic (nolock) 
					INNER JOIN tInvoice cc (nolock) ON cc.InvoiceKey = ic.CreditInvoiceKey
				WHERE
					ic.InvoiceKey = i.InvoiceKey AND
					cc.PostingDate <= @EndDate AND
					cc.Posted >= 1
			)
		)
	FROM tInvoice i (nolock)
	WHERE
		i.CompanyKey = @CompanyKey AND
		i.PostingDate <= @EndDate AND
		i.InvoiceTotalAmount >= 0 AND
		(@GLCompanyKey = -1 OR (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0))) AND
		(@GLAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @GLAccountKey) AND
		i.Posted >= 1



	-- delete if over applied already
	delete #Aging where BilledAmount < AppliedAmount


	------AR INSERT 2------
	INSERT INTO #Aging
	SELECT
		ch.GLCompanyKey,
		ca.Amount * -1,
		0
	FROM
		tCheck ch (nolock)
		INNER JOIN tCompany c (nolock) ON ch.ClientKey = c.CompanyKey
		INNER JOIN tCheckAppl ca (nolock) ON ch.CheckKey = ca.CheckKey
		INNER JOIN tInvoice i (nolock) ON ca.InvoiceKey = i.InvoiceKey
	WHERE
		c.OwnerCompanyKey = @CompanyKey AND
		i.PostingDate > @EndDate AND
		ch.PostingDate <= @EndDate AND
		ca.Prepay = 0 AND -- you dont want the stuff applied as a prepayment as that should come off the other invoice.
		(@GLCompanyKey = -1 OR (ISNULL(@GLCompanyKey, 0) = ISNULL(ch.GLCompanyKey, 0))) AND
		(@GLAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @GLAccountKey) AND
		ch.Posted >= 1



	------AR INSERT 3------
	INSERT INTO #Aging
	SELECT
		i.GLCompanyKey,
		ISNULL(i.InvoiceTotalAmount, 0) - ISNULL(i.DiscountAmount, 0) - ISNULL(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0),
		(
			(
				SELECT ISNULL(SUM(Amount), 0) 
				FROM
					tCheckAppl ca (nolock) 
					INNER JOIN tCheck ch (nolock) ON ch.CheckKey = ca.CheckKey
				WHERE
					ca.InvoiceKey = i.InvoiceKey AND
					ch.PostingDate <= @EndDate AND
					ch.Posted >= 1	
			) +
			(
				SELECT ISNULL(SUM(Amount), 0) * -1 
				FROM
					tInvoiceCredit icd (nolock) 
					INNER JOIN tInvoice ic (nolock) ON ic.InvoiceKey = icd.InvoiceKey
				WHERE
					icd.CreditInvoiceKey = i.InvoiceKey AND
					ic.PostingDate <= @EndDate AND
					ic.Posted >= 1
			)
		)
	FROM
		tInvoice i (nolock)
	WHERE
		i.CompanyKey = @CompanyKey AND
		i.PostingDate <= @EndDate AND
		i.InvoiceTotalAmount < 0 AND
		(@GLCompanyKey = -1 OR (ISNULL(@GLCompanyKey, 0) = ISNULL(i.GLCompanyKey, 0))) AND
		(@GLAccountKey IS NULL OR ISNULL(i.ARAccountKey, 0) = @GLAccountKey) AND
		i.Posted >= 1
		
	-- If the user selected ALL Companies and we restrict
	-- we need to look up into tUserGLCompanyAccess
	IF @GLCompanyKey =-1 AND @RestrictToGLCompany = 1
	begin
		update #Aging set GLCompanyKey = isnull(GLCompanyKey, 0)

		-- this does not delete null GLCompanyKey
		delete #Aging
		where  GLCompanyKey not in (select GLCompanyKey from tUserGLCompanyAccess where UserKey = @UserKey) 
	end

	-- Only keep open amounts
	DELETE #Aging 
	WHERE  BilledAmount - AppliedAmount = 0

END
ELSE
BEGIN

------------------AP INSERT 1---------------------------------------------
	INSERT INTO #Aging
	SELECT 
		v.GLCompanyKey
		,ISNULL(v.VoucherTotal, 0) 
		,(Select ISNULL(Sum(Amount + DiscAmount), 0) 
			from tPaymentDetail pd (nolock) 
			inner join tPayment p (nolock) on p.PaymentKey = pd.PaymentKey
			Where pd.VoucherKey = v.VoucherKey AND
				p.PostingDate <= @EndDate and p.Posted >= 1) 
		+ 
		 (Select ISNULL(Sum(Amount), 0) 
			from tVoucherCredit vcd (nolock) 
			inner join tVoucher vc (nolock) on vc.VoucherKey = vcd.CreditVoucherKey
			Where vcd.VoucherKey = v.VoucherKey AND
				vc.PostingDate <= @EndDate and vc.Posted >= 1) 
		+ 
		 (Select ISNULL(Sum(Amount), 0) 
			from tVoucherCC vcc (nolock) 
			inner join tVoucher vc (nolock) on vc.VoucherKey = vcc.VoucherCCKey
			Where vcc.VoucherKey = v.VoucherKey AND
				vc.PostingDate <= @EndDate and vc.Posted >= 1) 
	 
	FROM 
		tVoucher v (nolock)
		LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
	Where
		v.PostingDate <= @EndDate 
	And	v.CompanyKey = @CompanyKey 
	And	v.VoucherTotal >= 0 
	And	(@GLCompanyKey = -1 OR ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey) 
	And (@GLAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @GLAccountKey)
	And v.Posted >= 1	
	And isnull(v.CreditCard, 0) = 0


----------------AP INSERT 2-------------------------------------------------
	INSERT INTO #Aging
	Select
		p.GLCompanyKey
		,pd.Amount * -1
		,0
	From
		tPayment p (nolock)
		inner join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
		inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
		LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
	Where
		p.CompanyKey = @CompanyKey
	And	v.PostingDate > @EndDate 
	And	p.PostingDate <= @EndDate
	And pd.Prepay = 0
	And	(@GLCompanyKey = -1 OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey) 
	And (@GLAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @GLAccountKey)
	And p.Posted >= 1	
	And isnull(v.CreditCard, 0) = 0
	
	
---------------AP INSERT 3------------------------------------------------

--Add in the credit card charges that are applied to vouchers later than the window
INSERT INTO #Aging
Select
	p.GLCompanyKey
	,pd.Amount * -1
	,0
From
	tVoucher p (nolock)
	inner join tVoucherCC pd (nolock) on p.VoucherKey = pd.VoucherCCKey
	inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
Where
	p.CompanyKey = @CompanyKey
And	v.PostingDate > @EndDate 
And	p.PostingDate <= @EndDate
And	(@GLCompanyKey = -1 OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey) 
And (@GLAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @GLAccountKey)
And p.Posted >= 1	
And isnull(v.CreditCard, 0) = 0
And isnull(p.CreditCard, 0) = 1


	INSERT INTO #Aging
	Select
		 v.GLCompanyKey
		,ISNULL(v.VoucherTotal, 0) VoucherTotal
		,((Select ISNULL(Sum(Amount), 0) 
			from tPaymentDetail pd (nolock) 
			inner join tPayment p (nolock) on p.PaymentKey = pd.PaymentKey
			Where pd.VoucherKey = v.VoucherKey AND
				p.PostingDate <= @EndDate and p.Posted >= 1) + 
		 (Select ISNULL(Sum(Amount), 0) * -1 
			from tVoucherCredit vcd (nolock) 
			inner join tVoucher vc (nolock) on vc.VoucherKey = vcd.VoucherKey
			Where vcd.CreditVoucherKey = v.VoucherKey AND
				vc.PostingDate <= @EndDate and vc.Posted >= 1) 
		 + (Select ISNULL(Sum(Amount), 0)
			from tVoucherCC vcc (nolock) 
			inner join tVoucher vc (nolock) on vc.VoucherKey = vcc.VoucherCCKey
			Where vcc.VoucherKey = v.VoucherKey AND
				vc.PostingDate <= @EndDate and vc.Posted >= 1) ) 
			as AmountPaid
	From
		tVoucher v (nolock) 
		LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
	Where
		v.PostingDate <= @EndDate 
	And	v.CompanyKey = @CompanyKey 
	And	v.VoucherTotal < 0 
	And	(@GLCompanyKey = -1 OR ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey) 
	And (@GLAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @GLAccountKey)
	And v.Posted >= 1	
	And isnull(v.CreditCard, 0) = 0
	
	-- If the user selected ALL Companies and we restrict
	-- we need to look up into tUserGLCompanyAccess
	IF @GLCompanyKey =-1 AND @RestrictToGLCompany = 1
	begin
		update #Aging set GLCompanyKey = isnull(GLCompanyKey, 0)

		-- this does not delete null GLCompanyKey
		delete #Aging
		where  GLCompanyKey not in (select GLCompanyKey from tUserGLCompanyAccess where UserKey = @UserKey) 
	end

	-- Only keep open amounts
	DELETE #Aging 
	WHERE  BilledAmount - AppliedAmount = 0

END


--------------------
DECLARE @NetOpenAmount money

SELECT
	@NetOpenAmount = SUM(BilledAmount) - SUM(AppliedAmount)
FROM
	#Aging


-------------------------------------------------------------------------
SELECT
	MAX(TransactionDate) AS LastTran,
	MIN(TransactionDate) AS FirstTran,
	DATEDIFF(d, MIN(TransactionDate), MAX(TransactionDate)) AS TranDays,
	@NetOpenAmount AS NetOpenAmount,
	CASE @AcctType WHEN 20 THEN SUM(Credit) - SUM(Debit) ELSE SUM(Debit) - SUM(Credit) END AS TrialBalance
FROM
	tTransaction t (nolock)
	LEFT JOIN tGLAccount gla (nolock) ON t.GLAccountKey = gla.GLAccountKey
WHERE
	t.CompanyKey = @CompanyKey AND
	gla.AccountType = @AcctType AND
	gla.Active = 1 AND
	(@GLAccountKey IS NULL OR ISNULL(t.GLAccountKey, 0) = @GLAccountKey) AND
	(@GLCompanyKey = -1 OR (ISNULL(@GLCompanyKey, 0) = ISNULL(t.GLCompanyKey, 0))) AND
	TransactionDate <= ISNULL(@EndDate, GETDATE())
GO
