USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostJournalEntry]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostJournalEntry]

	(
		@CompanyKey int
		,@JournalEntryKey int
		,@Prepost int = 0		-- Can be used by Preposting as well, Preposting does not validate GL accounts 
		,@CreateTemp int = 1	-- In some cases (PrePost) do not create temp table		
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 06/13/07 GHL 8.5    Modifications for GLCompanyKey, OfficeKey, DepartmentKey + complete rework
|| 09/17/07 GHL 8.5   Added overhead (more)
|| 03/05/08 GHL 8.505 (22514) Removed validation of GL Closing Date when preposting 
|| 02/26/09 GHL 10.019 Added cash basis process
|| 05/04/09 GHL 10.024 Added exclude accrual basis
|| 02/16/11 RLB 10.541 (103835) removed check for  Post to GL
|| 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
|| 03/30/12 GHL 10.554 Added call to spGLPostICTCreateDTDF
|| 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
|| 01/22/13 GHL 10.564 (164475) Added error @kErrICTBlankGLAccount = -103 as a last defense protection
||                     against null gl accounts linked to ICT
|| 02/15/13 GHL 10.565 TrackCash = 1 now 
|| 06/24/13 GHL 10.569 (182080) Using now #tTransaction.GPFlag (general purpose flag) to validate missing offices and depts 
||                      This is why I execute sptGLValidatePostTemp before exiting in case of preposting
|| 08/05/13 GHL 10.571 Added Multi Currency stuff
|| 09/24/14 GHL 10.584 (229124) Allowing now transfers between bank accounts of different currencies
*/

	-- Bypass cash basis process or not
	DECLARE @TrackCash INT SELECT @TrackCash = 1
	
	IF @CreateTemp = 1
	BEGIN
		CREATE TABLE #tTransaction (
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL,
			ICTGLCompanyKey int null, 
			
			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,TempTranLineKey int IDENTITY(1,1) NOT NULL
			)	 
	END

-- Register all constants
DECLARE @kErrInvalidGLAcct INT					SELECT @kErrInvalidGLAcct = -1

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrICTBlankGLAccount INT				SELECT @kErrICTBlankGLAccount = -103
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

-- Also declared in spGLPostInvoice
DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionICT int						SELECT @kSectionICT = 8
DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10

Declare @GLClosedDate smalldatetime
Declare @Customizations varchar(1000)
Declare @UseMultiCompanyGLCloseDate tinyint
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  

Declare @TransactionDate smalldatetime
Declare @Posted tinyint
Declare @GLCompanyKey int
        ,@Entity VARCHAR(50)
		,@EntityKey INT
		,@Reference VARCHAR(100)
		,@RetVal INT
		,@TransactionCount INT
 		,@ExcludeCashBasis INT
 		,@ExcludeAccrualBasis INT
 		,@CurrencyID varchar(10)
		,@ExchangeRate decimal(24,7)	

Select
	 @GLClosedDate = GLClosedDate
	,@Customizations = ISNULL(Customizations, '')
	,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
	,@MultiCurrency = ISNULL(MultiCurrency, 0)
	,@RoundingDiffAccountKey = RoundingDiffAccountKey
	,@RealizedGainAccountKey = RealizedGainAccountKey  
From
	tPreference (nolock)
Where
	CompanyKey = @CompanyKey
		
Select 
	@TransactionDate =  dbo.fFormatDateNoTime(PostingDate),
	@Reference = JournalNumber,
	@GLCompanyKey = GLCompanyKey, 
	@Posted = Posted,
	@ExcludeCashBasis = ISNULL(ExcludeCashBasis, 0),
	@ExcludeAccrualBasis = ISNULL(ExcludeAccrualBasis, 0),
	@CurrencyID = CurrencyID,
	@ExchangeRate = isnull(ExchangeRate, 1)
From 
	tJournalEntry (nolock)
Where
	JournalEntryKey = @JournalEntryKey

if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			

	END
	
if @Posted = 1
	return @kErrPosted


-- Common data
Select @Entity = 'GENJRNL'
	  ,@EntityKey = @JournalEntryKey

-- Can not post before gl close date
if @Prepost = 0 and not @GLClosedDate is null
	if @GLClosedDate > @TransactionDate
		return @kErrGLClosedDate

--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

	-- One entry per journal entry detail
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID,ExchangeRate)
	
	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		jed.GLAccountKey, ISNULL(jed.DebitAmount, 0), ISNULL(jed.CreditAmount, 0), jed.ClassKey, jed.Memo,
		jed.ClientKey, jed.ProjectKey, NULL, NULL,
		CASE WHEN ISNULL(jed.DebitAmount, 0) <> 0 THEN 'D' ELSE 'C' END

		-- ICT
		, case when isnull(jed.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else jed.TargetGLCompanyKey end
		
		, jed.OfficeKey, jed.DepartmentKey, jed.JournalEntryDetailKey, @kSectionLine ,@kErrInvalidGLAcct
		,@CurrencyID, @ExchangeRate
	From  tJournalEntryDetail jed (nolock)
		left outer join tGLAccount gla (nolock) on jed.GLAccountKey = gla.GLAccountKey
	Where jed.JournalEntryKey = @JournalEntryKey
	
	if @MultiCurrency = 1
	begin
		-- for bank AP AR CC accounts, get the currency from the GL account
		update #tTransaction
		set    #tTransaction.CurrencyID = gla.CurrencyID
		from   tGLAccount gla (nolock)
		where  #tTransaction.GLAccountKey = gla.GLAccountKey
		and    gla.AccountType in (10,11,20,23) 
		and    #tTransaction.Entity = @Entity
		and    #tTransaction.EntityKey = @EntityKey

		-- then get the rate from either the header or the detail
		update #tTransaction
		set    #tTransaction.ExchangeRate = 
			case when isnull(gla.CurrencyID, '') = isnull(@CurrencyID, '') and isnull(@CurrencyID, '') <> '' then @ExchangeRate
			    when isnull(gla.CurrencyID, '') = '' then 1
				else isnull(jed.ExchangeRate, 1) end
		from   tJournalEntryDetail jed (nolock)
		      ,tGLAccount gla (nolock)
		where  #tTransaction.GLAccountKey = gla.GLAccountKey
		and    gla.AccountType in (10,11,20,23) 
		and    #tTransaction.DetailLineKey = jed.JournalEntryDetailKey 
		and    #tTransaction.Entity = @Entity
		and    #tTransaction.EntityKey = @EntityKey

		--1 Accrual Basis, 1 Force to Rounding account
		exec spGLPostCalcRoundingDiff @CompanyKey,@Entity,@EntityKey,1,1,@GLCompanyKey,@TransactionDate,@Reference, @RoundingDiffAccountKey,@RealizedGainAccountKey 
		
		if exists (select 1 from #tTransaction where Entity = @Entity and EntityKey = @EntityKey 
			and Section in (@kSectionMCRounding, @kSectionMCGain))
		begin
			-- Correct and prepared data for final insert
			EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
		end
	end

	-- Create DT and DF for ICT -- 1 Accrual Basis
	exec spGLPostICTCreateDTDF @CompanyKey,@Entity,@EntityKey,1,@GLCompanyKey,@TransactionDate,NULL,@Reference 

	-- Correct and prepared data for final insert
	EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
	-- Exit when we are not really posting, but preposting
	--IF @Prepost = 1
	--	RETURN 1
		
	/*
	 * Validations
	 */

	Select @TransactionCount = COUNT(*) from #tTransaction Where Entity = @Entity and EntityKey = @EntityKey

	EXEC @RetVal = spGLValidatePostTemp @CompanyKey, @Entity, @EntityKey, @kErrBalance, @kErrPosted 

	-- Exit when we are not really posting, but preposting
	IF @Prepost = 1
		RETURN 1

	IF @RetVal <> 1
		RETURN @RetVal
		
	IF @TrackCash = 1 AND @ExcludeCashBasis = 0
	BEGIN
		CREATE TABLE #tCashTransaction (
			UIDCashTransactionKey uniqueidentifier null,
			
			-- Copied from tTransaction
			CompanyKey int NULL ,
			DateCreated smalldatetime NULL ,
			TransactionDate smalldatetime NULL ,
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Reference varchar (100) NULL ,
			GLAccountKey int NULL ,
			Debit money NULL ,
			Credit money NULL ,
			ClassKey int NULL ,
			Memo varchar (500) NULL ,
			PostMonth int NULL,
			PostYear int NULL,
			PostSide char (1) NULL ,
			ClientKey int NULL ,
			ProjectKey int NULL ,
			SourceCompanyKey int NULL ,
			DepositKey int NULL ,
			GLCompanyKey int NULL ,
			OfficeKey int NULL ,
			DepartmentKey int NULL ,
			DetailLineKey int NULL ,
			Section int NULL, 
			Overhead tinyint NULL, 
			ICTGLCompanyKey int null,

			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null,

			-- Application fields
			AEntity varchar (50) NULL ,
			AEntityKey int NULL ,
			AReference varchar (100) NULL ,
			AEntity2 varchar (50) NULL ,
			AEntity2Key int NULL ,
			AReference2 varchar (100) NULL ,
			AAmount MONEY NULL,
			LineAmount MONEY NULL,
			CashTransactionLineKey INT NULL

			-- our work space
			,GLValid int null
			,GLAccountErrRet int null
			,GPFlag int null -- General purpose flag
			
			,UpdateTranLineKey int null
			)	 


		END

	If Exists (Select 1 From #tTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
		return @kErrICTBlankGLAccount
				 	
	/*
	 * Posting!!
	 */
				
	Begin Tran

	Update tJournalEntry
	Set Posted = 1
	Where JournalEntryKey = @JournalEntryKey
	
	if @@ERROR <> 0 
	begin
		rollback tran 
		return @kErrUnexpected
	end

	IF @ExcludeAccrualBasis = 0
	AND NOT EXISTS (SELECT 1 FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
	BEGIN
		INSERT tTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, Reversed, Cleared, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, 0, 0, CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		

		-- Protect against double postings
		IF (SELECT COUNT(*) FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
		<> @TransactionCount
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
	END

	IF @TrackCash = 1 And @ExcludeCashBasis = 0
	AND NOT EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
	BEGIN

		INSERT #tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		-- Assign UIDs
		exec sptCashPostCleanupTemp @Entity, @EntityKey, @TransactionDate, 1
		
		INSERT tCashTransaction(UIDCashTransactionKey,CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT UIDCashTransactionKey,CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tCashTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
	
		-- Protect against double postings
		IF (SELECT COUNT(*) FROM tCashTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
		<> @TransactionCount
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
	END
		

	
	commit tran
	
Return 1
GO
