USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptCashProjectionDD]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptCashProjectionDD]
	(
		@CompanyKey int
		,@StartDate datetime
		,@EndDate datetime
		,@CashType varchar(100)		-- AR, AP, Bank
		,@DelayReceiptsBy int 
		,@PostStatus int 
		,@IncludeCredit int 
		,@GLCompanyKey int = NULL	
		,@UserKey int = null	
	)
AS --Encrypt

  /*
  || When		Who		Rel		What
  || 10/31/08   GHL    10.011   (39145) Added JEs for bank accounts
  ||                            Also taking in account GLCompanyKey now
  || 11/11/08   GWG    10.012   Journal Entry Date changed to posting date from entry date
  || 04/09/10   GHL    10.521   (78547) casting now HeaderComment from text field to varchar(2000) 
  ||                             to prevent stored procedure execution error
  || 05/24/10   GWG    10.530   Modified the queries to hide all the 0's in the list
  || 01/11/12   RLB    10.552   (131255) change made because voucher description field was changed to a text field
  || 04/11/12   GHL    10.555   Added UserKey for UserGLCompanyAccess
  || 01/07/14   GHL    10.576   Converted to Home Currency
  */
  
	SET NOCOUNT ON
			
Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

	IF @CashType = 'AR'
	BEGIN			
		-- Process AR

		IF @IncludeCredit = 0
		BEGIN			    	
		    SELECT i.InvoiceKey			AS TranKey
				   ,i.InvoiceDate		AS TranDate
				   ,i.InvoiceNumber		As TranNumber	
				   ,c.CompanyName
				   ,CAST(i.HeaderComment AS VARCHAR(2000))     AS Description
				   ,i.DueDate
				   ,(ISNULL(i.InvoiceTotalAmount, 0) 
						- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
						- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
					) * i.ExchangeRate
					AS OpenAmount
			FROM  tInvoice i (nolock)
				INNER JOIN tCompany c (NOLOCK) ON i.ClientKey = c.CompanyKey
			WHERE i.CompanyKey = @CompanyKey 
			AND   ISNULL(i.InvoiceTotalAmount, 0) 
						- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
						- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) > 0	
			AND   i.Posted >= @PostStatus
			--AND   ISNULL(i.AdvanceBill, 0) = 0 
			AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) >= @StartDate -- Apply Delay only on Invoices
			AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) <= @EndDate
			--AND	  (ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)		

		END
		ELSE
		BEGIN
			
		    SELECT i.InvoiceKey			AS TranKey
				   ,i.InvoiceDate		AS TranDate
				   ,i.InvoiceNumber		As TranNumber	
				   ,c.CompanyName
				   ,CAST(i.HeaderComment AS VARCHAR(2000))     AS Description
				   ,i.DueDate
				   ,(ISNULL(i.InvoiceTotalAmount, 0) 
						- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
						- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0)
					) * i.ExchangeRate
					AS OpenAmount
			FROM  tInvoice i (nolock)
				INNER JOIN tCompany c (NOLOCK) ON i.ClientKey = c.CompanyKey
			WHERE i.CompanyKey = @CompanyKey 
			AND   ISNULL(i.InvoiceTotalAmount, 0) 
						- isnull(i.DiscountAmount, 0) - isnull(i.AmountReceived, 0)  
						- isnull(i.RetainerAmount, 0) - ISNULL(i.WriteoffAmount, 0) <> 0
			AND   i.Posted >= @PostStatus
			AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) >= @StartDate -- Apply Delay only on Invoices
			AND   DATEADD(Day, @DelayReceiptsBy, i.DueDate) <= @EndDate
			--AND	  (ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)		
/*
			UNION

			SELECT i.InvoiceKey			AS TranKey
				   ,i.InvoiceDate		AS TranDate
				   ,i.InvoiceNumber		As TranNumber	
				   ,c.CompanyName
				   ,CAST(i.HeaderComment AS VARCHAR(2000))     AS Description
				   ,i.DueDate
				   ,ISNULL(i.InvoiceTotalAmount, 0)
					+ ISNULL((SELECT SUM(ic.Amount)
					FROM tInvoiceCredit ic (NOLOCK) WHERE i.InvoiceKey = ic.CreditInvoiceKey), 0)
					AS OpenAmount
			FROM   tInvoice i (nolock)
				INNER JOIN tCompany c (NOLOCK) ON i.ClientKey = c.CompanyKey
			WHERE i.CompanyKey = @CompanyKey 
			AND   i.InvoiceTotalAmount < 0	
			AND   i.Posted >= @PostStatus
			AND   i.DueDate >= @StartDate -- Do not apply delay here
			AND   i.DueDate <= @EndDate
			--AND	  (ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND i.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(i.GLCompanyKey, 0) = @GLCompanyKey)
			)		
*/
		END
	END
		
	IF @CashType = 'AP'
	BEGIN							
		-- Process AP

		IF @IncludeCredit = 0
		BEGIN
			SELECT v.VoucherKey			AS TranKey
				   ,v.InvoiceDate		AS TranDate
				   ,v.InvoiceNumber		As TranNumber	
				   ,c.CompanyName
				   ,v.Description	     AS Description
				   ,v.DueDate
				   ,(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)) * v.ExchangeRate AS OpenAmount
			FROM  tVoucher v (nolock)
				INNER JOIN tCompany c (NOLOCK) ON v.VendorKey = c.CompanyKey
			WHERE v.CompanyKey = @CompanyKey
			AND   ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) > 0
			AND   v.Posted >= @PostStatus
			AND   v.DueDate >= @StartDate
			AND   v.DueDate <= @EndDate
			--AND	  (ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)		

		END	
		ELSE
		BEGIN
		
			SELECT v.VoucherKey			AS TranKey
				   ,v.InvoiceDate		AS TranDate
				   ,v.InvoiceNumber		As TranNumber	
				   ,c.CompanyName
				   ,CAST(v.Description as VARCHAR(2000)) AS Description
				   ,v.DueDate
				   ,(ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0)) * v.ExchangeRate AS OpenAmount
			FROM  tVoucher v (nolock)
				INNER JOIN tCompany c (NOLOCK) ON v.VendorKey = c.CompanyKey
			WHERE v.CompanyKey = @CompanyKey
			AND   ISNULL(v.VoucherTotal, 0) - ISNULL(v.AmountPaid, 0) > 0
			AND   v.Posted >= @PostStatus
			AND   v.DueDate >= @StartDate
			AND   v.DueDate <= @EndDate
			--AND	  (ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)		

			UNION
			
			SELECT v.VoucherKey			AS TranKey
				   ,v.InvoiceDate		AS TranDate
				   ,v.InvoiceNumber		As TranNumber	
				   ,c.CompanyName
				   ,CAST(v.Description as VARCHAR(2000)) AS Description
				   ,v.DueDate 
					,(ISNULL(v.VoucherTotal, 0)
					+ ISNULL((SELECT SUM(vc.Amount)
					FROM tVoucherCredit vc (NOLOCK) WHERE v.VoucherKey = vc.CreditVoucherKey), 0)
					) * v.ExchangeRate
				AS OpenAmount	
			FROM   tVoucher v (nolock)
				INNER JOIN tCompany c (NOLOCK) ON v.VendorKey = c.CompanyKey			
			WHERE v.CompanyKey = @CompanyKey 
			AND   v.VoucherTotal < 0	
			AND   v.Posted >= @PostStatus
			AND   v.DueDate >= @StartDate 
			AND   v.DueDate <= @EndDate
			--AND	  (ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
			AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND v.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(v.GLCompanyKey, 0) = @GLCompanyKey)
			)		

		END

	END
	
	IF @CashType = 'Bank'
	BEGIN	
		-- Process Bank

		SELECT  cast('Check' as varchar(20))	As TranType
			   ,ch.CheckKey			As TranKey
			   ,ch.CheckDate		AS TranDate
			   ,CAST(ch.ReferenceNumber AS VARCHAR(100))	As TranNumber
			   ,c.CompanyName	
		       ,CAST(ch.Description	AS VARCHAR(500))		AS Description
		       ,NULL				AS DueDate
		       ,ch.CheckAmount * ch.ExchangeRate		As OpenAmount
		FROM   tCheck ch (NOLOCK) 
			INNER JOIN tCompany c (NOLOCK) ON ch.ClientKey = c.CompanyKey
		WHERE  c.OwnerCompanyKey = @CompanyKey
		AND    ch.CheckDate >= @StartDate
		AND    ch.CheckDate <= @EndDate 
		AND    ch.Posted >= @PostStatus
		--AND	  (ISNULL(ch.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
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

		UNION ALL
				
		SELECT cast('Payment' as varchar(20))	As TranType
			   ,p.PaymentKey			As TranKey
			   ,p.PaymentDate		AS TranDate
			   ,CAST(p.CheckNumber AS VARCHAR(100))	As TranNumber
			   ,c.CompanyName
		       ,CAST(p.Memo AS VARCHAR(500))			AS Description
		       ,NULL				AS DueDate
		       ,-p.PaymentAmount * p.ExchangeRate		As OpenAmount
		FROM   tPayment p (NOLOCK) 
			INNER JOIN tCompany c (nolock) on p.VendorKey = c.CompanyKey 
		WHERE  p.CompanyKey = @CompanyKey
		AND    p.PaymentDate >= @StartDate
		AND    p.PaymentDate <= @EndDate 
		AND    p.Posted >= @PostStatus
		--AND	  (ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey OR @GLCompanyKey IS NULL)
		AND     (-- case when @GLCompanyKey = ALL
				(@GLCompanyKey IS NULL AND 
					(
					@RestrictToGLCompany = 0 OR 
					(@RestrictToGLCompany = 1 AND p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )
					)
				)
			--case when @GLCompanyKey = X or Blank(0)
			 OR (@GLCompanyKey IS NOT NULL AND ISNULL(p.GLCompanyKey, 0) = @GLCompanyKey)
			)		

		UNION ALL 
		
		SELECT cast('JE' as varchar(20))	As TranType
			   ,je.JournalEntryKey			As TranKey
			   ,je.EntryDate		AS TranDate
			   ,CAST(je.JournalNumber AS VARCHAR(100))	As TranNumber
			   ,'Journal Entry'		AS CompanyName
		       ,LEFT(je.Description, 500)			AS Description
		       ,NULL				AS DueDate
		       ,DebitAmount - CreditAmount		As OpenAmount
		FROM   tJournalEntry je (NOLOCK)
		INNER JOIN tJournalEntryDetail jed (NOLOCK) ON je.JournalEntryKey = jed.JournalEntryKey
		INNER JOIN tGLAccount gl (NOLOCK) on jed.GLAccountKey = gl.GLAccountKey
		WHERE  je.CompanyKey = @CompanyKey
		AND    je.PostingDate >= @StartDate
		AND    je.PostingDate <= @EndDate 
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
		
	END	
								   		

	RETURN 1
GO
