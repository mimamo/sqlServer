USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCCEntryUpdate]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCCEntryUpdate]
	@CCEntryKey int,
	@CompanyKey int,
	@GLAccountKey int,	
	@ProjectKey int,
	@VendorKey int,
	@ItemKey int,
	@VoucherKey int,
	@TaskKey int,
	@ChargedByKey int,
	@Amount money,
	@TransactionDate smalldatetime,
	@FITID varchar(100),
	@PayeeName varchar(100),
	@Memo varchar(2000),
	@FID varchar(100),
	@TransactionPostedDate smalldatetime,
	@TransactionAccountID varchar(100),
	@TransactionType varchar(100),
	@OfficeKey int,
	@GLCompanyKey int,
	@DepartmentKey int,
	@ExpenseAccountKey int,
	@Overhead tinyint = 0,
	@ClassKey int = null,
	@SalesTaxKey int = null,
	@SalesTax2Key int = null,
	@SalesTaxAmount money = 0,
	@SalesTax2Amount money = 0,
	@SplitProjects tinyint = 0,
	@SplitVouchers tinyint = 0,
	@Billable tinyint = 1,
	@Receipt tinyint = 0

AS --Encrypt

/*
|| When      Who Rel		What
|| 02/06/12  MAS 10.5.5.2	Created
|| 03/29/12  MAS 10.5.5.4	Added office and GLCompany
|| 04/10/12  MAS 10.5.5.4	Added a Credit Card number -> GLAccount lookup used when importing a text file.
|| 6/27/12   CRG 10.5.5.7   Added Department and Expense Account
|| 6/28/12   CRG 10.5.5.8   Added Overhead
|| 07/01/12  MAS 10.5.5.8	Fixed issue with the insert order of columns
|| 07/7/12   GWG 10.5.5.8   Added class id and sales tax columns
|| 07/09/12  MAS 10.5.5.8	Allow the CC Transaction to be updated when downloading from the CC Provider if it has NOT been processed (CCVoucherKey)
|| 09/07/12  GHL 10.5.6.0   Added SplitProjects/SplitVouchers
|| 09/18/12  GHL 10.5.6.0   (154717) Added Billable flag
|| 10/29/12  RLB 10.5.6.1   (157719) If there is a Default CC GLCompany set it on the insert
|| 11/07/12  GWG 10.5.6.1   Modified the default for billable to 1 so new charges default to billable.
|| 12/04/12  MAS 10.5.6.2   (161343) Check for duplicate transactions based on date, payee, amount and part of the FITID
|| 12/04/12  MAS 10.5.6.3   (160939) Added Receipt flag
|| 01/31/13  MAS 10.5.6.4   (161343) Removed the duplicate check on the memo
|| 12/15/13  GWG 10.5.7.5   The processed check for duplicates was getting set on the wrong field
|| 04/10 14  RLB 10.5.7.9   (212536) Added a check for company default gl company if the gl account does not have one
*/

Declare @DefaultCCGLCompanyKey int, @CCVoucherKey int
Select @CCVoucherKey = 0

if @CCEntryKey > 0
	BEGIN
		UPDATE
			tCCEntry
		SET
			GLAccountKey = @GLAccountKey,
			ProjectKey = @ProjectKey,
			VendorKey = @VendorKey,
			ItemKey = @ItemKey,
			VoucherKey = @VoucherKey,
			TaskKey = @TaskKey,
			ChargedByKey = @ChargedByKey,
			--Amount = @Amount,
			TransactionDate = @TransactionDate,
			FITID = @FITID,
			PayeeName = @PayeeName,
			Memo = @Memo,
			FID = @FID,
			TransactionPostedDate = @TransactionPostedDate,
			TransactionAccountID = @TransactionAccountID,
			TransactionType = @TransactionType,
			OfficeKey = @OfficeKey,
			GLCompanyKey = @GLCompanyKey,
			DepartmentKey = @DepartmentKey,
			ExpenseAccountKey = @ExpenseAccountKey,
			Overhead = @Overhead,
			ClassKey = @ClassKey,
			SalesTaxKey = @SalesTaxKey,
			SalesTax2Key = @SalesTax2Key,
			SalesTaxAmount = @SalesTaxAmount,
			SalesTax2Amount = @SalesTax2Amount,
			SplitProjects = @SplitProjects,
			SplitVouchers = @SplitVouchers,
			Billable = @Billable,
			Receipt = @Receipt
		WHERE
			CCEntryKey = @CCEntryKey 

		RETURN @CCEntryKey
	END
ELSE
	BEGIN
		-- Check to see if this transaction has already been imported and procssed
		If exists (Select 1 from tCCEntry (nolock) where CompanyKey = @CompanyKey and ISNULL(FID,0) = ISNULL(@FID,0) and ISNULL(FITID,0) = ISNULL(@FITID,0) 
					and ISNULL(CCVoucherKey,0) > 0)
			RETURN - 1

		-- Check to see if we have a duplicate transaction when creating a CCEntry.  
		-- It's been reported that sometimes AMEX creates duplicate transactions
		-- where all the fields match except for the begining character sequence of the FITID
		-- For example: 20121112758758000103111422233213+000000141 
		--              02012317075875875808001422233213+000000141	
		-- Now Saving off the original memo because people change the memo in processing. use the original for duplicate checks
		if exists(SELECT 1 FROM tCCEntry (nolock) 
			   WHERE CompanyKey = @CompanyKey 
			   and ISNULL(FITID,'') <> @FITID
			   --and TransactionPostedDate = @TransactionPostedDate
			   and ISNULL(Amount,0) = ISNULL(@Amount,0) 
			   and ISNULL(@Amount,0) > 0  -- exclude payments		   
			   and ISNULL(PayeeName,'') = ISNULL(@PayeeName, '')
			   and ISNULL(OriginalMemo,'') = ISNULL(@Memo, '')
			   and ISNULL(FID,0) = ISNULL(@FID,0)
			   and RIGHT(ISNULL(FITID,''), 20) = RIGHT(@FITID, 20))

			Select @CCVoucherKey = -2
						

		-- If the transaction exists but has not been processed, we can update some of the fields 
		-- but don't want to overwrite any of the user's fields
	    SELECT @CCEntryKey = CCEntryKey FROM tCCEntry (nolock)
	    WHERE CompanyKey = @CompanyKey and ISNULL(FID,0) = ISNULL(@FID,0) and ISNULL(FITID,0) = ISNULL(@FITID,0) and ISNULL(CCVoucherKey,0) <= 0				

		IF ISNULL(@CCEntryKey,0) > 0
		BEGIN
			UPDATE
				tCCEntry
			SET
				Amount = @Amount,
				TransactionDate = @TransactionDate,
				TransactionPostedDate = @TransactionPostedDate,
				TransactionAccountID = @TransactionAccountID,
				TransactionType = @TransactionType				
			WHERE
				CCEntryKey = @CCEntryKey 

			RETURN @CCEntryKey
		END
		
		-- We need a GLAccountKey.  One has to be passed in or we look it up using the Credit Card Number
		-- This should only be an issue when importing a text file
		If ISNULL(@GLAccountKey, 0) = 0 
			BEGIN
				If ISNULL(@TransactionAccountID, '') = ''
					RETURN -2
					
				Select @GLAccountKey = GLAccountKey from tGLAccount (nolock) Where CompanyKey = @CompanyKey AND CreditCardNumber = @TransactionAccountID
				If ISNULL(@GLAccountKey, 0) = 0
					RETURN -2				
			END
		
		-- Check to see if there is a Vendor setup for this PayeeName
		Select @VendorKey = CompanyKey from tCompany (nolock) Where OwnerCompanyKey = @CompanyKey AND UPPER(CCPayeeName) = UPPER(@PayeeName)

		-- get default GLCompany from the GL Account
		Select @DefaultCCGLCompanyKey = ISNULL(DefaultCCGLCompanyKey, 0) from tGLAccount (nolock) where GLAccountKey = @GLAccountKey

		-- if no default is set on gl account try to get company default
		IF ISNULL(@DefaultCCGLCompanyKey,0) = 0
			Select @DefaultCCGLCompanyKey = ISNULL(DefaultGLCompanyKey, 0) from tPreference (nolock) where CompanyKey = @CompanyKey

		If ISNULL(@GLCompanyKey,0) = 0
			if ISNULL(@DefaultCCGLCompanyKey, 0) > 0
				Select @GLCompanyKey = @DefaultCCGLCompanyKey
			 
		INSERT tCCEntry
			(
			CompanyKey,
			GLAccountKey,
			ProjectKey,
			VendorKey,
			ItemKey,
			VoucherKey,
			CCVoucherKey,
			TaskKey,
			ChargedByKey,
			Amount,
			TransactionDate,
			FITID,
			PayeeName,
			Memo,
			OriginalMemo,
			FID,
			TransactionPostedDate,
			TransactionAccountID,
			TransactionType,
			OfficeKey,
			GLCompanyKey,
			DepartmentKey,
			ExpenseAccountKey,
			Overhead,
			ClassKey,
			SalesTaxKey,
			SalesTax2Key,
			SalesTaxAmount,
			SalesTax2Amount,
			SplitProjects,
			SplitVouchers,
			Billable,
			Receipt)
		VALUES
			(@CompanyKey,
			@GLAccountKey,
			@ProjectKey,
			@VendorKey,
			@ItemKey,
			@VoucherKey,
			@CCVoucherKey,
			@TaskKey,
			@ChargedByKey,
			@Amount,
			@TransactionDate,
			@FITID,
			@PayeeName,
			@Memo,
			@Memo,
			@FID,
			@TransactionPostedDate,
			@TransactionAccountID,
			@TransactionType,
			@OfficeKey,
			@GLCompanyKey,
			@DepartmentKey,
			@ExpenseAccountKey,
			@Overhead,
			@ClassKey,
			@SalesTaxKey,
			@SalesTax2Key,
			@SalesTaxAmount,
			@SalesTax2Amount,
			@SplitProjects,
			@SplitVouchers,
			@Billable,
			@Receipt)

		RETURN @@IDENTITY
	End
GO
