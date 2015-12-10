USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportJournalEntry]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportJournalEntry]
	@CompanyKey int,
	@EntryDate smalldatetime,
	@PostingDate smalldatetime,
	@EnteredBy int,
	@JournalNumber varchar(50),
	@GLCompanyID varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 7/16/08   CRG 10.0.0.5 (30400) Added GLCompanyID
*/

Declare @NextJournalNumber int,
		@GLCompanyKey int

if exists(Select 1 from tJournalEntry (nolock) Where JournalNumber = @JournalNumber and CompanyKey = @CompanyKey)
	return -1

IF @GLCompanyID IS NOT NULL
BEGIN
	SELECT @GLCompanyKey = GLCompanyKey FROM tGLCompany (nolock) WHERE GLCompanyID = @GLCompanyID AND CompanyKey = @CompanyKey
	IF @GLCompanyKey IS NULL
		RETURN -2
END

if @JournalNumber is null
	Select @JournalNumber = NextJournalNumber from tPreference (nolock) Where CompanyKey = @CompanyKey
	
if ISNUMERIC(@JournalNumber) = 1
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
		GLCompanyKey
		)

	VALUES
		(
		@CompanyKey,
		@EntryDate,
		@PostingDate,
		@EnteredBy,
		@JournalNumber,
		0,
		@GLCompanyKey
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
