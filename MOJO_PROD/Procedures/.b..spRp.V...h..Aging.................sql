USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptVoucherAging]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptVoucherAging]

(
	@CompanyKey int,
	@AsOfDate smalldatetime,
	@GLCompanyKey int, -- Null All, 0 Blank, > 0 certain company
	@ClassKey int, -- Null All, 0 Blank, > 0 certain class
	@VendorKey int = null,
	@PostStatus tinyint,
	@Payments tinyint,
	@Days1 smallint,
	@Days2 smallint,
	@Days3 smallint,
	@AgingDateOption tinyint,
	@APAccountKey int, -- Null or 0 All, > 0 certain account
	@SummaryOnly tinyint = 0,
	@UserKey int = null,
	@CurrencyID varchar(10) = null -- Null Home Currency, or a foreign currency

)
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/28/06 GWG 8.35 Removed the unapplied payment link to invoices to take into account all applications
|| 10/17/07 CRG 8.5  Added GLCompanyKey parameter, and OfficeName to the return data
|| 11/06/07 CRG 8.5  (9515) Added APAccountKey
|| 11/26/07 GHL 8.5  Returning now office for payments
|| 12/18/07 GHL 8.5  Added fields for AE view
|| 12/21/07 GHL 8.5  Added VendorFullName so that I do not have to format in report (and create problem with groups)
|| 01/17/08 GHL 8502 Requirements for Project Numbers have changed
||                   Old requirement:
||					-- when no project on header, look at invoice line or summary, if none display 'None', else 'MULTI'  
||                   New requirement:
||                  -- display all projects for invoices 
||                     proj #1 - proj name 1
||                     proj #2 - proj name 2         
|| 06/09/08 GHL 8513 (25847) Added new AR aging summary parameter
|| 09/09/08 GWG 10.1 Added a restrict for adding back payments only if they are not added as prepayments (same as a different AR bug)
|| 06/23/09 GHL 10.5 (55527) Since WMJ sends @APAccountKey = 0 and CMP90 sends @APAccountKey = NULL, use same logic for both values 
|| 09/16/10 RLB 10.535 (61907) Added days for enhancement request 
|| 11/15/10 RLB 10.538 (92053) Added filtering for Vendor
|| 09/20/11 GHL 10.548 Added filtering out of credit card charges
|| 09/30/11 RLB 10.548 (122474) only pulling none voided payments for open payments
|| 01/27/12 GHL 10.552 (132650) Checking now posting status of credit invoice (instead of real invoice)
||                     when calculating AmountPaid
|| 04/13/12 GHL 10.555  Added UserKey for UserGLCompanyAccess
|| 06/04/12 GHL 10.556 (144893) Added payments by credit cards to first query
|| 11/25/12 GWG 10.562 Added payments on credit cards to credits
|| 07/16/13 WDF 10.5.7.0 (176497) Added VoucherID
|| 01/23/14 GHL 10.576 Added CurrencyID param + @MultiCurrency logic 
|| 02/05/15 GHL 10.588 (242156) When a payment by credit card is before the vendor invoice, it will not be taken in account
||                     So just include it like regular payment in the same situation 
|| 04/27/15 WDF 10.591 (245447) Added PaidByClient] and BilledToClient
*/
  	  
IF @APAccountKey = 0 
	SELECT @APAccountKey = NULL
	  	  
Declare @RestrictToGLCompany int
Declare @MultiCurrency int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)
       ,@MultiCurrency = isnull(@MultiCurrency, 0)

-- Create table rather than select into to reduce time locking tempdb, 17000 records my be read below
CREATE TABLE #APAging
	(CompanyKey INT NULL
	,GLCompanyKey INT NULL
	,VendorKey INT NULL
	,Posted INT NULL
	,Type VARCHAR(50) NULL
	,VoucherKey INT NULL      -- Can be VoucherKey or PaymentKey
	,InvoiceNumber VARCHAR(250) NULL
	,ClassKey INT NULL
	,DueDate DATETIME NULL
	,PostingDate DATETIME NULL
	,InvoiceDate DATETIME NULL
	,VoucherTotal MONEY NULL
	,AmountPaid MONEY NULL
	,OfficeKey INT NULL
	,AccountManager INT NULL
	,RealVoucherKey INT NULL -- real voucher key to determine projects on vouchers
	,VoucherID INT NULL
	,CurrencyID VARCHAR(10) NULL
	,PaidByClient VARCHAR(3) NULL
	,BilledToClient VARCHAR(3) NULL
	)
 
INSERT #APAging(CompanyKey,GLCompanyKey,VendorKey,Posted,Type,VoucherKey,InvoiceNumber
	,ClassKey,DueDate,PostingDate,InvoiceDate,VoucherTotal,AmountPaid ,OfficeKey 
	,AccountManager,RealVoucherKey,VoucherID,CurrencyID,PaidByClient,BilledToClient)
SELECT 
	 v.CompanyKey
	,v.GLCompanyKey
	,v.VendorKey
	,v.Posted
	,'Invoice' 
	,v.VoucherKey
    ,RTRIM(v.InvoiceNumber)
    ,v.ClassKey
    ,v.DueDate
	,v.PostingDate
    ,v.InvoiceDate
	,ISNULL(v.VoucherTotal, 0) 
	,(Select ISNULL(Sum(Amount + DiscAmount), 0) 
		from tPaymentDetail pd (nolock) 
		inner join tPayment p (nolock) on p.PaymentKey = pd.PaymentKey
		Where pd.VoucherKey = v.VoucherKey AND
			p.PostingDate <= @AsOfDate and p.Posted >= @PostStatus) 
	+ 
	 (Select ISNULL(Sum(Amount), 0) 
		from tVoucherCredit vcd (nolock) 
		inner join tVoucher vc (nolock) on vc.VoucherKey = vcd.CreditVoucherKey
		Where vcd.VoucherKey = v.VoucherKey AND
			vc.PostingDate <= @AsOfDate and vc.Posted >= @PostStatus) 
	+ 
	 (Select ISNULL(Sum(Amount), 0) 
		from tVoucherCC vcc (nolock) 
		inner join tVoucher vc (nolock) on vc.VoucherKey = vcc.VoucherCCKey
		Where vcc.VoucherKey = v.VoucherKey AND
			vc.PostingDate <= @AsOfDate and vc.Posted >= @PostStatus) 
    ,v.OfficeKey
	,pr.AccountManager
	,v.VoucherKey
	,v.VoucherID
	,v.CurrencyID
	,CASE WHEN (SELECT COUNT(*) 
              FROM tVoucherDetail vd (nolock)
             WHERE vd.VoucherKey = v.VoucherKey 
               AND v.Status = 4 
               AND vd.DatePaidByClient IS NOT NULL
            ) > 0 
      THEN 'YES' 
      ELSE 'NO' 
	 END   -- PaidByClient
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
	 END  -- BilledToClient
FROM 
	tVoucher v (nolock)
	LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
Where
	v.PostingDate <= @AsOfDate 
And	v.CompanyKey = @CompanyKey 
And	v.VoucherTotal >= 0 
And	(@GLCompanyKey IS NULL OR ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey) 
And (@APAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @APAccountKey)
And	(@ClassKey IS NULL OR ISNULL(v.ClassKey, 0) = @ClassKey)  -- Reduce # of records upfront
AND (@VendorKey IS NULL OR v.VendorKey = @VendorKey)
AND (@MultiCurrency = 0
		OR isnull(v.CurrencyID, '') = isnull(@CurrencyID, '') )
And v.Posted >= @PostStatus	
And isnull(v.CreditCard, 0) = 0
	
	
--Add in the payments that are applied to vouchers later than the window
INSERT #APAging(CompanyKey,GLCompanyKey,VendorKey,Posted,Type,VoucherKey,InvoiceNumber
	,ClassKey,DueDate,PostingDate,InvoiceDate,VoucherTotal,AmountPaid ,OfficeKey 
	,AccountManager,RealVoucherKey,VoucherID,CurrencyID,PaidByClient,BilledToClient)
Select
	p.CompanyKey
	,p.GLCompanyKey
	,p.VendorKey
	,p.Posted
	,'Payment'
	,p.PaymentKey
	,RTRIM(p.CheckNumber)
	,p.ClassKey
	,p.PaymentDate
	,p.PaymentDate
	,p.PaymentDate
	,pd.Amount * -1
	,0
	,v.OfficeKey
    ,pr.AccountManager
	,v.VoucherKey
	,null -- VoucherID
	,p.CurrencyID
	,CASE WHEN (SELECT COUNT(*) 
              FROM tVoucherDetail vd (nolock)
             WHERE vd.VoucherKey = v.VoucherKey 
               AND v.Status = 4 
               AND vd.DatePaidByClient IS NOT NULL
            ) > 0 
      THEN 'YES' 
      ELSE 'NO' 
	 END   -- PaidByClient
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
	 END  -- BilledToClient
From
	tPayment p (nolock)
	inner join tPaymentDetail pd (nolock) on p.PaymentKey = pd.PaymentKey
	inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
	LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
Where
	p.CompanyKey = @CompanyKey
And	v.PostingDate > @AsOfDate 
And	p.PostingDate <= @AsOfDate
And pd.Prepay = 0
And	(@GLCompanyKey IS NULL OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey) 
And (@APAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @APAccountKey)
And	(@ClassKey IS NULL OR ISNULL(p.ClassKey, 0) = @ClassKey)  -- Reduce # of records upfront
AND (@VendorKey IS NULL OR p.VendorKey = @VendorKey)
AND (@MultiCurrency = 0
		OR isnull(p.CurrencyID, '') = isnull(@CurrencyID, '') )
And p.Posted >= @PostStatus	
And isnull(v.CreditCard, 0) = 0

--Add in the credit card charges that are applied to vouchers later than the window
INSERT #APAging(CompanyKey,GLCompanyKey,VendorKey,Posted,Type,VoucherKey,InvoiceNumber
	,ClassKey,DueDate,PostingDate,InvoiceDate,VoucherTotal,AmountPaid ,OfficeKey 
	,AccountManager,RealVoucherKey,VoucherID,CurrencyID,PaidByClient,BilledToClient)
Select
	p.CompanyKey
	,p.GLCompanyKey
	,p.VendorKey
	,p.Posted
	,'Credit Card'
	,p.VoucherKey
	,RTRIM(p.InvoiceNumber)
	,p.ClassKey
	,p.InvoiceDate
	,p.InvoiceDate
	,p.InvoiceDate
	,pd.Amount * -1
	,0
	,v.OfficeKey
    ,pr.AccountManager
	,v.VoucherKey
	,null -- VoucherID
	,p.CurrencyID
	,CASE WHEN (SELECT COUNT(*) 
              FROM tVoucherDetail vd (nolock)
             WHERE vd.VoucherKey = v.VoucherKey 
               AND v.Status = 4 
               AND vd.DatePaidByClient IS NOT NULL
            ) > 0 
      THEN 'YES' 
      ELSE 'NO' 
	 END   -- PaidByClient
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
	 END  -- BilledToClient
From
	tVoucher p (nolock)
	inner join tVoucherCC pd (nolock) on p.VoucherKey = pd.VoucherCCKey
	inner join tVoucher v (nolock) on pd.VoucherKey = v.VoucherKey
	LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
Where
	p.CompanyKey = @CompanyKey
And	v.PostingDate > @AsOfDate 
And	p.PostingDate <= @AsOfDate
And	(@GLCompanyKey IS NULL OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey) 
And (@APAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @APAccountKey)
And	(@ClassKey IS NULL OR ISNULL(p.ClassKey, 0) = @ClassKey)  -- Reduce # of records upfront
AND (@VendorKey IS NULL OR v.VendorKey = @VendorKey)
AND (@MultiCurrency = 0
		OR isnull(p.CurrencyID, '') = isnull(@CurrencyID, '') )
And p.Posted >= @PostStatus	
And isnull(v.CreditCard, 0) = 0
And isnull(p.CreditCard, 0) = 1

INSERT #APAging(CompanyKey,GLCompanyKey,VendorKey,Posted,Type,VoucherKey,InvoiceNumber
	,ClassKey,DueDate,PostingDate,InvoiceDate,VoucherTotal,AmountPaid ,OfficeKey 
	,AccountManager,RealVoucherKey,VoucherID,CurrencyID,PaidByClient,BilledToClient)
Select
	 v.CompanyKey
	,v.GLCompanyKey
	,v.VendorKey
	,v.Posted
	,'Credit' 
	,v.VoucherKey
	,RTRIM(v.InvoiceNumber)
    ,v.ClassKey
    ,v.DueDate
	,v.PostingDate
    ,v.InvoiceDate
	,ISNULL(v.VoucherTotal, 0) VoucherTotal
	,((Select ISNULL(Sum(Amount), 0) 
		from tPaymentDetail pd (nolock) 
		inner join tPayment p (nolock) on p.PaymentKey = pd.PaymentKey
		Where pd.VoucherKey = v.VoucherKey AND
			p.PostingDate <= @AsOfDate and p.Posted >= @PostStatus) + 
	 (Select ISNULL(Sum(Amount), 0) * -1 
		from tVoucherCredit vcd (nolock) 
		inner join tVoucher vc (nolock) on vc.VoucherKey = vcd.VoucherKey
		Where vcd.CreditVoucherKey = v.VoucherKey AND
			vc.PostingDate <= @AsOfDate and vc.Posted >= @PostStatus) 
	 + (Select ISNULL(Sum(Amount), 0)
		from tVoucherCC vcc (nolock) 
		inner join tVoucher vc (nolock) on vc.VoucherKey = vcc.VoucherCCKey
		Where vcc.VoucherKey = v.VoucherKey AND
			vc.PostingDate <= @AsOfDate and vc.Posted >= @PostStatus) ) 
		as AmountPaid

	,v.OfficeKey
    ,pr.AccountManager	
	,v.VoucherKey
	,v.VoucherID
	,v.CurrencyID
	,CASE WHEN (SELECT COUNT(*) 
              FROM tVoucherDetail vd (nolock)
             WHERE vd.VoucherKey = v.VoucherKey 
               AND v.Status = 4 
               AND vd.DatePaidByClient IS NOT NULL
            ) > 0 
      THEN 'YES' 
      ELSE 'NO' 
	 END   -- PaidByClient
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
	 END  -- BilledToClient
From
	tVoucher v (nolock) 
	LEFT JOIN tProject pr (nolock) ON v.ProjectKey = pr.ProjectKey 
Where
	v.PostingDate <= @AsOfDate 
And	v.CompanyKey = @CompanyKey 
And	v.VoucherTotal < 0 
And	(@GLCompanyKey IS NULL OR ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey) 
And (@APAccountKey IS NULL OR ISNULL(v.APAccountKey, 0) = @APAccountKey)
And	(@ClassKey IS NULL OR ISNULL(v.ClassKey, 0) = @ClassKey)  -- Reduce # of records upfront
AND (@VendorKey IS NULL OR v.VendorKey = @VendorKey)
AND (@MultiCurrency = 0
		OR isnull(v.CurrencyID, '') = isnull(@CurrencyID, '') )
And v.Posted >= @PostStatus	
And isnull(v.CreditCard, 0) = 0


-- Add Back any unapplied payments from the vendor
IF (@Payments = 1) AND (@APAccountKey IS NULL )
BEGIN
INSERT #APAging(CompanyKey,GLCompanyKey,VendorKey,Posted,Type,VoucherKey,InvoiceNumber
	,ClassKey,DueDate,PostingDate,InvoiceDate,VoucherTotal,AmountPaid ,OfficeKey 
	,AccountManager, RealVoucherKey,VoucherID,CurrencyID)
Select
	p.CompanyKey
	,p.GLCompanyKey
	,p.VendorKey
	,p.Posted
	,'Open Paymt'
	,p.PaymentKey
	,RTRIM(p.CheckNumber)
	,p.ClassKey
	,p.PaymentDate
	,p.PaymentDate
	,p.PaymentDate
	,p.PaymentAmount * -1
	,(Select ISNULL(SUM(pd.Amount), 0) * -1
		from tPaymentDetail pd (nolock)
		-- Need to include all applications regardless of invoice to deal with items directly applied to Expenses on a mixed payment
		--inner join tVoucher v (nolock) on v.VoucherKey = pd.VoucherKey
		Where pd.PaymentKey = p.PaymentKey)	
	,null -- OfficeKey
	,null -- AE
	,null -- RealVoucherKey
	,null -- VoucherID
	,p.CurrencyID
From
	tPayment p (nolock)
Where
	p.CompanyKey = @CompanyKey 
And	p.PostingDate <= @AsOfDate 
And ISNULL(VoidPaymentKey, 0) = 0
And	(@GLCompanyKey IS NULL OR ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
And	(@ClassKey IS NULL OR ISNULL(p.ClassKey, 0) = @ClassKey)  -- Reduce # of records upfront
AND (@VendorKey IS NULL OR p.VendorKey = @VendorKey)
AND (@MultiCurrency = 0
		OR isnull(p.CurrencyID, '') = isnull(@CurrencyID, '') )
And p.Posted >= @PostStatus	
		
END

-- If the user selected ALL Companies and we restrict
-- we need to look up into tUserGLCompanyAccess
IF @GLCompanyKey IS NULL AND @RestrictToGLCompany = 1
begin
	update #APAging set GLCompanyKey = isnull(GLCompanyKey, 0)

	-- this does not delete null GLCompanyKey
	delete #APAging
	where  GLCompanyKey not in (select GLCompanyKey from tUserGLCompanyAccess where UserKey = @UserKey) 
end

-- Only keep open amounts
DELETE #APAging 
WHERE  #APAging.VoucherTotal - #APAging.AmountPaid = 0

IF @SummaryOnly = 1
BEGIN
	
	IF @AgingDateOption = 1		-- Using InvoiceDate
	BEGIN
		SELECT #APAging.VendorKey
				,ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME') AS VendorFullName
				,SUM(VoucherTotal - AmountPaid) as NetAmount
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days1 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period0
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days1 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days2 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period1
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days2 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days3 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period2
				,SUM(CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days3 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period3
		FROM	#APAging 
			inner join tCompany v (NOLOCK) on #APAging.VendorKey = v.CompanyKey 
		GROUP BY  #APAging.VendorKey, ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME')
		ORDER BY ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME')

	END
	ELSE IF @AgingDateOption = 2		-- Using PostingDate
	BEGIN
		SELECT #APAging.VendorKey
				,ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME') AS VendorFullName
				,SUM(VoucherTotal - AmountPaid) as NetAmount
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) <= @Days1 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period0
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days1 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days2 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period1
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days2 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days3 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period2
				,SUM(CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days3 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period3
		FROM	#APAging 
			inner join tCompany v (NOLOCK) on #APAging.VendorKey = v.CompanyKey 
		GROUP BY  #APAging.VendorKey, ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME')
		ORDER BY ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME')

	END
	ELSE		-- Using Due Date
	BEGIN
		SELECT #APAging.VendorKey
				,ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME') AS VendorFullName
				,SUM(VoucherTotal - AmountPaid) as NetAmount
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) <= @Days1 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period0
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days1 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days2 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period1
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days2 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days3 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period2
				,SUM(CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days3 
					THEN VoucherTotal - AmountPaid ELSE 0 END) as Period3
		FROM	#APAging 
			inner join tCompany v (NOLOCK) on #APAging.VendorKey = v.CompanyKey 
		GROUP BY  #APAging.VendorKey, ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME')
		ORDER BY ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME')
		
	END	
END
ELSE
BEGIN

	IF @AgingDateOption = 1 -- By Invoice Date
	Select #APAging.* 
			,VoucherTotal - AmountPaid as NetAmount
			,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days1 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period0
			,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days1 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days2 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period1
			,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days2 and DATEDIFF(d, InvoiceDate, @AsOfDate) <= @Days3 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period2
			,CASE WHEN DATEDIFF(d, InvoiceDate, @AsOfDate) > @Days3 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period3
			,DATEDIFF(d, InvoiceDate, @AsOfDate) AS Days

			,ISNULL(o.OfficeName, 'NO OFFICE') AS OfficeName
			,ISNULL(am.FirstName + ' ' + am.LastName, 'NO ACCOUNT MANAGER') AS AccountManagerName 
			,ISNULL(v.VendorID, 'NO ID') AS VendorID
			,ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME') AS VendorFullName
	        ,BilledToClient
	        ,PaidByClient
	        ,BilledToClient + ' \ ' + PaidByClient AS BilledToPaidBy
			
		from #APAging 
			left outer join tOffice o (NOLOCK) on #APAging.OfficeKey = o.OfficeKey 
			left outer join tUser am (NOLOCK) on #APAging.AccountManager = am.UserKey
			inner join tCompany v (NOLOCK) on #APAging.VendorKey = v.CompanyKey 
			
		Order By
			ISNULL(o.OfficeName, 'NO OFFICE'), ISNULL(v.VendorID, 'NO ID'), InvoiceDate Desc

	ELSE IF @AgingDateOption = 2 -- By Posting Date

	Select #APAging.* 
			,VoucherTotal - AmountPaid as NetAmount
			,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) <= @Days1 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period0
			,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days1 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days2 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period1
			,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days2 and DATEDIFF(d, PostingDate, @AsOfDate) <= @Days3 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period2
			,CASE WHEN DATEDIFF(d, PostingDate, @AsOfDate) > @Days3 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period3
			,DATEDIFF(d, PostingDate, @AsOfDate) AS Days

			,ISNULL(o.OfficeName, 'NO OFFICE') AS OfficeName
			,ISNULL(am.FirstName + ' ' + am.LastName, 'NO ACCOUNT MANAGER') AS AccountManagerName 
			,ISNULL(v.VendorID, 'NO ID') AS VendorID
			,ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME') AS VendorFullName
	        ,BilledToClient
	        ,PaidByClient
	        ,BilledToClient + ' \ ' + PaidByClient AS BilledToPaidBy

		from #APAging 
			left outer join tOffice o (NOLOCK) on #APAging.OfficeKey = o.OfficeKey 
			left outer join tUser am (NOLOCK) on #APAging.AccountManager = am.UserKey
			inner join tCompany v (NOLOCK) on #APAging.VendorKey = v.CompanyKey 

		Order By
			ISNULL(o.OfficeName, 'NO OFFICE'), ISNULL(v.VendorID, 'NO ID'), PostingDate Desc
	Else				-- By Due Date

	Select #APAging.* 
			,VoucherTotal - AmountPaid as NetAmount
			,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) <= @Days1 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period0
			,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days1 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days2 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period1
			,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days2 and DATEDIFF(d, DueDate, @AsOfDate) <= @Days3 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period2
			,CASE WHEN DATEDIFF(d, DueDate, @AsOfDate) > @Days3 
				THEN VoucherTotal - AmountPaid ELSE 0 END as Period3
			,DATEDIFF(d, DueDate, @AsOfDate) AS Days

			,ISNULL(o.OfficeName, 'NO OFFICE') AS OfficeName
			,ISNULL(am.FirstName + ' ' + am.LastName, 'NO ACCOUNT MANAGER') AS AccountManagerName 
			,ISNULL(v.VendorID, 'NO ID') AS VendorID
			,ISNULL(v.VendorID, 'NO ID') + ' - ' + ISNULL(v.CompanyName, 'NO NAME') AS VendorFullName
	        ,BilledToClient
	        ,PaidByClient
	        ,BilledToClient + ' \ ' + PaidByClient AS BilledToPaidBy
			
		from #APAging 
			left outer join tOffice o (NOLOCK) on #APAging.OfficeKey = o.OfficeKey 
			left outer join tUser am (NOLOCK) on #APAging.AccountManager = am.UserKey
			inner join tCompany v (NOLOCK) on #APAging.VendorKey = v.CompanyKey 

		Order By
			ISNULL(o.OfficeName, 'NO OFFICE'), ISNULL(v.VendorID, 'NO ID'), DueDate Desc
			
	END
GO
