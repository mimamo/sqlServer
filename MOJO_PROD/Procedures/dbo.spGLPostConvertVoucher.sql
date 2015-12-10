USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertVoucher]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertVoucher]
	(
		@CompanyKey int
		,@VoucherKey int
		,@Prepost int = 0		-- Can be used by Preposting as well, Preposting does not validate GL accounts 
		,@CreateTemp int = 1	-- In some cases (PrePost) do not create temp table		
		,@CheckClosedDate int = 1 -- When transferring voucher details, repost them ignoring closed date
	)

AS --Encrypt

/*
  || When     Who Rel   What
  || 10/17/06 GWG 8.35  Moved the Updating of the posted flag to the top of the transaction 
  || 12/5/06  CRG 8.4   Prebill accrual reversals have been modified to post with the correct ClientKey.
  || 01/08/07 GHL 8.4   Added protection against missing GL accounts  
  || 02/21/07 GHL 8.4   Added protection against double postings    
  || 03/15/07 GWG 8.41  Changes for media logic to post revenue to sales accounts   
  || 03/26/07 GHL 8.41  Use billable cost instead of total cost in @WIPRecognizeCostRev case   
  ||                    Create #Sales outside of the transaction
  || 04/02/07 GHL 8.41  Added validation of item sales gl account  
  || 04/03/07 GHL 8.41  Added client lines logic     
  || 04/05/07 GHL 8.41  Added more protection against double postings. Bug 8799.  
  || 06/19/07 GHL 8.5   Modifications for GLCompanyKey, OfficeKey, DepartmentKey + rework               
  || 08/10/07 GHL 8.5   Added param @IgnoreClosedDate
  || 09/17/07 GHL 8.5   Added overhead (more)
  || 10/16/07 GHL 8.5   Corrected memos for accruals and section for prepayments 
  || 10/25/07 GHL 8.5   Corrected GroupBy for prepayments
  || 11/12/07 GHL 8.5   Added logic for old exp accts
  || 12/07/07 GHL 8.5   Changed to vd.PrebillAmount vs pod.TotalCost for pre bill acruals
  || 03/05/08 GHL 8.505 (22514) Removed validation of GL Closing Date when preposting 
  || 04/23/08 GHL 8.509 (25415) Changed order of prebill accruals to eliminate rounding errors 
  ||                    (Detail/Credit first then Summary/Debit)
  || 05/09/08 GHL 8.510 (21023) When doing the prebill accruals we must remember the GL account used
  ||                    It will be used during the prebill accrual reversals in spGLPostInvoice
  || 06/18/08 GHL 8.513 Added logic for OpeningTransaction  
  || 02/26/09 GHL 10.019 Added cash basis process
  */
 
-- Bypass cash basis process or not
DECLARE @TrackCash INT SELECT @TrackCash = 1
 
-- Register all constants
DECLARE @kErrInvalidAPAcct INT					SELECT @kErrInvalidAPAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -2
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -3
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -4
DECLARE @kErrInvalidWIPExpenseAssetAcct INT		SELECT @kErrInvalidWIPExpenseAssetAcct = -5
DECLARE @kErrInvalidWIPMediaAssetAcct INT		SELECT @kErrInvalidWIPMediaAssetAcct = -6
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -7
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -8
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -9
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -10
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -11
DECLARE @kErrTranDateMissing INT				SELECT @kErrTranDateMissing = -12

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Voucher # '
DECLARE @kMemoSalesTax VARCHAR(100)				SELECT @kMemoSalesTax = 'Sales Tax for Voucher # '
DECLARE @kMemoSalesTax2 VARCHAR(100)			SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Voucher # '
DECLARE @kMemoSalesTax3 VARCHAR(100)			SELECT @kMemoSalesTax3 = 'Other Sales Tax for Voucher # '
DECLARE @kMemoPrepayments VARCHAR(100)			SELECT @kMemoPrepayments = 'Reverse Prepayment Accrual '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Prebilled Order Accrual for Voucher # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Voucher # '
DECLARE @kMemoWIP VARCHAR(100)					SELECT @kMemoWIP = 'VI Post WIP Sales'

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionWIP int						SELECT @kSectionWIP = 6


-- Vars for tPref
Declare @PostToGL tinyint
Declare @GLClosedDate smalldatetime
Declare @POAccruedExpenseAccountKey int
Declare @POPrebillAccrualAccountKey int
Declare @IOClientLink int
Declare @BCClientLink int
Declare	@AccrueCostToItemExpenseAccount int
Declare	@WIPRecognizeCostRev int
Declare	@WIPMediaAssetAccountKey int
Declare	@WIPExpenseAssetAccountKey int

-- Vars for invoice info
DECLARE @APAccountKey int
		,@Amount money
		,@SalesTaxKey int
		,@SalesTaxAccountKey int
		,@SalesTaxAmount money
		,@SalesTax2Key int
		,@SalesTax2AccountKey int
		,@SalesTax2Amount money
		,@InvoiceNumber varchar(100)
		,@Posted tinyint
		,@VendorKey int
        ,@VendorID varchar(100)
		,@HeaderOfficeKey INT
		,@PrepaymentAmount money
		,@OpeningTransaction tinyint
		,@CreditCard int
			
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
		@PostToGL = ISNULL(PostToGL, 0)
		,@GLClosedDate = GLClosedDate
		,@POAccruedExpenseAccountKey = POAccruedExpenseAccountKey
		,@POPrebillAccrualAccountKey = POPrebillAccrualAccountKey
		,@IOClientLink = ISNULL(IOClientLink, 1)
		,@BCClientLink = ISNULL(BCClientLink, 1)
		,@AccrueCostToItemExpenseAccount = ISNULL(AccrueCostToItemExpenseAccount, 0)
		,@WIPRecognizeCostRev = ISNULL(WIPRecognizeCostRev, 0)
		,@WIPMediaAssetAccountKey = WIPMediaAssetAccountKey
		,@WIPExpenseAssetAccountKey = WIPExpenseAssetAccountKey
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey

	Select 
		@GLCompanyKey = v.GLCompanyKey
		,@VendorID = rtrim(ltrim(c.VendorID))
		,@TransactionDate = PostingDate
		,@APAccountKey = ISNULL(APAccountKey, 0)
		,@Amount = ISNULL(VoucherTotal, 0)
		,@ClassKey = v.ClassKey
		,@InvoiceNumber = rtrim(ltrim(InvoiceNumber))
		,@ProjectKey = v.ProjectKey
		,@ClientKey = p.ClientKey
		,@VendorKey = c.CompanyKey
		,@Posted = Posted
		,@SalesTaxKey = v.SalesTaxKey
		,@SalesTaxAmount = ISNULL(v.SalesTax1Amount, 0)
		,@SalesTax2Key = v.SalesTax2Key
		,@SalesTax2Amount = ISNULL(v.SalesTax2Amount, 0)
		,@HeaderOfficeKey = v.OfficeKey
		,@OpeningTransaction = ISNULL(OpeningTransaction, 0)
		,@CreditCard = ISNULL(CreditCard, 0)
	From tVoucher v (nolock)
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	Where v.VoucherKey = @VoucherKey
	
	if @OpeningTransaction = 1
		Select @PostToGL = 0	
						
	if not exists(Select 1 from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey)
		Select @PostToGL = 0
	IF @PostToGL = 0 And @Prepost = 0
	BEGIN
		RETURN 1		
	END

if @CreditCard = 1
begin
	SELECT @kMemoHeader = 'Credit Card Charge '
	SELECT @kMemoSalesTax = 'Sales Tax for Credit Card Charge '
	SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Credit Card Charge '
	SELECT @kMemoSalesTax3 = 'Other Sales Tax for Credit Card Charge '
	SELECT @kMemoPrepayments = 'Reverse Prepayment Accrual '
	SELECT @kMemoPrebillAccruals = 'Reverse Order Accrual for Credit Card Charge '
	SELECT @kMemoLine = 'Credit Card Charge '
	SELECT @kMemoWIP = 'VI Post WIP Sales'
end

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
	
		
	-- These should not change
	Select	@Entity = 'VOUCHER'
			,@EntityKey = @VoucherKey
			,@Reference = @InvoiceNumber
			,@SourceCompanyKey = @VendorKey			
			,@DepositKey = NULL 
	-- TransactionDate, ProjectKey, GLCompanyKey, ClientKey already set
		
if @CreditCard = 1
	Select	@Entity = 'CREDITCARD'

	-- Correct and prepared data for final insert
	--EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
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
	
		If @CashEntity IN ('VOUCHER', 'CREDITCARD')
			exec @RetVal = sptCashPostVoucher @CompanyKey, @CashEntityKey
	
		If @CashEntity = 'PAYMENT'
			exec @RetVal = sptCashPostPayment @CompanyKey, @CashEntityKey
					  	
	End
	
	
	END -- End Track Cash

	/*
	 * Posting!!
	 */
		
	
	
	IF @TrackCash = 1
	BEGIN
				
			
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
	
return 1
GO
