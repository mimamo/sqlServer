USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportCheckAppl]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportCheckAppl]
	@CompanyKey int,
	@CheckKey int,
	@InvoiceNumber varchar(35),
	@SalesAccountNumber varchar(35),
	@ClassID varchar(50),
	@Description varchar(500),
	@Amount money
AS --Encrypt

Declare @CheckAmount money,
		@ClientKey int,
		@InvoiceAmount money,
		@InvoiceOpenAmount money,
		@AppliedAmount money,
		@RequireGL tinyint,
		@InvoiceDate smalldatetime,
		@CheckDate smalldatetime,
		@InvoiceKey int,
		@SalesAccountKey int,
		@ClassKey int
		

if @InvoiceNumber is not null
BEGIN
	Select @ClientKey = ClientKey from tCheck (nolock) Where CheckKey = @CheckKey
	
	SELECT	@InvoiceKey = InvoiceKey
	FROM	tInvoice (nolock)
	WHERE	InvoiceNumber = @InvoiceNumber
	AND		CompanyKey = @CompanyKey
	AND		ClientKey = @ClientKey
	
	if @InvoiceKey is null
		Return -1

	Select @SalesAccountKey = ARAccountKey from tInvoice (nolock)
	Inner join tGLAccount gl (nolock) on tInvoice.ARAccountKey = gl.GLAccountKey
	Where InvoiceKey = @InvoiceKey
	
	if @SalesAccountKey is null
	BEGIN
		if @SalesAccountNumber is not null
		BEGIN
			SELECT	@SalesAccountKey = GLAccountKey
			FROM	tGLAccount (nolock)
			WHERE	AccountNumber = @SalesAccountNumber
			AND		CompanyKey = @CompanyKey
			AND		Rollup = 0	
			
			if @SalesAccountKey is null
				Return -2
		END
		ELSE
		BEGIN
			Select @SalesAccountKey = 0
		END
	END
			
		
END
ELSE
BEGIN
	if @SalesAccountNumber is not null
	BEGIN
		SELECT	@SalesAccountKey = GLAccountKey
		FROM	tGLAccount (nolock)
		WHERE	AccountNumber = @SalesAccountNumber
		AND		CompanyKey = @CompanyKey
		AND		Rollup = 0	
		
		if @SalesAccountKey is null
			Return -2
	END
	ELSE
	BEGIN
		Select @SalesAccountKey = 0
	END	
END

if @SalesAccountKey is null
	Select @SalesAccountKey = 0
	
if @ClassID is not null
BEGIN
	SELECT	@ClassKey = ClassKey
	FROM	tClass (nolock)
	WHERE	ClassID = @ClassID
	AND		CompanyKey = @CompanyKey
	
	if @ClassKey is null
		Return -3
END

if @ClassKey is null and (select isnull(RequireClasses, 0) from tPreference (nolock) where CompanyKey = @CompanyKey) = 1
		Return -3


-- Make sure the amount is not overapplied to the invoice

if NOT @InvoiceKey IS NULL
BEGIN
	Select @AppliedAmount = Sum(Amount) from tCheckAppl (nolock) Where InvoiceKey = @InvoiceKey

	Select @InvoiceDate = InvoiceDate, @InvoiceAmount = ISNULL(InvoiceTotalAmount, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0)
	From tInvoice (nolock)
	Where InvoiceKey = @InvoiceKey
	
	Select @CheckDate = CheckDate from tCheck (nolock) Where CheckKey = @CheckKey

	Select @InvoiceOpenAmount = ISNULL(@InvoiceAmount, 0) - ISNULL(@AppliedAmount, 0)

	If @InvoiceOpenAmount < @Amount
		return -4
		
END

-- Make sure the applied amount is not more than the check
Select @AppliedAmount = Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey
Select @CheckAmount = CheckAmount from tCheck (nolock) Where CheckKey = @CheckKey

IF @CheckAmount > 0
BEGIN
	If ISNULL(@CheckAmount, 0) < ISNULL(@AppliedAmount, 0) + ISNULL(@Amount, 0)
		return -5
END
ELSE
BEGIN
	If ISNULL(@CheckAmount, 0) > ISNULL(@AppliedAmount, 0) + ISNULL(@Amount, 0)
		return -5
END
		

	INSERT tCheckAppl
		(
		CheckKey,
		InvoiceKey,
		SalesAccountKey,
		ClassKey,
		Description,
		Amount,
		Prepay
		)
	VALUES
		(
		@CheckKey,
		@InvoiceKey,
		@SalesAccountKey,
		@ClassKey,
		@Description,
		@Amount,
		0
		)

	exec sptInvoiceUpdateAmountPaid @InvoiceKey

RETURN 1
GO
