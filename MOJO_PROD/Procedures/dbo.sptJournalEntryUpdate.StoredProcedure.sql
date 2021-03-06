USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryUpdate]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryUpdate]
	@CompanyKey int,
	@JournalEntryKey int,
	@PostingDate smalldatetime,
	@JournalNumber varchar(50),
	@Description varchar(1000),
	@AutoReverse tinyint,
	@GLCompanyKey int,
	@ExcludeCashBasis tinyint,
	@ExcludeAccrualBasis tinyint,
	@EntryDate smalldatetime = NULL,
	@EnteredBy int = 0,
	@GLAccountRecKey int = NULL,
	@IntercompanyAccountSource tinyint,
	@PostedByKey int = null,
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24, 7) = 1
AS --Encrypt

  /*
  || When     Who Rel         What
  || 10/16/07 BSH 8.5         (9659)Update GLCompanyKey
  || 02/26/09 GHL 10.019      Added @ExcludeCashBasis
  || 05/04/09 GHL 10.024      Added @ExcludeAccrualBasis
  || 10/15/09 MFT 10.511      Added insert logic, added @EntryDate and @EnteredBy parameters
  || 10/20/09 MFT 10.513      Defaulted @EntryDate to GETDATE()
  || 12/28/10 MFT 10.539      Added GLAccountRecKey
  || 03/30/12 MFT 10.554      Added IntercompanyAccountSource
  || 09/21/12 RLB 10.560      Added CreatedDate and PostedByKey for HMI enhancements
  || 01/08/14 GHL 10.576      Added currency parameters
  */
  
IF EXISTS(SELECT 1 FROM tJournalEntry (nolock) WHERE JournalNumber = @JournalNumber and CompanyKey = @CompanyKey and JournalEntryKey <> @JournalEntryKey)
	RETURN -1
	
if isnull(@ExchangeRate, 0) <= 0
	select @ExchangeRate = 1

IF @JournalEntryKey > 0
	BEGIN
		DECLARE @CurReverse int, @CurAuto tinyint
		
		SELECT @CurReverse = ISNULL(ReversingEntry, 0), @CurAuto = ISNULL(AutoReverse, 0) FROM tJournalEntry (nolock) WHERE JournalEntryKey = @JournalEntryKey 
		
		IF @AutoReverse = 0 AND @CurAuto = 1 and @CurReverse > 0
			RETURN -2
		
		UPDATE
			tJournalEntry
		SET
			PostingDate = @PostingDate,
			JournalNumber = @JournalNumber,
			Description = @Description,
			AutoReverse = @AutoReverse,
			GLCompanyKey = @GLCompanyKey,
			ExcludeCashBasis = @ExcludeCashBasis,
			ExcludeAccrualBasis = @ExcludeAccrualBasis,
			GLAccountRecKey = @GLAccountRecKey,
			IntercompanyAccountSource = @IntercompanyAccountSource,
			PostedByKey = @PostedByKey,
			CurrencyID = @CurrencyID,
			ExchangeRate = @ExchangeRate
		WHERE
			JournalEntryKey = @JournalEntryKey 
		
		RETURN @JournalEntryKey
	END
ELSE
	BEGIN
		DECLARE @NextJournalNumber int
		
		IF ISNUMERIC(@JournalNumber) = 1 AND CHARINDEX('.', @JournalNumber) = 0
		BEGIN
			SELECT @NextJournalNumber = CAST(@JournalNumber AS int) + 1
			
			UPDATE tPreference
			SET    NextJournalNumber = @NextJournalNumber
			WHERE  CompanyKey = @CompanyKey
		END
		
		IF @EntryDate IS NULL SET @EntryDate = GETDATE()
		
		INSERT tJournalEntry
		(
			CompanyKey,
			EntryDate,
			PostingDate,
			EnteredBy,
			JournalNumber,
			Posted,
			Description,
			AutoReverse,
			GLCompanyKey,
			ExcludeCashBasis,
			ExcludeAccrualBasis,
			GLAccountRecKey,
			IntercompanyAccountSource,
			CreatedDate,
			CurrencyID,
			ExchangeRate
		)

		VALUES
		(
			@CompanyKey,
			@EntryDate,
			@PostingDate,
			@EnteredBy,
			@JournalNumber,
			0,
			@Description,
			@AutoReverse,
			@GLCompanyKey,
			@ExcludeCashBasis,
			@ExcludeAccrualBasis,
			@GLAccountRecKey,
			@IntercompanyAccountSource,
			GETUTCDATE(),
			@CurrencyID,
			@ExchangeRate
		)
		
		RETURN SCOPE_IDENTITY()
	END
GO
