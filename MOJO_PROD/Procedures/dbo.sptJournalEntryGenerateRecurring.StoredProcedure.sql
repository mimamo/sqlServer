USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryGenerateRecurring]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryGenerateRecurring]

	(
		@JournalEntryKey int,
		@CompanyKey int,
		@RecurringInterval smallint,
		@RecurringCount int
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 2/5/07   CRG 8.4.0.3 Added Description to the Insert for the new JournalEntry 
|| 10/18/07 BSH 8.5   (9659)Update OfficeKey, DepartmentKey
|| 02/28/09 GHL 10.019 Added @ExcludeCashBasis
|| 05/04/09 GHL 10.024 Added @ExcludeAccrualBasis
|| 09/25/14 GHL 10.584 (229124) Added update of ExchangeRate to allow for transfer of foreign currencies
*/
	
if @RecurringCount = 0
	Return 1
	
If exists(Select 1 from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey and RecurringParentKey > 0)
	return -1

Begin Transaction

Update tJournalEntry Set RecurringParentKey = @JournalEntryKey Where JournalEntryKey = @JournalEntryKey
if @@ERROR <> 0 
begin
	rollback tran
	return -3					   	
end

Declare @Loop int, @CurOrder int, @RetVal INTEGER, @NextTranNo VARCHAR(100), @NewKey int, @CurPostingDate smalldatetime, @CurDueDate smalldatetime, @PostingDate smalldatetime, @DueDate smalldatetime
Declare @JournalNumber varchar(50), @NextJournalNumber int

Select @CurPostingDate = PostingDate from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey

Select @NextJournalNumber = ISNULL(NextJournalNumber, 1)
From
	tPreference p (nolock)
Where
	p.CompanyKey = @CompanyKey
		
Select @Loop = 0
While @Loop < @RecurringCount
BEGIN

	Select @Loop = @Loop + 1
	
 -- Get the next number
	While 1=1
	BEGIN
		if exists(Select 1 from tJournalEntry (nolock) Where JournalNumber = Cast(@NextJournalNumber as Varchar) and CompanyKey = @CompanyKey)
			Select @NextJournalNumber = @NextJournalNumber + 1
		else
			Break
	END

	IF @RetVal <> 1
		begin
			rollback tran
			return -3					   	
		end
		

	IF @RecurringInterval = 1
		SELECT @PostingDate = DATEADD(month, @Loop, @CurPostingDate)
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
	IF @RecurringInterval = 2
		SELECT @PostingDate = DATEADD(month, 3 * @Loop, @CurPostingDate)
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
	IF @RecurringInterval = 3
		SELECT @PostingDate = DATEADD(year, @Loop, @CurPostingDate)
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end


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
		@PostingDate,
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
		ExchangeRate
	From tJournalEntry Where JournalEntryKey = @JournalEntryKey

	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end
	
	Select @NewKey = @@Identity
	
	Insert Into tJournalEntryDetail (JournalEntryKey, GLAccountKey, ClassKey, ClientKey, ProjectKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey, ExchangeRate)
	Select @NewKey, ISNULL(GLAccountKey, 0), ClassKey, ClientKey, ProjectKey, Memo, DebitAmount, CreditAmount, OfficeKey, DepartmentKey, ExchangeRate
	From tJournalEntryDetail (nolock) 
	Where JournalEntryKey = @JournalEntryKey
	
	
	if @@ERROR <> 0 
	begin
		rollback tran
		return -3					   	
	end


END	

Select @NextJournalNumber = @NextJournalNumber + 1

Update tPreference
Set NextJournalNumber = @NextJournalNumber
Where CompanyKey = @CompanyKey
	
Commit Transaction
GO
