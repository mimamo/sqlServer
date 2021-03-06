USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPaymentUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPaymentUpdate]
	@PaymentKey int,
	@CompanyKey int,
	@CashAccountKey int,
	@ClassKey int,
	@UnappliedPaymentAccountKey int,
	@PaymentDate smalldatetime,
	@PostingDate smalldatetime,
	@CheckNumber varchar(50),
	@PaymentAmount money,
	@VendorKey int,
	@PayToName varchar(300),
	@PayToAddress1 varchar(300),
	@PayToAddress2 varchar(300),
	@PayToAddress3 varchar(300),
	@PayToAddress4 varchar(300),
	@PayToAddress5 varchar(300),
	@Memo varchar(500),
	@GLCompanyKey int,
	@OpeningTransaction tinyint,
	@NoOverApplyCheck tinyint = NULL,
	@CurrencyID varchar(10) = null,
    @ExchangeRate decimal(14,7) = 1 

AS --Encrypt

/*
|| When     Who Rel       What
|| 09/21/07 BSH 8.5       (9659)Update GLCompanyKey
|| 06/18/08 GHL 8.513     Added OpeningTransaction
|| 03/16/09 GHL 10.020    Added Exclude1099 to match WMJ code
|| 03/01/10 MAS 10.5.2    Added insert logic
|| 03/10/10 MAS 10.5.2    Added @NoOverApplyCheck flag
|| 07/01/12 GWG 10.5.5.7  Modified dup check number check to take into account multi company payments
|| 07/19/12 MFT 10.5.5.8  (149330) Removed check number incrementing; corrected OnHold error return value
|| 09/11/12 GWG 10.5.5.9  Modified dup check again. wrong nesting of check number if statements
|| 11/08/13 GHL 10.574    Added support for multi currency
|| 01/08/14  GHL 10.576   Made correction to the checking of currency on cash accounts
*/

DECLARE @OnHold tinyint, @MultiCompanyPayments tinyint

Select @MultiCompanyPayments = ISNULL(MultiCompanyPayments, 0) from tGLAccount (nolock) Where GLAccountKey = @CashAccountKey

-- Now multi currency
declare @MultiCurrency int 
declare @CashAccountCurrencyID varchar(10)

select @MultiCurrency = isnull(MultiCurrency, 0) from tPreference (nolock) where CompanyKey = @CompanyKey
 
if @MultiCurrency = 0
begin
	select @CurrencyID = null 
		  ,@ExchangeRate = 1
end
else 
begin
	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate = 1

	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null -- no empty string
			  ,@ExchangeRate = 1
	
	-- Now bank account must be in same currency as the header
	select @CashAccountCurrencyID = CurrencyID from tGLAccount (nolock) where GLAccountKey = @CashAccountKey
	if isnull(@CashAccountCurrencyID, '') <> isnull(@CurrencyID, '')
		return -4

end


IF @PaymentKey < 1
	BEGIN
		if len(@CheckNumber) > 0 or not @CheckNumber is null
		BEGIN
			IF @MultiCompanyPayments = 1
			BEGIN
				if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = @CheckNumber and CashAccountKey = @CashAccountKey and ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and CompanyKey = @CompanyKey)
					return -1
			END
			ELSE
			BEGIN
				if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = @CheckNumber and CashAccountKey = @CashAccountKey and CompanyKey = @CompanyKey)
					return -1
			END
		END
		
		Select @OnHold = OnHold from tCompany (nolock) WHERE CompanyKey = @VendorKey
		If @OnHold = 1 
			return -3
		
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
			CurrencyID,
		    ExchangeRate
			)
		
		VALUES
			(
			@CompanyKey,
			@CashAccountKey,
			@ClassKey,
			@UnappliedPaymentAccountKey,
			@PaymentDate,
			@PostingDate,
			@CheckNumber,
			@PaymentAmount,
			@VendorKey,
			@PayToName,
			@PayToAddress1,
			@PayToAddress2,
			@PayToAddress3,
			@PayToAddress4,
			@PayToAddress5,
			@Memo,
			@GLCompanyKey,
			@OpeningTransaction,
			@CurrencyID,
			@ExchangeRate
			)
		
		SELECT @PaymentKey = @@IDENTITY
		/*
		IF  @CheckNumber is not null
			if ISNUMERIC(@CheckNumber) = 1
			BEGIN
				Declare @NextNum bigint, @CheckNumberN bigint
				if @MultiCompanyPayments = 1
					Select @NextNum = ISNULL(NextCheckNumber, 0) from tGLAccountMultiCompanyPayments (nolock) Where ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and GLAccountKey =  @CashAccountKey
				else
					Select @NextNum = ISNULL(NextCheckNumber, 0) from tGLAccount (nolock) Where GLAccountKey =  @CashAccountKey
		
				Select @CheckNumberN = Cast(@CheckNumber as bigint)
			
				if @CheckNumberN > @NextNum
					Select @NextNum = @CheckNumberN

				Select @NextNum = @NextNum + 1

				if @MultiCompanyPayments = 1
					Update tGLAccountMultiCompanyPayments Set NextCheckNumber = @NextNum Where ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and GLAccountKey =  @CashAccountKey
				else
					Update tGLAccount Set NextCheckNumber = @NextNum Where GLAccountKey =  @CashAccountKey
		
			END
		*/

		RETURN @PaymentKey
	END
ELSE
	BEGIN	
		if len(@CheckNumber) > 0
		BEGIN
			if @MultiCompanyPayments = 1
			BEGIN
				if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = @CheckNumber and CashAccountKey = @CashAccountKey and ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0) and CompanyKey = @CompanyKey and PaymentKey <> @PaymentKey)
					return -1
			END
			ELSE
			BEGIN
				if exists(Select 1 from tPayment (NOLOCK) Where CheckNumber = @CheckNumber and CashAccountKey = @CashAccountKey and CompanyKey = @CompanyKey and PaymentKey <> @PaymentKey)
					return -1
			END
		END

		IF ISNULL(@NoOverApplyCheck,0) = 0
			BEGIN
				Declare @Applied money
				Select @Applied = Sum(Amount) from tPaymentDetail (NOLOCK) Where PaymentKey = @PaymentKey
				
				if @PaymentAmount > 0
					if ISNULL(@Applied, 0) > @PaymentAmount
						return -2
					
				if @PaymentAmount < 0
					if ISNULL(@Applied, 0) < @PaymentAmount
						return -2
			END
			
		UPDATE
			tPayment
		SET
			CompanyKey = @CompanyKey,
			CashAccountKey = @CashAccountKey,
			ClassKey = @ClassKey,
			UnappliedPaymentAccountKey = @UnappliedPaymentAccountKey,
			PaymentDate = @PaymentDate,
			PostingDate = @PostingDate,
			CheckNumber = @CheckNumber,
			PaymentAmount = @PaymentAmount,
			VendorKey = @VendorKey,
			PayToName = @PayToName,
			PayToAddress1 = @PayToAddress1,
			PayToAddress2 = @PayToAddress2,
			PayToAddress3 = @PayToAddress3,
			PayToAddress4 = @PayToAddress4,
			PayToAddress5 = @PayToAddress5,
			Memo = @Memo,
			GLCompanyKey = @GLCompanyKey,
			OpeningTransaction = @OpeningTransaction,
			CurrencyID = @CurrencyID,
			ExchangeRate = @ExchangeRate
		WHERE
			PaymentKey = @PaymentKey 



		RETURN @PaymentKey
	END
GO
