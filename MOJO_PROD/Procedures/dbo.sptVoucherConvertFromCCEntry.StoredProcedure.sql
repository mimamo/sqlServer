USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVoucherConvertFromCCEntry]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVoucherConvertFromCCEntry]
	(
	@CCEntryKey int
	,@PostingDate smalldatetime
	,@CreatedByKey int
	)

AS --Encrypt

/*
|| When     Who Rel      What
|| 03/14/12 GHL 10.554   Creation to convert a credit card entry to a voucher of type credit card
||                       Inserts: header + single line
||                       Returns:
||                       - Success: CCVoucherKey >0
||                       - Error: <0 
||03/15/12  GHL 10.554   Added posting of CC charge if approved
||03/15/12  GHL 10.554   Added check of current CC charge for the entry
||04/12/12  MAS 10.554   No need to flip the amount from negative to positive as we're doing it on the import now.
||6/27/12   CRG 10.5.5.7 Now getting OfficeKey, DepartmentKey, and ExpenseAccountKey from tCCEntry
||6/28/12   CRG 10.5.5.7 Now getting Overhead from tCCEntry
||7/3/12    CRG 10.5.5.7 Now using the FITID from tCCEntry for the Invoice Number
||7/9/12    GWG 10.5.5.7 Added class ID and sales tax amounts
||8/29/12   GHL 10.5.5.9 Added conversion of attachments + fixed inserts of tVoucherCC rec
||8/30/12   GHL 10.5.5.9 Reviewed logic for tVoucherDetail and tVoucherCC records
||                       Only 1 detail type (tVoucherDetail Or tVoucherCC) can be inserted 
||                       and the sum of the amounts must be equal to tCCEntry.Amount 
||                       Had to use sptVoucherUpdateCC, sptVoucherDetailInsertCC, sptVoucherCCUpdate instead of
||                       sptVoucherInsertCC (both voucher and detail) and sptVoucherCCUpdate
||9/5/12    GHL 10.5.5.9 (153478) Purchased From = Payee Name (tVoucher.BoughtFrom = tCCEntry.PayeeName)
||9/7/12    GHL 10.5.5.9 When deleting credit card charge, call sptVoucherDeleteCC rather than sptVoucherDelete
||9/10/12   GHL 10.5.6.0 (149891) Added logic for split projects and split vouchers
||9/18/12   GHL 10.5.6.0 (154747) Getting now Billable from tCCEntry
||09/19/12  GHL 10.5.6.0 Increased Memo to 2000 
||12/05/12  MAS 10.5.6.3 (160939) Now Getting Receipt from tCCEntry 
||01/10/13  MAS 10.5.6.4 (160998) Using tProject.GetMarkUpFrom instead tProject.GetMarkUpFrom to determine which Markup we should use 
||03/12/13  GHL 10.5.6.6 (168704) Allowing now splits with same projects 
||04/08/13  RLB 10.5.6.7 (173228) If there is a BrougtByKey set the Payee to that 
||05/10/13  GWG 10.5.6.7 Striping time off of the invoice date
||05/20/13  RLB 10.5.6.8 (178619) Adding some error messages
||08/28/13  WDF 10.5.7.1 (179763) Add PostingDate
||11/22/13  GHL 10.5.7.4  Added multi currency logic 
||03/22/14  RLB 10.5.7.8 (203504) Added field for enhancement. Which one??? Exclude1099
||06/16/14  GHL 10.5.8.1 (219726) Checking now if the user has the right to post before posting
||07/03/14  KMC 10.5.8.1 (221513) Added sptProjectRollupUpdate for vouchers
||10/29/14  GAR 10.5.8.5 (225553) Added the project number to the header record so users can report on the project ID and name
						 from the CC listing screen.
*/

	SET NOCOUNT ON

	declare @kErrTaskNoBudget int			select @kErrTaskNoBudget = -1			-- from sptVoucherInsertCC
	declare @kErrCCInvalid int				select @kErrCCInvalid = -2				-- from sptVoucherInsertCC, invalid CC card in tGLAccount
	declare @kErrCCEntryInvalid int			select @kErrCCEntryInvalid = -3			-- invalid Credit Card entry
	declare @kErrCCChargeAlreadyExists int	select @kErrCCChargeAlreadyExists = -4	-- Credit Card charge already exists for that entry
	declare @kErrTaxWithVoucher int			select @kErrTaxWithVoucher = -5
	declare @kErrProjectWithVoucher int		select @kErrProjectWithVoucher = -6
	declare @kErrOpenAmountVoucher int		select @kErrOpenAmountVoucher = -7
	declare @kErrGLCompanyOnProject int     select @kErrGLCompanyOnProject = -8
	declare @kErrGLCompanyOnVoucher int     select @kErrGLCompanyOnVoucher = -9
	declare @kErrGLCompanyOnOffice int      select @kErrGLCompanyOnOffice = -10
	declare @kErrAmountOnSplits int			select @kErrAmountOnSplits = -11
	declare @kErrCurrencyOnVoucher int      select @kErrCurrencyOnVoucher = -12

	declare @kErrVoucherBase int					select @kErrVoucherBase = -1000
	declare @kErrVoucherDetailBase int				select @kErrVoucherDetailBase = -2000
	declare @kErrVoucherDetailProjectExpense int	select @kErrVoucherDetailProjectExpense = -2002
	declare @kErrVoucherDetailVoucherPosted int		select @kErrVoucherDetailVoucherPosted = -2003

	declare @RetVal int
	declare @CCVoucherKey int
	declare @VoucherKey int
	declare @PrefClassKey int
	declare @ProjectClassKey int
	declare @CCEntryClassKey int
	declare @UseClass int
	declare @UseGLCompany int
	declare @RestrictToGLCompany int
	declare @PrefExpenseAccountFromItem int
	declare @PrefExpenseAccountKey int
	declare @VendorExpenseAccountKey int
	declare @ItemExpenseAccountKey int
	declare @Amount money
	declare @Key int
	declare @VDProjectKey int
	declare @VDTaskKey int


	-- Vars needed to create the CC voucher

	-- Header info
	declare	@CompanyKey int,
	@APAccountKey int, -- Credit Card account key
	@InvoiceNumber varchar(50),
	@GLCompanyKey int,
	@VendorKey int,
	@BoughtByKey int,
	@BoughtFromKey int,
	@BoughtFrom varchar(250),
	@InvoiceDate smalldatetime,
	@Overhead tinyint,
	@SalesTaxKey int,
	@SalesTax2Key int,
	@Receipt tinyint,

	-- detail Info
	@VoucherDetailKey int,
	@ItemKey int,
	@Quantity decimal(24,4), 
	@UnitCost money,
	@TotalCost money,
	@PTotalCost money, -- Project Net
	@Billable tinyint,
	@Markup decimal(24,4),
	@UnitRate money,
	@GrossAmount money,
	@BillableCost money, -- Project Gross
	@ShortDescription varchar(2000), -- text cannot be declared
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
	@PostMe tinyint

declare @CCVoucherTotal money -- on credit card 
declare @ApplyVoucher int -- 0 create voucher detail, 1 apply voucher
declare @SplitProjects int
declare @SplitVouchers int

declare @MultiCurrency int
declare @CurrencyID varchar(10)
declare @PCurrencyID varchar(10)
declare @ExchangeRate decimal(24,7)	 
declare @PExchangeRate decimal(24,7)
declare @RateHistory int

-- get all info we need from tCCEntry
select @CompanyKey = CompanyKey
      ,@GLCompanyKey = GLCompanyKey
	  ,@ProjectKey = ProjectKey
	  ,@TaskKey = TaskKey
	  ,@VoucherKey = VoucherKey -- user wants to apply to voucher, we will calc amount to apply
	  ,@ItemKey = ItemKey
      ,@UnitCost = Amount
	  ,@TotalCost = Amount
	  ,@CCVoucherTotal = isnull(Amount, 0)
	  ,@InvoiceDate = dbo.fFormatDateNoTime(TransactionPostedDate)
	  ,@ShortDescription = Memo -- will be set on header and detail
	  ,@BoughtByKey = ChargedByKey
	  ,@APAccountKey = GLAccountKey
	  ,@BoughtFromKey = VendorKey
	  ,@BoughtFrom = PayeeName
	  ,@CCVoucherKey = CCVoucherKey
	  ,@OfficeKey = OfficeKey
	  ,@DepartmentKey = DepartmentKey
	  ,@ExpenseAccountKey = ExpenseAccountKey
	  ,@Overhead = ISNULL(Overhead, 0)
	  ,@InvoiceNumber = FITID
	  ,@CCEntryClassKey = ClassKey
	  ,@SalesTaxKey = SalesTaxKey
	  ,@SalesTax2Key = SalesTax2Key
	  ,@SalesTax1Amount = isnull(SalesTaxAmount, 0)
	  ,@SalesTax2Amount = isnull(SalesTax2Amount, 0)
	  ,@SplitProjects = isnull(SplitProjects, 0)
	  ,@SplitVouchers = isnull(SplitVouchers, 0)
	  ,@Billable = isnull(Billable, 0)
	  ,@Receipt = isnull(Receipt, 0)
from   tCCEntry (nolock)
where  CCEntryKey = @CCEntryKey


set @PostingDate = isnull(@PostingDate, @InvoiceDate)

select @UseClass = pref.UseClass
        ,@PrefClassKey = pref.DefaultClassKey 
		,@PrefExpenseAccountKey = pref.DefaultExpenseAccountKey 
		,@PrefExpenseAccountFromItem = isnull(pref.DefaultExpenseAccountFromItem, 0)
		,@UseGLCompany = isnull(pref.UseGLCompany, 0)
		,@RestrictToGLCompany = isnull(pref.RestrictToGLCompany, 0)
		,@MultiCurrency = isnull(pref.MultiCurrency, 0)
from  tPreference pref (nolock)
where pref.CompanyKey = @CompanyKey	

-- init exch rates to 1
select @ExchangeRate = 1
		,@PExchangeRate = 1

if @MultiCurrency = 1
begin
	select @CurrencyID = CurrencyID from tGLAccount (nolock) where GLAccountKey = @APAccountKey

	-- get the exchange rate 
	if isnull(@CurrencyID, '') <> ''
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @InvoiceDate, @ExchangeRate output, @RateHistory output
	else
		select @ExchangeRate = 1
end

create table #voucher(VoucherKey int null, Amount money null, VoucherTotal money null, OpenAmount money null
					, CurrencyID varchar(10) null)
create table #project(ProjectID int identity(1,1), ProjectKey int null, TaskKey int null
					  ,Amount money null, UnitCost money null, TotalCost money null 
					  ,SalesTax1Amount money null, SalesTax2Amount money null
					  ,CurrencyID varchar(10) null, ExchangeRate decimal(24,7) null)

/*
	Before we start, perform a series of validation
*/

if @SplitProjects = 1 and not exists 
	(select 1 from tCCEntrySplit (nolock) where CCEntryKey = @CCEntryKey and isnull(ProjectKey, 0) > 0)
	select @SplitProjects = 0

if @SplitVouchers = 1 and not exists 
	(select 1 from tCCEntrySplit (nolock) where CCEntryKey = @CCEntryKey and isnull(VoucherKey, 0) > 0)
	select @SplitVouchers = 0

-- Cannot have projects and vouchers at same time

if ((isnull(@ProjectKey, 0) + @SplitProjects) > 0) and ((isnull(@VoucherKey, 0)  + @SplitVouchers) > 0)
	return @kErrProjectWithVoucher

-- Cannot have taxes with vouchers
if (@SalesTaxKey > 0 OR @SalesTax2Key > 0) and ((isnull(@VoucherKey, 0) + @SplitVouchers) > 0) 
	return @kErrTaxWithVoucher

-- check gl companies on projects and vouchers
if @UseGLCompany = 1 and isnull(@ProjectKey, 0) > 0 and exists (
		select 1 from tProject (nolock) where ProjectKey = @ProjectKey
		and isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
		)
	return @kErrGLCompanyOnProject

if @UseGLCompany = 1 and isnull(@VoucherKey, 0) > 0 and exists (
		select 1 from tVoucher (nolock) where VoucherKey = @VoucherKey
		and isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
		)
	return @kErrGLCompanyOnVoucher

if @UseGLCompany = 1 and @SplitProjects > 0 and exists (
		select 1 from tProject p (nolock)
			inner join tCCEntrySplit  ccs (nolock) on ccs.CCEntryKey = @CCEntryKey and ccs.ProjectKey = p.ProjectKey  
		where isnull(p.GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
		)
	return @kErrGLCompanyOnProject

if @UseGLCompany = 1 and @SplitVouchers > 0 and exists (
		select 1 from tVoucher v (nolock)
			inner join tCCEntrySplit  ccs (nolock) on ccs.CCEntryKey = @CCEntryKey and ccs.VoucherKey = v.VoucherKey   
		where isnull(v.GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
		)
	return @kErrGLCompanyOnVoucher

-- check gl companies on offices
if @RestrictToGLCompany = 1 and isnull(@OfficeKey, 0) > 0 and not exists (
		select 1 
		from tGLCompanyAccess (nolock) where Entity = 'tOffice' and EntityKey = @OfficeKey and GLCompanyKey = isnull(@GLCompanyKey, 0) 
		)
	return @kErrGLCompanyOnOffice

-- check amounts in splits
if @CCVoucherTotal <> (select sum(Amount) from tCCEntry (nolock) where CCEntryKey = @CCEntryKey)
	return @kErrAmountOnSplits

if isnull(@VoucherKey, 0) > 0 Or @SplitVouchers > 0 
	select @ApplyVoucher = 1 	 
else
	select @ApplyVoucher = 0

-- check open amounts on vouchers
if @ApplyVoucher = 1
begin
	if isnull(@VoucherKey, 0) > 0
		insert #voucher (VoucherKey, Amount) values (@VoucherKey, @CCVoucherTotal)

	if @SplitVouchers = 1
		insert #voucher (VoucherKey, Amount) 
		select VoucherKey, Amount
		from   tCCEntrySplit (nolock)
		where  CCEntryKey = @CCEntryKey

	update #voucher
	set    #voucher.OpenAmount = isnull(v.VoucherTotal, 0) - isnull(v.AmountPaid, 0)
	      ,#voucher.VoucherTotal = isnull(v.VoucherTotal, 0)
		  ,#voucher.CurrencyID = v.CurrencyID
	from   tVoucher v (nolock)
	where  #voucher.VoucherKey = v.VoucherKey

	-- vouchers and credit card charges must have the same currency
	if exists (select 1 from #voucher where isnull(CurrencyID, '') <> isnull(@CurrencyID, '') )
		return @kErrCurrencyOnVoucher

	if exists (select 1 from #voucher where VoucherTotal >=0 and Amount > OpenAmount)
		return @kErrOpenAmountVoucher

	if exists (select 1 from #voucher where VoucherTotal <0 and Amount < OpenAmount)
		return @kErrOpenAmountVoucher

end

select @VendorKey = VendorKey from tGLAccount (nolock) where GLAccountKey = @APAccountKey
if @@ROWCOUNT = 0
	return @kErrCCEntryInvalid

if isnull(@CCVoucherKey, 0) >0
	return @kErrCCChargeAlreadyExists



if @ApplyVoucher = 0
begin
	-- if we do not apply a voucher
	-- we may or may not have a project

	--subtract the taxes
	Select @UnitCost = @UnitCost - @SalesTax1Amount - @SalesTax2Amount
	Select @TotalCost = @UnitCost

	if @SplitProjects = 0
		insert #project (ProjectKey, TaskKey, Amount, UnitCost, TotalCost, SalesTax1Amount, SalesTax2Amount) 
		values (isnull(@ProjectKey, 0), @TaskKey, @CCVoucherTotal, @UnitCost, @TotalCost, @SalesTax1Amount, @SalesTax2Amount)
	else
	begin
		insert #project (ProjectKey, TaskKey, Amount) 
		select  ProjectKey, TaskKey, Amount
		from   tCCEntrySplit (nolock)
		where  CCEntryKey = @CCEntryKey

	/*
	create table #project(ProjectKey int null, Amount money null, UnitCost money null, TotalCost money null, BillableCost money null
					, SalesTax1Amount money null, SalesTax2Amount money null)
	*/

		-- assign taxes proportionally to Amount
		if (@CCVoucherTotal <> 0) 
		begin
			update #project 
			set    SalesTax1Amount = ROUND((@SalesTax1Amount * Amount) / @CCVoucherTotal, 2)

			update #project 
			set    SalesTax2Amount = ROUND((@SalesTax2Amount * Amount) / @CCVoucherTotal, 2) 	

			-- handle rounding errors
			select @Amount = sum(SalesTax1Amount) from #project
			select @Amount = @SalesTax1Amount - @Amount

			if @Amount <> 0
			begin
				select @Key = min(ProjectKey) from #project
				update #project set SalesTax1Amount = SalesTax1Amount + @Amount where ProjectKey = @Key
			end

			-- handle rounding errors
			select @Amount = sum(SalesTax2Amount) from #project
			select @Amount = @SalesTax2Amount - @Amount

			if @Amount <> 0
			begin
				select @Key = min(ProjectKey) from #project
				update #project set SalesTax2Amount = SalesTax2Amount + @Amount where ProjectKey = @Key
			end

			update #project
			set    UnitCost = isnull(Amount, 0) - isnull(SalesTax1Amount, 0) - isnull(SalesTax2Amount, 0) 
			      ,TotalCost =isnull(Amount, 0) - isnull(SalesTax1Amount, 0) - isnull(SalesTax2Amount, 0)
		end 

	end
end

-- now get the exchange rates for the project

-- by default, exch rate is 1
update #project 
set    #project.ExchangeRate = 1

declare @ProjectID int -- cannot use ProjectKey because they may have the same project/ diff task 

if @MultiCurrency = 1
begin

	update #project 
	set    #project.CurrencyID = p.CurrencyID
	from   tProject p (nolock)
	where  #project.ProjectKey = p.ProjectKey

	
	select @ProjectID = -1

	while (1=1)
	begin

		select @ProjectID = min(ProjectID)
		from   #project
		where  ProjectID > @ProjectID

		if @ProjectID is null
			break

		select @PCurrencyID = CurrencyID 
		from   #project
		where  ProjectID = @ProjectID

		if isnull(@PCurrencyID, '') <> ''
		begin
			-- if the project currency is the same as the CC charge, use the same exch rate 
			if isnull(@PCurrencyID, '') = isnull(@CurrencyID, '')
			begin
				select @PExchangeRate = @ExchangeRate
			end
			else
			begin
				exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @InvoiceDate, @PExchangeRate output, @RateHistory output	
			end
		
			update  #project
			set     ExchangeRate = @PExchangeRate
			where   ProjectID = @ProjectID
		end
		
		 
	end

end


-- other defaults
select   @Quantity = 1 
	    ,@Markup = 0
	    ,@UnitRate = 0
	    ,@BillableCost = 0
	    ,@Taxable = 0
	    ,@Taxable2 = 0
		,@PostMe = 0

if @SalesTaxKey > 0
	Select @Taxable = 1
if @SalesTax2Key > 0
	Select @Taxable2 = 1


/*
	1) for expense account key do like in spGetDfltExpenseGLAcct
*/


-- if there is a BroughtFromKey that should be the BroughtFrom Name
if ISNULL(@BoughtFromKey, 0) > 0
	select @BoughtFrom = CompanyName, 
		@VendorExpenseAccountKey = DefaultExpenseAccountKey
	from tCompany (nolock)
	where CompanyKey = @BoughtFromKey

If @PrefExpenseAccountFromItem = 1 And @ItemKey > 0
	Select @ItemExpenseAccountKey = ExpenseAccountKey
	From   tItem (nolock)
	Where  ItemKey = @ItemKey
Else
	Select @ItemExpenseAccountKey = 0


if isnull(@ExpenseAccountKey, 0) = 0
begin
	-- try to get it from the item
	if isnull(@ItemExpenseAccountKey, 0) > 0
		select @ExpenseAccountKey = @ItemExpenseAccountKey

	--otherwise try to get it from the vendor
	if isnull(@ExpenseAccountKey, 0) = 0 and isnull(@VendorExpenseAccountKey, 0) > 0 
		select @ExpenseAccountKey = @VendorExpenseAccountKey

	--otherwise try to get it from the company
	if isnull(@ExpenseAccountKey, 0) = 0  
		select @ExpenseAccountKey = @PrefExpenseAccountKey
end

/*
	2) Now Markup and UnitRate, do like in Functions.GetPurchaseMarkup
	will be completed in the project loop
*/

	declare @kGetMarkupFromClient int             select @kGetMarkupFromClient = 1
	declare @kGetMarkupFromProject int            select @kGetMarkupFromProject = 2
	declare @kGetMarkupFromItem int				select @kGetMarkupFromItem = 3
	declare @kGetMarkupFromItemRateSheet int		select @kGetMarkupFromItemRateSheet = 4
	declare @kGetMarkupFromTask int               select @kGetMarkupFromTask = 5

	DECLARE @GetMarkupFrom INT
           ,@ItemRateSheetKey INT
		   ,@ClientKey INT
		   ,@UseUnitRate INT
           ,@ProjectMarkup decimal(24,4)
		   ,@ItemMarkup decimal(24,4)
		   ,@ItemUnitRate decimal(24,4)
		   ,@RateSheetMarkup decimal(24,4)
		   ,@RateSheetUnitRate decimal(24,4)

	-- this can be done now because not project specific
	if isnull(@ItemKey, 0) > 0
	begin
		select @UseUnitRate = UseUnitRate
		      ,@ItemMarkup = Markup
			  ,@ItemUnitRate = UnitRate
		from   tItem (nolock)
		where  ItemKey = @ItemKey
	end
	else
	begin
		select @UseUnitRate = 0
		      ,@ItemMarkup = 0
			  ,@ItemUnitRate = 0
	end

	/*
	3) Now perform insert in tVoucher
	*/

	EXEC @CCVoucherKey = sptVoucherUpdateCC
		0,
		@CompanyKey,
		@CreatedByKey,
		@VendorKey,
		@InvoiceDate,
		@PostingDate,
		@InvoiceNumber,
		@InvoiceDate,
		0, -- @TermsPercent
		0, -- @TermsDays
		30, --@TermsNet
	    '1/1/2050', -- @DueDate
		@ShortDescription,
		null, -- @ApprovedByKey  -- let sptVoucherUpdateCC decide
		@APAccountKey,
		@CCEntryClassKey,
		@ProjectKey, --null, --@ProjectKey, -- because the regular UI does not allow it
		0, -- @Downloaded 
		@SalesTaxKey,
		@SalesTax2Key,
		@SalesTax1Amount,
		@SalesTax2Amount,
		@CCVoucherTotal, --@VoucherTotal on cc 
		@GLCompanyKey,
		@OfficeKey,
		0, --@OpeningTransaction,
		@BoughtFromKey,
		@BoughtFrom,
		@BoughtByKey,
		@Overhead, --@VoucherType,
		@Receipt,
		@CurrencyID,
		@ExchangeRate

	if @CCVoucherKey <= 0
		return @kErrVoucherBase

	-- connect the 2
	update tVoucher
	set    CCEntryKey = @CCEntryKey
	where  VoucherKey = @CCVoucherKey

	update tCCEntry
	set    CCVoucherKey = @CCVoucherKey
	where  CCEntryKey = @CCEntryKey

	-- convert the attachments
	update tAttachment
	set    AssociatedEntity = 'tVoucher'
	     ,EntityKey = @CCVoucherKey
	where  AssociatedEntity = 'tCCEntry'
	and    EntityKey = @CCEntryKey

	declare @ApprovedByKey int
	declare @Status int

	select @ApprovedByKey = ApprovedByKey from tVoucher (nolock) where VoucherKey = @CCVoucherKey

	if @ApprovedByKey = @CreatedByKey
		select @Status = 4 -- Approved
	else 
		select @Status = 2 -- submitted to approval

	update tVoucher set Status = @Status where VoucherKey = @CCVoucherKey


	/*
	4) Now perform insert in tVoucherdetail
	*/

if @ApplyVoucher = 0 
begin
	select @ProjectID = -1

	while (1=1)
	begin

		select @ProjectID = min(ProjectID)
		from   #project
		where  ProjectID > @ProjectID

		if @ProjectID is null
			break

		-----------------------------------------------------
		-- capture the net and tax/task info for each project
		----------------------------------------------------

		select @UnitCost = UnitCost
		      ,@TotalCost = TotalCost
			  ,@SalesTax1Amount = SalesTax1Amount
			  ,@SalesTax2Amount = SalesTax2Amount
			  ,@TaskKey = TaskKey
			  ,@ProjectKey = ProjectKey
			  ,@PCurrencyID = CurrencyID
			  ,@PExchangeRate = ExchangeRate
		from   #project
		where  ProjectID = @ProjectID

		------------------------------------------
		-- now get the gross info for each project
		------------------------------------------

		select   @Quantity = 1 
			,@Markup = 0
			,@UnitRate = 0
			,@BillableCost = 0
			,@GrossAmount = 0
			,@PTotalCost = 0

		-- All this below is project specific


		select @GetMarkupFrom = @kGetMarkupFromItem -- by default get it from item


		if isnull(@ProjectKey, 0) > 0
		begin
			SELECT @GetMarkupFrom = ISNULL(GetMarkupFrom, @kGetMarkupFromItem) 
					,@ItemRateSheetKey = ISNULL(ItemRateSheetKey, 0)
					,@ClientKey = ClientKey
					,@ProjectMarkup = ItemMarkup	
					,@ProjectClassKey = ClassKey	   
			FROM   tProject (NOLOCK)  
			WHERE  ProjectKey = @ProjectKey
		end

		if @GetMarkupFrom = @kGetMarkupFromClient
		begin
			if isnull(@ClientKey, 0) = 0 
				select @Markup = 0
			else
				select @Markup = ItemMarkup
				from   tCompany (nolock)
				where  CompanyKey = @ClientKey
		end

		if @GetMarkupFrom = @kGetMarkupFromProject
		begin
			select @Markup = @ProjectMarkup
		end 

		if @GetMarkupFrom = @kGetMarkupFromItem
		begin
			if isnull(@ItemKey, 0) = 0
				select @Markup = 0
			else
				select @Markup = @ItemMarkup
		end 

		if @GetMarkupFrom = @kGetMarkupFromItemRateSheet
		begin
			if isnull(@ItemRateSheetKey, 0) = 0 Or isnull(@ItemKey, 0) = 0
				select @Markup = 0
			else
			begin
				select @RateSheetMarkup = Markup
						,@RateSheetUnitRate = UnitRate
				from   tItemRateSheetDetail (nolock)
				where  ItemRateSheetKey = @ItemRateSheetKey
				and    ItemKey = @ItemKey

				-- like sptItemRateSheetDetailGetRate
				if @RateSheetMarkup is null
					select @RateSheetMarkup = @ItemMarkup
				if @RateSheetUnitRate is null
					select @RateSheetUnitRate = @ItemUnitRate

				select @Markup = @RateSheetMarkup
			end
		end 

		if @GetMarkupFrom = @kGetMarkupFromTask
		begin
			if isnull(@TaskKey, 0) = 0 
				select @Markup = 0
			else
			begin
				select @Markup = Markup
				from   tTask (nolock)
				where  TaskKey = @TaskKey 
			end
		end

		select @Markup = isnull(@Markup, 0)
		select @UnitRate = isnull(@UnitRate, 0)
		select @UnitCost = isnull(@UnitCost, 0)

		-- UnitRate same as voucher_expense.aspx

		if @UseUnitRate = 1
		begin
			-- we have to recalc markup from UnitRate
			if @GetMarkupFrom = @kGetMarkupFromItemRateSheet
				select @UnitRate = isnull(@RateSheetUnitRate, 0)
			else
				select @UnitRate = isnull(@ItemUnitRate, 0)

			if @UnitRate <> 0 And @UnitCost <> 0
			begin
				select @Markup = ((@UnitRate - @UnitCost) / @UnitCost) * 100.0
			end	
		end
		else
		begin
			-- we have to recalc UnitRate from Markup
			select @UnitRate = @UnitCost * (1.0 + (@Markup / 100.0))
		end

		if @Billable = 1
		begin
			select @GrossAmount = ROUND(@Quantity * @UnitRate, 2)
		end

		-- now multicurrency stuff
		if isnull(@PExchangeRate, 0) <= 0
			select @PExchangeRate = 1

		select @BillableCost = (isnull(@GrossAmount, 0) * @ExchangeRate) / @PExchangeRate
		select @PTotalCost = (isnull(@TotalCost, 0) * @ExchangeRate) / @PExchangeRate
		select @BillableCost = ROUND(@BillableCost, 2)
		select @PTotalCost = ROUND(@PTotalCost, 2)

		-------------
		-- Class info
		-------------

		if @UseClass = 1
		begin
			select @ClassKey = @CCEntryClassKey 

			if isnull(@ClassKey, 0) = 0 and isnull(@ProjectKey, 0) > 0
			begin
				if isnull(@ProjectClassKey, 0) > 0
					select @ClassKey = @ProjectClassKey
			end

			if isnull(@ClassKey, 0) = 0
				select @ClassKey = @PrefClassKey
		end
		else 
			select @ClassKey = null

		-- convert 0 into null
		select @VDProjectKey = @ProjectKey
		if @VDProjectKey = 0
			select @VDProjectKey = null

		select @VDTaskKey = @TaskKey
		if @VDTaskKey = 0
			select @VDTaskKey = null

		exec @RetVal = sptVoucherDetailInsertCC
			@CCVoucherKey ,
			null, --@ClientKey ,
			@VDProjectKey ,
			@VDTaskKey ,
			@ItemKey ,
			@ClassKey ,
			@ShortDescription ,
			@Quantity ,
			@UnitCost ,
			null, --@UnitDescription ,
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
			0, --- Exclude1099 added option
			@VoucherDetailKey output

		if @RetVal <= 0
		begin
			exec sptVoucherDeleteCC @CCVoucherKey
			if @RetVal = -2
				return @kErrVoucherDetailProjectExpense 
			if @RetVal = -3
				return @kErrVoucherDetailVoucherPosted 
			if @RetVal = -1
				return @kErrVoucherDetailBase  
		end

	end
end



	/*
	5) Now take in account VoucherKey to apply
	*/


	if @ApplyVoucher = 1
	begin
		select @VoucherKey = -1
		while (1=1)
		begin
			select @VoucherKey = min(VoucherKey)
			from   #voucher
			where  VoucherKey > @VoucherKey

			if @VoucherKey is null
				break

			select @Amount = Amount 
			from   #voucher
			where  VoucherKey = @VoucherKey

			exec sptVoucherCCUpdate @CCVoucherKey, @VoucherKey, @Amount, 1 -- 1 indicates to create temp tables required
		end
	end

	-- only now that we can post
	declare @CanPost int
	select @CanPost = 0

	declare @Administrator int
	declare @SecurityGroupKey int

	select @Administrator = Administrator
	      ,@SecurityGroupKey = SecurityGroupKey
	from   tUser (nolock) where UserKey = @CreatedByKey

	if @Administrator = 1
		select @CanPost = 1

	if exists (select 1 from tRight r (nolock)
					inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey 
						and ra.EntityKey = @SecurityGroupKey and ra.EntityType ='Security Group'
				   where r.RightID = 'gl_post'
				   )
		select @CanPost = 1

	if @Status = 4 and @CanPost = 1
		exec spGLPostVoucher @CompanyKey, @CCVoucherKey 

	/*
	6) Perform the project rollup for the vouchers
	*/

	exec sptProjectRollupUpdate @ProjectKey, 4, 1, 1, 1, 1

RETURN isnull(@CCVoucherKey, 0)
GO
