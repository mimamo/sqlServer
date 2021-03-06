USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashQueueAppliedEntities]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashQueueAppliedEntities]
	(
	@CompanyKey INT
	,@Entity VARCHAR(25)
	,@EntityKey INT
	,@PostingDate SMALLDATETIME
	,@Action SMALLINT -- 0 Post, 1 Unpost
	,@AdvanceBill INT 
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 10/13/11 GHL 10.459 Added new entity CREDITCARD
|| 03/26/14 GHL 10.578 If the Credit Card charge is considered a payment
||                     when posting a voucher, repost the credit card
*/
	SET NOCOUNT ON
	
	declare @CreditCardPayment int
	select @CreditCardPayment = isnull(CreditCardPayment, 0) from tPreference (nolock) 
	where CompanyKey = @CompanyKey

	IF @Entity = 'RECEIPT'
	BEGIN		
		-- Repost the invoices (convention same day they are always considered before the check) 
		INSERT #tCashQueue
		   (Entity
		   ,EntityKey
		   ,PostingDate
		   ,AdvanceBill
		   ,Action
		   )
		SELECT 'INVOICE', ca.InvoiceKey, i.PostingDate, i.AdvanceBill, 0 -- Repost
		FROM   tCheckAppl ca (NOLOCK)
			INNER JOIN tInvoice i (NOLOCK) ON ca.InvoiceKey = i.InvoiceKey
		WHERE ca.CheckKey = @EntityKey
		AND   ca.Prepay = 0
		AND   i.Posted = 1
		AND   i.PostingDate > @PostingDate
		AND   i.InvoiceKey NOT IN (
			SELECT EntityKey FROM #tCashQueue WHERE Entity = 'INVOICE'
			)
		
		-- Now repost the invoices linked to adv bill
		INSERT #tCashQueue
		   (Entity
		   ,EntityKey
		   ,PostingDate
		   ,AdvanceBill
		   ,Action
		   )
		SELECT 'INVOICE', real_i.InvoiceKey, real_i.PostingDate, real_i.AdvanceBill, 0 -- Repost
		FROM   tCheckAppl ca (NOLOCK)
			INNER JOIN tInvoice i (NOLOCK) ON ca.InvoiceKey = i.InvoiceKey
			INNER JOIN tInvoiceAdvanceBill iab (NOLOCK) ON ca.InvoiceKey = iab.AdvBillInvoiceKey
			INNER JOIN tInvoice real_i (NOLOCK) ON iab.InvoiceKey = real_i.InvoiceKey
		WHERE ca.CheckKey = @EntityKey
		AND   i.Posted = 1
		--AND   i.PostingDate > @PostingDate
		-- do not consider AB PostingDate for the situation AB Posted-->R-->real I Posted
		AND   real_i.Posted = 1
		AND   real_i.PostingDate > @PostingDate
		AND   real_i.InvoiceKey NOT IN (
			SELECT EntityKey FROM #tCashQueue WHERE Entity = 'INVOICE'
			)
		AND iab.InvoiceKey <> iab.AdvBillInvoiceKey -- filter out self applications 
				
	END

	IF @Entity = 'INVOICE'
	BEGIN
		-- Repost the checks (convention same day they are always considered before the check) 
		INSERT #tCashQueue
		   (Entity
		   ,EntityKey
		   ,PostingDate
		   ,Action)
		SELECT 'RECEIPT', ca.CheckKey, c.PostingDate, 0 -- Repost
		FROM   tCheckAppl ca (NOLOCK)
			INNER JOIN tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
		WHERE ca.InvoiceKey = @EntityKey
		AND   ca.Prepay = 0
		AND   c.Posted = 1
		AND   c.PostingDate >= @PostingDate
		AND   c.CheckKey NOT IN (
				SELECT EntityKey FROM #tCashQueue WHERE Entity = 'RECEIPT'
				)
				
		IF @AdvanceBill = 1
		BEGIN
			-- Now repost the invoices linked to adv bill
			INSERT #tCashQueue
			   (Entity
			   ,EntityKey
			   ,PostingDate
			   ,AdvanceBill
			   ,Action)
			SELECT 'INVOICE', real_i.InvoiceKey, real_i.PostingDate, 0, 0 -- Repost
			FROM   tInvoiceAdvanceBill iab (NOLOCK)
				INNER JOIN tInvoice real_i (NOLOCK) ON iab.InvoiceKey = real_i.InvoiceKey
			WHERE iab.AdvBillInvoiceKey = @EntityKey
			AND   real_i.Posted = 1
			--AND   real_i.PostingDate >= @PostingDate -- Or take them all ???????
			AND   real_i.InvoiceKey NOT IN (
				SELECT EntityKey FROM #tCashQueue WHERE Entity = 'INVOICE'
				)
			AND iab.InvoiceKey <> iab.AdvBillInvoiceKey -- filter out self applications 

		END		
		ELSE
		BEGIN
			-- if we are on an advance bill, we must report posted receipts and invoices after this date
			IF EXISTS (SELECT 1 FROM tInvoiceAdvanceBill (NOLOCK)
						WHERE InvoiceKey = @EntityKey
						AND InvoiceKey <> AdvBillInvoiceKey -- filter out self applications 
						)
			BEGIN
			
				INSERT #tCashQueue
				   (Entity
				   ,EntityKey
				   ,PostingDate
				   ,AdvanceBill
				   ,Action)
				SELECT 'INVOICE', real_i.InvoiceKey, real_i.PostingDate, 0, 0 -- Repost
				FROM   tInvoiceAdvanceBill iab (NOLOCK)
					INNER JOIN tInvoiceAdvanceBill iab2 (NOLOCK) 
						ON iab.AdvBillInvoiceKey = iab2.AdvBillInvoiceKey AND iab2.InvoiceKey <> @EntityKey
					INNER JOIN tInvoice real_i (NOLOCK) ON iab2.InvoiceKey = real_i.InvoiceKey
				WHERE iab.InvoiceKey = @EntityKey
				AND   real_i.Posted = 1
				AND   real_i.PostingDate >= @PostingDate 
				AND   real_i.InvoiceKey NOT IN (
					SELECT EntityKey FROM #tCashQueue WHERE Entity = 'INVOICE'
					)    
				AND iab.InvoiceKey <> iab.AdvBillInvoiceKey -- filter out self applications 
	
				INSERT #tCashQueue
					   (Entity
					   ,EntityKey
					   ,PostingDate
					   ,AdvanceBill
					   ,Action)
					SELECT 'RECEIPT', ca.CheckKey, c.PostingDate, 0, 0 -- Repost
					FROM   tInvoiceAdvanceBill iab (NOLOCK)
						INNER JOIN tCheckAppl ca (NOLOCK) ON iab.AdvBillInvoiceKey = ca.InvoiceKey
						INNER JOIN tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
					WHERE iab.InvoiceKey = @EntityKey
					AND   c.Posted = 1
					AND   c.PostingDate >= @PostingDate 
					AND   ca.Prepay = 0
					AND   c.CheckKey NOT IN (
						SELECT EntityKey FROM #tCashQueue WHERE Entity = 'RECEIPT'
						)
			
		
			END
			
		END
		
	END	
	
	IF @Entity = 'PAYMENT'
	BEGIN		
		-- Repost the invoices (convention same day they are always considered before the check) 
		INSERT #tCashQueue
		   (Entity
		   ,EntityKey
		   ,PostingDate
		   ,Action)
		SELECT case when isnull(v.CreditCard, 0) = 0 then 'VOUCHER' else 'CREDITCARD' end
				, pd.VoucherKey, v.PostingDate, 0 -- Repost
		FROM   tPaymentDetail pd (NOLOCK)
			INNER JOIN tVoucher v (NOLOCK) ON pd.VoucherKey = v.VoucherKey
		WHERE pd.PaymentKey = @EntityKey
		AND   pd.Prepay = 0
		AND   v.Posted = 1
		AND   v.PostingDate > @PostingDate
		AND   v.VoucherKey NOT IN (
			SELECT EntityKey FROM #tCashQueue WHERE Entity in ('VOUCHER', 'CREDITCARD')
			)	
	
		-- Now repost the vouchers linked to credit card charges
		INSERT #tCashQueue
		   (Entity
		   ,EntityKey
		   ,PostingDate
		   ,AdvanceBill
		   ,Action
		   )
		SELECT 'VOUCHER', real_v.VoucherKey, real_v.PostingDate, 0, 0 -- Repost
		FROM   tPaymentDetail pd (NOLOCK)
			INNER JOIN tVoucher v (NOLOCK) ON pd.VoucherKey = v.VoucherKey
			INNER JOIN tVoucherCC vcc (NOLOCK) ON pd.VoucherKey = vcc.VoucherCCKey
			INNER JOIN tVoucher real_v (NOLOCK) ON vcc.VoucherKey = real_v.VoucherKey
		WHERE pd.PaymentKey = @EntityKey
		AND   v.Posted = 1
		--AND   i.PostingDate > @PostingDate
		-- do not consider AB PostingDate for the situation AB Posted-->R-->real I Posted
		AND   real_v.Posted = 1
		AND   real_v.PostingDate > @PostingDate
		AND   real_v.VoucherKey NOT IN (
			SELECT EntityKey FROM #tCashQueue WHERE Entity = 'VOUCHER'
			)
		
	END


	
	IF @Entity IN ('VOUCHER', 'CREDITCARD')
	BEGIN		
		-- Repost the payments (convention same day they are always considered before the check) 
		INSERT #tCashQueue
		   (Entity
		   ,EntityKey
		   ,PostingDate
		   ,Action)
		SELECT 'PAYMENT', pd.PaymentKey, p.PostingDate, 0 -- Repost
		FROM   tPaymentDetail pd (NOLOCK)
			INNER JOIN tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		WHERE pd.VoucherKey = @EntityKey
		AND   pd.Prepay = 0
		AND   p.Posted = 1
		AND   p.PostingDate >= @PostingDate
		AND   p.PaymentKey NOT IN (
			SELECT EntityKey FROM #tCashQueue WHERE Entity = 'PAYMENT'
			)
			
		-- Now repost the vouchers linked to credit cards
		INSERT #tCashQueue
			(Entity
			,EntityKey
			,PostingDate
			,AdvanceBill
			,Action)
		SELECT 'VOUCHER', real_v.VoucherKey, real_v.PostingDate, 0, 0 -- Repost
		FROM   tVoucherCC vcc (NOLOCK)
			INNER JOIN tVoucher real_v (NOLOCK) ON vcc.VoucherKey = real_v.VoucherKey
		WHERE vcc.VoucherCCKey = @EntityKey
		AND   real_v.Posted = 1
		--AND   real_i.PostingDate >= @PostingDate -- Or take them all ???????
		AND   real_v.VoucherKey NOT IN (
			SELECT EntityKey FROM #tCashQueue WHERE Entity = 'VOUCHER'
			)
		
		-- if we are on an credit card charge, we must report posted receipts and invoices after this date
		IF EXISTS (SELECT 1 FROM tVoucherCC (NOLOCK)
						WHERE VoucherKey = @EntityKey
						)
			BEGIN
				-- the current entity is a voucher

				INSERT #tCashQueue
				   (Entity
				   ,EntityKey
				   ,PostingDate
				   ,AdvanceBill
				   ,Action)
				SELECT 'VOUCHER', real_v.VoucherKey, real_v.PostingDate, 0, 0 -- Repost
				FROM   tVoucherCC vcc (NOLOCK)
					INNER JOIN tVoucherCC vcc2 (NOLOCK) 
						ON vcc.VoucherCCKey = vcc2.VoucherCCKey AND vcc2.VoucherKey <> @EntityKey
					INNER JOIN tVoucher real_v (NOLOCK) ON vcc2.VoucherKey = real_v.VoucherKey
				WHERE vcc.VoucherKey = @EntityKey
				AND   real_v.Posted = 1
				AND   real_v.PostingDate >= @PostingDate 
				AND   real_v.VoucherKey NOT IN (
					SELECT EntityKey FROM #tCashQueue WHERE Entity = 'VOUCHER'
					)    
	
				INSERT #tCashQueue
					   (Entity
					   ,EntityKey
					   ,PostingDate
					   ,AdvanceBill
					   ,Action)
					SELECT 'PAYMENT', pd.PaymentKey, p.PostingDate, 0, 0 -- Repost
					FROM   tVoucherCC vcc (NOLOCK)
						INNER JOIN tPaymentDetail pd (NOLOCK) ON vcc.VoucherCCKey = pd.VoucherKey
						INNER JOIN tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
					WHERE vcc.VoucherKey = @EntityKey
					AND   p.Posted = 1
					AND   p.PostingDate >= @PostingDate 
					AND   pd.Prepay = 0
					AND   p.PaymentKey NOT IN (
						SELECT EntityKey FROM #tCashQueue WHERE Entity = 'PAYMENT'
						)
			
		
				IF @CreditCardPayment = 1
				BEGIN
					-- 
					INSERT #tCashQueue
					   (Entity
					   ,EntityKey
					   ,PostingDate
					   ,AdvanceBill
					   ,Action)
					SELECT 'CREDITCARD', vcc.VoucherCCKey, ccc.PostingDate, 0,0 -- Repost
					FROM  tVoucherCC vcc (NOLOCK)
						INNER JOIN tVoucher ccc (nolock) ON vcc.VoucherCCKey = ccc.VoucherKey 
					WHERE vcc.VoucherKey = @EntityKey
					AND   ccc.Posted = 1
					AND   ccc.PostingDate >= @PostingDate
					AND   vcc.VoucherCCKey NOT IN (
						SELECT EntityKey FROM #tCashQueue WHERE Entity = 'CREDITCARD'
						)

				END -- CreditCardPayment = 1

			END -- the voucher is on a credit card
			
	END	-- VOUCHER / CREDITCARD
	
	RETURN 1
GO
