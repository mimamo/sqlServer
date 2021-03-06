USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryInsert]
	@CompanyKey int,
	@EntryDate smalldatetime,
	@PostingDate smalldatetime,
	@EnteredBy int,
	@JournalNumber varchar(50),
	@Description varchar(1000),
	@AutoReverse tinyint,
	@GLCompanyKey int,
	@ExcludeCashBasis tinyint,
	@ExcludeAccrualBasis tinyint,
	@IntercompanyAccountSource tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

  /*
  || When     Who Rel         What
  || 05/01/07 BSH 8.4.2.1     Issue 9082
  || 10/16/07 BSH 8.5         (9659)Insert GLCompanyKey
  || 02/26/09 GHL 10.019      Added @ExcludeCashBasis
  || 05/04/09 GHL 10.024      Added @ExcludeAccrualBasis
  || 03/30/12 MFT 10.554      Added IntercompanyAccountSource
  */

Declare @NextJournalNumber int

if exists(Select 1 from tJournalEntry (nolock) Where JournalNumber = @JournalNumber and CompanyKey = @CompanyKey)
	return -1
	
	
if ISNUMERIC(@JournalNumber) = 1 and CHARINDEX('.', @JournalNumber) = 0
BEGIN
	Select @NextJournalNumber = Cast(@JournalNumber as int) + 1
	Update tPreference
	Set NextJournalNumber = @NextJournalNumber
	Where CompanyKey = @CompanyKey
END


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
		IntercompanyAccountSource
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
		@IntercompanyAccountSource
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
