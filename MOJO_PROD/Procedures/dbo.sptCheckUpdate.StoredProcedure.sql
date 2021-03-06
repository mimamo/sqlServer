USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckUpdate]
 @CheckKey int,
 @CheckAmount money,
 @CheckDate smalldatetime,
 @PostingDate smalldatetime,
 @ReferenceNumber varchar(100),
 @Description varchar(500),
 @CashAccountKey int,
 @ClassKey int,
 @PrepayAccountKey int,
 @DepositID varchar(50),
 @CheckMethodKey int,
 @GLCompanyKey int,
 @ClientKey int = 0,
 @OpeningTransaction tinyint = 0,
 @CurrencyID varchar(10) = null,
 @ExchangeRate decimal(14,7) = 1 

AS --Encrypt

/*
|| When      Who Rel     What
|| 06/18/08  GHL 8.513   Added OpeningTransaction
|| 10/24/08  GHL 10.011  Added GLCompanyKey when creating the deposit
|| 04/20/09  GHL 10.023  Added check of the posting date of the voided checks for cash basis posting
|| 02/10/10  GWG 10.518  Added the insert logic and insertion of the company key onto the header
|| 03/10/10  MFT 10.520  Added @ClientKey to support insert logic
|| 09/19/13  GHL 10.572  Added support for multi currency
|| 01/08/14  GHL 10.576  Made correction to the checking of currency on cash accounts
*/

Declare @AppliedAmount money
Declare @CurDepositKey int
Declare @CompanyKey int
Declare @DepositKey int
Declare @CurrAcctKey int
Declare @Cleared tinyint
Declare @VoidCheckKey int
Declare @VoidCheckPostingDate smalldatetime	

if Exists(Select 1 from tCheck (nolock) Where CheckKey = @CheckKey and Posted = 1)
	return -1

IF ISNULL(@CheckKey, 0) > 0
	SELECT @ClientKey = ClientKey, @CurDepositKey = DepositKey, @VoidCheckKey = VoidCheckKey 
	FROM tCheck (nolock)
	WHERE CheckKey = @CheckKey

IF @ClientKey IS NULL
	return - 5

-- check if the posting date is before the date of the original check that was voided
If Isnull(@VoidCheckKey, 0) > 0 And Isnull(@VoidCheckKey, 0) <> @CheckKey 
Begin
	Select @VoidCheckPostingDate = PostingDate
	From   tCheck (nolock)
	Where  CheckKey = @VoidCheckKey
	
	If @VoidCheckPostingDate Is Not Null
		If @PostingDate < @VoidCheckPostingDate
			return -6
End

-- same check of the posting dates but seen from the other side (the VOID check)
If Isnull(@VoidCheckKey, 0) > 0 And Isnull(@VoidCheckKey, 0) = @CheckKey 
Begin
	Select @VoidCheckPostingDate = PostingDate
	From   tCheck (nolock)
	Where  VoidCheckKey = @VoidCheckKey
	And    CheckKey <> @VoidCheckKey
	
	If @VoidCheckPostingDate Is Not Null
		If @PostingDate > @VoidCheckPostingDate
			return -7
End

Select @AppliedAmount = Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey
IF @CheckAmount > 0
BEGIN
	If ISNULL(@AppliedAmount, 0) > @CheckAmount
		return -2
END
ELSE
BEGIN
	If ISNULL(@AppliedAmount, 0) < @CheckAmount
		return -2
END
		
if exists(Select 1 from tCheck (nolock) Where ReferenceNumber = @ReferenceNumber and ClientKey = @ClientKey and CheckKey <> @CheckKey)
	return -3
	
if @CashAccountKey is null
	Select @DepositID = NULL
	
Select @CompanyKey = OwnerCompanyKey from tCompany (nolock) Where CompanyKey = @ClientKey


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
	-- multi currency = 1
	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate = 1

	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null -- no empty string
			  ,@ExchangeRate = 1
	
	-- Now bank account must be in same currency as the header
	select @CashAccountCurrencyID = CurrencyID from tGLAccount (nolock) where GLAccountKey = @CashAccountKey
	if isnull(@CashAccountCurrencyID, '') <> isnull(@CurrencyID, '')
		return -8


end


-- There is a possible new or existing and one was already specified
if not @DepositID is null and not @CurDepositKey is null
begin
	
	
	Select @CurrAcctKey = GLAccountKey 
	from tDeposit (nolock) 
	Where DepositKey = @CurDepositKey
	
	Select @DepositKey = DepositKey, @Cleared = Cleared 
	from tDeposit (nolock) 
	Where CompanyKey = @CompanyKey 
	and DepositID = @DepositID 
	and ISNULL(GLAccountKey, 0) = ISNULL(@CashAccountKey, 0)
	and ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
	
	if @DepositKey is null
		-- new deposit, create and delete old
		BEGIN
			-- Insert the new
			Insert tDeposit 
			( CompanyKey, DepositID, GLAccountKey, DepositDate, GLCompanyKey )
			VALUES
			( @CompanyKey, @DepositID, @CashAccountKey, @CheckDate, @GLCompanyKey )
			
			Select @DepositKey = @@Identity
			
			-- Delete the old if no other checks are tied to it
			if not exists(select 1 from tCheck (nolock) Where DepositKey = @CurDepositKey and CheckKey <> @CheckKey)
				Delete tDeposit Where DepositKey = @CurDepositKey
		END
	else
		if @DepositKey = @CurDepositKey
			-- The deposits are the same, do nothing
			select @DepositKey = @CurDepositKey
		else
			-- The new and the old exists, just delete the old one if there are no other deposits.
			begin
				-- if the new deposit key has been cleared, then do not allow the update
				if ISNULL(@Cleared, 0) = 1
					return -4
				-- They reasigned it to a different existing deposit.
				if not exists(select 1 from tCheck (nolock) Where DepositKey = @CurDepositKey and CheckKey <> @CheckKey)
					Delete tDeposit Where DepositKey = @CurDepositKey
			end
end

-- If they passed in a deposit id and there was never an id
if not @DepositID is null and @CurDepositKey is null
BEGIN
	Select @CompanyKey = OwnerCompanyKey 
	from tCompany (nolock) 
	Where CompanyKey = @ClientKey
	
	Select @CurrAcctKey = GLAccountKey 
	from tDeposit (nolock) 
	Where DepositKey = @CurDepositKey
	
	Select @DepositKey = DepositKey, @Cleared = Cleared 
	from tDeposit (nolock) 
	Where CompanyKey = @CompanyKey 
	and DepositID = @DepositID 
	and ISNULL(GLAccountKey, 0) = ISNULL(@CashAccountKey, 0)
	and ISNULL(GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
	
	if @DepositKey is null
		-- new deposit, create and delete old
		BEGIN
			-- Insert the new
			Insert tDeposit 
			( CompanyKey, DepositID, GLAccountKey, DepositDate, GLCompanyKey )
			VALUES
			( @CompanyKey, @DepositID, @CashAccountKey, @CheckDate, @GLCompanyKey )
			
			Select @DepositKey = @@Identity
			
		END
	else
		-- The new exists, just reassign it if not cleared
		if ISNULL(@Cleared, 0) = 1
			return -4

END

If @DepositID is null and not @CurDepositKey is null
begin
	if not exists(select 1 from tCheck (nolock) Where DepositKey = @CurDepositKey and CheckKey <> @CheckKey)
		Delete tDeposit Where DepositKey = @CurDepositKey

end
 
IF ISNULL(@CheckKey, 0) = 0
BEGIN
	INSERT tCheck
	(
		ClientKey,
		CompanyKey,
		CheckAmount,
		CheckDate,
		PostingDate,
		ReferenceNumber,
		Description,
		CashAccountKey,
		ClassKey,
		PrepayAccountKey,
		Posted,
		DepositKey,
		CheckMethodKey,
		GLCompanyKey,
		OpeningTransaction,
		CurrencyID,
		ExchangeRate
	)
	VALUES
	(
		@ClientKey,
		@CompanyKey,
		@CheckAmount,
		@CheckDate,
		@PostingDate,
		@ReferenceNumber,
		@Description,
		@CashAccountKey,
		@ClassKey,
		@PrepayAccountKey,
		0,
		@DepositKey,
		@CheckMethodKey,
		@GLCompanyKey,
		@OpeningTransaction,
		@CurrencyID,
		@ExchangeRate
	)

	SELECT @CheckKey = @@IDENTITY

END
ELSE
BEGIN
	UPDATE
		tCheck
	SET
		CheckAmount = @CheckAmount,
		CheckDate = @CheckDate,
		PostingDate = @PostingDate,
		ReferenceNumber = @ReferenceNumber,
		Description = @Description,
		CashAccountKey = @CashAccountKey,
		ClassKey = @ClassKey,
		PrepayAccountKey = @PrepayAccountKey,
		DepositKey = @DepositKey,
		CheckMethodKey = @CheckMethodKey,
		GLCompanyKey = @GLCompanyKey,
		OpeningTransaction = @OpeningTransaction,	
		CurrencyID = @CurrencyID,
		ExchangeRate = @ExchangeRate
	WHERE
		CheckKey = @CheckKey 
END

RETURN @CheckKey
GO
