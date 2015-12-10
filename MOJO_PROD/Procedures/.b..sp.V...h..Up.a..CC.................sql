USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdateCC]    Script Date: 12/10/2015 10:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdateCC]
	@VoucherKey int,
	@CompanyKey int,
	@CreatedByKey int,
	@VendorKey int,
	@InvoiceDate smalldatetime,
	@PostingDate smalldatetime,
	@InvoiceNumber varchar(50),
	@DateReceived smalldatetime,
	@TermsPercent  decimal(24,4),
	@TermsDays int,
	@TermsNet int,
	@DueDate smalldatetime,
	@Description text,
	@ApprovedByKey int,
	@APAccountKey int,
	@ClassKey int,
	@ProjectKey int,
	@Downloaded tinyint,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@VoucherTotal money,
	@GLCompanyKey int,
	@OfficeKey int,
	@OpeningTransaction tinyint,
	@BoughtFromKey int,
	@BoughtFrom varchar(250),
	@BoughtByKey int,
	@VoucherType tinyint,
	@Receipt tinyint = 0,
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24,7) = 1

AS --Encrypt

/*
|| When     Who Rel      What
|| 07/31/07 BSH 8.5      (9659)Update GLCompanyKey, OfficeKey
|| 01/17/08 BSH 8.5      (18369)Validate that Project on line and header belong to same GLC.
|| 06/18/08 GHL 8.513    Added OpeningTransaction
|| 5/17/11  CRG 10.5.4.4 Added Insert logic (copied over from sptVoucherInsert)
|| 8/09/11  GHL 10.5.4.7 Cloned sptVoucherUpdate and made changes for credit cards 
|| 8/26/11  GHL 10.5.4.7 Allowing now saving after posting so that we can save descriptions, etc..
|| 9/29/11  GHL 10.5.4.8 Added @VoucherType parameter + logic for PurchasedFrom/BoughtFrom
|| 10/7/11  GHL 10.5.4.9 Setting now PostingDate = InvoiceDate if not posted yet
|| 07/20/12 GWG 10.5.5.8 Modified the puchased from to look at the CCPayeeName
|| 07/23/12 GHL 10.5.5.8 (147996) Patch to assign a BoughtByKey 
|| 09/19/12 GHL 10.5.6.0 (154716) There is now a separate approver for credit card + description is now a text field 
|| 12/05/12 MAS 10.5.6.3 (160939) Added Receipt flag
|| 12/05/12 MAS 10.5.6.3 (164454) Use the BoughtBy User's CreditCardApprover
|| 01/17/13 GHL 10.5.6.3 (165422) Added default Receipt = 0 because calling sps do not specify the param
|| 07/30/13 KMC 10.5.7.0 (184557) Added check for new right purch_approvecreditcardcharge (60403).  If the
||                       CreditCardApprover is blank, and you do not have the right to approve credit card charges
||                       then the prior fall through logic to put yourself as the approver no longer happens.
|| 08/28/13 WDF 10.5.7.1 (179763) Modified how PostingDate was set
|| 11/15/13 GHL 10.574   Added multicurrency fields
|| 12/06/13 RLB 10.5.7.5 (198495) Changed how the approver is validated when creating a new cc voucher
|| 01/14/14 GHL 10.5.7.5 (202641)) If no approver, fall back to CreatedByKey
|| 01/03/14 WDF 10.5.7.6 (188500) Added DateCreated to Insert tVoucher
|| 04/08/14 GHL 10.5.7.9 For imports, if currency is blank, set exchange rate to 1
|| 07/29/14 GHL 10.5.8.2 (224101) Set VendorKey on update also because now the credit card can be changed after save
|| 02/07/15 MAS 10.5.8.9 (243079) Added VoucherID

*/
	
	DECLARE @DuplicateVendorInvoiceNbr tinyint
	
	-- credit cards have duplicate invoice numbers
	--SELECT @DuplicateVendorInvoiceNbr = ISNULL(DuplicateVendorInvoiceNbr, 0) FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey
	SELECT @DuplicateVendorInvoiceNbr = 1
	
	IF @DuplicateVendorInvoiceNbr = 0
	BEGIN
		IF EXISTS(SELECT 1 FROM tVoucher (NOLOCK) WHERE InvoiceNumber = @InvoiceNumber AND VendorKey = @VendorKey AND VoucherKey <> @VoucherKey)
		RETURN -1
	END
	
	/* we can save things like description now, even if posted
	IF (SELECT Posted
	    FROM   tVoucher (NOLOCK)
	    WHERE  VoucherKey = @VoucherKey) = 1
	    RETURN -3
	*/
	    
		
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2
			
	/*
	IF EXISTS(SELECT 1 from tVoucherDetail vd (nolock) inner join tProject p on vd.ProjectKey = p.ProjectKey
		Where vd.VoucherKey = @VoucherKey and ISNULL(p.GLCompanyKey, 0) <> ISNULL(@GLCompanyKey, 0))
		Return -4
	*/

	if isnull(@ExchangeRate, 0) <=0 Or isnull(@CurrencyID, '') = ''
		select @ExchangeRate =1

	declare @Posted int

	IF @VoucherKey > 0
	BEGIN

		select @Posted = Posted from tVoucher (nolock) where VoucherKey = @VoucherKey

		if @Posted = 0
			select @PostingDate = isnull(@PostingDate, @InvoiceDate)
			
		UPDATE
			tVoucher
		SET
			InvoiceDate = @InvoiceDate,
			PostingDate = @PostingDate,
			InvoiceNumber = @InvoiceNumber,
			DateReceived = @DateReceived,
			TermsPercent = @TermsPercent,
			TermsDays = @TermsDays,
			TermsNet = @TermsNet,
			DueDate = @DueDate,
			Description = @Description,
			ApprovedByKey = @ApprovedByKey,
			ProjectKey = @ProjectKey,
			APAccountKey = @APAccountKey,
			ClassKey = @ClassKey,
			Downloaded = @Downloaded,
			SalesTaxKey = @SalesTaxKey,
			SalesTax2Key = @SalesTax2Key,
			GLCompanyKey = @GLCompanyKey,
			OfficeKey = @OfficeKey,
			OpeningTransaction = @OpeningTransaction,
			CreditCard = 1,
			VoucherTotal = @VoucherTotal,
			SalesTaxAmount = isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0),
			SalesTax1Amount = isnull(@SalesTax1Amount, 0),
			SalesTax2Amount = isnull(@SalesTax2Amount, 0),

			BoughtFromKey = @BoughtFromKey,
			BoughtFrom = @BoughtFrom,
			BoughtByKey = @BoughtByKey,
			VoucherType = @VoucherType,
			Receipt = @Receipt,
			CurrencyID = @CurrencyID,
	        ExchangeRate = @ExchangeRate,
			VendorKey = @VendorKey
 
		WHERE
			VoucherKey = @VoucherKey 

		DELETE tVoucherTax
		WHERE  VoucherKey = @VoucherKey
		
		IF isnull(@SalesTaxKey, 0) > 0 
		INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
		SELECT @VoucherKey, @SalesTaxKey, ISNULL(@SalesTax1Amount, 0), 1
	
		IF isnull(@SalesTax2Key, 0) > 0 
		INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
		SELECT @VoucherKey, @SalesTax2Key, ISNULL(@SalesTax2Amount, 0), 2

		RETURN @VoucherKey
	END
	ELSE
	BEGIN
		DECLARE @ApproverPref smallint, 
				@DefaultApprover int,
				@Status smallint

/* The approver should be like for the expense reports

		SELECT	@ApproverPref = ISNULL(DefaultAPApprover, 0),
				@DefaultApprover = ISNULL(DefaultAPApproverKey, 0)
		FROM	tPreference (nolock)
		WHERE	CompanyKey = @CompanyKey

		SELECT	@Status = 1
		IF @ApproverPref = 1 AND ISNULL(@ProjectKey, 0) > 0
		BEGIN
			DECLARE @AE int
			SELECT @AE = ISNULL(AccountManager, 0) FROM tProject (nolock) Where ProjectKey = @ProjectKey
			IF @AE > 0
				SELECT @ApprovedByKey = @AE
		END

		IF @ApproverPref = 2
			SELECT @Status = 4

		IF @ApproverPref = 3 AND @DefaultApprover > 0
			SELECT @ApprovedByKey = @DefaultApprover
*/
	
		select @Status = 1

		-- Use the BoughtBy User's CreditCardApprover
		if isnull(@ApprovedByKey, 0) = 0
		begin
			select @ApprovedByKey = CreditCardApprover
			from   tUser (nolock) 
			where  UserKey = @BoughtByKey
			
			IF NOT EXISTS(select 1 from tUser u (NOLOCK) INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey WHERE u.UserKey = @ApprovedByKey  AND ra.EntityType = 'Security Group' AND RightKey = 60403)
				select @ApprovedByKey = 0
		end
			
			
		if isnull(@ApprovedByKey, 0) = 0
		begin
			select @ApprovedByKey = CreditCardApprover
			from   tUser (nolock) 
			where  UserKey = @CreatedByKey
			
			IF NOT EXISTS(select 1 from tUser u (NOLOCK) INNER JOIN tRightAssigned ra (NOLOCK) ON u.SecurityGroupKey = ra.EntityKey WHERE u.UserKey = @ApprovedByKey  AND ra.EntityType = 'Security Group' AND RightKey = 60403)
				select @ApprovedByKey = 0
		end
		
		-- have to return an error here their is no valid approver and it is a required field
		-- fall back to user (issue 202641)
		if isnull(@ApprovedByKey, 0) = 0
			--RETURN -5
			select @ApprovedByKey = @CreatedByKey

		-- for the import
		if isnull(@BoughtFromKey, 0) = 0 And isnull(@BoughtFrom, '') <> ''
		begin
			 select @BoughtFromKey = CompanyKey
			 from   tCompany (nolock)
			 where  OwnerCompanyKey = @CompanyKey
			 and    [Vendor] = 1
			 and    UPPER(CCPayeeName) = UPPER(@BoughtFrom)

			 if ISNULL(@BoughtFromKey, 0) = 0
				 select @BoughtFromKey = CompanyKey
				 from   tCompany (nolock)
				 where  OwnerCompanyKey = @CompanyKey
				 and    [Vendor] = 1
				 and    UPPER(CompanyName) = UPPER(@BoughtFrom)


		end

		-- patch to try to find a BoughtByKey if missing (could be if converted from CCEntry)
		if isnull(@BoughtByKey, 0) = 0
		begin
			-- check if createdbykey can use this CC 
			if exists (select 1 from tGLAccountUser (NOLOCK) where GLAccountKey = @APAccountKey and UserKey = @CreatedByKey)
				select  @BoughtByKey = @CreatedByKey

			-- if not pickup somebody in the list
			if isnull(@BoughtByKey, 0) = 0
				select @BoughtByKey = min(glau.UserKey) 
				from  tGLAccountUser glau (NOLOCK)
					inner join tUser u (nolock) on glau.UserKey = u.UserKey 
				where glau.GLAccountKey = @APAccountKey
				and   u.Active = 1

			-- if not assign to createdby
			if isnull(@BoughtByKey, 0) = 0
				select  @BoughtByKey = @CreatedByKey

		end	

		select @PostingDate = isnull(@PostingDate, @InvoiceDate)
		
		Declare @VoucherID int
		Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 from tVoucher (nolock) 
		Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 1

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
			ProjectKey,
			ApprovedByKey,
			APAccountKey,
			ClassKey,
			SalesTaxKey,
			SalesTax2Key,
			Status,
			GLCompanyKey,
			OfficeKey,
			OpeningTransaction,
			CreditCard,
			VoucherTotal,
			SalesTaxAmount,
			SalesTax1Amount,
			SalesTax2Amount,
			BoughtFromKey,
			BoughtFrom,
			BoughtByKey,
			VoucherType,
			Receipt,
			VoucherID,
			CurrencyID,
	        ExchangeRate 
			)

		VALUES
			(
			@CompanyKey,
			@VendorKey,
			@InvoiceDate,
			@PostingDate,
			@InvoiceNumber,
			@DateReceived,
			GETDATE(),
			@CreatedByKey,
			@TermsPercent,
			@TermsDays,
			@TermsNet,
			@DueDate,
			@Description,
			@ProjectKey,
			@ApprovedByKey,
			@APAccountKey,
			@ClassKey,
			@SalesTaxKey,
			@SalesTax2Key,
			@Status,
			@GLCompanyKey,
			@OfficeKey,
			@OpeningTransaction,
			1, -- CreditCard
			@VoucherTotal,
			isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0),
			isnull(@SalesTax1Amount, 0),
			isnull(@SalesTax2Amount, 0),
			@BoughtFromKey,
			@BoughtFrom,
			@BoughtByKey,
			@VoucherType,
			@Receipt,
			@VoucherID,
			@CurrencyID,
	        @ExchangeRate
			)

		SELECT @VoucherKey = @@IDENTITY

		DELETE tVoucherTax
		WHERE  VoucherKey = @VoucherKey
		
		IF isnull(@SalesTaxKey, 0) > 0 
		INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
		SELECT @VoucherKey, @SalesTaxKey, ISNULL(@SalesTax1Amount, 0), 1
	
		IF isnull(@SalesTax2Key, 0) > 0 
		INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
		SELECT @VoucherKey, @SalesTax2Key, ISNULL(@SalesTax2Amount, 0), 2
	
		RETURN @VoucherKey
	END
GO
