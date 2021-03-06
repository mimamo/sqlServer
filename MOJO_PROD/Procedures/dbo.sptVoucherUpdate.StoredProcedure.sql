USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherUpdate]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherUpdate]
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
	@GLCompanyKey int,
	@OfficeKey int,
	@OpeningTransaction tinyint,
	@VoucherType smallint,
	@RecalcTaxes tinyint = 1, -- 1 from ASPX, 0 from FLEX
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24,7) = 1,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@UserKey int = null,
	@CompanyMediaKey int = null,
	@VoucherTotalNoTaxesControl money = null,
	@SalesTax1AmountControl money = null,
	@SalesTax2AmountControl money = null

AS --Encrypt

/*
|| When     Who Rel      What
|| 07/31/07 BSH 8.5      (9659)Update GLCompanyKey, OfficeKey
|| 01/17/08 BSH 8.5      (18369)Validate that Project on line and header belong to same GLC.
|| 06/18/08 GHL 8.513    Added OpeningTransaction
|| 5/17/11  CRG 10.5.4.4 Added Insert logic (copied over from sptVoucherInsert)
|| 09/14/11 MFT 10.5.4.8 Added VoucherType, tCompany update (overhead)
|| 10/12/11 MFT 10.5.4.9 Changed Description to text
|| 10/20/11 MFT 10.5.4.9 Corrected Overhead/VoucherType conversion
|| 11/29/11 GHL 10.5.5.0 Added @RecalcTaxes parameter because on the Flex screen, we do not want to recalc taxes
||                       In Flex, taxes are constantly calculated on the UI from the lines by the Tax Manager
||                       In ASP, we are dealing with the header only, and changing the taxes with possible diff rates
||                       requires the recalc of sales tax amounts 
|| 12/01/11 GHL 10.5.5.0 (127709) if we cannot find an AE and there is a default AP Approver, take AP Approver
|| 05/04/12 GHL 10.5.5.5 (142427) Added UserKey for GLCompany logic
|| 05/11/12 GHL 10.5.5.6 (142898) Added logic for vendor DefaultAPApproverKey override
|| 05/22/12 GHL 10.5.5.6 (144366) Allow updates even if posted (FLEX only)
|| 05/24/12 GHL 10.5.5.6 Added update of ApprovedDate
|| 11/19/12 GHL 10.5.6.2 (160312) No matter what the vendor AP approver is, approve if we approve automatically
|| 02/07/13 GHL 10.5.6.5 (167854) Added VoucherID for a customization for Spark44
|| 04/17/13 GHL 10.5.6.7 (175144) Removed extra check of invoice number even if @DuplicateVendorInvoiceNbr = 1 
|| 04/18/13 GHL 10.5.6.7 (175287) Reviewed the approver logic mainly because users are surprised by blank approver
||                       Approver will be then defaulted on UI to oneself like ASPX. Also reviewed logic in flow chart fashion 
|| 10/17/13 GHL 10.5.7.3 Added currency info
|| 12/02/13 GHL 10.5.7.4 (198131) Do not save without a vendor
|| 01/03/14 WDF 10.5.7.6 (188500) Added DateCreated to Insert tVoucher
|| 02/21/14 GHL 10.5.7.7 AP Account must match currency on the header
|| 01/08/15 PLC 10.5.8.7 Added CompanyMediaKey
|| 02/11/15 GHL 10.5.8.9 Added control total amounts for the new media screens
*/
	
	DECLARE @DuplicateVendorInvoiceNbr tinyint
	
	SELECT @DuplicateVendorInvoiceNbr = ISNULL(DuplicateVendorInvoiceNbr, 0) FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey
	IF @DuplicateVendorInvoiceNbr = 0
	BEGIN
		IF EXISTS(SELECT 1 FROM tVoucher (NOLOCK) WHERE InvoiceNumber = @InvoiceNumber AND VendorKey = @VendorKey AND VoucherKey <> @VoucherKey)
		RETURN -1
	END
	
	-- only do this if we are calling this sp from ASPX
	IF @RecalcTaxes = 1 AND (SELECT Posted
	    FROM   tVoucher (NOLOCK)
	    WHERE  VoucherKey = @VoucherKey) = 1
	    RETURN -3
	    
		
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2

Declare @RestrictToGLCompany int
Declare @UseGLCompany int
Declare @MultiCurrency int 

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
      ,@UseGLCompany = ISNULL(UseGLCompany, 0)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tPreference (nolock) 
	Where CompanyKey = @CompanyKey	
	
IF @UseGLCompany = 1
BEGIN
	IF @RestrictToGLCompany = 1 AND EXISTS(SELECT 1 from tVoucherDetail vd (nolock) inner join tProject p on vd.ProjectKey = p.ProjectKey
		Where vd.VoucherKey = @VoucherKey 
		and not (ISNULL(p.GLCompanyKey, 0) = ISNULL(@GLCompanyKey, 0)
			OR
			p.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey )
			)
		)
		Return -4
END	

IF isnull(@VendorKey, 0) = 0
	RETURN -5

	--Update the vendor record with overhead option
	--UPDATE tCompany
	--SET Overhead = CASE @VoucherType WHEN 1 THEN 1 ELSE 0 END
	--WHERE CompanyKey = @VendorKey

declare @APAccountCurrencyID varchar(10)

if @MultiCurrency = 0
begin
	select @CurrencyID = null 
		  ,@ExchangeRate = 1
		  ,@PCurrencyID = null 
		  ,@PExchangeRate = 1
end
else 
begin
	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate = 1 -- no division by 0 allowed

	if isnull(@CurrencyID, '') = ''
		select @CurrencyID = null -- no empty string
			  ,@ExchangeRate = 1

	if isnull(@PExchangeRate, 0) <=0
		select @PExchangeRate = 1

	if isnull(@PCurrencyID, '') = ''
		select @PCurrencyID = null -- no empty string
			  ,@PExchangeRate = 1

	-- Now AP account must be in same currency as the header
	select @APAccountCurrencyID = CurrencyID from tGLAccount (nolock) where GLAccountKey = @APAccountKey
	if isnull(@APAccountCurrencyID, '') <> isnull(@CurrencyID, '')
		return -6


end
	
	IF @VoucherKey > 0
	BEGIN
		DECLARE @OldSalesTaxKey INT
		DECLARE @OldSalesTax2Key INT
	
		SELECT @OldSalesTaxKey = SalesTaxKey, @OldSalesTax2Key = SalesTax2Key
		FROM   tVoucher (NOLOCK)
		WHERE  VoucherKey = @VoucherKey
			
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
			VoucherType = @VoucherType,
			CurrencyID = @CurrencyID,
			ExchangeRate = @ExchangeRate,
			PCurrencyID = @PCurrencyID,
			PExchangeRate = @PExchangeRate,
			CompanyMediaKey = @CompanyMediaKey,
			VoucherTotalNoTaxesControl = @VoucherTotalNoTaxesControl,
			SalesTax1AmountControl = @SalesTax1AmountControl,
			SalesTax2AmountControl = @SalesTax2AmountControl
		WHERE
			VoucherKey = @VoucherKey 

		IF @RecalcTaxes = 1
		BEGIN
			IF ISNULL(@OldSalesTaxKey, 0) <> ISNULL(@SalesTaxKey, 0) OR ISNULL(@OldSalesTax2Key, 0) <> ISNULL(@SalesTax2Key, 0)
			BEGIN
				DELETE tVoucherDetailTax
				FROM tVoucherDetail vd (NOLOCK) 
				WHERE vd.VoucherKey = @VoucherKey
				AND   tVoucherDetailTax.VoucherDetailKey = vd.VoucherDetailKey
				AND   tVoucherDetailTax.SalesTaxKey IN (@SalesTaxKey, @SalesTax2Key)
		
				EXEC sptVoucherRecalcAmounts @VoucherKey
			END
		END

		RETURN @VoucherKey
	END
	ELSE
	BEGIN
		DECLARE @ApproverPref smallint, 
				@DefaultAPApprover int,
				@VendorDefaultAPApprover int,
				@Status smallint
				
		SELECT	@ApproverPref = ISNULL(DefaultAPApprover, 0),
				@DefaultAPApprover = ISNULL(DefaultAPApproverKey, 0)
		FROM	tPreference (nolock)
		WHERE	CompanyKey = @CompanyKey	

		Declare @kApproverPrefPersonEnteringInvoice int		select @kApproverPrefPersonEnteringInvoice = 0
		Declare @kApproverPrefAEFromProjectHeader int		select @kApproverPrefAEFromProjectHeader = 1
		Declare @kApproverPrefAutomatically int				select @kApproverPrefAutomatically = 2
		Declare @kApproverPrefDefaultAPApprover int			select @kApproverPrefDefaultAPApprover = 3
		Declare @AE int

		-- Set defaults
		if  isnull(@ApprovedByKey, 0) = 0
			select @ApprovedByKey = @CreatedByKey
		select @Status = 1

		--issue 142898 vendor AP Approver is an override of the transactions preference
		select @VendorDefaultAPApprover = c.DefaultAPApproverKey 
		from tCompany c (nolock) 
			inner join tUser u (nolock) on c.DefaultAPApproverKey = u.UserKey
		where c.CompanyKey = @VendorKey
		and   u.Active = 1

		if isnull(@VendorDefaultAPApprover, 0) > 0
		begin
			select @ApprovedByKey = @VendorDefaultAPApprover

			-- however for issue 160312, approve now if we approve automatically
			if @ApproverPref = @kApproverPrefAutomatically
				Select @Status = 4
		end
		else
		begin
			-- no vendor override
			-- follow transactions preference
		
			-- if we approve automatically, we should be done	
			if @ApproverPref = @kApproverPrefAutomatically
				Select @Status = 4
			else
			begin
				-- if this is the user entering the invoice, we should be done, already defaulted
				-- so deal with other cases
				 if @ApproverPref <> @kApproverPrefPersonEnteringInvoice
				 begin
					if @ApproverPref = @kApproverPrefAEFromProjectHeader 
					begin
						if ISNULL(@ProjectKey, 0) > 0
						begin
							Select @AE = ISNULL(AccountManager, 0) from tProject Where ProjectKey = @ProjectKey
							if @AE > 0
								Select @ApprovedByKey = @AE
	
						end

						-- issue 127709: if we cannot find an AE and there is a default AP Approver, take AP Approver
						if isnull(@AE, 0) = 0 and isnull(@DefaultAPApprover, 0) > 0
							select @ApprovedByKey = @DefaultAPApprover 

					end -- AE is approver
					else
					begin
						if @ApproverPref = @kApproverPrefDefaultAPApprover 
							select @ApprovedByKey = @DefaultAPApprover
					end -- default AP approver
				 end -- not person entering invoice
			end -- not automatical approval 

		end -- vendor override

		-- if anything went wrong, assign yourself
		if  isnull(@ApprovedByKey, 0) = 0
			select @ApprovedByKey = @CreatedByKey

		declare @ApprovedDate smalldatetime
		if @Status = 4
			select @ApprovedDate = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as smalldatetime)
		-- else we leave ApprovedDate at null

		Declare @VoucherID int
		Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 from tVoucher (nolock) 
		Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 0    

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
			VoucherType,
			ApprovedDate,
			VoucherID,
			CurrencyID, 
		    ExchangeRate,
		    PCurrencyID,  
		    PExchangeRate,
		    CompanyMediaKey,
			VoucherTotalNoTaxesControl,
			SalesTax1AmountControl,
			SalesTax2AmountControl
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
			@VoucherType,
			@ApprovedDate,
			@VoucherID,
			@CurrencyID, 
		    @ExchangeRate,
		    @PCurrencyID,  
		    @PExchangeRate,
		    @CompanyMediaKey,
			@VoucherTotalNoTaxesControl,
			@SalesTax1AmountControl,
			@SalesTax2AmountControl
			)
	
		RETURN @@IDENTITY
	END
GO
