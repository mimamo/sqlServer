USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportJournalEntryDetail]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportJournalEntryDetail]
	@CompanyKey int,
	@JournalEntryKey int,
	@GLAccountNumber varchar(100),
	@ClassID varchar(50),	
	@Memo varchar(500),
	@DebitAmount money,
	@CreditAmount money,
	@CustomerID varchar(50),
	@ProjectNumber varchar(50),
	@OfficeID varchar(50),
	@DepartmentName varchar(200) 
AS --Encrypt

/*
|| When     Who Rel      What
|| 09/20/06 CRG 8.35     Modified to round the DebitAmount and CreditAmount to 2 decimal places.
|| 7/16/08  CRG 10.0.0.5 (30400) Added CustomerID, ProjectNumber, OfficeID, DepartmentName
||                    
*/

Declare @GLAccountKey int, 
		@ClassKey int,
		@ClientKey int,
		@ProjectKey int,
		@OfficeKey int,
		@DepartmentKey int

Select @GLAccountKey = GLAccountKey from tGLAccount (nolock) Where AccountNumber = @GLAccountNumber and CompanyKey = @CompanyKey and Rollup = 0
if @GLAccountKey is null
	return -1
	
if @ClassID is not null
begin
	Select @ClassKey = ClassKey from tClass (nolock) Where ClassID = @ClassID and CompanyKey = @CompanyKey
	if @ClassKey is null
		return -2
end

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -2

IF @CustomerID IS NOT NULL
BEGIN
	SELECT @ClientKey = CompanyKey FROM tCompany (nolock) WHERE CustomerID = @CustomerID AND OwnerCompanyKey = @CompanyKey
	IF @ClientKey IS NULL
		RETURN -3
END

IF @ProjectNumber IS NOT NULL
BEGIN
	SELECT @ProjectKey = ProjectKey FROM tProject (nolock) WHERE ProjectNumber = @ProjectNumber AND CompanyKey = @CompanyKey
	IF @ProjectKey IS NULL
		RETURN -4
END

IF @OfficeID IS NOT NULL
BEGIN
	SELECT @OfficeKey = OfficeKey FROM tOffice (nolock) WHERE OfficeID = @OfficeID AND CompanyKey = @CompanyKey
	IF @OfficeKey IS NULL
		RETURN -5
END

IF @DepartmentName IS NOT NULL
BEGIN
	SELECT @DepartmentKey = DepartmentKey FROM tDepartment (nolock) WHERE DepartmentName = @DepartmentName AND CompanyKey = @CompanyKey
	IF @DepartmentKey IS NULL
		RETURN -6
END

if isnull(@DebitAmount, 0) <> 0
	select @DebitAmount = round(@DebitAmount, 2)

if isnull(@CreditAmount, 0) <> 0
	select @CreditAmount = round(@CreditAmount, 2)

	INSERT tJournalEntryDetail
		(
		JournalEntryKey,
		GLAccountKey,
		ClassKey,
		Memo,
		DebitAmount,
		CreditAmount,
		ClientKey,
		ProjectKey,
		OfficeKey,
		DepartmentKey
		)

	VALUES
		(
		@JournalEntryKey,
		@GLAccountKey,
		@ClassKey,
		@Memo,
		@DebitAmount,
		@CreditAmount,
		@ClientKey,
		@ProjectKey,
		@OfficeKey,
		@DepartmentKey
		)
	

	RETURN 1
GO
