USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertCheck]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertCheck]

	(
		@CompanyKey int
		,@CheckKey int
		,@Prepost int = 0		-- Can be used by Preposting as well, Preposting does not validate GL accounts 
		,@CreateTemp int = 1	-- In some cases (PrePost) do not create temp table		
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 02/21/07 GHL 8.4   Added protection against double postings 
  || 04/05/07 GHL 8.4   Added another protection against double postings. Bug 8799.    
  || 04/05/07 GHL 8.4   Changed memo to 'Reference #' instead of 'Check #' because receipts can be cash or card 
  ||                    Bug 8818        
  || 06/19/07 GHL 8.5   Modifications for GLCompanyKey, OfficeKey, DepartmentKey + complete rework
  || 09/17/07 GHL 8.5   Added overhead (more)
  || 10/06/07 GWG 8.5   Fixed posting side for the receipt
  || 02/07/08 GWG 8.53  Changed posting of the lines so that it does not take into account prepays
  || 03/05/08 GHL 8.505 (22514) Removed validation of GL Closing Date when preposting   
  || 06/18/08 GHL 8.513 Added logic for OpeningTransaction
  || 02/26/09 GHL 10.019 Added cash basis process
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
			Overhead tinyint NULL ,
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

CREATE TABLE #tCashTransactionLine (
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
			
			CurrencyID varchar(10) null,	-- 4 lines added for multicurrency
			ExchangeRate decimal(24,7) null,
			HDebit money null,
			HCredit money null,

			AdvBillAmount money NULL,
			PrepaymentAmount money NULL,
			ReceiptAmount money NULL,
			
			TempTranLineKey int NULL
			)	 
			
	CREATE TABLE #tInvoiceAdvanceBillSale (
		InvoiceKey int null
		,AdvBillInvoiceKey int null
		,CashTransactionLineKey int null
		,Amount money null
		,TempTranLineKey int NULL
		)	
			
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

-- Vars for tPreference
Declare @PostToGL tinyint
Declare @RequireAccounts tinyint
Declare @GLClosedDate smalldatetime

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
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
		
	Select
		@GLCompanyKey = GLCompanyKey
		,@ClientKey = ClientKey
		,@CheckAmount = ISNULL(CheckAmount, 0)
		,@TransactionDate = PostingDate
		,@ReferenceNumber = ReferenceNumber
		,@CashAccountKey = CashAccountKey
		,@PrepayAccountKey = PrepayAccountKey
		,@ClassKey = ClassKey
		,@DepositKey = DepositKey
		,@Posted = Posted
		,@ProjectKey = NULL
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
	from tCheck (nolock)
	Where CheckKey = @CheckKey
	
	if @OpeningTransaction = 1
		Select @PostToGL = 0	

	If @PostToGL = 0 And @RequireAccounts = 0 And @Prepost = 0
	Begin
		
		return 1
	End
	
	
	-- These should not change
	Select	@Entity = 'RECEIPT'
			,@EntityKey = @CheckKey
			,@Reference = @ReferenceNumber
			,@Memo = 'Reference # ' + @ReferenceNumber
			,@SourceCompanyKey = @ClientKey			
	-- TransactionDate, ProjectKey, GLCompanyKey, ClassKey, ClientKey already set

	/*
	 * Cash-Basis prep
	 */
	
	IF @TrackCash = 1 AND @Prepost = 0
	BEGIN
		CREATE TABLE #tCashQueue(
			Entity varchar(25) NULL,
			EntityKey int NULL,
			PostingDate smalldatetime NULL,
			QueueOrder int identity(1,1),
			PostingOrder int NULL,
			Action smallint NULL, 
			AdvanceBill int NULL
			)
	
		-- This table will track of which cash basis transactions are not valid anymore
		/*
		CREATE TABLE #tCashTransactionUnpost (
			Entity varchar (50) NULL ,
			EntityKey int NULL ,
			Unpost int NULL)
		*/
		
		-- So that we get the same Entity's collation
		SELECT Entity, EntityKey, 1 AS Unpost INTO #tCashTransactionUnpost 
		FROM tCashTransaction (NOLOCK) WHERE 1 = 2 
		
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
			
	Declare @PostingOrder int
	Declare @Action int Select @Action = 0 -- Posting
	Declare @CashEntity varchar(25)
	Declare @CashEntityKey varchar(25)
	Declare @CashPostingDate smalldatetime
	
	--exec @RetVal = sptCashQueue @CompanyKey, @Entity, @EntityKey, @TransactionDate, @Action
	 
	INSERT #tCashQueue(
			Entity,
			EntityKey,
			PostingDate,
			PostingOrder,
			Action , 
			AdvanceBill 
			)
		VALUES (@Entity, @EntityKey, @TransactionDate, 1, 0, 0) 	
	 
	INSERT #tCashTransactionUnpost (Entity, EntityKey, Unpost)
	Select Entity, EntityKey, 1
	From   #tCashQueue (NOLOCK)
	Where  Action = 1 -- UnPosting
 
	-- then post
	Select @PostingOrder = -1
	While (1=1)
	Begin
		Select @PostingOrder = MIN(PostingOrder)
		From   #tCashQueue (NOLOCK)
		Where  PostingOrder > @PostingOrder
		And    Action = 0 -- Posting
		
		If @PostingOrder is null
			break
			
		Select @CashEntity = Entity
		      ,@CashEntityKey = EntityKey
			  ,@CashPostingDate = PostingDate
		From   #tCashQueue (NOLOCK)
		Where  PostingOrder = @PostingOrder
		And    Action = 0 -- Posting
	
		If @CashEntity = 'INVOICE'
			exec @RetVal = sptCashPostInvoice @CompanyKey, @CashEntityKey
	
		If @CashEntity = 'RECEIPT'
			exec @RetVal = sptCashPostCheck @CompanyKey, @CashEntityKey
					  	
	End
	
	
	END -- End Track Cash
					
	/*
	 * Posting!!
	 */
				
	
	IF @TrackCash = 1 AND @Prepost = 0
	BEGIN
		
		IF EXISTS (SELECT 1 FROM tCashTransaction (NOLOCK) where Entity = @Entity and EntityKey = @EntityKey)
			delete  tCashTransaction where Entity = @Entity and EntityKey = @EntityKey
		
			
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey, Reversed, Cleared
		
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		)
		
		SELECT @CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,ISNULL(GLAccountKey, 0),Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey, 0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		
		FROM #tCashTransaction 	
		--WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
			Return -1	
			
	END
	
	
Return 1
GO
