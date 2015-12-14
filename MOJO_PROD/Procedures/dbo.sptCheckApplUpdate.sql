USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCheckApplUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCheckApplUpdate]
	@CheckApplKey int = NULL, --Required only for updates
	@CheckKey int = NULL, --Required only for inserts
	@InvoiceKey int,
	@SalesAccountKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@ClassKey int,
	@Description varchar(500),
	@Amount money,
	@Prepay tinyint = NULL,
	@SalesTaxKey int = NULL,
	@NoOverApplyCheck tinyint = NULL,
	@TargetGLCompanyKey int = NULL
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/5/07   GWG 8.5     Added Office and department
|| 10/20/07  GWG 8.5     Modified to get class from invoice if there is one
|| 12/17/07  CRG 8.5     (17571) Added validation on the SalesAccountKey
|| 02/19/10  MFT 10.518  Added insert logic
|| 03/04/10  MFT 10.519  Corrected execution of sptInvoiceUpdateAmountPaid only when @InvoiceKey is not NULL
|| 05/11/10  MFT 10.523  Removed unused @CompanyKey parameter, added checks for Client, OpenAmount and GL Company
|| 07/22/10  MFT 10.532  Added SalesTaxKey
|| 11/30/10  MFT 10.538  Removed (-5) check for "open" invoice and enhanced (-1) check for over-applied invoice, added ISNULL on @OfficeKey and @ClassKey select to allow edits
|| 12/14/10  MFT 10.358  Added required check for @SalesAccountKey
|| 12/17/10  MFT 10.358  Corrected subtraction of negative error in -1 check
|| 03/28/11  MFT 10.542  Added ISNULL test to the check for Active on @SalesAccountKey to prevent false -3 error
|| 05/31/11  MFT 10.544  Added ISNULL override to the select of @InvoiceAppliedAmount to prevent @InvoiceFinalAmount being set to NULL
|| 03/27/12  MAS 10.554  Added TargetGLCompanyKey to the tCheckAppl insert and added 
|| 04/13/12  GHL 10.555  Removed matching of tInvoice.GLCompanyKey and tCheck.GLCompanyKey
|| 05/08/12  GHL 10.556  (142796) Make TargetGLCompanyKey null if possible
|| 6/21/12   GHL 10.557  Rolled back Rob's changes. Situation $0 invoice linked to $200 + -$200 handled in flash screen
|| 09/23/13  GHL 10.572  If the client is the alternate payer, do not return an error (same logic as in sptCheckGetUnappliedInvoice)
|| 10/21/13  GHL 10.573  Make sure that the currency on the check is the same as the currency on the invoice 
*/

DECLARE @InvoiceAmount money
DECLARE @CheckAmount money
DECLARE @CreditAmount money
DECLARE @InvoiceAppliedAmount money
DECLARE @InvoiceFinalAmount money
DECLARE @AppliedAmount money
DECLARE @RequireGL tinyint
DECLARE @InvoiceDate smalldatetime
DECLARE @CheckDate smalldatetime
DECLARE @ParentCompanyKey int
DECLARE @ClientKey int
DECLARE @CompanyKey int
DECLARE @CheckGLCompanyKey int
DECLARE @MultiCurrency int
DECLARE @CheckCurrencyID varchar(10)
DECLARE @TargetCurrencyID varchar(10)

IF @InvoiceKey <= 0
	RETURN -99
IF @CheckKey IS NULL AND @CheckApplKey IS NULL
	RETURN -99

IF @CheckKey IS NULL 
	SELECT @CheckKey = CheckKey FROM tCheckAppl (nolock) WHERE CheckApplKey = @CheckApplKey

SELECT
	@ClientKey = c.ClientKey
	,@CheckGLCompanyKey = c.GLCompanyKey
	,@CheckCurrencyID = c.CurrencyID
	,@MultiCurrency = isnull(pref.MultiCurrency, 0)
FROM
	tCheck c (nolock)
	inner join tPreference pref (nolock) on c.CompanyKey = pref.CompanyKey 
WHERE
	c.CheckKey = @CheckKey

IF NOT @InvoiceKey IS NULL
	BEGIN
		SELECT
			@InvoiceAmount = InvoiceTotalAmount,
			@OfficeKey = ISNULL(@OfficeKey, OfficeKey),
			@ClassKey = ISNULL(@ClassKey, ClassKey),
			@CompanyKey = CompanyKey,
			@TargetGLCompanyKey = GLCompanyKey,
			@TargetCurrencyID = CurrencyID
		FROM tInvoice (nolock)
		WHERE InvoiceKey = @InvoiceKey
		
		if @TargetGLCompanyKey = 0
			select @TargetGLCompanyKey = null

		SELECT @InvoiceAppliedAmount = ISNULL(SUM(Amount), 0)
		FROM tCheckAppl (nolock)
		WHERE
			InvoiceKey = @InvoiceKey AND
			CheckApplKey != @CheckApplKey
		
		/*
		IF ABS(@InvoiceOpenAmount + ISNULL(@OrigAmount, 0)) < ABS(@Amount)
			RETURN -1
		*/
		
		--Make sure the Invoice is not over applied
		SELECT @InvoiceFinalAmount = @InvoiceAppliedAmount + @Amount
		IF @InvoiceAmount < 0
			BEGIN
				IF @InvoiceFinalAmount < @InvoiceAmount OR @InvoiceFinalAmount > 0 RETURN -1
				--IF @InvoiceFinalAmount < @InvoiceAmount RETURN -1
			END
		ELSE
			BEGIN
				IF @InvoiceFinalAmount > @InvoiceAmount OR @InvoiceFinalAmount < 0 RETURN -1
				--IF @InvoiceFinalAmount > @InvoiceAmount RETURN -1
			END
		
		IF @SalesAccountKey IS NULL
			SELECT @SalesAccountKey = ARAccountKey FROM tInvoice (nolock) WHERE InvoiceKey = @InvoiceKey
		
		--Make sure the Client on the Check is a valid for the invoice
		
		SELECT
			@ParentCompanyKey = cp.ParentCompanyKey
		FROM
			tCompany cp (nolock)
		WHERE
			cp.CompanyKey = @ClientKey
		
		IF NOT EXISTS
			(
				SELECT 1
				FROM tInvoice (nolock)
				WHERE
					InvoiceKey = @InvoiceKey AND
					(
						ClientKey = @ClientKey OR --Self
						ClientKey = @ParentCompanyKey OR --Parent
						ClientKey IN --Children
						(
							SELECT
								CompanyKey
							FROM
								tCompany (nolock)
							WHERE
								ParentCompanyKey = @ClientKey
						) OR
						ClientKey IN --Siblings
						(
							SELECT
								CompanyKey
							FROM
								tCompany (nolock)
							WHERE
								ParentCompanyKey = @ParentCompanyKey
						)
						OR
						AlternatePayerKey = @ClientKey --Alternate Payer
					)
			)
			RETURN -4
		
		/*
		--Make sure the Invoice is still open
		IF NOT EXISTS
			(
				SELECT 1
				FROM tInvoice (nolock)
				WHERE
					InvoiceKey = @InvoiceKey AND
					ABS(AmountReceived) < ABS(ISNULL(InvoiceTotalAmount, 0) - ISNULL(WriteoffAmount, 0) - ISNULL(DiscountAmount, 0) - ISNULL(RetainerAmount, 0))
			)
			RETURN -5
		*/
		
		/* Remove this because of ICT
		--Make sure the Check GL Company is the same as the Invoice
		IF NOT EXISTS
			(
				SELECT 1
				FROM tCheck (nolock)
				WHERE
					CheckKey = @CheckKey AND
					ISNULL(GLCompanyKey, 0) IN
					(
						SELECT ISNULL(GLCompanyKey, 0)
						FROM tInvoice (nolock)
						WHERE InvoiceKey = @InvoiceKey
					)
			)
			RETURN -6
		*/
	END --NOT @InvoiceKey IS NULL

IF @CompanyKey IS NULL
	IF @CheckKey IS NULL
		SELECT @CompanyKey = CompanyKey
		FROM tCheck c (nolock) INNER JOIN tCheckAppl ca (nolock) ON c.CheckKey = ca.CheckKey
		WHERE c.CheckKey = @CheckKey
	ELSE
		SELECT @CompanyKey = CompanyKey
		FROM tCheck c (nolock)
		WHERE c.CheckKey = @CheckKey

--If @SalesAccountKey is still null and it is required, return with an error
IF @SalesAccountKey IS NULL AND EXISTS
	(
		SELECT *
		FROM tPreference (nolock)
		WHERE
			CompanyKey = @CompanyKey AND
			RequireGLAccounts = 1
	)
	RETURN -3

--Make sure the @SalesAccountKey is still active
IF ISNULL(@SalesAccountKey, 0) > 0 AND NOT EXISTS
		(SELECT NULL
		FROM	tGLAccount (nolock)
		WHERE	GLAccountKey = @SalesAccountKey
		AND		Active = 1)
	RETURN -3

-- Check to make sure the check is not overapplied
IF ISNULL(@NoOverApplyCheck,0) = 0
	BEGIN
		SELECT @AppliedAmount = SUM(Amount) FROM tCheckAppl (nolock) WHERE CheckKey = @CheckKey AND CheckApplKey <> ISNULL(@CheckApplKey, 0)
		SELECT @CheckAmount = CheckAmount FROM tCheck (nolock) WHERE CheckKey = @CheckKey
		
		IF ISNULL(@CheckAmount, 0) > 0
			BEGIN
				IF ISNULL(@CheckAmount, 0) < ISNULL(@AppliedAmount, 0) + ISNULL(@Amount, 0)
					RETURN -2
			END
		ELSE
			BEGIN
				IF ISNULL(@CheckAmount, 0) > ISNULL(@AppliedAmount, 0) + ISNULL(@Amount, 0)
					RETURN -2
			END
	END

-- correct the TargetGLCompanyKey (make it null if same)
if isnull(@CheckGLCompanyKey, 0) = isnull(@TargetGLCompanyKey, 0)
	select @TargetGLCompanyKey = null

if @MultiCurrency = 1 And isnull(@InvoiceKey, 0) > 0 And isnull(@CheckCurrencyID, '') <> isnull(@TargetCurrencyID, '')
	return -7
	  
BEGIN TRANSACTION
	IF @CheckApplKey IS NULL
		BEGIN
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
					SalesTaxKey,
					TargetGLCompanyKey
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
					@SalesTaxKey,
					@TargetGLCompanyKey
				)
			
			IF @@ERROR <> 0 
				BEGIN
					ROLLBACK TRANSACTION 
					RETURN -99
				END
			
			SET @CheckApplKey = SCOPE_IDENTITY()
		END
	ELSE
		UPDATE
			tCheckAppl
		SET
			InvoiceKey = @InvoiceKey,
			SalesAccountKey = @SalesAccountKey,
			OfficeKey = @OfficeKey,
			DepartmentKey = @DepartmentKey,
			ClassKey = @ClassKey,
			Description = @Description,	
			Amount = @Amount,
			SalesTaxKey = @SalesTaxKey,
			TargetGLCompanyKey = @TargetGLCompanyKey
		WHERE
			CheckApplKey = @CheckApplKey
	
	IF NOT @InvoiceKey IS NULL
		EXEC sptInvoiceUpdateAmountPaid @InvoiceKey

	IF @@ERROR <> 0 
	BEGIN
		ROLLBACK TRANSACTION 
		RETURN -99
	END
	
COMMIT TRANSACTION

RETURN @CheckApplKey
GO
