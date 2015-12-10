USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportVoucher]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportVoucher]

	(
		@CompanyKey int,
		@UserKey int,
		@VendorID varchar(100),
		@InvoiceNumber varchar(100),
		@InvoiceDate smalldatetime,
		@DateReceived smalldatetime,
		@APAccountNumber varchar(100),
		@ClassID varchar(50),
		@OfficeID varchar(50),
		@GLCompanyID varchar(50),
		@TermsPercent int,
		@TermsDays int,
		@TermsNet int,
		@DueDate smalldatetime,
		@Description varchar(500),
		@ApprovedBy varchar(100),
		@SalesTaxID varchar(100),
		@SalesTax2ID varchar(100),
		@OpeningTransaction tinyint = 0
	)

AS --Encrypt

/*
|| When     Who Rel   What
|| 06/18/08 GHL 8.513 Added OpeningTransaction
|| 12/18/09 RLB 10.515 Added GLCompanyKey
|| 04/08/11 RLB 10.543 (108265) Added OfficeKey
|| 02/07/13 GHL 10.565 (167854) Added VoucherID for a customization for Spark44
|| 01/03/14 WDF 10.576 (188500) Added DateCreated to Insert tVoucher
*/

Declare @VendorKey int, @APAccountKey int, @HClassKey int, @ExpenseAccountKey int, @DClassKey int, @ApprovedByKey int, @Retval int, @NewVoucherKey int, @GLCompanyKey int, @HOfficeKey int

Select @VendorKey = CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey and VendorID = @VendorID
if @VendorKey is null
	Return -1
If exists(Select 1 from tVoucher (nolock) Where VendorKey = @VendorKey and InvoiceNumber = @InvoiceNumber)
	Return -2
if not @APAccountNumber is null
BEGIN
	Select @APAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey and AccountNumber = @APAccountNumber
	if @APAccountKey is null
		Return -3
END
if not @ClassID is null
BEGIN
	Select @HClassKey = ClassKey from tClass (nolock) Where CompanyKey = @CompanyKey and ClassID = @ClassID
	if @HClassKey is null
		return -4
END

if @HClassKey is null and (select ISNULL(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -4

 if not @OfficeID is null
BEGIN
	Select @HOfficeKey = OfficeKey from tOffice (nolock) Where CompanyKey = @CompanyKey and OfficeID = @OfficeID
	if @HClassKey is null
		return -9
END

if @HOfficeKey is null and (select ISNULL(RequireOffice, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		return -9

IF @GLCompanyID IS NOT NULL
BEGIN
	SELECT @GLCompanyKey = GLCompanyKey FROM tGLCompany (nolock) WHERE GLCompanyID = @GLCompanyID AND CompanyKey = @CompanyKey
	IF @GLCompanyKey IS NULL
		RETURN -8
END
		
	IF @GLCompanyKey is null and (select isnull(RequireGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		Return - 8
 
if not @ApprovedBy is null
BEGIN
	Select @ApprovedByKey = UserKey from tUser (nolock) Where CompanyKey = @CompanyKey and (UserID = @ApprovedBy or SystemID = @ApprovedBy)
	if @ApprovedByKey is null
		Return -5
END

DECLARE @SalesTaxKey int
if @SalesTaxID is not null
	begin
		SELECT	@SalesTaxKey = SalesTaxKey
		FROM	tSalesTax (nolock)
		WHERE	SalesTaxID = @SalesTaxID
		AND		CompanyKey = @CompanyKey
		if @SalesTaxKey is null
			Return -6
	end 

DECLARE @SalesTax2Key int
if @SalesTax2ID is not null
	begin
		SELECT	@SalesTax2Key = SalesTaxKey
		FROM	tSalesTax (nolock)
		WHERE	SalesTaxID = @SalesTax2ID
		AND		CompanyKey = @CompanyKey
		if @SalesTax2Key is null
			Return -7
	end 
	
Declare @VoucherID int
Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 
from tVoucher (nolock) Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 0

Select @DateReceived = ISNULL(@DateReceived, @InvoiceDate)
, @TermsPercent = ISNULL(@TermsPercent, 0)
, @TermsDays = ISNULL(@TermsDays, 0)
, @TermsNet = ISNULL(@TermsNet, 0)
, @DueDate = ISNULL(@DueDate, DateAdd(dd, @TermsNet, @InvoiceDate))
, @ApprovedByKey = ISNULL(@ApprovedByKey, @UserKey)

	INSERT tVoucher
		(
		CompanyKey,
		VendorKey,
		InvoiceDate,
		PostingDate,
		InvoiceNumber,
		DateReceived,
		DateCreated,
		CreatedByKey,
		TermsPercent,
		TermsDays,
		TermsNet,
		DueDate,
		Description,
		ApprovedByKey,
		APAccountKey,
		Status,
		ClassKey,
		OfficeKey,
		GLCompanyKey,
		SalesTaxKey,
		SalesTax2Key,
		OpeningTransaction,
		VoucherID		
		)

	VALUES
		(
		@CompanyKey,
		@VendorKey,
		@InvoiceDate,
		@InvoiceDate,
		@InvoiceNumber,
		@DateReceived,
		GETDATE(),
		@UserKey,
		@TermsPercent,
		@TermsDays,
		@TermsNet,
		@DueDate,
		@Description,
		@ApprovedByKey,
		@APAccountKey,
		4,
		@HClassKey,
		@HOfficeKey,
		@GLCompanyKey,
		@SalesTaxKey,
		@SalesTax2Key,
		@OpeningTransaction,
		@VoucherID		
		)
	
	Return @@IDENTITY
GO
