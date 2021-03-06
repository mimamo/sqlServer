USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashPostCheck]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashPostCheck]
	(
		@CompanyKey int
		,@CheckKey int
		,@CreateTemp int = 0	-- Can be used for testing	
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 02/26/09 GHL 10.019 Creation for cash basis posting 
|| 05/07/09 GHL 10.024 Added reading of Unapplied Account from pref
|| 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
|| 03/27/12 GHL 10.554 Changes for ICT
|| 07/03/12 GHL 10.557 Added call to spGLPostICTCreateDTDF for Inter Company Transactions
|| 07/03/12 GHL 10.557 Added tCashTransaction.ICTGLCompanyKey
|| 08/07/13 GHL 10.571 Added Multi Currency stuff
||                     This does not create a realized gain like sptCashPostInvoice
||                     The exchange rate from the check just propagates to the invoices
*/
	
	IF @CreateTemp = 1
	BEGIN
	
		-- This table will track of which cash basis transactions are not valid anymore
		-- Just to get the same Entity's collation
		SELECT Entity, EntityKey, 1 AS Unpost INTO #tCashTransactionUnpost 
		FROM tCashTransaction (NOLOCK) WHERE 1 = 2 
		
		CREATE TABLE #tCashTransaction (
			UIDCashHistoryKey uniqueidentifier null,
			
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

-- Register all constants
DECLARE @kErrInvalidGLAcct INT					SELECT @kErrInvalidGLAcct = -1
DECLARE @kErrInvalidPrePayAcct INT				SELECT @kErrInvalidPrePayAcct = -2

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
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

-- Vars for tPreference
Declare @PostToGL tinyint
Declare @RequireAccounts tinyint
Declare @GLClosedDate smalldatetime
Declare @UnappliedCashAccountKey int
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  

-- Vars for check/receipt info
Declare @CashAccountKey int
Declare @PrepayAccountKey int
Declare @CheckAmount money
Declare @AppliedAmount money
Declare @PrepayAmount money
Declare @ReferenceNumber varchar(100)
Declare @Amount money
Declare @Posted tinyint
Declare @OpeningTransaction tinyint

-- Vars for GL tran
DECLARE @TransactionDate smalldatetime
		,@Entity VARCHAR(50)
		,@EntityKey INT
		,@Reference VARCHAR(100)
		,@GLAccountKey INT
		,@ClassKey int
		,@Memo varchar(500)
		,@PostSide char(1)
		,@ClientKey int
		,@ProjectKey int
		,@SourceCompanyKey INT
		,@DepositKey INT
		,@GLCompanyKey INT
		,@OfficeKey INT
		,@DepartmentKey INT
		,@DetailLineKey INT
		,@Section INT
		,@GLAccountErrRet INT
		,@RetVal INT
		,@TransactionCount INT
 		 
	Select
		@RequireAccounts = ISNULL(RequireGLAccounts, 0)
		,@PostToGL = ISNULL(PostToGL, 0)
		,@GLClosedDate = GLClosedDate
		,@UnappliedCashAccountKey = isnull(UnappliedCashAccountKey, 0) -- for conversion mainly
		,@MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey  
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
		
	Select
		@GLCompanyKey = GLCompanyKey
		,@ClientKey = ClientKey
		,@CheckAmount = ISNULL(CheckAmount, 0)
		,@TransactionDate = dbo.fFormatDateNoTime(PostingDate)
		,@ReferenceNumber = ReferenceNumber
		,@CashAccountKey = CashAccountKey
		,@PrepayAccountKey = ISNULL(PrepayAccountKey, 0)
		,@ClassKey = ClassKey
		,@DepositKey = DepositKey
		,@Posted = Posted
		,@ProjectKey = NULL
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
	from tCheck (nolock)
	Where CheckKey = @CheckKey

	IF @PrepayAccountKey = 0
		SELECT @PrepayAccountKey = @UnappliedCashAccountKey
	
	Select @AppliedAmount = ISNULL(sum(Amount), 0) 
	from tCheckAppl (nolock) 
	where CheckKey = @CheckKey 
	and Prepay = 0
	Select @PrepayAmount = @CheckAmount - @AppliedAmount
		
	if @OpeningTransaction = 1
		Select @PostToGL = 0	

	
	-- These should not change
	Select	@Entity = 'RECEIPT'
			,@EntityKey = @CheckKey
			,@Reference = @ReferenceNumber
			,@Memo = 'Reference # ' + @ReferenceNumber
			,@SourceCompanyKey = @ClientKey			
	-- TransactionDate, ProjectKey, GLCompanyKey, ClassKey, ClientKey already set
	
	/*
	* Insert the header Amount
	*/
	
	SELECT @PostSide = 'D'
		  ,@GLAccountKey = @CashAccountKey
		  ,@GLAccountErrRet = @kErrInvalidGLAcct 
		  ,@Amount = @CheckAmount, @Section = @kSectionHeader 
		  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
		  		
	exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

		--,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference,AAmount,LineAmount,CashTransactionLineKey
		,NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL
		
	/*
	* Insert the prepayed amount if there is one
	*/
	
	if ISNULL(@PrepayAmount, 0) <> 0
	Begin
		SELECT @PostSide = 'C'
		      ,@GLAccountKey = @PrepayAccountKey
			  ,@GLAccountErrRet = @kErrInvalidPrePayAcct 
			  ,@Amount = @PrepayAmount, @Section = @kSectionHeader 
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL, @DepositKey = NULL
			  		
		exec sptCashInsertTranTemp NULL, @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

		--,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference,AAmount,LineAmount,CashTransactionLineKey
		,NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL

	End
	
	/*
	* Insert the lines
	*/
	
	SELECT @PostSide = 'C', @Section = @kSectionLine, @GLAccountErrRet = @kErrInvalidGLAcct, @DepositKey = NULL 
	
	-- credit each line tCheckAppl where InvoiceKey is null and prepay = 0
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,
		AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount,LineAmount,CashTransactionLineKey
		)
	
	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		SalesAccountKey, 0, ISNULL(Amount, 0), ClassKey, @Memo,
		@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide

		-- ICT
		, case when isnull(TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else TargetGLCompanyKey end
		
		, OfficeKey, DepartmentKey, CheckApplKey, @kSectionLine ,@GLAccountErrRet
		,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL
	From  tCheckAppl (nolock)
	Where CheckKey = @CheckKey 
	and   InvoiceKey is null
	and Prepay = 0
		
	/*
	if the invoice is not posted consider it does not exist yet
	Things could go wrong during the posting of the invoice
	so post the receipt against the unapplied account
	when posting the invoice, repost the check
	*/
	
	-- credit each line tCheckAppl where InvoiceKey is not null and prepay = 0 and invoice not posted 
	-- against unapplied account
	-- same if invoice is posted but posting date > check posting date
	-- Talked to Greg 02/23/2009. We should use the AR account on the invoice
	INSERT #tCashTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,
		AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount,LineAmount,CashTransactionLineKey
		)
	
	SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
		i.ARAccountKey, 0, ISNULL(ca.Amount, 0), ca.ClassKey, @Memo,
		@ClientKey, @ProjectKey, @SourceCompanyKey, @DepositKey, @PostSide

		-- ICT
		, case when isnull(ca.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else ca.TargetGLCompanyKey end
		
		, ca.OfficeKey, ca.DepartmentKey, ca.CheckApplKey, @kSectionLine ,@GLAccountErrRet
		,NULL, NULL, NULL, NULL,NULL, NULL, 0, 0, NULL
	From  tCheckAppl ca (nolock)
		inner join tInvoice i (nolock) on ca.InvoiceKey = i.InvoiceKey
	Where ca.CheckKey = @CheckKey 
	--and   ca.InvoiceKey is not null
	and ca.Prepay = 0
	and (	
		-- Unposted AND not in the process of being posted to ACCRUAL
		(i.Posted = 0 AND i.InvoiceKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=0))
		-- Or posted in the future  
		OR (i.Posted = 1 AND i.PostingDate > @TransactionDate)
		-- Or we are in the process from unposting from ACCRUAL
		OR	i.InvoiceKey IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=1)
		
	) 
	 
	--select * from #tCashTransaction
	--SELECT * FROM #tCashQueue
	
	-- if an invoice is on same posting date as a check, we can consider it like before the check
	-- similar to the convention of the invoices linked to an Advance Bill
 	
 	-- now process the posted invoices
	DECLARE @InvoiceKey INT
	DECLARE @AdvanceBill INT
	DECLARE @IsLastApplication INT
	DECLARE @ApplyAmount MONEY
	DECLARE @CheckApplKey INT
	
	SELECT @InvoiceKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @InvoiceKey = MIN(ca.InvoiceKey)
		FROM   tCheckAppl ca (NOLOCK)
			INNER JOIN tInvoice i (NOLOCK) ON ca.InvoiceKey = i.InvoiceKey
		WHERE ca.CheckKey = @CheckKey 
		and ca.Prepay = 0
		and (i.Posted = 1
			OR
			-- Or we are in the process of posting it to Accrual
			ca.InvoiceKey IN (SELECT EntityKey FROM #tCashQueue 
				WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=0)
			)	 
		AND i.PostingDate <= @TransactionDate 
		AND  ca.InvoiceKey > @InvoiceKey  
		-- And we are not in the process of unposting it from Accrual
		AND	ca.InvoiceKey NOT IN (SELECT EntityKey FROM #tCashQueue 
			WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=1)
		
		--SELECT * FROM #tCashQueue
		
		IF @InvoiceKey IS NULL
			BREAK
			
		--select @InvoiceKey
			
		SELECT @CheckApplKey = CheckApplKey
			  ,@ApplyAmount = Amount
		FROM   tCheckAppl (NOLOCK)
		WHERE  CheckKey = @CheckKey
		AND    InvoiceKey = @InvoiceKey
					
		SELECT @AdvanceBill = AdvanceBill
		FROM   tInvoice (NOLOCK)
		WHERE  InvoiceKey =	@InvoiceKey
		
			
		IF @AdvanceBill = 1
		BEGIN
			-- Prevent the situation of an advance bill with a negative check
			-- and no invoices before this check
			IF NOT EXISTS (
				SELECT i.InvoiceKey
				FROM   tInvoiceAdvanceBill iab (NOLOCK)
				INNER JOIN tInvoice i (NOLOCK) ON iab.InvoiceKey = i.InvoiceKey
				WHERE  iab.AdvBillInvoiceKey = @InvoiceKey   
				-- They should be posted
				AND (i.Posted = 1
						OR
						-- Or we are in the process of posting it to Accrual
						i.InvoiceKey IN (SELECT EntityKey FROM #tCashQueue 
							WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=0)
						)	 
				-- And we are not in the process of unposting it from Accrual
				AND	i.InvoiceKey NOT IN (SELECT EntityKey FROM #tCashQueue 
					WHERE Entity = 'INVOICE' AND PostingOrder = 1 AND Action=1)		
					
				-- we consider that if the invoices have the same posting date
				-- they are BEFORE the check
				AND    i.PostingDate <= @TransactionDate  
				AND    iab.InvoiceKey <> iab.AdvBillInvoiceKey -- filter out self applications
			)
			
			SELECT @AdvanceBill = 0
		END
		
			
		IF @AdvanceBill = 0
		BEGIN
			EXEC sptCashPostCheckFillInvoice @CompanyKey, @InvoiceKey,@CheckKey, @CheckApplKey, @ApplyAmount
		END
		ELSE
		BEGIN
			--EXEC sptCashPostCheckFillAB @CompanyKey, @InvoiceKey,@CheckKey, @CheckApplKey, @ApplyAmount
			EXEC sptCashPostCheckFillABInvoice @CompanyKey, @InvoiceKey,@CheckKey, @CheckApplKey, @ApplyAmount
		END
	END 	
 	
	if @MultiCurrency = 1
	begin
		-- Correct before because this creates the 'Added to balance cash transaction records' record 
		EXEC sptCashPostCleanupTemp @Entity, @EntityKey, @TransactionDate 

		exec sptCashPostSetExchangeRate @Entity,@EntityKey

		-- 0 Cash Basis, 1 Force to rounding account
		exec spGLPostCalcRoundingDiff @CompanyKey,@Entity,@EntityKey,0,1,@GLCompanyKey,@TransactionDate,@Reference, @RoundingDiffAccountKey,@RealizedGainAccountKey 
	end

	-- Create DT and DF for ICT -- 0 Cash Basis
	exec spGLPostICTCreateDTDF @CompanyKey,@Entity,@EntityKey,0,@GLCompanyKey,@TransactionDate,@Memo,@Reference 

	-- Correct and prepared data for final insert
	EXEC sptCashPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
			
Return 1
GO
