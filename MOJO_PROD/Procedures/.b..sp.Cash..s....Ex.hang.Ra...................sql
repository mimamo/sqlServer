USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostSetExchangeRate]    Script Date: 12/10/2015 10:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostSetExchangeRate]
	(
	@Entity varchar(50)
	,@EntityKey int
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 08/07/13 GHL 10.571  Created for multi currency
||                      Rather than getting the rate in separate queries like in the accrual posting routines
||                      I am pulling now the exchange rate based on entities in cash basis 
*/

	SET NOCOUNT ON

	IF @Entity = 'INVOICE'
	BEGIN
		-- first get it from Entity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = i.CurrencyID
			  ,#tCashTransaction.ExchangeRate = i.ExchangeRate
		from   tInvoice i (nolock)
		where  i.InvoiceKey = #tCashTransaction.EntityKey
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'INVOICE'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain
		and    #tCashTransaction.AEntity <> 'INVOICE'
		 
		-- then get it from AEntity (AB)
		/*  Did not seem right after testing
		The problem is that AB lines should be reversed with the Exchange Rate on the AB
		Real invoice lines should be created with the new exchange rate

		For this case, all reversals and new line have the same Entity/EntityKey and AEntity/AEntityKey
		which is a problem, so it must be set in sptCashPostInvoice

		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = i.CurrencyID
			  ,#tCashTransaction.ExchangeRate = i.ExchangeRate
		from   tInvoice i (nolock)
		where  i.InvoiceKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'INVOICE'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'INVOICE'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain
		*/

		-- PREPAYMENT...Prepay accounts
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = c.CurrencyID
			  ,#tCashTransaction.ExchangeRate = c.ExchangeRate
		from   tCheck c (nolock)
		where  c.CheckKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'RECEIPT'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'INVOICE'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		-- there are no AEntity2 with Invoices
	END

	IF @Entity = 'RECEIPT'
	BEGIN
		-- By default, set it to 1
		update #tCashTransaction
		set    #tCashTransaction.ExchangeRate = 1
		where  #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = @Entity

		-- first get it from Entity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = c.CurrencyID
			  ,#tCashTransaction.ExchangeRate = c.ExchangeRate
		from   tCheck c (nolock)
		where  c.CheckKey = #tCashTransaction.EntityKey
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'RECEIPT'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		/* here the exchange rate from the receipt should flow to the invoice lines without creating a gain

		-- then get it from AEntity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = i.CurrencyID
			  ,#tCashTransaction.ExchangeRate = i.ExchangeRate
		from   tInvoice i (nolock)
		where  i.InvoiceKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'INVOICE'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'RECEIPT'

		-- then get it from AEntity2 (Receipt --> AB -- real)
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = i.CurrencyID
			  ,#tCashTransaction.ExchangeRate = i.ExchangeRate
		from   tInvoice i (nolock)
		where  i.InvoiceKey = #tCashTransaction.AEntity2Key
		and    #tCashTransaction.AEntity2 = 'INVOICE'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'RECEIPT'
		*/
	END


	IF @Entity = 'VOUCHER'
	BEGIN
		-- By default, set it to 1
		update #tCashTransaction
		set    #tCashTransaction.ExchangeRate = 1
		where  #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = @Entity

		-- first get it from Entity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = v.CurrencyID
			  ,#tCashTransaction.ExchangeRate = v.ExchangeRate
		from   tVoucher v (nolock)
		where  v.VoucherKey = #tCashTransaction.EntityKey
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'VOUCHER'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		-- then AEntity PREPAYMENT
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = p.CurrencyID
			  ,#tCashTransaction.ExchangeRate = p.ExchangeRate
		from   tPayment p (nolock)
		where  p.PaymentKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'PAYMENT'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'VOUCHER'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		-- there are no AEntity2 with vouchers
	END

	IF @Entity = 'PAYMENT'
	BEGIN
		-- By default, set it to 1
		update #tCashTransaction
		set    #tCashTransaction.ExchangeRate = 1
		where  #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = @Entity

		-- first get it from Entity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = p.CurrencyID
			  ,#tCashTransaction.ExchangeRate = p.ExchangeRate
		from   tPayment p (nolock)
		where  p.PaymentKey = #tCashTransaction.EntityKey
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'PAYMENT'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		/* here the exchange rate from the receipt should flow to the invoice lines without creating a gain 

		-- then AEntity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = v.CurrencyID
			  ,#tCashTransaction.ExchangeRate = v.ExchangeRate
		from   tVoucher v (nolock)
		where  v.VoucherKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'VOUCHER'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'PAYMENT'

		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = v.CurrencyID
			  ,#tCashTransaction.ExchangeRate = v.ExchangeRate
		from   tVoucher v (nolock)
		where  v.VoucherKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'CREDITCARD'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'PAYMENT'

		-- then AEntity2 (Payment-->CreditCard-->Voucher)
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = v.CurrencyID
			  ,#tCashTransaction.ExchangeRate = v.ExchangeRate
		from   tVoucher v (nolock)
		where  v.VoucherKey = #tCashTransaction.AEntity2Key
		and    #tCashTransaction.AEntity2 = 'VOUCHER'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'PAYMENT'

		-- Not found but precaution
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = v.CurrencyID
			  ,#tCashTransaction.ExchangeRate = v.ExchangeRate
		from   tVoucher v (nolock)
		where  v.VoucherKey = #tCashTransaction.AEntity2Key
		and    #tCashTransaction.AEntity2 = 'CREDITCARD'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'PAYMENT'

		*/

	END

	IF @Entity = 'CREDITCARD'
	BEGIN
		-- By default, set it to 1
		update #tCashTransaction
		set    #tCashTransaction.ExchangeRate = 1
		where  #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = @Entity

		-- first get it from Entity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = v.CurrencyID
			  ,#tCashTransaction.ExchangeRate = v.ExchangeRate
		from   tVoucher v (nolock)
		where  v.VoucherKey = #tCashTransaction.EntityKey
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'CREDITCARD'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		-- then AEntity PREPAYMENT
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = p.CurrencyID
			  ,#tCashTransaction.ExchangeRate = p.ExchangeRate
		from   tPayment p (nolock)
		where  p.PaymentKey = #tCashTransaction.AEntityKey
		and    #tCashTransaction.AEntity = 'PAYMENT'
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'CREDITCARD'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

		-- there are no AEntity2 with vouchers
	END

	IF @Entity = 'GENJRNL'
	BEGIN
		-- By default, set it to 1
		update #tCashTransaction
		set    #tCashTransaction.ExchangeRate = 1
		where  #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = @Entity

		-- first get it from Entity
		update #tCashTransaction
		set    #tCashTransaction.CurrencyID = je.CurrencyID
			  ,#tCashTransaction.ExchangeRate = je.ExchangeRate
		from   tJournalEntry je (nolock)
		where  je.JournalEntryKey = #tCashTransaction.EntityKey
		and    #tCashTransaction.EntityKey = @EntityKey
		and    #tCashTransaction.Entity = 'GENJRNL'
		and    #tCashTransaction.Section not in (9,10) -- not a rounding error or realized gain

	END

	RETURN 1
GO
