USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherInsert]
	@CompanyKey int,
	@VendorKey int,
	@InvoiceDate smalldatetime,
	@PostingDate smalldatetime,
	@InvoiceNumber varchar(50),
	@DateReceived smalldatetime,
	@CreatedByKey int,
	@TermsPercent decimal(24,4),
	@TermsDays int,
	@TermsNet int,
	@DueDate smalldatetime,
	@Description text,
	@ProjectKey int,
	@ApprovedByKey int,
	@APAccountKey int,
	@ClassKey int,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@GLCompanyKey int,
	@OfficeKey int,	
	@OpeningTransaction tinyint,
	@VoucherType smallint,
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24,7) = 1,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@CompanyMediaKey int = null,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel      What
|| 07/31/07 BSH 8.5      (9659)Update GLCompanyKey, OfficeKey
|| 06/03/08 RTC 10.0.0.0 Added system option to allow duplicate vendor invoice numbers
|| 06/18/08 GHL 8.513    Added OpeningTransaction
|| 08/31/10 RLB 10.5.3.4 (88154) @ApproverPref now pulling from voucher transaction preference
|| 09/14/11 MFT 10.5.4.8 Added VoucherType, tCompany update (overhead)
|| 10/12/11 MFT 10.5.4.9 Changed Description to text
|| 12/01/11 GHL 10.5.5.0 (127709) if we cannot find an AE and there is a default AP Approver, take AP Approver
|| 05/24/12 GHL 10.5.5.6 Added update of ApprovedDate
|| 02/07/13 GHL 10.565  (167854) Added VoucherID for a customization for Spark44
|| 11/06/13 GHL 10.574  Added multi currency info
|| 01/14/14 PLC 10.575  Added DateCreated default to getdate()
|| 01/08/15 PLC 10.587  Added CompanyMediaKey

*/
		   
	Declare @Status smallint
	declare @DuplicateVendorInvoiceNbr tinyint
	Declare @MultiCurrency int 

	select @DuplicateVendorInvoiceNbr = isnull(DuplicateVendorInvoiceNbr,0) from tPreference (nolock) where CompanyKey = @CompanyKey
	if @DuplicateVendorInvoiceNbr = 0
		begin
			IF EXISTS(SELECT 1 FROM tVoucher (NOLOCK) WHERE InvoiceNumber = @InvoiceNumber AND VendorKey = @VendorKey)
			Return -1
		end
		
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -2
			
	Declare @ApproverPref smallint, @DefaultAPApprover int
	Select @ApproverPref = ISNULL(DefaultAPApprover, 0)
		  ,@DefaultAPApprover = ISNULL(DefaultAPApproverKey, 0)
		  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
	from tPreference 
	Where CompanyKey = @CompanyKey

	Declare @kApproverPrefPersonEnteringInvoice int		select @kApproverPrefPersonEnteringInvoice = 0
	Declare @kApproverPrefAEFromProjectHeader int		select @kApproverPrefAEFromProjectHeader = 1
	Declare @kApproverPrefAutomatically int				select @kApproverPrefAutomatically = 2
	Declare @kApproverPrefDefaultAPApprover int			select @kApproverPrefDefaultAPApprover = 3
	Declare @AE int

	-- In UI db call, ApprovedByKey = user entering invoice by default  
	if @ApproverPref = @kApproverPrefAEFromProjectHeader 
	begin
		if ISNULL(@ProjectKey, 0) > 0
		begin
			Select @AE = ISNULL(AccountManager, 0) from tProject Where ProjectKey = @ProjectKey
			if @AE > 0
				Select @ApprovedByKey = @AE
	
		end

		-- issue 127709: if we cannot find an AE and there is a default AP Approver, take AP Approver
		-- or just change the approval method here
		if isnull(@AE, 0) = 0 and isnull(@DefaultAPApprover, 0) > 0
			select @ApproverPref = @kApproverPrefDefaultAPApprover
	end

	if @ApproverPref = @kApproverPrefDefaultAPApprover AND @DefaultAPApprover > 0
		Select @ApprovedByKey = @DefaultAPApprover
	
	select @Status = 1
	if @ApproverPref = @kApproverPrefAutomatically
		Select @Status = 4

	declare @ApprovedDate smalldatetime
	if @Status = 4
		select @ApprovedDate = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as smalldatetime)
	-- else we leave ApprovedDate at null

	Declare @VoucherID int
	Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 from tVoucher (nolock) 
	Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 0

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

end

	INSERT tVoucher
		(
		CompanyKey,
		VendorKey,
		InvoiceDate,
		PostingDate,
		InvoiceNumber,
		DateReceived,
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
		DateCreated,
		CompanyMediaKey
		)

	VALUES
		(
		@CompanyKey,
		@VendorKey,
		@InvoiceDate,
		@PostingDate,
		@InvoiceNumber,
		@DateReceived,
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
		getdate(),
		@CompanyMediaKey
		)
	
	SELECT @oIdentity = @@IDENTITY


	
RETURN 1
GO
