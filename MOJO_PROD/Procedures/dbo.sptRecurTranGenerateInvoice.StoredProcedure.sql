USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGenerateInvoice]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGenerateInvoice]
	(
	@CurrInvoiceKey int
	,@CompanyKey int
	,@NewInvoiceDate datetime	-- for invoice record
	,@CreateAsApproved int
	,@ProjectRollup int = 1
	
	,@RecurTranKey int
	,@NextDate datetime			-- for recur tran record
	,@NextNumberRemaining int	-- for recur tran record
	)
AS --Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel    What
  || 02/22/10 GHL 10.519 Creation for new recurring logic
  || 03/22/12 GWG 10.554 Added TargetGLCompanyKey to the copy
  || 09/19/13 MFT 10.572 (190447) Added	LayoutKey in INSERT statement
  || 09/27/13 GHL 10.572 Added currency info
  || 01/03/14 WDF 10.576 (188500) Added CreatedByKey, DateCreated to Insert tInvoice
  */
  	
	-- Constants
	declare @kErrInvoiceNotFound int		select @kErrInvoiceNotFound = 0
	declare @kErrValidateUseDetail int		select @kErrValidateUseDetail = -1
	declare @kErrGetTranNumber int			select @kErrGetTranNumber = -2
	declare @kErrUnexpected int				select @kErrUnexpected = -10

	if isnull(@CurrInvoiceKey, 0) <= 0
		return @kErrInvoiceNotFound

	-- Vars
	declare @RetVal int
	declare @Error int
	
	declare @NewInvoiceKey int
	declare @NewInvoiceLineKey int	
	declare @NewDueDate datetime
	declare @CurrInvoiceLineKey int	
	declare @CurrInvoiceDate datetime
	declare @CurrDueDate datetime
	declare @CurrDiffDays int
	declare @RecurringParentKey int

	-- Multi currency info
	declare @GLCompanyKey int
	declare @MultiCurrency int
	declare @HomeCurrencyID varchar(10)
	declare @CurrencyID varchar(10)
	declare @ExchangeRate decimal(24,7) 
	declare @RateHistory int
	
	select 	@CurrInvoiceDate = i.InvoiceDate
			,@CurrDueDate = i.DueDate
			,@RecurringParentKey = i.RecurringParentKey
			,@GLCompanyKey = i.GLCompanyKey
			,@CurrencyID = i.CurrencyID
			,@HomeCurrencyID = pref.CurrencyID
			,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	from	tInvoice i (nolock)
		inner join tPreference pref (nolock) on i.CompanyKey = pref.CompanyKey
	where	i.InvoiceKey = @CurrInvoiceKey
	
	if @@ROWCOUNT = 0
		return @kErrInvoiceNotFound
	
	Select @CurrDiffDays = datediff(d, @CurrInvoiceDate, @CurrDueDate)
	Select @NewDueDate = dateadd(d, @CurrDiffDays, @NewInvoiceDate)
			
	-- perform validation, cannot be recurring if the invoice has transaction details
	If Exists(Select 1 from tInvoiceLine (NOLOCK) Where InvoiceKey = @CurrInvoiceKey and BillFrom = 2)
		return @kErrValidateUseDetail 	
	
	-- logic for invoice number and approval
	declare @SetInvoiceNumberOnApproval int, @InvoiceNumberRequired int, @NextTranNo VARCHAR(100)
	  	
	Select @SetInvoiceNumberOnApproval = ISNULL(SetInvoiceNumberOnApproval, 0)
	from tPreference (NOLOCK) 
	Where CompanyKey = @CompanyKey

	-- Only case when Invoice Number is not required
	If @SetInvoiceNumberOnApproval = 1 And @CreateAsApproved = 0
		Select @InvoiceNumberRequired = 0
	Else
		Select @InvoiceNumberRequired = 1

	Begin Tran
	
	IF @InvoiceNumberRequired = 1
	 BEGIN					
		EXEC spGetNextTranNo
			@CompanyKey,
			'AR',		-- TranType
			@RetVal		      OUTPUT,
			@NextTranNo 		OUTPUT
	
		IF @RetVal <> 1
		Begin
			Rollback Tran
			RETURN @kErrGetTranNumber
		End
	END
	
	if isnull(@RecurringParentKey, 0) = 0
	begin
		Update tInvoice Set RecurringParentKey = @CurrInvoiceKey Where InvoiceKey = @CurrInvoiceKey
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected					   	
		end
	end
	

	select @ExchangeRate = 1

	if @MultiCurrency = 1 And  @CurrencyID is not null And @CurrencyID <> @HomeCurrencyID 
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @NewInvoiceDate, @ExchangeRate output, @RateHistory output


	-- Invoice header
	INSERT tInvoice
	(
		CompanyKey,
		ClientKey,
		ContactName,
		BillingContactKey,
		AdvanceBill,
		InvoiceNumber,
		InvoiceDate,
		PostingDate,
		DueDate,
		RecurringParentKey,
		TermsKey,
		ARAccountKey,
		GLCompanyKey,
		OfficeKey,
		ClassKey,
		ProjectKey,
		RetainerAmount,
		WriteoffAmount,
		DiscountAmount,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		TotalNonTaxAmount,
		InvoiceTotalAmount,
		AmountReceived,
		HeaderComment,
		SalesTaxKey,
		SalesTax2Key,
		InvoiceStatus,
		ApprovedDate,
		ApprovedByKey,
		ApprovalComments,
		Posted,
		Downloaded,
		InvoiceTemplateKey,
		LayoutKey,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		PrimaryContactKey,
		CurrencyID,
		ExchangeRate,
		CreatedByKey,
		DateCreated
	)
	Select
		CompanyKey,
		ClientKey,
		ContactName,
		BillingContactKey,
		AdvanceBill,
		RTRIM(@NextTranNo),
		@NewInvoiceDate,
		@NewInvoiceDate,
		@NewDueDate,
		RecurringParentKey,
		TermsKey,
		ARAccountKey,
		GLCompanyKey,
		OfficeKey,
		ClassKey,
		ProjectKey,
		0,
		0,
		DiscountAmount,
		SalesTaxAmount,
		SalesTax1Amount,
		SalesTax2Amount,
		TotalNonTaxAmount,
		InvoiceTotalAmount,
		0,
		HeaderComment,
		SalesTaxKey,
		SalesTax2Key,
		case when @CreateAsApproved = 1 then 4 else 1 end, --InvoiceStatus
		case when @CreateAsApproved = 1 then dbo.fFormatDateNoTime(GETDATE()) else null end, --ApprovedDate,
		ApprovedByKey,
		null, --ApprovalComments,
		0,
		0,
		InvoiceTemplateKey,
		LayoutKey,
		UserDefined1,
		UserDefined2,
		UserDefined3,
		UserDefined4,
		UserDefined5,
		UserDefined6,
		UserDefined7,
		UserDefined8,
		UserDefined9,
		UserDefined10,
		PrimaryContactKey,
		CurrencyID,
		@ExchangeRate, -- new exchange rate for the day
		CreatedByKey,
		DateCreated
	From tInvoice (nolock) Where InvoiceKey = @CurrInvoiceKey
	
	select @Error = @@ERROR, @NewInvoiceKey = @@Identity
	
	if @Error <> 0 
	begin
		rollback tran
		return @kErrUnexpected				   	
	end
			
	-- Invoice lines
	exec @RetVal = sptInvoiceGenerateRecurringLines @CurrInvoiceKey, @NewInvoiceKey, 0 , 0
	if @RetVal <> 1 
	begin
		rollback tran
		return @kErrUnexpected				   	
	end
	
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
			
	Commit Tran

	-- Rollups do not have to be in transaction
	
	exec sptInvoiceSummary @NewInvoiceKey	 
	
	If @ProjectRollup = 1
	begin
		-- Rollup for entity @InvoiceKey since same projects have been copied from that invoice to the other ones
		EXEC sptProjectRollupUpdateEntity 'tInvoice', @CurrInvoiceKey
	end
	
	RETURN @NewInvoiceKey
GO
