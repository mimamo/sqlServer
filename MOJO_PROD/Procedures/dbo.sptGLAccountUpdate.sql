USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountUpdate]
	@GLAccountKey int = 0,
	@CompanyKey int,
	@AccountNumber varchar(100),
	@AccountName varchar(200),
	@ParentAccountKey int,
	@AccountType smallint,
	@AccountTypeCash smallint,
	@PayrollExpense smallint,
	@FacilityExpense smallint,
	@LaborIncome smallint,
	@Rollup tinyint,
	@Description varchar(500),
	@BankAccountNumber varchar(50),
	@NextCheckNumber bigint,
	@Active tinyint,
	@FIName varchar(100) = NULL,
	@FIID varchar(50) = NULL,
	@FIOrg varchar(50) = NULL,
	@FIUrl varchar(100) = NULL,
	@CreditCardNumber varchar(100) = NULL,
	@CreditCardLogin varchar(1000) = NULL,
	@CreditCardPassword varchar(1000) = NULL,
	@VendorKey int = NULL,
	@ManualCCNumber varchar(100) = NULL,
	@ManualCCExpMonth tinyint = NULL,
	@ManualCCExpYear smallint = NULL,
	@ManualCCV varchar(50) = NULL,
	@CCDeliveryOption smallint = NULL

AS --Encrypt

/*
|| When     Who Rel			What
|| 11/2/06  CRG 8.35		Converted NextCheckNumber to bigint
|| 06/01/08 GWG 8.512		Took out the restrictions on GL Account Type changing.
|| 06/10/09 GHL 10.027		Added AccountTypeCash param to support cash basis posting/reports
|| 08/13/09 MFT 10.507		Added insert logic
|| 06/09/11 GHL 10.545		Fixed problems with identity
|| 01/30/12 MAS 10.5.5.3	Added Credit card fields
|| 04/11/12 MAS 10.5.5.4	Changed the CC fields.  Removed FIKey and added specific FIName, FIOrg, etc..
|| 04/19/12 MAS 10.5.5.4  Don't update the CreditCardNumber if it hasn't been updated (still masked)
|| 11/27/12 RLB 10.5.6.2  (160767) added to CC Login and Password length
|| 08/12/13 MFT 10.5.7.1  Added VendorKey to support import of Credit Card accounts
|| 10/06/14 CRG 10.5.8.5  Added the Manual CC fields
*/

-- In DB should be NULL indicating no override when the account types are the same
IF ISNULL(@AccountTypeCash, 0) = ISNULL(@AccountType, 0)  
	SELECT @AccountTypeCash = NULL

DECLARE @CurrentType smallint
DECLARE @CurrentRollup tinyint
DECLARE @ParentAccountType smallint

IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE AccountNumber = @AccountNumber AND CompanyKey = @CompanyKey AND GLAccountKey <> @GLAccountKey )
	RETURN -1

IF @AccountType = 32
	IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE AccountType = 32 AND CompanyKey = @CompanyKey AND GLAccountKey <> @GLAccountKey)
		RETURN -2

IF @ParentAccountKey IS NOT NULL
	BEGIN
		SELECT @ParentAccountType = AccountType
		FROM tGLAccount (nolock)
		WHERE GLAccountKey = @ParentAccountKey

		IF @ParentAccountType <> @AccountType
			RETURN -12
	END

IF @GLAccountKey <= 0
	BEGIN
		INSERT tGLAccount
			(
				CompanyKey,
				AccountNumber,
				AccountName,
				ParentAccountKey,
				AccountType,
				AccountTypeCash,
				PayrollExpense,
				FacilityExpense,
				LaborIncome,
				Rollup,
				Description,
				BankAccountNumber,
				NextCheckNumber,
				Active,
				FIName,
				FIID,
				FIOrg,
				FIUrl,
				CreditCardNumber,
				CreditCardLogin,
				CreditCardPassword,
				VendorKey,
				ManualCCNumber,
				ManualCCExpMonth,
				ManualCCExpYear,
				ManualCCV,
				CCDeliveryOption
			)
		
		VALUES
			(
				@CompanyKey,
				@AccountNumber,
				@AccountName,
				@ParentAccountKey,
				@AccountType,
				@AccountTypeCash,
				@PayrollExpense,
				@FacilityExpense,
				@LaborIncome,	
				@Rollup,
				@Description,
				@BankAccountNumber,
				@NextCheckNumber,
				@Active,
				@FIName,
				@FIID,
				@FIOrg,
				@FIUrl,
				@CreditCardNumber,
				@CreditCardLogin,
				@CreditCardPassword,
				@VendorKey,
				@ManualCCNumber,
				@ManualCCExpMonth,
				@ManualCCExpYear,
				@ManualCCV,
				@CCDeliveryOption
			)

		SELECT @GLAccountKey = @@IDENTITY 

		EXEC sptGLAccountOrder @CompanyKey, 0, 0, -1

		RETURN @GLAccountKey
	END
ELSE
	BEGIN
		SELECT @CurrentType = AccountType, @CurrentRollup = Rollup
		FROM tGLAccount (nolock)
		WHERE GLAccountKey = @GLAccountKey
		
		/*
			IF @CurrentType in (10, 12, 13) and not @AccountType in (10, 12, 13, 14)
				Return -3
			IF @CurrentType in (21, 22) and not @AccountType in (21, 22)
				Return -4
			IF @CurrentType in (30, 31, 32) and not @AccountType in (30, 31, 32)
				Return -5
			IF @CurrentType in (40, 41) and not @AccountType in (40, 41)
				Return -6
			IF @CurrentType in (50, 51, 52) and not @AccountType in (50, 51, 52)
				Return -7
			IF (@CurrentType = 11 and @AccountType <> 11) or (@CurrentType <> 11 and @AccountType = 11 and @CurrentType <> 0)
				Return -10
			IF (@CurrentType = 20 and @AccountType <> 20) or (@CurrentType <> 20 and @AccountType = 20 and @CurrentType <> 0)
				Return -11
		*/
		
		IF @CurrentRollup <> @Rollup AND @CurrentRollup = 1
			IF EXISTS(SELECT 1 FROM tGLAccount (nolock) WHERE ParentAccountKey = @GLAccountKey)
				RETURN -8
		
		IF (@CurrentRollup = 1) AND (@CurrentType <> @AccountType) AND (ISNULL(@CurrentType, 0) <> 0)
			RETURN -13
		
		IF @CurrentRollup <> @Rollup AND @CurrentRollup = 0
			BEGIN
				IF EXISTS(SELECT 1 FROM tVoucher (nolock) WHERE APAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tVoucherDetail (nolock) WHERE ExpenseAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tInvoice (nolock) WHERE ARAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tInvoiceLine (nolock) WHERE SalesAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tCheck (nolock) WHERE CashAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tCheckAppl (nolock) WHERE SalesAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tPayment (nolock) WHERE CashAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tPaymentDetail (nolock) WHERE GLAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tItem (nolock) WHERE ExpenseAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tJournalEntryDetail (nolock) WHERE GLAccountKey = @GLAccountKey)
					RETURN -14

				IF EXISTS(SELECT 1 FROM tTransaction (nolock) WHERE GLAccountKey = @GLAccountKey)
					RETURN -14
			END

		--If it is a rollup and it's Account Type has changed (and it's passed all of the above validations),
		--cascade the Account Type down
		IF (@Rollup = 1) AND (@CurrentType <> @AccountType)
			EXEC sptGLAccountCascadeAccountTypeChange @GLAccountKey, @AccountType

		UPDATE
			tGLAccount
		SET
			CompanyKey = @CompanyKey,
			AccountNumber = @AccountNumber,
			AccountName = @AccountName,
			ParentAccountKey = @ParentAccountKey,
			AccountType = @AccountType,
			AccountTypeCash = @AccountTypeCash,
			PayrollExpense = @PayrollExpense,
			FacilityExpense = @FacilityExpense,
			LaborIncome = @LaborIncome,
			Rollup = @Rollup,
			Description = @Description,
			BankAccountNumber = @BankAccountNumber,
			NextCheckNumber = @NextCheckNumber,
			Active = @Active,
			FIName = @FIName,
			FIID = @FIID,
			FIOrg =	@FIOrg,
			FIUrl = @FIUrl,
			CreditCardNumber = CASE LEFT(@CreditCardNumber, 1) WHEN '*' THEN CreditCardNumber ELSE @CreditCardNumber END,
			CreditCardLogin = @CreditCardLogin,
			CreditCardPassword = @CreditCardPassword,
			VendorKey = @VendorKey,
			ManualCCNumber = CASE LEFT(@ManualCCNumber, 1) WHEN '*' THEN ManualCCNumber ELSE @ManualCCNumber END,
			ManualCCExpMonth = @ManualCCExpMonth,
			ManualCCExpYear = @ManualCCExpYear,
			ManualCCV = CASE LEFT(@ManualCCV, 1) WHEN '*' THEN ManualCCV ELSE @ManualCCV END,
			CCDeliveryOption = @CCDeliveryOption
		WHERE
			GLAccountKey = @GLAccountKey 
		
		EXEC sptGLAccountOrder @CompanyKey, 0, 0, -1
		
		RETURN @GLAccountKey
	END
GO
