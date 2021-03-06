USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostCalcRoundingDiff]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostCalcRoundingDiff]
	(
	@CompanyKey int
	,@Entity varchar(50)
	,@EntityKey int
	,@IsAccrual int -- 1 Accrual, 0 Cash basis
	,@ForceToRounding int -- If 1 we use the rounding account
	,@GLCompanyKey int
	,@TransactionDate smalldatetime
	,@Reference varchar(100)
	,@RoundingDiffAccountKey int
	,@RealizedGainAccountKey int
	)

AS --Encrypt

/*
|| When     Who Rel    What
|| 09/23/14 GHL 10.584 In cash basis posting, read #tCashTransaction
*/
	SET NOCOUNT ON

	declare @HDebits money
	declare @HCredits money
	declare @HDebit money
	declare @HCredit money
	declare @Diff money
	declare @PostSide char(1)
	declare @ExchangeRateCount int

	declare @RoundingDiffErrRet int					select @RoundingDiffErrRet = -350
	declare @RealizedGainErrRet int					select @RoundingDiffErrRet = -351

	DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
	DECLARE @kSectionLine int						SELECT @kSectionLine = 2
	DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
	DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
	DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
	DECLARE @kSectionWIP int						SELECT @kSectionWIP = 6
	DECLARE @kSectionVoucherCC int					SELECT @kSectionVoucherCC = 7
	DECLARE @kSectionICT int						SELECT @kSectionICT = 8
	DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
	DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10

	if @IsAccrual = 1
	begin
		update #tTransaction
		set    HDebit = round(isnull(ExchangeRate, 1) * isnull(Debit, 0), 2)
		      ,HCredit = round(isnull(ExchangeRate, 1) * isnull(Credit, 0), 2)
		where  Entity = @Entity collate database_default
		and    EntityKey = @EntityKey	    
		and    [Section] not in (@kSectionMCRounding, @kSectionMCGain)

		select @HDebits= sum(HDebit)
				,@HCredits = sum(HCredit)
		from   #tTransaction
		where  Entity = @Entity collate database_default
		and    EntityKey = @EntityKey	    
	
		-- how many different exchange rates?
		select @ExchangeRateCount = COUNT(distinct isnull(ExchangeRate, 1))
		from   #tTransaction
		where  Entity = @Entity collate database_default
		and    EntityKey = @EntityKey	    
	 
	end
	else
	begin
		update #tCashTransaction
		set    HDebit = round(isnull(ExchangeRate, 1) * isnull(Debit, 0), 2)
		      ,HCredit = round(isnull(ExchangeRate, 1) * isnull(Credit, 0), 2)
		where  Entity = @Entity collate database_default
		and    EntityKey = @EntityKey	
		and    [Section] not in (@kSectionMCRounding, @kSectionMCGain)

		select @HDebits= sum(HDebit)
				,@HCredits = sum(HCredit)
		from   #tCashTransaction
		where  Entity = @Entity collate database_default
		and    EntityKey = @EntityKey	    
    
		-- how many different exchange rates?
		select @ExchangeRateCount = COUNT(distinct isnull(ExchangeRate, 1))
		from   #tCashTransaction
		where  Entity = @Entity collate database_default
		and    EntityKey = @EntityKey	    
	 
	end
	
	select @Diff = @HDebits - @HCredits
	
	if @Diff = 0
		return 1

	-- try to save a positive value in either Debit or Credit 
	if @HDebits > 0
	begin
		if @Diff > 0
			-- Debits greater than credits, put diff in credits
			select @HDebit = 0
				  ,@HCredit = @Diff
				  ,@PostSide = 'C'
		else
			-- Debits smaller than credits, put diff in debits
			select @HDebit = -1 * @Diff
				  ,@HCredit = 0
				  ,@PostSide = 'D'
	end
	else
	begin
		if @Diff > 0
			select @HDebit = @Diff
				  ,@HCredit = 0
				  ,@PostSide = 'D'
		else
			select @HDebit = 0
				  ,@HCredit = -1 * @Diff
				  ,@PostSide = 'C'
	end
	
	-- copy main 

	-- for the GL trans	
	Declare @TransactionKey int
	Declare @GLAccountKey int
	Declare @GLAccountErrRet int
	Declare @ClassKey int
	Declare @ClientKey int
	Declare @ProjectKey int
	Declare @OfficeKey int
	Declare @DepartmentKey int
	Declare @Memo varchar(500)
	Declare @SourceCompanyKey int
    Declare @DepositKey int
	Declare @DetailLineKey int
	Declare @Section int
	Declare @CurrencyID varchar(10) -- leave it blank/null means home currency
	Declare @ExchangeRate int

	-- if we have 1 single exchange rate, I consider the diff a rounding error
	-- else it will be a realized gain
	if (@ExchangeRateCount <= 1 Or @ForceToRounding = 1)
		select @GLAccountKey = @RoundingDiffAccountKey
			  ,@GLAccountErrRet = @RoundingDiffErrRet
			  ,@Section = @kSectionMCRounding -- Multi Currency rounding
			  ,@Memo = 'Multi Currency Rounding Diff '
	else
		select @GLAccountKey = @RealizedGainAccountKey
			  ,@GLAccountErrRet = @RealizedGainErrRet
			  ,@Section = @kSectionMCGain -- Multi Currency gain/loss
			  ,@Memo = 'Multi Currency Realized Gain/Loss '

	select @ExchangeRate = 1 -- default to 1 but not meaningfull

	-- Here, we dont want to use sptInsertGLTranTemp because it sets default values for HDebit and HCredit
	-- direct inserts in temp tables and set HDebit and HCredit now

	if @IsAccrual = 1 

	INSERT #tTransaction
		(
		CompanyKey,
		TransactionDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		Debit,
		Credit,
		ClassKey,
		Memo,
		ClientKey,
		ProjectKey,
		SourceCompanyKey,
		DepositKey,
		PostSide,
		GLCompanyKey,
		OfficeKey,
		DepartmentKey,
		DetailLineKey,
		Section,
		Overhead,
		CurrencyID,
		ExchangeRate,
		HDebit,
		HCredit,
		GLAccountErrRet,
		GLValid,
		GPFlag
		)

	VALUES
		(
		@CompanyKey,
		@TransactionDate,
		@Entity,
		@EntityKey,
		@Reference,
		@GLAccountKey,
		0, -- @Debit,
		0, --@Credit,
		@ClassKey,
		@Memo,
		@ClientKey,
		@ProjectKey,
		@SourceCompanyKey,
		@DepositKey,
		@PostSide,
		@GLCompanyKey,
		@OfficeKey,
		@DepartmentKey,
		@DetailLineKey,
		@Section,
		0, -- Overhead
		@CurrencyID,
		@ExchangeRate,
		@HDebit,
		@HCredit,
		@GLAccountErrRet,
		0,0
		)

	else

		INSERT #tCashTransaction
		(
		CompanyKey,
		TransactionDate,
		Entity,
		EntityKey,
		Reference,
		GLAccountKey,
		Debit,
		Credit,
		ClassKey,
		Memo,
		ClientKey,
		ProjectKey,
		SourceCompanyKey,
		DepositKey,
		PostSide,
		GLCompanyKey,
		OfficeKey,
		DepartmentKey,
		DetailLineKey,
		Section,
		Overhead,
		CurrencyID,
		ExchangeRate,
		HDebit,
		HCredit,
		GLAccountErrRet,
		GLValid,
		GPFlag
		)

	VALUES
		(
		@CompanyKey,
		@TransactionDate,
		@Entity,
		@EntityKey,
		@Reference,
		@GLAccountKey,
		0, -- @Debit,
		0, --@Credit,
		@ClassKey,
		@Memo,
		@ClientKey,
		@ProjectKey,
		@SourceCompanyKey,
		@DepositKey,
		@PostSide,
		@GLCompanyKey,
		@OfficeKey,
		@DepartmentKey,
		@DetailLineKey,
		@Section,
		0, -- Overhead
		@CurrencyID,
		@ExchangeRate,
		@HDebit,
		@HCredit,
		@GLAccountErrRet,
		0,0
		)

	RETURN 1
GO
