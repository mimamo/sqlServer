USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGeneratePayment]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGeneratePayment]
	(
	@CurrPaymentKey int
	,@CompanyKey int
	,@NewPaymentDate datetime	-- for receipt record
	
	,@RecurTranKey int
	,@NextDate datetime			-- for recur tran record
	,@NextNumberRemaining int	-- for recur tran record

	)
	
AS --Encrypt

	SET NOCOUNT ON 
	
  /*
  || When     Who Rel    What
  || 02/23/10 GHL 10.519 Creation for new recurring logic            
  || 03/22/12 GWG 10.554 Added TargetGLCompanyKey to the copy  
  || 09/27/13 GHL 10.572 Added currency info      
  */
  	
	-- Constants	
	declare @kErrPaymentNotFound int		select @kErrPaymentNotFound = 0
	declare @kErrAppliedToInvoice int		select @kErrAppliedToInvoice = -1
	declare @kErrUnexpected int				select @kErrUnexpected = -10

	if isnull(@CurrPaymentKey, 0) <= 0
		return @kErrPaymentNotFound
	
	Declare @Error int
	Declare @NewPaymentKey int
	Declare @RecurringParentKey int
	
	-- Multi currency info
	declare @GLCompanyKey int
	declare @MultiCurrency int
	declare @HomeCurrencyID varchar(10)
	declare @CurrencyID varchar(10)
	declare @ExchangeRate decimal(24,7) 
	declare @RateHistory int

	select 	@RecurringParentKey = p.RecurringParentKey
			,@GLCompanyKey = p.GLCompanyKey
	        ,@CurrencyID = p.CurrencyID
			,@HomeCurrencyID = pref.CurrencyID
			,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	from	tPayment p (nolock)
		inner join tPreference pref (nolock) on p.CompanyKey = pref.CompanyKey
	where	p.PaymentKey = @CurrPaymentKey
	
	if @@ROWCOUNT = 0
		return @kErrPaymentNotFound
	
	if exists (select 1 from tPaymentDetail (nolock) where PaymentKey = @CurrPaymentKey and isnull(VoucherKey, 0) > 0)
		return @kErrAppliedToInvoice

	Begin Tran
		
	if isnull(@RecurringParentKey, 0) = 0
	begin
		Update tPayment Set RecurringParentKey = @CurrPaymentKey Where PaymentKey = @CurrPaymentKey
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected					   	
		end
	end
	
	select @ExchangeRate = 1

	if @MultiCurrency = 1 And  @CurrencyID is not null And @CurrencyID <> @HomeCurrencyID 
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @NewPaymentDate, @ExchangeRate output, @RateHistory output


	INSERT tPayment
		(
		CompanyKey,
		CashAccountKey,
		ClassKey,
		UnappliedPaymentAccountKey,
		PaymentDate,
		PostingDate,
		CheckNumber,
		PaymentAmount,
		VendorKey,
		PayToName,
		PayToAddress1,
		PayToAddress2,
		PayToAddress3,
		PayToAddress4,
		PayToAddress5,
		Memo,
		GLCompanyKey,
		OpeningTransaction,
		RecurringParentKey,
		CurrencyID,
		ExchangeRate
		)

	SELECT
		CompanyKey,
		CashAccountKey,
		ClassKey,
		UnappliedPaymentAccountKey,
		@NewPaymentDate,
		@NewPaymentDate,--PostingDate,
		null, --CheckNumber,
		PaymentAmount,
		VendorKey,
		PayToName,
		PayToAddress1,
		PayToAddress2,
		PayToAddress3,
		PayToAddress4,
		PayToAddress5,
		Memo,
		GLCompanyKey,
		OpeningTransaction,
		RecurringParentKey,
		CurrencyID,
		@ExchangeRate -- new exchange rate for the date
	FROM tPayment (nolock)
	WHERE PaymentKey = @CurrPaymentKey
	
	Select @Error = @@ERROR, @NewPaymentKey = @@Identity
	If @Error <> 0
	begin
		rollback Tran
		return @kErrUnexpected
	end
	
	INSERT tPaymentDetail
           (PaymentKey
           ,GLAccountKey
           ,ClassKey
           ,VoucherKey
           ,Description
           ,Quantity
           ,UnitAmount
           ,DiscAmount
           ,Amount
           ,Prepay
           ,OfficeKey
           ,DepartmentKey
           ,Exclude1099
		   ,TargetGLCompanyKey)
     SELECT
           @NewPaymentKey
           ,GLAccountKey
           ,ClassKey
           ,VoucherKey
           ,Description
           ,Quantity
           ,UnitAmount
           ,DiscAmount
           ,Amount
           ,Prepay
           ,OfficeKey
           ,DepartmentKey
           ,Exclude1099
		   ,TargetGLCompanyKey
	 FROM  tPaymentDetail (nolock)
	 WHERE PaymentKey = @CurrPaymentKey 
	 
	If @@ERROR <> 0
	begin
		rollback Tran
		return @kErrUnexpected
	end
	
	
	if isnull(@RecurTranKey, 0) > 0
	begin		
		update tRecurTran
		set    NextDate = @NextDate, NumberRemaining = @NextNumberRemaining 
		where  RecurTranKey = @RecurTranKey
		
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected				   	
		end
	end		
	
	Commit Tran
	
	RETURN @NewPaymentKey
GO
