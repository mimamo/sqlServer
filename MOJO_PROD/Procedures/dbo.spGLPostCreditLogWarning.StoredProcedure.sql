USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostCreditLogWarning]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostCreditLogWarning]
	(
	@CompanyKey int,
	@Entity varchar(25),
	@EntityKey int,
	@UserKey int,
	@NewExchangeRate decimal(24, 7)
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 01/16/14 GHL 10.576  Creation to handle the posting of credits with foreign currencies
||                      If the rate is changed on the regular invoice, we warn the user to repost the credits
||                      and log a change of exchange rate
*/

	declare @MultiCurrency int
	declare @OldExchangeRate decimal(24, 7)
	declare @CurrencyID as varchar(10)
	declare @ProjectKey int
	declare @InvoiceNumber varchar(50)
	declare @SourceCompanyID varchar(100)
	declare @ActionBy varchar(500)
	declare @ActionDate as smalldatetime
	declare @Comments varchar(200)

	select @MultiCurrency = isnull(MultiCurrency, 0) 
	from tPreference (nolock)
	where CompanyKey = @CompanyKey

	if @MultiCurrency = 0
		RETURN 1
	
	select @ActionDate = getutcdate()

	if @Entity = 'INVOICE'
	begin
		select @OldExchangeRate = i.ExchangeRate
		      ,@CurrencyID = i.CurrencyID
			  ,@ProjectKey = i.ProjectKey
			  ,@InvoiceNumber = isnull(i.InvoiceNumber, '')
			  ,@SourceCompanyID = c.CustomerID
		from tInvoice i (nolock)
			left outer join tCompany c (nolock) on i.ClientKey = c.CompanyKey
		where i.InvoiceKey = @EntityKey

		if @CurrencyID is null
			RETURN 1
			   
		select @NewExchangeRate = isnull(@NewExchangeRate, 1)
		select @NewExchangeRate = round(@NewExchangeRate, 6)
	
		select @OldExchangeRate = isnull(@OldExchangeRate, 1)
		select @OldExchangeRate = round(@OldExchangeRate, 6)

		if @NewExchangeRate = @OldExchangeRate
			RETURN 1

		-- these should not have changed on the UI
		if exists (
			select 1
			from   tInvoiceCredit ic (nolock)
				inner join tInvoice cr (nolock) on ic.CreditInvoiceKey = cr.InvoiceKey
			where  ic.InvoiceKey = @EntityKey
			and    cr.Posted = 1
			and    isnull(cr.OpeningTransaction, 0) = 0
			)
			begin
				select @Comments = 'Exchange rate changed on ' + @InvoiceNumber + '. Repost Credits'
				select @ActionBy = UserName from vUserName where UserKey = @UserKey
				exec sptActionLogInsert 'Client Invoice', @EntityKey, @CompanyKey, @ProjectKey, 'Exchange Rate Changed', @ActionDate, @ActionBy, @Comments, @InvoiceNumber, @SourceCompanyID, @UserKey 
				return -1
			end
	end
	else
	begin
		select @OldExchangeRate = v.ExchangeRate
		      ,@CurrencyID = v.CurrencyID
			  ,@ProjectKey = v.ProjectKey
			  ,@InvoiceNumber = isnull(v.InvoiceNumber, '')
			  ,@SourceCompanyID = c.VendorID
		from tVoucher v (nolock)
			left outer join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		where v.VoucherKey = @EntityKey

		if @CurrencyID is null
			RETURN 1
			   
		select @NewExchangeRate = isnull(@NewExchangeRate, 1)
		select @NewExchangeRate = round(@NewExchangeRate, 6)
	
		select @OldExchangeRate = isnull(@OldExchangeRate, 1)
		select @OldExchangeRate = round(@OldExchangeRate, 6)

		if @NewExchangeRate = @OldExchangeRate
			RETURN 1
		
		if exists (
			select 1
			from   tVoucherCredit ic (nolock)
				inner join tVoucher cr (nolock) on ic.CreditVoucherKey = cr.VoucherKey
			where  ic.VoucherKey = @EntityKey
			and    cr.Posted = 1
			and    isnull(cr.OpeningTransaction, 0) = 0
			)
			begin
				select @Comments = 'Exchange rate changed on ' + @InvoiceNumber + '. Repost Credits'
				select @ActionBy = UserName from vUserName where UserKey = @UserKey

				exec sptActionLogInsert 'Vendor Invoice', @EntityKey, @CompanyKey, @ProjectKey, 'Exchange Rate Changed', @ActionDate, @ActionBy, @Comments, @InvoiceNumber, @SourceCompanyID, @UserKey 
				return -1
			end
	end

	RETURN 1
GO
