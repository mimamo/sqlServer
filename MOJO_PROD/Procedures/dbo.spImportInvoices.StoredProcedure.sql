USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportInvoices]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportInvoices]
	@CompanyKey int,
	@CustomerID varchar(50),
	@ContactName varchar(100),
	@AdvanceBill tinyint,
	@InvoiceNumber varchar(35),
	@InvoiceDate smalldatetime,
	@DueDate smalldatetime,
	@TermsDescription varchar(100),
	@ARAccountNumber varchar(100),
	@ClassID varchar(50),
	@OfficeID varchar(50),
	@GLCompanyID varchar(50),
	@RetainerAmount money,
	@WriteoffAmount money,
	@HeaderComment varchar(500),
	@SalesTaxID varchar(100),
	@ApprovedDate smalldatetime,
	@ApprovedByUserID varchar(100),
	@ApprovalComments varchar(500),
	@UserDefined1 varchar(250),
	@UserDefined2 varchar(250),
	@UserDefined3 varchar(250),
	@UserDefined4 varchar(250),
	@UserDefined5 varchar(250),
	@UserDefined6 varchar(250),
	@UserDefined7 varchar(250),
	@UserDefined8 varchar(250),
	@UserDefined9 varchar(250),
	@UserDefined10 varchar(250),
	@UserKey int,
	@TemplateName varchar(200),
	@OpeningTransaction tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 7/6/07    CRG 8.4.3.2 (9654) Added Invoice Template.
|| 06/18/08  GHL 8.513   Added OpeningTransaction
|| 12/18/09	 RLB 10.515  Added GLCompany
|| 04/08/11  RLB 10.543  (108265) Added Office
*/

	DECLARE	@ClientKey int,
			@TermsKey int,
			@ARAccountKey int,
			@ClassKey int,
			@OfficeKey int,
			@SalesTaxKey int,
			@ApprovedByKey int,
			@InvoiceTemplateKey int,
			@GLCompanyKey int	

	SELECT	@ClientKey = CompanyKey
	FROM	tCompany (nolock)
	WHERE	CustomerID = @CustomerID
	AND		OwnerCompanyKey = @CompanyKey
	
	IF @ClientKey IS NULL
		RETURN -1
		
	IF EXISTS(
			SELECT *
			FROM tInvoice (nolock)
			WHERE CompanyKey = @CompanyKey 
			AND	InvoiceNumber = @InvoiceNumber)
	BEGIN
		SELECT @oIdentity = 0
		RETURN -2
	END

	
	if @TermsDescription is not null
	begin
		SELECT	@TermsKey = PaymentTermsKey
		FROM	tPaymentTerms (nolock)
		WHERE	TermsDescription = @TermsDescription
		AND		CompanyKey = @CompanyKey
		if @TermsKey is null
			Return -3
	end 
	if @ARAccountNumber is not null
	begin
		SELECT	@ARAccountKey = GLAccountKey
		FROM	tGLAccount (nolock)
		WHERE	AccountNumber = @ARAccountNumber
		AND		CompanyKey = @CompanyKey
		AND		AccountType = 11
		if @ARAccountKey is null
			Return -4
	end 
	if @ClassID is not null
	begin
		SELECT	@ClassKey = ClassKey
		FROM	tClass (nolock)
		WHERE	ClassID = @ClassID
		AND		CompanyKey = @CompanyKey
		if @ClassKey is null
			Return -5
	end 
	if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
			Return -5

	if @OfficeID is not null
	begin
		SELECT	@OfficeKey = OfficeKey
		FROM	tOffice (nolock)
		WHERE	OfficeID = @OfficeID
		AND		CompanyKey = @CompanyKey
		if @OfficeKey is null
			Return -10
	end 
	if @OfficeKey is null and (select isnull(RequireOffice, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
			Return -10
			
	IF @GLCompanyID IS NOT NULL
	BEGIN
		SELECT @GLCompanyKey = GLCompanyKey FROM tGLCompany (nolock) WHERE GLCompanyID = @GLCompanyID AND CompanyKey = @CompanyKey
		IF @GLCompanyKey IS NULL
			RETURN -9
	END
	
	IF @GLCompanyKey is null and (select isnull(RequireGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
			Return - 9
	 
	if @SalesTaxID is not null
	begin
		SELECT	@SalesTaxKey = SalesTaxKey
		FROM	tSalesTax (nolock)
		WHERE	SalesTaxID = @SalesTaxID
		AND		CompanyKey = @CompanyKey
		if @SalesTaxKey is null
			Return -6
	end 
	if @ApprovedByUserID is not null
	begin
		SELECT	@ApprovedByKey = UserKey
		FROM	tUser (nolock)
		WHERE	UserID = @ApprovedByUserID
		AND		CompanyKey = @CompanyKey
		if @ApprovedByKey is null
			Return -7
	end 
	
	IF @TemplateName IS NOT NULL
	BEGIN
		SELECT	@InvoiceTemplateKey = InvoiceTemplateKey
		FROM	tInvoiceTemplate (nolock)
		WHERE	TemplateName = @TemplateName
		AND		CompanyKey = @CompanyKey
		
		IF @InvoiceTemplateKey IS NULL
			RETURN -8
	END
			
	IF @ApprovedDate IS NULL
		SELECT	@ApprovedDate = GETDATE()
		
	INSERT tInvoice
	(
		CompanyKey,
		ClientKey,
		ContactName,
		AdvanceBill,
		InvoiceNumber,
		InvoiceDate,
		PostingDate,
		DueDate,
		TermsKey,
		ARAccountKey,
		ClassKey,
		OfficeKey,
		GLCompanyKey,
		RetainerAmount,
		WriteoffAmount,
		HeaderComment,
		SalesTaxKey,
		InvoiceStatus,
		ApprovedDate,
		ApprovedByKey,
		ApprovalComments,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		InvoiceTemplateKey,
		OpeningTransaction
	)
	VALUES
	(
		@CompanyKey,
		@ClientKey,
		@ContactName,
		@AdvanceBill,
		@InvoiceNumber,
		@InvoiceDate,
		@InvoiceDate,
		@DueDate,
		@TermsKey,
		@ARAccountKey,
		@ClassKey,
		@OfficeKey,
		@GLCompanyKey,
		@RetainerAmount,
		@WriteoffAmount,
		@HeaderComment,
		@SalesTaxKey,
		4,
		@ApprovedDate,
		@ApprovedByKey,
		@ApprovalComments,
		@UserDefined1,
		@UserDefined2,
		@UserDefined3,
		@UserDefined4,
		@UserDefined5,
		@UserDefined6,
		@UserDefined7,
		@UserDefined8,
		@UserDefined9,
		@UserDefined10,
		@InvoiceTemplateKey,
		@OpeningTransaction
	)
	 
	SELECT @oIdentity = @@IDENTITY
	RETURN 1
GO
