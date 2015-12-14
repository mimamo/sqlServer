USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGenerateJournalEntry]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGenerateJournalEntry]
	(
	@CurrJournalEntryKey int
	,@CompanyKey int
	,@NewJournalEntryDate datetime	-- for JE record
	
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
  || 09/25/14 GHL 10.584 (229124) Added update of ExchangeRate to allow for transfer of foreign currencies    
  */
  	
	-- Constants	
	declare @kErrJENotFound int				select @kErrJENotFound = 0
	declare @kErrUnexpected int				select @kErrUnexpected = -10

	if isnull(@CurrJournalEntryKey, 0) <= 0
		return @kErrJENotFound
	
	Declare @NewJournalEntryKey int
	Declare @NextJournalNumber int
	Declare @RecurringParentKey int
	Declare @Error int
	
	-- Multi currency info
	declare @GLCompanyKey int
	declare @MultiCurrency int
	declare @HomeCurrencyID varchar(10)
	declare @CurrencyID varchar(10)
	declare @ExchangeRate decimal(24,7) 
	declare @RateHistory int

	select 	@RecurringParentKey = je.RecurringParentKey
			,@GLCompanyKey = je.GLCompanyKey
			,@CurrencyID = je.CurrencyID
			,@HomeCurrencyID = pref.CurrencyID
			,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	from	tJournalEntry je (nolock)
		inner join tPreference pref (nolock) on je.CompanyKey = pref.CompanyKey
	where	je.JournalEntryKey = @CurrJournalEntryKey
	
	if @@ROWCOUNT = 0
		return @kErrJENotFound
		
	Select @NextJournalNumber = ISNULL(NextJournalNumber, 1)
	From tPreference p (nolock) Where p.CompanyKey = @CompanyKey
		
	While 1=1
	BEGIN
		if exists(Select 1 from tJournalEntry (nolock) Where JournalNumber = Cast(@NextJournalNumber as Varchar) and CompanyKey = @CompanyKey)
			Select @NextJournalNumber = @NextJournalNumber + 1
		else
			Break
	END

	Begin Tran
	
	if isnull(@RecurringParentKey, 0) = 0
	begin
		Update tJournalEntry Set RecurringParentKey = @CurrJournalEntryKey Where JournalEntryKey = @CurrJournalEntryKey
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected					   	
		end
	end

	select @ExchangeRate = 1

	if @MultiCurrency = 1 And  @CurrencyID is not null And @CurrencyID <> @HomeCurrencyID 
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @NewJournalEntryDate, @ExchangeRate output, @RateHistory output

	INSERT tJournalEntry
		(
		CompanyKey,
		EntryDate,
		PostingDate,
		EnteredBy,
		JournalNumber,
		Posted,
		RecurringParentKey,
		AutoReverse,
		Description,
		GLCompanyKey,
		ExcludeCashBasis,
		ExcludeAccrualBasis,
		CurrencyID,
		ExchangeRate
		)

	Select
		CompanyKey,
		EntryDate,
		@NewJournalEntryDate, -- Why only PostingDate here?
		EnteredBy,
		@NextJournalNumber,
		0,
		RecurringParentKey,
		AutoReverse,
		Description,
		GLCompanyKey,
		ExcludeCashBasis,
		ExcludeAccrualBasis,
		CurrencyID,
		@ExchangeRate -- new exchange rate for the day
	From tJournalEntry Where JournalEntryKey = @CurrJournalEntryKey
	

	Select @Error = @@ERROR, @NewJournalEntryKey = @@Identity
	if @Error <> 0 
	begin
		rollback tran
		return @kErrUnexpected					   	
	end	
	
	Insert Into tJournalEntryDetail (JournalEntryKey, GLAccountKey, ClassKey, ClientKey, ProjectKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey,TargetGLCompanyKey, ExchangeRate)
	Select @NewJournalEntryKey, ISNULL(GLAccountKey, 0), ClassKey, ClientKey, ProjectKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey,TargetGLCompanyKey, ExchangeRate
	From tJournalEntryDetail (nolock) 
	Where JournalEntryKey = @CurrJournalEntryKey
	
	if @@ERROR <> 0 
	begin
		rollback tran
		return @kErrUnexpected					   	
	end
		
	Select @NextJournalNumber = @NextJournalNumber + 1

	Update tPreference
	Set NextJournalNumber = @NextJournalNumber
	Where CompanyKey = @CompanyKey

	if @@ERROR <> 0 
	begin
		rollback tran
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
	
	RETURN @NewJournalEntryKey
GO
