USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCashProjection]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCashProjection]
	(
		@CompanyKey int
		,@StartDate datetime
		,@EndDate datetime
		,@GroupBy int	-- 1 Day, 2 Week, 3 Month
		,@DelayReceiptsBy int 
		,@PostStatus int 
		,@IncludeCredit int
		,@GLCompanyKey int --0 indicates the report is looking for "No Company Specified". NULL indicates All.	
		,@UserKey int = null	
	)
AS --Encrypt

  /*
  || When		Who		Rel		What
  || 3/28/07	GWG		8.5		Changed the routine to include advance billings
  || 10/18/07   CRG     8.5     Added GLCompanyKey parameter.
  || 10/31/08   GHL    10.011   (39145) Added JEs for bank accounts
  || 11/11/08   GWG    10.012   Journal Entry Date changed to posting date from entry date
  || 12/14/09   RLB    10.515   Added a bold field for the Flash version
  || 02/27/12   GHL    10.553   (135246) End Date = dateadd(day, -1, @StartDate) for beginning balance
  ||                            + remove advance bills when calc @InvoiceOpenAmount for beginning balance 
  || 04/10/12   GHL    10.555   Added UserKey for UserGLCompanyAccess
  || 01/07/14   GHL    10.576   Converted to home currency except for JEs (UI not converted yet)
  */
  
  
	SET NOCOUNT ON

	-- Vars for Cash Periods calcs
	DECLARE @CurrStartDate datetime	
			,@CurrEndDate datetime
			,@StartWeek INT	
			,@EndWeek INT	
			,@CurrWeek INT	
			,@StartMonth INT	
			,@EndMonth INT	
			,@CurrMonth INT
			,@StartYear INT
			,@EndYear INT
			,@CurrYear INT	
			,@PeriodID INT
			
	-- Vars for amount calcs					
	DECLARE	 @InvoiceOpenAmount MONEY
			,@InvoiceCreditAmount MONEY
			,@InvoiceAppliedCreditAmount MONEY
			,@VoucherOpenAmount MONEY
			,@VoucherCreditAmount MONEY
			,@VoucherAppliedCreditAmount MONEY
			,@CheckAmount MONEY
			,@PaymentAmount MONEY
			,@BankJEAmount MONEY
			
	CREATE TABLE #CashPeriod (
				 Type int null			-- 1: Begin Period, 2: Other Period, 3: Period Total, 4: End Period
				,PeriodID int null 
				,BoldRow tinyint
				,StartDate datetime null
				,EndDate datetime null
				,AR money null
				,AP money null
				,Bank money null
				,Net money null
				,Balance money null)

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

	/*
	|| First Section: Insert dates for cash periods
	|| Skip to second section below for analysis of the data only
	*/
	
	-- Insert begin period				
	INSERT #CashPeriod SELECT 1, 0, 1, '1/1/1975', dateadd(day, -1, @StartDate), 0, 0, 0, 0, 0	
	-- Insert total period	
	INSERT #CashPeriod SELECT 3, -1, 1, @StartDate, @EndDate, 0, 0, 0, 0, 0
	-- Insert end period	
	INSERT #CashPeriod SELECT 4, -1, 1, @EndDate, '7/30/2025', 0, 0, 0, 0, 0
				
	IF @GroupBy = 1
	BEGIN
		-- By Day
		SELECT @CurrStartDate = @StartDate
		SELECT @PeriodID = 1
		WHILE @CurrStartDate <= @EndDate
		BEGIN
			INSERT #CashPeriod SELECT 2, @PeriodID, 0, @CurrStartDate, @CurrStartDate, 0, 0, 0, 0, 0
			SELECT @CurrStartDate = DATEADD(Day, 1, @CurrStartDate)
				
			SELECT @PeriodID = @PeriodID + 1 	
		END
	END			
	

	IF @GroupBy = 3
	BEGIN
		-- By Month
		SELECT @StartMonth = DATEPART(Month, @StartDate)
		SELECT @EndMonth = DATEPART(Month, @EndDate)
		SELECT @StartYear = DATEPART(Year, @StartDate)
		SELECT @EndYear = DATEPART(Year, @EndDate)
				
		IF (@StartMonth = @EndMonth AND @StartYear = @EndYear)
		BEGIN
			-- Spans just 1 month
			INSERT #CashPeriod SELECT 2, 1, 0, @StartDate, @EndDate, 0, 0, 0, 0, 0
		END
		ELSE
		BEGIN
			-- Spans several months
			SELECT @CurrMonth = @StartMonth
			SELECT @CurrYear = @StartYear
			SELECT @PeriodID = 1
					
			WHILE (@CurrYear <= @EndYear)
			BEGIN
			
				IF (@CurrYear = @EndYear AND @CurrMonth > @EndMonth)
					BREAK
				
				SELECT @CurrStartDate = CAST(@CurrMonth AS VARCHAR(10)) + '/1/' + CAST(@CurrYear AS VARCHAR(10))
				SELECT @CurrEndDate = DATEADD(Month, 1, @CurrStartDate)
				SELECT @CurrEndDate = DATEADD(Day, -1, @CurrEndDate)

				IF (@CurrMonth = @StartMonth AND @CurrYear = @StartYear)
					SELECT @CurrStartDate = @StartDate	
					
				IF (@CurrMonth = @EndMonth AND @CurrYear = @EndYear)
					SELECT @CurrEndDate = @EndDate	
									
				INSERT #CashPeriod SELECT 2, @PeriodID, 0, @CurrStartDate, @CurrEndDate, 0, 0, 0, 0, 0
				
				SELECT @CurrMonth = @CurrMonth + 1
				IF @CurrMonth = 13
					SELECT @CurrMonth = 1
					      ,@CurrYear = @CurrYear + 1

				SELECT @PeriodID = @PeriodID + 1
			END
		END
	END			
	
	IF @GroupBy = 2
	BEGIN
		-- By Week
		SELECT @StartWeek = DATEPART(Week, @StartDate)
		SELECT @EndWeek = DATEPART(Week, @EndDate)
		SELECT @StartYear = DATEPART(Year, @StartDate)
		SELECT @EndYear = DATEPART(Year, @EndDate)
				
		IF (@StartWeek = @EndWeek AND @StartYear = @EndYear)
		BEGIN
			-- Spans just 1 week
			INSERT #CashPeriod SELECT 2, 1, 0, @StartDate, @EndDate, 0, 0, 0, 0, 0
		END
		ELSE
		BEGIN
			SELECT @CurrStartDate = @StartDate
			SELECT @CurrEndDate = DATEADD(Day, 7 - DATEPART(WeekDay, @CurrStartDate), @CurrStartDate)
			SELECT @PeriodID = 1
		
			WHILE (@CurrEndDate <= @EndDate)
			BEGIN
				INSERT #CashPeriod SELECT 2, @PeriodID, 0, @CurrStartDate, @CurrEndDate, 0, 0, 0, 0, 0
				
				SELECT @CurrWeek = DATEPART(Week, @CurrEndDate)
				SELECT @CurrYear = DATEPART(Year, @CurrEndDate)

				IF (@CurrYear = @EndYear AND @CurrWeek = @EndWeek)
					BREAK
				
				SELECT @CurrStartDate = DATEADD(Day, 1, @CurrEndDate)
				SELECT @CurrEndDate = DATEADD(Day, 7, @CurrEndDate)
				IF @CurrEndDate > @EndDate
					SELECT @CurrEndDate = @EndDate
					
				SELECT @PeriodID = @PeriodID + 1
			END 	
		END	
	END
		
	/*
	|| Second Section: Get Data for Cash Periods
	*/

	SELECT @CurrStartDate = '1/1/1975'
							
	WHILE (1=1)
	BEGIN	
		SELECT @CurrStartDate = MIN(StartDate)
		FROM   #CashPeriod 
		WHERE  Type = 2
		AND    StartDate > @CurrStartDate
			
		IF @CurrStartDate IS NULL
			BREAK
			
		SELECT @CurrEndDate = EndDate
		FROM   #CashPeriod 
		WHERE  Type = 2
		AND    StartDate = @CurrStartDate
		
		-- Reset amounts for this loop
		SELECT	@InvoiceOpenAmount = NULL
				,@InvoiceCreditAmount = NULL
				,@InvoiceAppliedCreditAmount = NULL
				,@VoucherOpenAmount = NULL
				,@VoucherCreditAmount = NULL
				,@VoucherAppliedCreditAmount = NULL
				,@CheckAmount = NULL
				,@PaymentAmount = NULL
			
		-- Process AR
					    	
		-- Find the open amount on invoices	
		SELECT @InvoiceOpenAmount = ISNULL(SUM(
									(
									ISNULL(i.InvoiceTotalAmount, 0) 
									- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
									- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
									) * i.ExchangeRate
									), 0)
		FROM  tInvoice i (nolock)
		WHERE i.CompanyKey = @CompanyKey 
		AND   i.InvoiceTotalAmount >= 0	
		AND   i.Posted >= @PostStatus
		--AND   ISNULL(i.AdvanceBill, 0) = 0 -- do not take advance billings
		AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) >= @CurrStartDate -- Apply Delay only on Invoices
		AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) <= @CurrEndDate
		--AND	  (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)		

		IF @IncludeCredit = 1
		BEGIN
			SELECT @InvoiceCreditAmount = SUM(
									(i.InvoiceTotalAmount
									- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
									- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) 
									) * i.ExchangeRate
									)
			FROM   tInvoice i (nolock)
			WHERE i.CompanyKey = @CompanyKey 
			AND   i.InvoiceTotalAmount < 0	
			AND   i.Posted >= @PostStatus
			AND   i.DueDate >= @CurrStartDate -- Do not apply delay here
			AND   i.DueDate <= @CurrEndDate
			--AND	  (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

			
			/*
			-- This is > 0 will be added to credits
			SELECT @InvoiceAppliedCreditAmount = SUM(ic.Amount)
			FROM   tInvoice i (nolock)
				INNER JOIN tInvoiceCredit ic (NOLOCK) ON i.InvoiceKey = ic.CreditInvoiceKey 
			WHERE i.CompanyKey = @CompanyKey 
			AND   i.InvoiceTotalAmount < 0	
			AND   i.Posted >= @PostStatus
			AND   i.DueDate >= @CurrStartDate 
			AND   i.DueDate <= @CurrEndDate
			--AND	  (ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

			SELECT @InvoiceCreditAmount = ISNULL(@InvoiceCreditAmount, 0) + ISNULL(@InvoiceAppliedCreditAmount, 0)
			*/
		END
		
						
		-- Process AP
		
		-- Find the open amount on vouchers	
		SELECT @VoucherOpenAmount = ISNULL(SUM(
						(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)
						) * v.ExchangeRate
						), 0)
		FROM  tVoucher v (nolock)
		WHERE v.CompanyKey = @CompanyKey
		AND   v.VoucherTotal >= 0
	    AND   v.Posted >= @PostStatus
		AND   v.DueDate >= @CurrStartDate
		AND   v.DueDate <= @CurrEndDate
		--AND	 (ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	
				
		IF @IncludeCredit = 1
		BEGIN
			SELECT @VoucherCreditAmount = ISNULL(SUM(
					(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)
					) * v.ExchangeRate
					), 0)
			FROM   tVoucher v (nolock)
			WHERE v.CompanyKey = @CompanyKey 
			AND   v.VoucherTotal < 0	
			AND   v.Posted >= @PostStatus
			AND   v.DueDate >= @CurrStartDate 
			AND   v.DueDate <= @CurrEndDate
			--AND   (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	
/*
			-- This is > 0 will be added to credits
			SELECT @VoucherAppliedCreditAmount = SUM(vc.Amount)
			FROM   tVoucher v (nolock)
				INNER JOIN tVoucherCredit vc (NOLOCK) ON v.VoucherKey = vc.CreditVoucherKey 
			WHERE v.CompanyKey = @CompanyKey 
			AND   v.VoucherTotal < 0	
			AND   v.Posted >= @PostStatus
			AND   v.DueDate >= @CurrStartDate 
			AND   v.DueDate <= @CurrEndDate
			--AND	  (ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

			SELECT @VoucherCreditAmount = ISNULL(@VoucherCreditAmount, 0) + ISNULL(@VoucherAppliedCreditAmount, 0)
			*/
		END
								
		-- Process Bank

		SELECT @CheckAmount = ISNULL(SUM(ch.CheckAmount * ch.ExchangeRate), 0)
		FROM   tCheck ch (NOLOCK) 
			INNER JOIN tCompany c (NOLOCK) ON ch.ClientKey = c.CompanyKey
		WHERE  c.OwnerCompanyKey = @CompanyKey
		AND    ch.CheckDate >= @CurrStartDate
		AND    ch.CheckDate <= @CurrEndDate 
		AND    ch.Posted >= @PostStatus
		--AND	   (ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)		
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND ch.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey)
			)	

		SELECT @PaymentAmount = ISNULL(SUM(p.PaymentAmount * p.ExchangeRate), 0)
		FROM   tPayment p (NOLOCK) 
		WHERE  p.CompanyKey = @CompanyKey
		AND    p.PaymentDate >= @CurrStartDate
		AND    p.PaymentDate <= @CurrEndDate 
		AND    p.Posted >= @PostStatus
		--AND	   (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

		SELECT @BankJEAmount = SUM(DebitAmount - CreditAmount)
		FROM   tJournalEntry je (NOLOCK)
		INNER JOIN tJournalEntryDetail jed (NOLOCK) ON je.JournalEntryKey = jed.JournalEntryKey
		INNER JOIN tGLAccount gl (NOLOCK) on jed.GLAccountKey = gl.GLAccountKey
		WHERE  je.CompanyKey = @CompanyKey
		AND    je.PostingDate >= @CurrStartDate
		AND    je.PostingDate <= @CurrEndDate 
		AND    je.Posted >= @PostStatus
		AND    gl.AccountType = 10
		--AND	   (ISNULL(je.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND je.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(je.GLCompanyKey, 0) = @GLCompanyKey)
			)	

		-- do this at end of loop 		
		UPDATE #CashPeriod
		SET    AR = AR + ISNULL(@InvoiceOpenAmount, 0) + ISNULL(@InvoiceCreditAmount, 0)  		
			,AP = AP + ISNULL(@VoucherOpenAmount, 0) + ISNULL(@VoucherCreditAmount, 0)
			,Bank = Bank + ISNULL(@CheckAmount, 0) - ISNULL(@PaymentAmount, 0)
				+ISNULL(@BankJEAmount, 0)
			,Balance = Balance	+ ISNULL(@InvoiceOpenAmount, 0) + ISNULL(@InvoiceCreditAmount, 0)
									+ ISNULL(@VoucherOpenAmount, 0) + ISNULL(@VoucherCreditAmount, 0)
									+ ISNULL(@CheckAmount, 0) - ISNULL(@PaymentAmount, 0)
		WHERE  Type = 2
		AND    StartDate = @CurrStartDate
								   		
	END
	
	/*
	|| Third Section: Update balances
	*/
		
	-- Update beginning balance
	SELECT	@InvoiceOpenAmount = NULL
			,@InvoiceCreditAmount = NULL
			,@InvoiceAppliedCreditAmount = NULL
			,@VoucherOpenAmount = NULL
			,@VoucherCreditAmount = NULL
			,@VoucherAppliedCreditAmount = NULL
			,@CheckAmount = NULL
			,@PaymentAmount = NULL
	
	-- AR
	SELECT @InvoiceOpenAmount = ISNULL(SUM(
								(ISNULL(i.InvoiceTotalAmount, 0) 
								- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
								- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
								) * i.ExchangeRate
								), 0)
	FROM  tInvoice i (nolock)
	WHERE i.CompanyKey = @CompanyKey 
	AND   i.InvoiceTotalAmount >= 0	
	AND   i.Posted >= @PostStatus
	--AND   ISNULL(i.AdvanceBill, 0) = 0 -- do not take advance billings
	AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) < @StartDate
	--AND	  (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

	IF @IncludeCredit = 1
	BEGIN
		SELECT @InvoiceCreditAmount = SUM(
									(i.InvoiceTotalAmount
									- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
									- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) 
									) * i.ExchangeRate
									)
		FROM   tInvoice i (nolock)
		WHERE i.CompanyKey = @CompanyKey 
		AND   i.InvoiceTotalAmount < 0	
		AND   i.Posted >= @PostStatus
		AND   i.DueDate < @StartDate
		--AND	  (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	
/*
		-- This is > 0 will be added to credits
		SELECT @InvoiceAppliedCreditAmount = SUM(ic.Amount)
		FROM   tInvoice i (nolock)
			INNER JOIN tInvoiceCredit ic (NOLOCK) ON i.InvoiceKey = ic.CreditInvoiceKey 
		WHERE i.CompanyKey = @CompanyKey 
		AND   i.InvoiceTotalAmount < 0	
		AND   i.Posted >= @PostStatus
		AND   i.DueDate < @StartDate
		--AND   (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

		SELECT @InvoiceCreditAmount = ISNULL(@InvoiceCreditAmount, 0) + ISNULL(@InvoiceAppliedCreditAmount, 0)
		*/
	END

	-- AP
	SELECT @VoucherOpenAmount = ISNULL(SUM(
					(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)) * v.ExchangeRate
					), 0)
	FROM  tVoucher v (nolock)
	WHERE v.CompanyKey = @CompanyKey
	AND   v.VoucherTotal >= 0
	AND   v.Posted >= @PostStatus
	AND   v.DueDate < @StartDate
	--AND	  (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

	IF @IncludeCredit = 1
		BEGIN
			SELECT @VoucherCreditAmount = ISNULL(SUM(
				(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)) * v.ExchangeRate
				), 0)
			FROM   tVoucher v (nolock)
			WHERE v.CompanyKey = @CompanyKey 
			AND   v.VoucherTotal < 0	
			AND   v.Posted >= @PostStatus
			AND   v.DueDate < @StartDate
			--AND	  (ISNULL(GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	
				
				/*
			-- This is > 0 will be added to credits
			SELECT @VoucherAppliedCreditAmount = SUM(vc.Amount)
			FROM   tVoucher v (nolock)
				INNER JOIN tVoucherCredit vc (NOLOCK) ON v.VoucherKey = vc.CreditVoucherKey 
			WHERE v.CompanyKey = @CompanyKey 
			AND   v.VoucherTotal < 0	
			AND   v.Posted >= @PostStatus
			AND   v.DueDate < @StartDate
			--AND	  (ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(GLCompanyKey, 0) = @GLCompanyKey)
			)	

			SELECT @VoucherCreditAmount = ISNULL(@VoucherCreditAmount, 0) + ISNULL(@VoucherAppliedCreditAmount, 0)
			*/
		END
	
	/*  Assumes getting begging balance from transaction. Need to get it from the ledger
	SELECT @CheckAmount = ISNULL(SUM(ch.CheckAmount), 0)
	FROM   tCheck ch (NOLOCK) 
		INNER JOIN tCompany c (NOLOCK) ON ch.ClientKey = c.CompanyKey
	WHERE  c.OwnerCompanyKey = @CompanyKey
	AND    ch.CheckDate < @StartDate 

	SELECT @PaymentAmount = ISNULL(SUM(p.PaymentAmount), 0)
	FROM   tPayment p (NOLOCK) 
	WHERE  p.CompanyKey = @CompanyKey
	AND    p.PaymentDate < @StartDate 
	*/
	-- Calc opening bank balance from GL Transactions
	SELECT @CheckAmount = ISNULL(SUM(Debit - Credit), 0)
	FROM   vHTransaction t (NOLOCK) 
	INNER JOIN tGLAccount gl (NOLOCK) on t.GLAccountKey = gl.GLAccountKey
	WHERE  t.CompanyKey = @CompanyKey
	AND    t.TransactionDate < @StartDate 
	AND    gl.AccountType = 10
	--AND	   (ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
	AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND t.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(t.GLCompanyKey, 0) = @GLCompanyKey)
			)	

	UPDATE #CashPeriod
	SET    AR = AR + ISNULL(@InvoiceOpenAmount, 0) + ISNULL(@InvoiceCreditAmount, 0)  		
		  ,AP = AP + ISNULL(@VoucherOpenAmount, 0) + ISNULL(@VoucherCreditAmount, 0)
		  ,Bank = Bank + ISNULL(@CheckAmount, 0) - ISNULL(@PaymentAmount, 0)
		  ,Balance = Balance	+ ISNULL(@InvoiceOpenAmount, 0) + ISNULL(@InvoiceCreditAmount, 0)
								- ISNULL(@VoucherOpenAmount, 0) - ISNULL(@VoucherCreditAmount, 0)
								+ ISNULL(@CheckAmount, 0) - ISNULL(@PaymentAmount, 0)
	WHERE  Type = 1

	-- Update period net inflows
	UPDATE #CashPeriod
	SET    Net = AR - AP + Bank
	WHERE  Type = 2

	-- Update Projected balances
	SELECT @CurrStartDate = '1/1/1975'
	SELECT @PeriodID = 1 
							
	WHILE (1=1)
	BEGIN	
		SELECT @CurrStartDate = MIN(StartDate)
		FROM   #CashPeriod 
		WHERE  Type = 2
		AND    StartDate > @CurrStartDate
			
		IF @CurrStartDate IS NULL
			BREAK
			
		UPDATE #CashPeriod
		SET    #CashPeriod.Balance = #CashPeriod.Net + (SELECT Balance
									  FROM   #CashPeriod (NOLOCK)
									  WHERE  PeriodID = @PeriodID - 1 )
		WHERE  #CashPeriod.Type = 2
		AND    #CashPeriod.StartDate = @CurrStartDate
		
		SELECT @PeriodID = @PeriodID + 1 	
	END			
	
	-- Update Subtotals
	UPDATE #CashPeriod
	SET    AR = (SELECT SUM(AR) FROM #CashPeriod WHERE Type = 2)
	      ,AP = (SELECT SUM(AP) FROM #CashPeriod WHERE Type = 2)
	      ,Bank = (SELECT SUM(Bank) FROM #CashPeriod WHERE Type = 2)
	      ,Net = (SELECT SUM(Net) FROM #CashPeriod WHERE Type = 2)			
	WHERE  Type = 3

	-- Update Totals
	SELECT @PeriodID = MAX(PeriodID) FROM #CashPeriod WHERE Type = 2
	
	UPDATE #CashPeriod
	SET    AR = (SELECT SUM(AR) FROM #CashPeriod WHERE Type in (1, 3))
	      ,AP = (SELECT SUM(AP) FROM #CashPeriod WHERE Type in (1, 3))
	      ,Bank = (SELECT SUM(Bank) FROM #CashPeriod WHERE Type in (1, 3))
		  ,Balance = (SELECT Balance FROM #CashPeriod WHERE PeriodID = @PeriodID)	
	WHERE  Type = 4
	
	
	SELECT * FROM #CashPeriod Order By Type, StartDate
	
	RETURN 1
GO
