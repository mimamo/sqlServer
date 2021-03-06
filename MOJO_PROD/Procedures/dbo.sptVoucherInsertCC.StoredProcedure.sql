USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherInsertCC]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherInsertCC]
	-- Header info
	@CompanyKey int,
	@GLCompanyKey int,
	@CreatedByKey int,
	@APAccountKey int, -- Credit Card account key
	@InvoiceNumber varchar(50),
	@BoughtByKey int,
	@BoughtFromKey int,
	@BoughtFrom varchar(250),
	@InvoiceDate smalldatetime,
	@VoucherType int, -- Overhead
	@SalesTaxKey int,
	@SalesTax2Key int,
	
	-- detail Info
	@ItemKey int,
	@Quantity decimal(24,4), 
	@UnitCost money,
	@TotalCost money,
	@Billable tinyint,
	@Markup decimal(24,4),
	@UnitRate money,
	@BillableCost money,
	@ShortDescription text,
	@ProjectKey int,
	@TaskKey int,
	@ClassKey int,
	@OfficeKey int,	
	@DepartmentKey int,
	@ExpenseAccountKey int,
	@SalesTax1Amount money,
	@SalesTax2Amount money,
	@Taxable tinyint,
	@Taxable2 tinyint,
	@Receipt tinyint,
	@ApprovedByKey int = null,
	@PostMe tinyint = 1,

	-- multi currency
	@CurrencyID varchar(10) = null,
	@ExchangeRate decimal(24,7) = 1,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,
	@GrossAmount money = null,
    @Exclude1099 money = null
	
		
AS --Encrypt

/*
|| When     Who Rel      What
|| 09/08/11 GHL 10.548   Creation for CreditCardAdd.mxml
||                       Right now only used in Add screen
||                       Inserts: header + single line
|| 03/14/12 GHL 10.554   Added @PostMe and validation of APAccount
|| 04/12/12 GHL 10.555   Added TargetGLCompanyKey param when calling sptVoucherDetailInsertCC
|| 09/19/12 GHL 10.560   Changed description to 2000 chars
|| 10/17/12 RLB 10.561   (156717) Added option to pass in CC approver
|| 12/05/12 MAS 10.5.6.3 (160939) Added Receipt flag
|| 11/13/13 GHL 10.574   Added multicurrency fields 
|| 12/03/13 GHL 10.574   Replaced update of multicurrency fields by parameters when calling the other stored procedures
|| 03/22/14 RLB 10.578 (203504) Added field for enhancement 
|| 10/29/14 GAR 10.585 (225553) Added the project number to the header record so users can report on the project ID and name
						 from the CC listing screen.
*/
		   
declare @kErrVoucherBase int				select @kErrVoucherBase = -1000
declare @kErrVoucherDetailBase int			select @kErrVoucherDetailBase = -2000

	-- missing vars
	declare @VoucherKey int
	declare @VoucherDetailKey int
	declare @VendorKey int
	declare @DateReceived smalldatetime
	declare @TermsPercent  decimal(24,4)
	declare @TermsDays int
	declare @TermsNet int
	declare @PostingDate smalldatetime
	declare @DueDate smalldatetime
	declare @Description varchar(2000)
	declare @Status smallint
	declare @VoucherTotal money
	declare @SalesTaxAmount money

	-- other vars
	declare @RetVal int

	declare @kErrTaskNoBudget int		select @kErrTaskNoBudget = -1 
	declare @kErrCCInvalid int			select @kErrCCInvalid = -2

	if isnull(@TaskKey, 0) > 0
	begin
		if not exists (select 1 from tTask (nolock) where TaskKey = @TaskKey and TrackBudget =1)
			return @kErrTaskNoBudget 
	end

	select @VendorKey = VendorKey
	from  tGLAccount (nolock)
	where GLAccountKey = @APAccountKey

	if @@ROWCOUNT = 0
		return @kErrCCInvalid
	if isnull(@VendorKey, 0) = 0
		return @kErrCCInvalid 

	-- missing data
	select @PostingDate = @InvoiceDate
	select @DateReceived = @InvoiceDate
	select @DueDate = '1/1/2050'
	select @Description = substring(@ShortDescription, 1, 2000)
	--select @ApprovedByKey = @CreatedByKey -- let sptVoucherUpdateCC decide
	select @TermsDays = 0
	select @TermsNet = 30
	select @Status = 4 -- Approved as default, we will correct later 	
	select @SalesTaxAmount = isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0)
	select @VoucherTotal = isnull(@TotalCost,0) + isnull(@SalesTaxAmount, 0)

	if isnull(@ExchangeRate, 0) <=0
		select @ExchangeRate =1
	if isnull(@PExchangeRate, 0) <=0
		select @PExchangeRate =1
	if @PTotalCost is null
		select @PTotalCost = @TotalCost

	-- now call sptVoucherUpdateCC
	exec @VoucherKey = sptVoucherUpdateCC 0, -- VoucherKey
		@CompanyKey,
		@CreatedByKey,
		@VendorKey,
		@InvoiceDate,
		@PostingDate,
		@InvoiceNumber,
		@DateReceived,
		@TermsPercent,
		@TermsDays,
		@TermsNet,
		@DueDate,
		@ShortDescription, -- text field on the header, pass Short Description
		@ApprovedByKey,
		@APAccountKey,
		@ClassKey,
		@ProjectKey, --null, --@ProjectKey, -- because the regular UI does not allow it
		0, -- @Downloaded 
		@SalesTaxKey,
		@SalesTax2Key,
		@SalesTax1Amount,
		@SalesTax2Amount,
		@VoucherTotal,
		@GLCompanyKey,
		@OfficeKey,
		0, --@OpeningTransaction,
		@BoughtFromKey,
		@BoughtFrom,
		@BoughtByKey,
		@VoucherType,
		@Receipt,
		@CurrencyID,
		@ExchangeRate

	if @VoucherKey <= 0
		return @kErrVoucherBase + @VoucherKey
		 
	select @ApprovedByKey = ApprovedByKey from tVoucher (nolock) where VoucherKey = @VoucherKey

	if @ApprovedByKey = @CreatedByKey
		select @Status = 4 -- Approved
	else 
		select @Status = 2 -- submitted to approval

	-- because of these changes concerning the credit approvers, this can be null, if so, set status = 1
	if isnull(@ApprovedByKey, 0) = 0
		select @Status = 1

	update tVoucher set Status = @Status where VoucherKey = @VoucherKey

	-- now do insert in tVoucherDetail	
	declare @UnitDescription varchar(30)

	select @UnitDescription = UnitDescription 
	from   tItem (nolock)
	where  ItemKey = @ItemKey

	-- this will do the project rollup as well

	exec @RetVal = sptVoucherDetailInsertCC
		@VoucherKey ,
		null, --@ClientKey ,
		@ProjectKey ,
		@TaskKey ,
		@ItemKey ,
		@ClassKey ,
		@Description , -- 2000 chars on detail, pass truncated version
		@Quantity ,
		@UnitCost ,
		@UnitDescription ,
		@TotalCost ,
		@UnitRate ,
		@Billable ,
		@Markup ,
		@BillableCost ,
		@ExpenseAccountKey ,
		@Taxable ,
		@Taxable2 ,
		@SalesTax1Amount ,
		@SalesTax2Amount ,
		@OfficeKey ,
		@DepartmentKey,
		null, -- TargetGLCompanyKey
		1, -- @CheckProject
		@GrossAmount, 
		@PCurrencyID,
		@PExchangeRate,
		@PTotalCost,
		@Exclude1099,
		@VoucherDetailKey output

	if @RetVal <= 0
	begin
		exec sptVoucherDelete @VoucherKey
		return @kErrVoucherDetailBase + @RetVal
	end

	-- now post if approved
	if @Status = 4 and @PostMe = 1
		exec spGLPostVoucher @CompanyKey, @VoucherKey 

RETURN @VoucherKey
GO
