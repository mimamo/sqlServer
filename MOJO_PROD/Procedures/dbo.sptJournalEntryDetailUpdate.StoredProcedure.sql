USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryDetailUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryDetailUpdate]
	@JournalEntryDetailKey int,
	@JournalEntryKey int,
	@GLAccountKey int,
	@ClassKey int,
	@ClientKey int,
	@ProjectKey int,
	@Memo varchar(500),
	@DebitAmount money,
	@CreditAmount money,
	@OfficeKey int,
	@DepartmentKey int,
	@TargetGLCompanyKey int,
	@ExchangeRate decimal(24,7) = 1

AS --Encrypt

/*
|| When     Who Rel    What
|| 10/17/07 BSH 8.5    (9659)Update OfficeKey, DepartmentKey
|| 10/05/09 MFT 10.511 Added insert logic
|| 03/27/12 MFT 10.554 Added TargetGLCompanyKey
|| 11/16/12 GWG 10.562 Added a check for project gl company to be the same as either the header or target.
|| 01/08/14 GHL 10.576 If foreign currencies are used, bank accounts must have the same currency
|| 03/10/14 GHL 10.578 Same check if AP,AR or Credit Card account 
|| 09/23/14 GHL 10.584 (229124) To be able to do Tranfers of Funds from EUR to CAD for example, relax return # 2
||                     Also added ExchangeRate on the line. We modified the Journal entry screen so that you can do
||                     , say a transfer from a bank in a foreign currency to a bank in Home Currency or another foreign currency. 
||                     The currency will be visible but readonly on the grid and for foreign currencies it will be possible to 
||                     enter an Exchange Rate. When multiple currencies are entered on a Journal entry
||                     , we will balance the Debit/Credit expressed in Home Currency, not the Debit/Credit expressed in foreign currencies. 
||                     Also you will be able to enter extra lines for fees, etc...
*/

declare @ProjectGLCompanyKey int, @HeaderGLCompanyKey int, @LineGlCompanyKey int
if @ProjectKey is not null and @ClientKey is null
	Select @ClientKey = ClientKey from tProject (nolock) Where ProjectKey = @ProjectKey


if ISNULL(@ProjectKey, 0) > 0
BEGIN
	select @LineGlCompanyKey = ISNULL(@TargetGLCompanyKey, 0)
	Select @HeaderGLCompanyKey = ISNULL(GLCompanyKey, 0) from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey
	Select @ProjectGLCompanyKey = ISNULL(GLCompanyKey, 0) from tProject (nolock) Where ProjectKey = @ProjectKey
	if @ProjectGLCompanyKey <> @HeaderGLCompanyKey and @ProjectGLCompanyKey <> @LineGlCompanyKey
		Return -1
END

declare @CompanyKey int
declare @MultiCurrency int
declare @JECurrencyID varchar(10)
declare @GLAccountCurrencyID varchar(10)
declare @AccountType int

select @JECurrencyID = CurrencyID 
      ,@CompanyKey = CompanyKey
from tJournalEntry (nolock) where JournalEntryKey = @JournalEntryKey

select @GLAccountCurrencyID = CurrencyID
      ,@AccountType = AccountType
from   tGLAccount (nolock)
where GLAccountKey = @GLAccountKey

/*
select @MultiCurrency = isnull(MultiCurrency, 0) from tPreference (nolock) where CompanyKey = @CompanyKey

if @MultiCurrency = 1
begin
	-- check bank AP AR Credit Card account
	if @AccountType in ( 10, 11, 20, 23) and isnull(@GLAccountCurrencyID, '') <> isnull(@JECurrencyID, '')
		return -2
end
*/

if isnull(@ExchangeRate, 0) <= 0
	select @ExchangeRate = 1

if not exists (select 1 from tJournalEntry (nolock) where JournalEntryKey = isnull(@JournalEntryKey, 0) )
	return 0

IF @JournalEntryDetailKey > 0
	UPDATE
		tJournalEntryDetail
	SET
		JournalEntryKey = @JournalEntryKey,
		GLAccountKey = @GLAccountKey,
		ClassKey = @ClassKey,
		ClientKey = @ClientKey,
		ProjectKey = @ProjectKey,
		Memo = @Memo,
		DebitAmount = @DebitAmount,
		CreditAmount = @CreditAmount,
		OfficeKey = @OfficeKey,
		DepartmentKey = @DepartmentKey,
		TargetGLCompanyKey = @TargetGLCompanyKey,
		ExchangeRate = @ExchangeRate
	WHERE
		JournalEntryDetailKey = @JournalEntryDetailKey 
ELSE
	BEGIN
		INSERT tJournalEntryDetail
			(
				JournalEntryKey,
				GLAccountKey,
				ClassKey,
				ClientKey,
				ProjectKey,
				Memo,
				DebitAmount,
				CreditAmount,
				OfficeKey,
				DepartmentKey,
				TargetGLCompanyKey,
				ExchangeRate
			)

		VALUES
			(
				@JournalEntryKey,
				@GLAccountKey,
				@ClassKey,
				@ClientKey,
				@ProjectKey,
				@Memo,
				@DebitAmount,
				@CreditAmount,
				@OfficeKey,
				@DepartmentKey,
				@TargetGLCompanyKey,
				@ExchangeRate
			)
		
		SELECT @JournalEntryDetailKey = SCOPE_IDENTITY()
	END
	
RETURN @JournalEntryDetailKey
GO
