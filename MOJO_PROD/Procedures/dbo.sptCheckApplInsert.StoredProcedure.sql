USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckApplInsert]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckApplInsert]
 @CompanyKey int,
 @CheckKey int,
 @InvoiceKey int,
 @SalesAccountKey int,
 @OfficeKey int, 
 @DepartmentKey int,
 @ClassKey int,
 @Description varchar(500),
 @Amount money,
 @Prepay tinyint,
 @SalesTaxKey int = NULL,
 @NoOverApplyCheck tinyint,
 @oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/5/07   GWG 8.5     Added Office and department
|| 10/20/07  GWG 8.5     Modified to get class from invoice if there is one
|| 12/17/07  CRG 8.5     (17571) Added validation on the SalesAccountKey
|| 12/18/07  GWG 8.5	   Removed sales account validation logic to allow no sales account
|| 07/22/10  MFT 10.532  Added SalesTaxKey
|| 6/21/12   GHL 10.557  Rolled back Rob's changes. Situation $0 invoice linked to $200 + -$200 handled in flash screen
*/

Declare @CheckAmount money
Declare @CreditAmount money
Declare @InvoiceAmount money
Declare @InvoiceOpenAmount money
Declare @AppliedAmount money
Declare @RequireGL tinyint
Declare @InvoiceDate smalldatetime, @CheckDate smalldatetime

if @InvoiceKey = 0
	return -99

-- Make sure the amount is not overapplied to the invoice

if NOT @InvoiceKey IS NULL
BEGIN

	Select @InvoiceOpenAmount = ISNULL(InvoiceTotalAmount, 0) - isnull(AmountReceived, 0) - isnull(WriteoffAmount, 0) - isnull(DiscountAmount, 0) - isnull(RetainerAmount, 0), @OfficeKey = OfficeKey, @ClassKey = ClassKey
	From tInvoice (nolock)
	Where InvoiceKey = @InvoiceKey
	
	If ABS(@InvoiceOpenAmount) < ABS(@Amount)
	--If @InvoiceOpenAmount - @Amount < 0
		return -1
		
	if @SalesAccountKey is null
		Select @SalesAccountKey = ARAccountKey from tInvoice (nolock) Where InvoiceKey = @InvoiceKey
	
END

--If @SalesAccountKey is still null, return with an error
/*
IF @SalesAccountKey IS NULL
	RETURN -3

--Make sure the @SalesAccountKey is still active
IF NOT EXISTS
		(SELECT NULL
		FROM	tGLAccount (nolock)
		WHERE	GLAccountKey = @SalesAccountKey
		AND		Active = 1)
	RETURN -3
*/

-- Make sure the applied amount is not more than the check
if isnull(@NoOverApplyCheck,0) = 0
begin
	Select @AppliedAmount = Sum(Amount) from tCheckAppl (nolock) Where CheckKey = @CheckKey
	Select @CheckAmount = CheckAmount from tCheck (nolock) Where CheckKey = @CheckKey

	IF @CheckAmount > 0
	BEGIN
		If ISNULL(@CheckAmount, 0) < ISNULL(@AppliedAmount, 0) + ISNULL(@Amount, 0)
			return -2
	END
	ELSE
	BEGIN
		If ISNULL(@CheckAmount, 0) > ISNULL(@AppliedAmount, 0) + ISNULL(@Amount, 0)
			return -2
	END
end
		
--Declare @GLAccountKey int

--Select @GLAccountKey = ISNULL(i.ARAccountKey, 0) from tInvoice i (nolock)
--Where i.InvoiceKey = @InvoiceKey

		
BEGIN TRANSACTION

	INSERT tCheckAppl
		(
		CheckKey,
		InvoiceKey,
		SalesAccountKey,
		OfficeKey,
		DepartmentKey,
		ClassKey,
		Description,
		Amount,
		Prepay,
		SalesTaxKey
		)
	VALUES
		(
		@CheckKey,
		@InvoiceKey,
		ISNULL(@SalesAccountKey, 0),
		@OfficeKey,
		@DepartmentKey,
		@ClassKey,
		@Description,
		@Amount,
		@Prepay,
		@SalesTaxKey
		)

	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end

	SELECT @oIdentity = @@IDENTITY
	
	exec sptInvoiceUpdateAmountPaid @InvoiceKey
	
	if @@ERROR <> 0 
	begin
		rollback transaction 
		return -99
	end



Commit Transaction

RETURN 1
GO
