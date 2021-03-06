USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryReverse]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryReverse]
	(
		@JournalEntryKey int,
		@ReversingDate smalldatetime
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 1/20/08  GWG 8.5    Added GLCompanyKey
|| 02/26/09 GHL 10.019 Added ExcludeCashBasis	
|| 03/18/09 GWG 10.021 Added a transaction to try and eliminate header being created with no lines	
|| 05/04/09 GHL 10.024 Added @ExcludeAccrualBasis
|| 06/26/09 RLB 10.500 Added Check to make sure detail line totals match 
|| 09/03/09 GWG 10.509 Added a delete if the counts dont match
|| 10/28/09 GHL 10.512 (66865) Added a couple of changes regarding the SQL transaction
|| 03/27/12 MFT 10.554 Added TargetGLCompanyKey
|| 03/30/12 MFT 10.554 Added IntercompanyAccountSource
|| 09/25/14 GHL 10.584 (229124) Added update of ExchangeRate to allow for transfer of foreign currencies
*/

Declare @NewKey int, @JournalNumber varchar(50), @NextNum int, @CompanyKey int, @UserKey int, @Posted tinyint, @Balance money
Declare @NextJournalNumber int, @GLCompanyKey int, @ExcludeCashBasis int, @ExcludeAccrualBasis int, @OldDetail int, @NewDetail int, @IntercompanyAccountSource tinyint
Declare @CurrencyID varchar(10), @ExchangeRate decimal(24,7)

if exists(select 1 from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey and ReversingEntry > 0)
	return -1

select @Balance = SUM(DebitAmount) - SUM(CreditAmount)
From   tJournalEntryDetail (nolock)
Where  JournalEntryKey = @JournalEntryKey

-- If out of balance, do not reverse 
if ISNULL(@Balance, 0) <> 0
	return -2 
			
Select @CompanyKey = CompanyKey, @UserKey = EnteredBy, @GLCompanyKey = GLCompanyKey
, @JournalNumber = JournalNumber, @Posted = Posted, @ExcludeCashBasis = ExcludeCashBasis, @ExcludeAccrualBasis = ExcludeAccrualBasis, @IntercompanyAccountSource = IntercompanyAccountSource
, @CurrencyID = CurrencyID, @ExchangeRate = ExchangeRate
from tJournalEntry (nolock) Where JournalEntryKey = @JournalEntryKey

 
Select @JournalNumber = @JournalNumber + '-REV'

Begin Transaction

INSERT tJournalEntry
	(
	CompanyKey,
	EntryDate,
	PostingDate,
	EnteredBy,
	JournalNumber,
	GLCompanyKey,
	Posted,
	Description,
	AutoReverse,
	ReversingEntry,
	ExcludeCashBasis,
	ExcludeAccrualBasis,
	IntercompanyAccountSource,
	CurrencyID,
	ExchangeRate
	)

VALUES
	(
	@CompanyKey,
	@ReversingDate,
	@ReversingDate,
	@UserKey,
	@JournalNumber,
	@GLCompanyKey,
	0,
	'Reversing Entry',
	0,
	@JournalEntryKey,
	@ExcludeCashBasis,
	@ExcludeAccrualBasis,
	@IntercompanyAccountSource,
	@CurrencyID,
	@ExchangeRate
	)

DECLARE @Error int
SELECT @NewKey = @@IDENTITY, @Error = @@ERROR

IF @Error <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -1 	
END

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

Select
	@NewKey,
	GLAccountKey,
	ClassKey,
	ClientKey,
	ProjectKey,
	Memo,
	CreditAmount,
	DebitAmount,
	OfficeKey,
	DepartmentKey,
	TargetGLCompanyKey,
	ExchangeRate
From 
	tJournalEntryDetail (nolock)
Where
	JournalEntryKey = @JournalEntryKey
	
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -1 	
END

select @OldDetail = Count(*) from tJournalEntryDetail (nolock) where JournalEntryKey = @JournalEntryKey
select @NewDetail = Count(*) from tJournalEntryDetail (nolock) where JournalEntryKey = @NewKey

IF ISNULL(@OldDetail,0) <> ISNULL(@NewDetail,0)	
BEGIN
	ROLLBACK TRAN
	delete tJournalEntryDetail Where JournalEntryKey = @NewKey
	delete tJournalEntry Where JournalEntryKey = @NewKey
	RETURN -1 
END

Update tJournalEntry
Set ReversingEntry = @NewKey
Where JournalEntryKey = @JournalEntryKey

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN -1 	
END

Commit Transaction

-- call posting after transaction because we create a temp table in there
if @Posted = 1
	exec spGLPostJournalEntry @CompanyKey, @NewKey
GO
