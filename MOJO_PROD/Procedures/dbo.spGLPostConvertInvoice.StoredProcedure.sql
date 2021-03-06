USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertInvoice]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertInvoice]
	(
		@CompanyKey int
		,@InvoiceKey int
		,@Prepost int = 0		-- Can be used by Preposting as well, Preposting does not validate GL accounts 
		,@CreateTemp int = 1	-- In some cases (PrePost) do not create temp table
	)
AS --Encrypt

	SET NOCOUNT ON
	
/*
|| When     Who Rel     What
|| 02/07/07 RTC 8.403  When posting an invoice for PO lines that are billed at commission only (IO or BC),
||                     close only the individual POD line not all lines with the same LineNumber
|| 02/19/07 GHL 8.404  Wrapped the update of Posted and InvoiceStatus within the transaction
||                     To prevent double postings. Bug 8318.
|| 04/05/07 GHL 8.410  Added more protection against double postings. Bug 8799.
|| 05/02/07 GHL 8.43   Added changes for advance bill sales taxes
|| 06/13/07 GHL 8.5    Modifications for GLCompanyKey, OfficeKey, DepartmentKey + complete rework
|| 08/01/07 GHL 8.5    Corrected memo for prebill acrruals
|| 09/17/07 GHL 8.5    Added overhead
|| 12/19/07 GHL 8.5    Replaced query of vSalesGLDetail by direct queries in 5 transaction tables 
||                     Was taking too long on app/app2
|| 01/18/08 GHL 8.502  (19399) Rounding now before inserting into temp table to prevent rounding errors with splits
|| 02/07/08 GHL 8.503  (20961) Modified the way I round invoice lines detail because of persistent problems with splits
||                      Rounding the sum of details rather than summing the rounded details
|| 03/05/08 GHL 8.505  (22514) Removed validation of GL Closing Date when preposting 
|| 05/09/08 GHL 8.510  (21023) When doing the prebill accruals we must remember the GL account used
||                      It will be used during the prebill accrual reversals in spGLPostVoucher  
|| 05/14/08 GHL 8.510  (26731) Changed order of prebill accruals to eliminate rounding errors 
||                     (Detail/Debit first then Summary/Credit)
|| 06/10/08 GHL 8.513  Added a patch for rounding errors (when there is a discrepancy between the lines and the header
||                     in the case of split billing)
|| 06/18/08 GHL 8.513  Added logic for OpeningTransaction
|| 11/20/08 GHL 10.013 (40387) Modified logic for prebill accruals to allow Brothers and Co 
||                     to delete client invoices
|| 12/03/08 GHL 10.013 (41544) Had to review the way I apply the rounding error in case
||                     of split billing, it should be applied to a unique line GL transaction 
||                     instead of a GL tran for an invoice line record because we may have 
||                     several GL transactions associated to a invoice line
|| 02/03/09 GHL 10.018 Split invoice adv bill tax records by tax key to help with cash basis
||                     Also place SalesTaxKey on DetailLineKey 
|| 02/26/09 GHL 10.019 Added cash basis process
*/
-- Bypass cash basis process or not
DECLARE @TrackCash INT SELECT @TrackCash = 1
	
-- Register all constants
DECLARE @kErrNotApproved INT					SELECT @kErrNotApproved = -1
DECLARE @kErrInvalidARAcct INT					SELECT @kErrInvalidARAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -2
DECLARE @kErrInvalidAdvBillAcct INT				SELECT @kErrInvalidAdvBillAcct = -3
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -4
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -5
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -6
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -7
DECLARE @kErrInvalidOUAcct INT					SELECT @kErrInvalidOUAcct = -8
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -9
DECLARE @kErrInvalidSalesTax3Acct INT			SELECT @kErrInvalidSalesTax3Acct = -10
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -11
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -12

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Invoice # '
DECLARE @kMemoAdvBill VARCHAR(100)				SELECT @kMemoAdvBill = 'Advance Billing for Invoice # '
DECLARE @kMemoSalesTax VARCHAR(100)				SELECT @kMemoSalesTax = 'Sales Tax for Invoice # '
DECLARE @kMemoSalesTax2 VARCHAR(100)			SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Invoice # '
DECLARE @kMemoSalesTax3 VARCHAR(100)			SELECT @kMemoSalesTax3 = 'Sales Tax for Invoice # '
DECLARE @kMemoPrepayments VARCHAR(100)			SELECT @kMemoPrepayments = 'Prepayment Reversal Check # '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Prebilled Order Accrual for Invoice # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Invoice # '

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5

DECLARE @kLineNoTransactions int				SELECT @kLineNoTransactions = 1
DECLARE @kLineUseTransactions int				SELECT @kLineUseTransactions = 2
DECLARE @kLineTypeDetail int					SELECT @kLineTypeDetail = 2

-- Vars for tPref
DECLARE @PostToGL tinyint
		,@GLClosedDate smalldatetime
		,@TrackOverUnder tinyint
		,@AccrueCostToItemExpenseAccount tinyint
		,@LaborOUAccountKey int
		,@ExpenseOUAccountKey int
		,@POAccruedExpenseAccountKey int
		,@POPrebillAccrualAccountKey int
		,@AdvBillAccountKey int

-- Vars for invoice info
DECLARE @InvoiceStatus int
		,@ARAccountKey int
		,@Amount money
		,@SalesTaxKey int
		,@SalesTaxAccountKey int
		,@SalesTaxAmount money
		,@SalesTax2Key int
		,@SalesTax2AccountKey int
		,@SalesTax2Amount money
		,@AdvBillAmount money
		,@AdvBillTaxAmount money
		,@AdvBillNoTaxAmount money
		,@InvoiceNumber varchar(100)
		,@Posted tinyint
		,@ParentInvoiceKey int
		,@ParentInvoice tinyint
		,@PercentageSplit decimal(24,4)
		,@Percent decimal (20,8)
		,@LineInvoiceKey int -- This is the invoice where to get the lines from (the parent invoice)
		,@HeaderOfficeKey int
		,@OpeningTransaction tinyint
		,@AdvanceBill int
			
-- Other vars for GL tran
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
		 @GLClosedDate = GLClosedDate
		,@PostToGL = ISNULL(PostToGL, 0)
		,@TrackOverUnder = ISNULL(TrackOverUnder, 0)
		,@AccrueCostToItemExpenseAccount = ISNULL(AccrueCostToItemExpenseAccount, 0)
		,@LaborOUAccountKey = LaborOverUnderAccountKey
		,@ExpenseOUAccountKey = ExpenseOverUnderAccountKey
		,@POAccruedExpenseAccountKey = POAccruedExpenseAccountKey
		,@POPrebillAccrualAccountKey = POPrebillAccrualAccountKey
		,@AdvBillAccountKey = AdvBillAccountKey
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
	
	Select 
		@InvoiceStatus = InvoiceStatus
		,@TransactionDate = ISNULL(PostingDate, InvoiceDate)
		,@ARAccountKey = ARAccountKey
		,@Amount = BilledAmount
		,@AdvBillAmount = ISNULL(RetainerAmount, 0)
		,@SalesTaxKey = SalesTaxKey
		,@SalesTaxAmount = ISNULL(SalesTax1Amount, 0)
		,@SalesTax2Key = SalesTax2Key
		,@SalesTax2Amount = ISNULL(SalesTax2Amount, 0)
		,@ClassKey = ClassKey
		,@InvoiceNumber = rtrim(ltrim(InvoiceNumber))
		,@ProjectKey = NULL
		,@ClientKey = ClientKey
		,@Posted = Posted
		,@ParentInvoice = ISNULL(ParentInvoice, 0)
		,@ParentInvoiceKey = ISNULL(ParentInvoiceKey, 0)
		,@PercentageSplit = ISNULL(PercentageSplit, 0)
		,@LineInvoiceKey = InvoiceKey -- By default, we get the lines from this invoice
		,@GLCompanyKey = GLCompanyKey
		,@HeaderOfficeKey = OfficeKey
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
		,@AdvanceBill = AdvanceBill 
	From vInvoice (nolock)
	Where InvoiceKey = @InvoiceKey

	Select @AdvBillTaxAmount = SUM(Amount)
	From   tInvoiceAdvanceBillTax (NOLOCK)
	Where  InvoiceKey = @InvoiceKey
	Select @AdvBillTaxAmount = ISNULL(@AdvBillTaxAmount, 0)
		,@AdvBillNoTaxAmount = @AdvBillAmount - ISNULL(@AdvBillTaxAmount, 0)

	if @OpeningTransaction = 1
		Select @PostToGL = 0	
		
	if @ParentInvoice = 1
		-- Parent invoices are never posted, only child invoices
		Select @PostToGL = 0
	else
	BEGIN
		if @ParentInvoiceKey > 0
			Select	@Percent = @PercentageSplit / 100.0
					,@LineInvoiceKey = @ParentInvoiceKey -- The lines belong to the parent invoice
		else
			Select @Percent = 1
	END

	IF @PostToGL = 0 And @Prepost = 0
	BEGIN
		RETURN 1		
	END


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
		
		
	-- These should not change
	Select	@Entity = 'INVOICE'
			,@EntityKey = @InvoiceKey
			,@Reference = @InvoiceNumber
			,@SourceCompanyKey = @ClientKey			
			,@DepositKey = NULL 
	-- TransactionDate, ProjectKey, GLCompanyKey, ClientKey already set
	
	-- Exit when we are not really posting, but preposting
	IF @Prepost = 1
		RETURN 1
		
	/*
	 * Validations
	 */

/*
	Select @TransactionCount = COUNT(*) from #tTransaction Where Entity = @Entity and EntityKey = @EntityKey
	
	EXEC @RetVal = spGLValidatePostTemp @CompanyKey, @Entity, @EntityKey, @kErrBalance, @kErrPosted 
	
	IF @RetVal <> 1
		RETURN @RetVal
*/	
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
		
		-- Just to get the same Entity's collation
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
	
	--exec @RetVal = sptCashQueue @CompanyKey, @Entity, @EntityKey, @TransactionDate, @Action , @AdvanceBill
	
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
	
			 		
	RETURN 1
GO
