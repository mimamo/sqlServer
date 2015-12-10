USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRecurTranGenerateReceipt]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRecurTranGenerateReceipt]
	(
	@CurrCheckKey int
	,@CompanyKey int
	,@NewCheckDate datetime	-- for receipt record
	
	,@RecurTranKey int
	,@NextDate datetime			-- for recur tran record
	,@NextNumberRemaining int	-- for recur tran record

	)
	
AS --Encrypt

	SET NOCOUNT ON 
	
  /*
  || When     Who Rel    What
  || 02/23/10 GHL 10.519 Creation for new recurring logic                      
  || 03/22/12 GWG 10.554 Added TargetGLCompanyKey to the copy
  || 09/27/13 GHL 10.572 Added currency info
  */
  	
	-- Constants	
	declare @kErrCheckNotFound int			select @kErrCheckNotFound = 0
	declare @kErrAppliedToInvoice int		select @kErrAppliedToInvoice = -1
	declare @kErrUnexpected int				select @kErrUnexpected = -10

	if isnull(@CurrCheckKey, 0) <= 0
		return @kErrCheckNotFound
	
	Declare @Error int
	Declare @NewCheckKey int
	Declare @RecurringParentKey int
	Declare @ClientKey int
	Declare @ReferenceNumber varchar(100)		 
	Declare @NextTranNo VARCHAR(100)
	
	-- Multi currency info
	declare @GLCompanyKey int
	declare @MultiCurrency int
	declare @HomeCurrencyID varchar(10)
	declare @CurrencyID varchar(10)
	declare @ExchangeRate decimal(24,7) 
	declare @RateHistory int

	select 	@RecurringParentKey = c.RecurringParentKey
	       ,@ClientKey = c.ClientKey
	       ,@ReferenceNumber = RTRIM(LTRIM(c.ReferenceNumber))
		   ,@GLCompanyKey = c.GLCompanyKey
		   ,@CurrencyID = c.CurrencyID
		   ,@HomeCurrencyID = pref.CurrencyID
		   ,@MultiCurrency = isnull(pref.MultiCurrency, 0)
	from	tCheck c (nolock)
		inner join tPreference pref (nolock) on c.CompanyKey = pref.CompanyKey
	where	c.CheckKey = @CurrCheckKey
	
	if @@ROWCOUNT = 0
		return @kErrCheckNotFound
	
	if exists (select 1 from tCheckAppl (nolock) where CheckKey = @CurrCheckKey and isnull(InvoiceKey, 0) > 0)
		return @kErrAppliedToInvoice
		
	-- Get the next number
	Declare @CurCount int
	Select @CurCount = 1

	While 1=1
	BEGIN
		if ISNUMERIC(@ReferenceNumber) = 1 AND CHARINDEX('.',@ReferenceNumber) = 0 
			if Cast(@ReferenceNumber as float) < 2147483647 -- Check with a float to prevent overflow
				-- But use an int
				Select @NextTranNo = Cast(Cast(@ReferenceNumber as integer) + @CurCount as Varchar)
			else
				Select @NextTranNo = @ReferenceNumber + '-' + CAST(@CurCount as Varchar)
			
		else
			Select @NextTranNo = @ReferenceNumber + '-' + CAST(@CurCount as Varchar)
	
		if exists(Select 1 from tCheck (NOLOCK) Where ClientKey = @ClientKey and RTRIM(LTRIM(ReferenceNumber)) = @NextTranNo)
			Select @CurCount = @CurCount + 1
		else
			begin
				Select @CurCount = @CurCount + 1
				Break
			end
	END
	
	Begin Tran
		
	if isnull(@RecurringParentKey, 0) = 0
	begin
		Update tCheck Set RecurringParentKey = @CurrCheckKey Where CheckKey = @CurrCheckKey
		if @@ERROR <> 0 
		begin
			rollback tran
			return @kErrUnexpected					   	
		end
	end
	
	select @ExchangeRate = 1

	if @MultiCurrency = 1 And  @CurrencyID is not null And @CurrencyID <> @HomeCurrencyID 
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @CurrencyID, @NewCheckDate, @ExchangeRate output, @RateHistory output

	INSERT tCheck
	  (
	  ClientKey,
	  CompanyKey,
	  CheckAmount,
	  CheckDate,
	  PostingDate,
	  ReferenceNumber,
	  Description,
	  CashAccountKey,
	  ClassKey,
	  PrepayAccountKey,
	  Posted,
	  DepositKey,
	  CheckMethodKey,
	  GLCompanyKey,
	  OpeningTransaction,
	  RecurringParentKey,
	  CurrencyID,
	  ExchangeRate
	  )
	 SELECT
	  ClientKey,
	  CompanyKey,
	  CheckAmount,
	  @NewCheckDate,
	  @NewCheckDate, --PostingDate,
	  @NextTranNo, --ReferenceNumber,
	  Description,
	  CashAccountKey,
	  ClassKey,
	  PrepayAccountKey,
	  0,
	  null, --DepositKey,
	  CheckMethodKey,
	  GLCompanyKey,
	  OpeningTransaction,
	  RecurringParentKey,
	  CurrencyID,
	  @ExchangeRate -- new rate for the day	  
	 FROM tCheck (nolock)
	 WHERE CheckKey = @CurrCheckKey
	
	Select @Error = @@ERROR, @NewCheckKey = @@Identity
	If @Error <> 0
	begin
		rollback Tran
		return @kErrUnexpected
	end
	
	INSERT tCheckAppl 
		(
		CheckKey
		,InvoiceKey
		,SalesAccountKey
		,ClassKey
		,Description
		,Amount
		,Prepay
		,OfficeKey
		,DepartmentKey
		,TargetGLCompanyKey
		)
	SELECT
		@NewCheckKey
		,InvoiceKey
		,SalesAccountKey
		,ClassKey
		,Description
		,Amount
		,Prepay
		,OfficeKey
		,DepartmentKey
		,TargetGLCompanyKey 
	FROM tCheckAppl (nolock)
	WHERE  CheckKey = @CurrCheckKey
	
	If @@ERROR <> 0
	begin
		rollback Tran
		return @kErrUnexpected
	end
	
	
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
	
	RETURN @NewCheckKey
GO
