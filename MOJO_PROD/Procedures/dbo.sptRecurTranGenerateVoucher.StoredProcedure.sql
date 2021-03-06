USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGenerateVoucher]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGenerateVoucher]

	(
	@CurrVoucherKey int
	,@CompanyKey int
	,@NewInvoiceDate datetime	-- for invoice record
	,@CreateAsApproved int
	,@ProjectRollup int = 1
	
	,@RecurTranKey int
	,@NextDate datetime			-- for recur tran record
	,@NextNumberRemaining int	-- for recur tran record
	
	,@CreditCard int = 0
	)

AS --Encrypt
	
 	SET NOCOUNT ON
	
  /*
  || When     Who Rel    What
  || 02/22/10 GHL 10.519 Creation for new recurring logic        
  || 11/03/11 GHL 10.549 Added support of credit cards   
  || 03/22/12 GWG 10.554 Added TargetGLCompanyKey to the copy
  || 01/21/13 GHL 10.564 (165194) Starting now at @CurCount = 2 for Invoice Numbers which are strings 
  || 02/07/13 GHL 10.565 (167854) Added VoucherID for a customization for Spark44       
  || 09/27/13 GHL 10.572 Added currency info   
  || 10/16/13 GHL 10.573 Added new fields GrossAmount and Commission    
  || 06/11/14 GHL 10.581 (219307) Added protection against very large invoice numbers for credit cards  
  */

	-- Constants	
	declare @kErrVoucherNotFound int		select @kErrVoucherNotFound = 0
	declare @kErrValidateHasPO int			select @kErrValidateHasPO = -1
	declare @kErrValidateHasVoucherCC int	select @kErrValidateHasVoucherCC = -2
	declare @kErrUnexpected int				select @kErrUnexpected = -10

	if isnull(@CurrVoucherKey, 0) <= 0
		return @kErrVoucherNotFound
			
	-- Vars
	declare @RetVal int
	declare @Error int
	
	declare @NewVoucherKey int
	declare @NewVoucherDetailKey int	
	declare @NewDueDate datetime
	declare @CurrVoucherDetailKey int	
	declare @CurrInvoiceDate datetime
	declare @CurrDueDate datetime
	declare @CurrDiffDays int
	declare @RecurringParentKey int
	declare @VendorKey int
	declare @InvoiceNumber varchar(100)		 
	declare @NextTranNo VARCHAR(50)
	
	-- Multi currency info
	declare @GLCompanyKey int
	declare @MultiCurrency int
	declare @HomeCurrencyID varchar(10)
	declare @CurrencyID varchar(10)
	declare @ExchangeRate decimal(24,7) 
	declare @PCurrencyID varchar(10)
	declare @PExchangeRate decimal(24,7) 
	declare @RateHistory int

	select 	@CurrInvoiceDate = v.InvoiceDate
			,@CurrDueDate = v.DueDate
			,@RecurringParentKey = v.RecurringParentKey
			,@VendorKey = v.VendorKey
			,@InvoiceNumber = RTRIM(LTRIM(v.InvoiceNumber))
			,@GLCompanyKey = v.GLCompanyKey
		    ,@CurrencyID = v.CurrencyID
			,@PCurrencyID = v.PCurrencyID
		    ,@HomeCurrencyID = pref.CurrencyID
		    ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	from	tVoucher v (nolock)
		inner join tPreference pref (nolock) on v.CompanyKey = pref.CompanyKey
	where	v.VoucherKey = @CurrVoucherKey
	
	if @@ROWCOUNT = 0
		return @kErrVoucherNotFound			
			
	Select @CurrDiffDays = datediff(d, @CurrInvoiceDate, @CurrDueDate)
	Select @NewDueDate = dateadd(d, @CurrDiffDays, @NewInvoiceDate)
		
	if exists(select 1 from tVoucherDetail (NOLOCK) WHERE VoucherKey = @CurrVoucherKey 
			  and ISNULL(PurchaseOrderDetailKey, 0) > 0)
		return @kErrValidateHasPO

	if @CreditCard = 1
		if exists(select 1 from tVoucherCC (NOLOCK) WHERE VoucherCCKey = @CurrVoucherKey)
			return @kErrValidateHasVoucherCC

	-- Get the next number
	Declare @CurCount int
	Declare @AddToInvoiceNumber int
	if ISNUMERIC(@InvoiceNumber) = 1 AND CHARINDEX('.',@InvoiceNumber) = 0
		if Cast(@InvoiceNumber as float) < 2147483647 -- Check with a float to prevent overflow
			select @AddToInvoiceNumber =1
		else
			select @AddToInvoiceNumber = 0
	else
		select @AddToInvoiceNumber = 0

	if @AddToInvoiceNumber = 1
		select @CurCount =1 -- If we increment a number, start at 1
	else
		select @CurCount =2 -- users want to see 'Monthly Bill 2013-2' as first recurrence

	While 1=1
	BEGIN
		if ISNUMERIC(@InvoiceNumber) = 1 AND CHARINDEX('.',@InvoiceNumber) = 0 
			if Cast(@InvoiceNumber as float) < 2147483647 -- Check with a float to prevent overflow
				-- But use an int
				Select @NextTranNo = Cast(Cast(@InvoiceNumber as integer) + @CurCount as Varchar)
			else
				Select @NextTranNo = @InvoiceNumber + '-' + CAST(@CurCount as Varchar)
			
		else
		begin
			--careful with very large NextTranNo for credit cards
			--Select @NextTranNo = @InvoiceNumber + '-' + CAST(@CurCount as Varchar)
			declare @CurCountChar Varchar(50)
			declare @CurCountLen Int
			select @CurCountChar = CAST(@CurCount as Varchar(50))
			select @CurCountLen = len(@CurCountChar) 
			select @CurCountLen =  @CurCountLen + 1 -- for the dash 

			Select @NextTranNo = substring(@InvoiceNumber, 1, 50 - @CurCountLen)
			Select @NextTranNo = @NextTranNo + '-' + @CurCountChar
		end

		if exists(Select 1 from tVoucher (NOLOCK) Where VendorKey = @VendorKey and RTRIM(LTRIM(InvoiceNumber)) = @NextTranNo)
			Select @CurCount = @CurCount + 1
		else
			begin
				Select @CurCount = @CurCount + 1
				Break
			end
	END
	
	Begin Transaction

	if isnull(@RecurringParentKey, 0) = 0
	begin
		Update tVoucher Set RecurringParentKey = @CurrVoucherKey Where VoucherKey = @CurrVoucherKey
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected					   	
		end
	end

	Declare @VoucherID int
	if @CreditCard = 0
		Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 
		from tVoucher (nolock) Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 0
	
	select @ExchangeRate = 1

	if @MultiCurrency = 1 And  @CurrencyID is not null And @CurrencyID <> @HomeCurrencyID 
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @NewInvoiceDate, @ExchangeRate output, @RateHistory output

	select @PExchangeRate = 1

	if @MultiCurrency = 1 And  @PCurrencyID is not null And @PCurrencyID <> @HomeCurrencyID 
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @NewInvoiceDate, @PExchangeRate output, @RateHistory output


	-- Insert header	
	INSERT tVoucher
		(
		CompanyKey,
		VendorKey,
		InvoiceDate,
		PostingDate,
		InvoiceNumber,
		RecurringParentKey,
		DateReceived,
		DateCreated,
		APAccountKey,
		ClassKey,
		CreatedByKey,
		TermsPercent,
		TermsDays,
		TermsNet,
		DueDate,
		Description,
		VoucherTotal,
		AmountPaid,
		ApprovedDate,
		ApprovedByKey,
		Status,
		ApprovalComments,
		Posted,
		Downloaded,
		ProjectKey,
		GLCompanyKey,
		OfficeKey,
		SalesTaxKey,
		SalesTax2Key,
		SalesTax1Amount,
		SalesTax2Amount,
		SalesTaxAmount,

		VoucherType, -- for credit cards
		CreditCard,
		BoughtFromKey,
		BoughtFrom,
		BoughtByKey,
		VoucherID,
		CurrencyID,
		ExchangeRate,
		PCurrencyID,
		PExchangeRate
		)
	Select
		CompanyKey,
		VendorKey,
		@NewInvoiceDate,
		@NewInvoiceDate,
		@NextTranNo,
		RecurringParentKey,
		DateReceived,
		DateCreated,
		APAccountKey,
		ClassKey,
		CreatedByKey,
		TermsPercent,
		TermsDays,
		TermsNet,
		@NewDueDate,
		Description,
		VoucherTotal,
		0,
		case when @CreateAsApproved = 1 then dbo.fFormatDateNoTime(GETDATE()) else null end, --ApprovedDate,
		ApprovedByKey,
		case when @CreateAsApproved = 1 then 4 else 1 end, --Status
		null, --ApprovalComments,
		0,
		0,
		ProjectKey,
		GLCompanyKey,
		OfficeKey,
		SalesTaxKey,
		SalesTax2Key,
		SalesTax1Amount,
		SalesTax2Amount,
		SalesTaxAmount,
	
		VoucherType, -- for credit cards
		CreditCard,
		BoughtFromKey,
		BoughtFrom,
		BoughtByKey,
		@VoucherID,
		CurrencyID,
		@ExchangeRate, -- new rate for the day
		PCurrencyID,
		@PExchangeRate -- new rate for the day
		
	From tVoucher (nolock) Where VoucherKey = @CurrVoucherKey
	
	Select @Error = @@ERROR, @NewVoucherKey = @@Identity
	If @Error <> 0
	begin
		rollback Tran
		return @kErrUnexpected
	end
	
	INSERT tVoucherTax (VoucherKey, SalesTaxKey, SalesTaxAmount, Type)
	SELECT @NewVoucherKey, SalesTaxKey, SalesTaxAmount, Type
	FROM   tVoucherTax  (NOLOCK)
	WHERE  VoucherKey = @CurrVoucherKey	
	
	If @@ERROR <> 0
	begin
		rollback Tran
		return @kErrUnexpected
	end
	
	SELECT @CurrVoucherDetailKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @CurrVoucherDetailKey = MIN(VoucherDetailKey)
		FROM   tVoucherDetail (nolock)
		WHERE  VoucherDetailKey > @CurrVoucherDetailKey
		AND    VoucherKey = @CurrVoucherKey
		AND    TransferToKey IS NULL -- why copy transferred voucher lines?...No reason to 
		
		IF @CurrVoucherDetailKey IS NULL
			BREAK
		
		select @PCurrencyID = PCurrencyID from tVoucherDetail (nolock) where VoucherDetailKey = @CurrVoucherDetailKey	

		select @PExchangeRate = 1

		if @MultiCurrency = 1 And  @PCurrencyID is not null And @PCurrencyID <> @HomeCurrencyID 
			exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @NewInvoiceDate, @PExchangeRate output, @RateHistory output

		INSERT tVoucherDetail
			(
			VoucherKey,
			LineNumber,
			PurchaseOrderDetailKey,
			ProjectKey,
			TaskKey,
			ShortDescription,
			ItemKey,
			Quantity,
			UnitCost,
			UnitDescription,
			TotalCost,
			Billable,
			Markup,
			BillableCost,
			AmountBilled,
			InvoiceLineKey,
			WriteOff,
			ExpenseAccountKey,
			ClassKey,
			QuantityBilled,
			WIPPostingInKey,
			WIPPostingOutKey,
			TransferComment,
			OfficeKey,
			DepartmentKey,
			Taxable,
			Taxable2,
			SalesTaxAmount,
			SalesTax1Amount,
			SalesTax2Amount,
			TargetGLCompanyKey,
			PCurrencyID,
			PExchangeRate,
			PTotalCost,
			Commission,
			GrossAmount
			)
		SELECT
			@NewVoucherKey,
			LineNumber,
			NULL,
			ProjectKey,
			TaskKey,
			ShortDescription,
			ItemKey,
			Quantity,
			UnitCost,
			UnitDescription,
			TotalCost,
			Billable,
			Markup,
			BillableCost,
			0,
			NULL,
			0,
			ExpenseAccountKey,
			ClassKey,
			0,
			0,
			0,
			NULL,
			OfficeKey,
			DepartmentKey,
			Taxable,
			Taxable2,
			SalesTaxAmount,
			SalesTax1Amount,
			SalesTax2Amount,
			TargetGLCompanyKey,
			PCurrencyID,
			@PExchangeRate, -- new rate for the day
			PTotalCost,
			Commission,
			GrossAmount
			
		FROM tVoucherDetail (nolock) 
		Where VoucherDetailKey = @CurrVoucherDetailKey
	  
		SELECT @Error = @@ERROR, @NewVoucherDetailKey = @@IDENTITY
		If @Error <> 0
		begin
			rollback Tran
			return @kErrUnexpected
		end

		INSERT tVoucherDetailTax (VoucherDetailKey, SalesTaxKey, SalesTaxAmount)
		SELECT @NewVoucherDetailKey, SalesTaxKey, SalesTaxAmount
		FROM   tVoucherDetailTax  (NOLOCK)
		WHERE  VoucherDetailKey = @CurrVoucherDetailKey	

		If @@ERROR <> 0
		begin
			rollback Tran
			return @kErrUnexpected
		end
		
	END

	-- Recur tran record, but check if it exists so that CMP can reuse
	if isnull(@RecurTranKey, 0) > 0
	begin		
		update tRecurTran
		set    NextDate = @NextDate, NumberRemaining = @NextNumberRemaining 
		where  RecurTranKey = @RecurTranKey
		
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected				   	
		end
	end		
	
	Commit Transaction

	-- Rollup does not have to be in transaction

	If @ProjectRollup = 1
	begin
		-- Rollup for entity @VoucherKey since same projects have been copied from that voucher to the other ones
		EXEC sptProjectRollupUpdateEntity 'tVoucher', @CurrVoucherKey
	end

	return @NewVoucherKey
GO
