USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryCopy]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryCopy]
	@JournalEntryKey int,
	@TranDate smalldatetime,
	@EnteredBy int,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 10/18/07 BSH 8.5   (9659)Insert GLCompanyKey, OfficeKey, DepartmentKey
|| 02/28/09 GHL 10.019 Added ExcludeCashBasis
|| 05/04/09 GHL 10.024 Added ExcludeAccrualBasis
|| 03/27/12 MFT 10.554 Added TargetGLCompanyKey
|| 01/08/14 GHL 10.576 Added currency info
|| 09/25/14 GHL 10.584 (229124) Added update of tJournalEntryDetail.ExchangeRate 
||                     to allow for transfer of foreign currencies
|| 11/04/14 GAR 10.585 (235118) Show an error if a user tries to copy a journal entry 
					   that contains a detail record withn an inactive GL Account.
*/
	Declare @JournalNumber varchar(50), @CompanyKey int, @NewKey int
	Declare @NextJournalNumber int
	Declare	@Description varchar(100)
	Declare @GLCompanyKey int
	Declare @ExcludeCashBasis int
	Declare @ExcludeAccrualBasis int
	Declare @CurrencyID varchar(10)
	Declare @ExchangeRate decimal(24,7)

	-- (235118) If any of the accounts on the JE is inactive, return an error.  Can't copy a JE with an inactive invoice.
	IF EXISTS(SELECT 1 FROM tGLAccount gl (NOLOCK) INNER JOIN tJournalEntryDetail jed (NOLOCK) ON gl.GLAccountKey = jed.GLAccountKey WHERE gl.Active = 0 AND jed.JournalEntryKey = @JournalEntryKey)
         RETURN -1                   

	Select @NextJournalNumber = ISNULL(NextJournalNumber, 1), @CompanyKey = je.CompanyKey
	From
		tJournalEntry je (nolock) 
		inner join tPreference p (nolock) on je.CompanyKey = p.CompanyKey
	Where
		je.JournalEntryKey = @JournalEntryKey

While 1=1
BEGIN
	if exists(Select 1 from tJournalEntry (nolock) Where JournalNumber = Cast(@NextJournalNumber as Varchar) and CompanyKey = @CompanyKey)
		Select @NextJournalNumber = @NextJournalNumber + 1
	else
		Break
END
	
	SELECT	@Description = Description,
			@GLCompanyKey = GLCompanyKey,
			@ExcludeCashBasis = ISNULL(ExcludeCashBasis, 0),
			@ExcludeAccrualBasis = ISNULL(ExcludeAccrualBasis, 0),
			@CurrencyID = CurrencyID,
			@ExchangeRate = ExchangeRate
	FROM	tJournalEntry (NOLOCK)
	WHERE	JournalEntryKey = @JournalEntryKey

	INSERT tJournalEntry
		(
		CompanyKey,
		EntryDate,
		PostingDate,
		EnteredBy,
		JournalNumber,
		Posted,
		RecurringParentKey,
		Description,
		GLCompanyKey,
		ExcludeCashBasis,
		ExcludeAccrualBasis,
		CurrencyID,
		ExchangeRate
		)

	VALUES
		(
		@CompanyKey,
		@TranDate,
		@TranDate,
		@EnteredBy,
		Cast(@NextJournalNumber as Varchar),
		0,
		0,
		@Description,
		@GLCompanyKey,
		@ExcludeCashBasis,
		@ExcludeAccrualBasis,
		@CurrencyID,
		@ExchangeRate
		)
	
	SELECT @oIdentity = @@IDENTITY
	Select @NewKey = @@IDENTITY
	
	Select @NextJournalNumber = @NextJournalNumber + 1
	Update tPreference
	Set NextJournalNumber = @NextJournalNumber
	Where CompanyKey = @CompanyKey

	
	Insert Into tJournalEntryDetail (JournalEntryKey, GLAccountKey, ClientKey, ProjectKey, ClassKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey, TargetGLCompanyKey, ExchangeRate)
	Select @NewKey, ISNULL(GLAccountKey, 0), ClientKey, ProjectKey, ClassKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey, TargetGLCompanyKey, ExchangeRate
	From tJournalEntryDetail (nolock) 
	Where JournalEntryKey = @JournalEntryKey
	Order By JournalEntryDetailKey
	RETURN 1
GO
