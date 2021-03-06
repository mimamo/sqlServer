USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerUpdate]
	@RetainerKey int,
	@UserKey int,
	@CompanyKey int,
	@ClientKey int,
	@Title varchar(200),
	@StartDate smalldatetime,
	@Frequency smallint,
	@NumberOfPeriods int,
	@AmountPerPeriod money,
	@LastBillingDate smalldatetime,
	@IncludeLabor tinyint,
	@IncludeExpense tinyint,
	@CustomFieldKey int,
	@LineFormat smallint,
	@InvoiceApprovedBy int,
	@Active tinyint,
	@InvoiceExpensesSeperate tinyint,
	@SalesAccountKey int,
	@GLCompanyKey int,
	@OfficeKey int,
	@Description text,
	@ClassKey int,
	@ContactKey int,
	@BillingManagerKey int,
	@CurrencyID varchar(10) = null,
	@CostPerPeriod money = null


AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/05/07 GHL 8.5   Added GLCompanyKey + OfficeKey  
  || 09/20/07 GHL 8.437 (Enh 13169) Added new field Description
  || 12/17/07 GHL 8.5   (Enh 17879) Added ClassKey
  || 06/19/08 GHL 8.514 (13169) Changed description to text from varchar(1500)
  || 11/04/11 RLB 10549 Added insert logic 
  || 08/15/12 GHL 10559 Added check of GL company on projects  
  || 08/22/12 RLB 10559 (87856) Added ContactKey  
  || 11/06/12 GHL 10562 Added update of tForecast.RegenerateNeeded
  || 01/21/13 MAS 10564 Added logging
  || 10/07/13 GHL 10573 Added CurrencyID for multi currency
  || 12/20/13 WDF 10575 (198697) Added BillingManagerKey
  || 04/07/14 GHL 10579 Added CostPerPeriod for revenue forecast
  */
  
DECLARE @Date smalldatetime
  
SELECT @Date = GETUTCDATE()	
  
if @RetainerKey > 0
BEGIN
	DECLARE @UseGLCompany INT
	DECLARE @OldGLCompanyKey INT
	DECLARE @OldActive INT
	DECLARE @MultiCurrency INT
	
	SELECT @UseGLCompany = isnull(UseGLCompany, 0)
	      ,@MultiCurrency = isnull(MultiCurrency, 0) 
	FROM tPreference (nolock)  where CompanyKey = @CompanyKey 

	IF @UseGLCompany = 1
	BEGIN
		IF EXISTS (SELECT 1 FROM tProject (NOLOCK) 
			WHERE CompanyKey = @CompanyKey
			AND   BillingMethod = 3 -- retainer
			AND   RetainerKey = @RetainerKey
			AND   isnull(GLCompanyKey, 0) <> isnull(@GLCompanyKey, 0) )
			RETURN -1
	END

	IF @MultiCurrency = 1
	BEGIN
		IF EXISTS (SELECT 1 FROM tProject (NOLOCK) 
			WHERE CompanyKey = @CompanyKey
			AND   BillingMethod = 3 -- retainer
			AND   RetainerKey = @RetainerKey
			AND   isnull(CurrencyID, '') <> isnull(@CurrencyID, '') )
			RETURN -2

		IF EXISTS (SELECT 1 FROM tInvoiceLine il (NOLOCK)
				INNER JOIN tInvoice i (NOLOCK) on il.InvoiceKey = i.InvoiceKey 
			WHERE i.CompanyKey = @CompanyKey
			AND   il.RetainerKey = @RetainerKey
			AND   isnull(i.CurrencyID, '') <> isnull(@CurrencyID, '') )
			RETURN -3

	END

	SELECT @OldGLCompanyKey = GLCompanyKey,
		   @OldActive = ISNULL(Active, 0)	
	FROM   tRetainer (nolock)
	WHERE  RetainerKey = @RetainerKey
	
	IF @OldActive <> @Active
	BEGIN
		IF @Active = 1
			EXEC sptActionLogInsert 'Retainer',@RetainerKey, @CompanyKey, 0, 'Active', @Date, NULL, 'Retainer marked active', @Title, NULL, @UserKey  
		ELSE
			EXEC sptActionLogInsert 'Retainer',@RetainerKey, @CompanyKey, 0, 'Inactive', @Date, NULL, 'Retainer marked inactive', @Title, NULL, @UserKey  
	END
	

	UPDATE
		tRetainer
	SET
		CompanyKey = @CompanyKey,
		ClientKey = @ClientKey,
		Title = @Title,
		StartDate = @StartDate,
		Frequency = @Frequency,
		NumberOfPeriods = @NumberOfPeriods,
		AmountPerPeriod = @AmountPerPeriod,
		LastBillingDate = @LastBillingDate,
		IncludeLabor = @IncludeLabor,
		IncludeExpense = @IncludeExpense,
		CustomFieldKey = @CustomFieldKey,
		Active = @Active,
		LineFormat = @LineFormat,
		InvoiceApprovedBy = @InvoiceApprovedBy,
		InvoiceExpensesSeperate = @InvoiceExpensesSeperate,
		SalesAccountKey = @SalesAccountKey,
		GLCompanyKey = @GLCompanyKey,
		OfficeKey = @OfficeKey,
		Description = @Description,
		ClassKey = @ClassKey,
		ContactKey = @ContactKey,
		BillingManagerKey = @BillingManagerKey,
		CurrencyID = @CurrencyID,
		CostPerPeriod = @CostPerPeriod
	WHERE
		RetainerKey = @RetainerKey
		
	if isnull(@OldGLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
		delete tForecastDetail
		where  Entity = 'tRetainer'
		and    EntityKey = @RetainerKey
	else		 
		update tForecastDetail
		set    tForecastDetail.RegenerateNeeded = 1
		where  Entity = 'tRetainer'
		and    EntityKey = @RetainerKey
			 
END
ELSE
BEGIN
	INSERT tRetainer
		(
		CompanyKey,
		ClientKey,
		Title,
		StartDate,
		Frequency,
		NumberOfPeriods,
		AmountPerPeriod,
		LastBillingDate,
		IncludeLabor,
		IncludeExpense,
		CustomFieldKey,
		LineFormat,
		InvoiceApprovedBy,
		Active,
		InvoiceExpensesSeperate,
		SalesAccountKey,
		GLCompanyKey,
		OfficeKey,
		Description,
		ClassKey,
		ContactKey,
		BillingManagerKey,
		CurrencyID,
		CostPerPeriod 
		)

	VALUES
		(
		@CompanyKey,
		@ClientKey,
		@Title,
		@StartDate,
		@Frequency,
		@NumberOfPeriods,
		@AmountPerPeriod,
		@LastBillingDate,
		@IncludeLabor,
		@IncludeExpense,
		@CustomFieldKey,
		@LineFormat,
		@InvoiceApprovedBy,
		@Active,
		@InvoiceExpensesSeperate,
		@SalesAccountKey,
		@GLCompanyKey,
		@OfficeKey,
		@Description,
		@ClassKey,
		@ContactKey,
		@BillingManagerKey,
		@CurrencyID,
		@CostPerPeriod
		)

	SELECT @RetainerKey = @@IDENTITY
	
	EXEC sptActionLogInsert 'Retainer',@RetainerKey, @CompanyKey, 0, 'Created', @Date, NULL, 'Retainer Created', @Title, NULL, @UserKey  
END


		RETURN @RetainerKey
GO
