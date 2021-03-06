USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertCashVoucher]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertCashVoucher]
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

	Select @PrepaymentAmount = Sum(Amount) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey and Prepay = 1
	Select @PrepaymentAmount = ISNULL(@PrepaymentAmount, 0)

/*
	if exists(Select 1 from tVoucher Where VoucherKey = @VoucherKey and Posted = 1)
		return @kErrPosted
*/
	
	/*
	if @OpeningTransaction = 1
		Select @PostToGL = 0	
	*/
			
			
	if not exists(Select 1 from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey)
		Select @PostToGL = 0


	IF @PostToGL = 0 And @Prepost = 0
	BEGIN
		-- Case when we do not post to GL
		/*
		Update tVoucher
		Set Posted = 1, Status = 4
		Where VoucherKey = @VoucherKey
*/
		RETURN 1		
	END

	if @TransactionDate is null
		return @kErrTranDateMissing
		
	-- Make sure the invoice is not posted prior to the closing date
/*
	if @Prepost = 0
		if not @GLClosedDate is null and @CheckClosedDate = 1
			if @GLClosedDate > @TransactionDate
				return @kErrGLClosedDate
*/

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
			
			
	-- create a temp table to hold the accrued expense account Keys
	create table #tAccruedExpenseAccount
		(
		VoucherDetailKey int null
		,GLAccountKey int null
		,GLAccountErrRet int null
		)	
		
	-- These should not change
	Select	@Entity = 'VOUCHER'
			,@EntityKey = @VoucherKey
			,@Reference = @InvoiceNumber
			,@SourceCompanyKey = @VendorKey			
			,@DepositKey = NULL 
	-- TransactionDate, ProjectKey, GLCompanyKey, ClientKey already set
	
	if @CreditCard = 1
	Select	@Entity = 'CREDITCARD'
		
	/*
	* Insert the header/AP Amount
	*/
	
	SELECT @PostSide = 'C'
		  ,@GLAccountKey = @APAccountKey
		  ,@GLAccountErrRet = @kErrInvalidAPAcct 
		  ,@Memo = @kMemoHeader + @InvoiceNumber, @Section = @kSectionHeader 
		  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
			
	exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	
	/*		
	* Sales Tax Amount
	*/
	
	if @SalesTaxAmount <> 0
	BEGIN
		-- this GL account will be validated later
		SELECT @GLAccountKey = APPayableGLAccountKey 
			  ,@GLAccountErrRet = @kErrInvalidSalesTaxAcct
		FROM   tSalesTax (nolock) Where SalesTaxKey = @SalesTaxKey
						
		SELECT @PostSide = 'D', @Amount = @SalesTaxAmount
			   ,@Memo = @kMemoSalesTax + @InvoiceNumber, @Section = @kSectionSalesTax  
			   ,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
				
	END		
	
	/*
	* Sales Tax 2 Amount
	*/
	
	if @SalesTax2Amount <> 0
	BEGIN
		-- this GL account will be validated later
		SELECT @GLAccountKey = APPayableGLAccountKey 
			  ,@GLAccountErrRet = @kErrInvalidSalesTax2Acct
		FROM   tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key
				
		SELECT @PostSide = 'D', @Amount = @SalesTax2Amount
				,@Memo = @kMemoSalesTax2 + @InvoiceNumber, @Section = @kSectionSalesTax  
				,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	END
	
	/*
	 * Prepayments
	 */
	if @PrepaymentAmount  <> 0
	BEGIN
		-- one entry for all prepayments
		SELECT @PostSide = 'D' , @GLAccountKey = @APAccountKey, @GLAccountErrRet = @kErrInvalidAPAcct 
				,@Memo = @kMemoPrepayments, @Amount = @PrepaymentAmount, @Section = @kSectionPrepayments   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet

		-- One entry per class, GL account
		SELECT @PostSide = 'C' , @GLAccountErrRet = @kErrInvalidPrepayAcct 
				,@Memo = @kMemoPrepayments, @Section = @kSectionPrepayments   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
		
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			p.UnappliedPaymentAccountKey, 0, SUM(pd.Amount),
			ISNULL(p.ClassKey, 0),  @Memo,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		Where	pd.VoucherKey = @VoucherKey
		And		pd.Prepay = 1
		Group By p.UnappliedPaymentAccountKey, ISNULL(p.ClassKey, 0) 
		
	END
	
	/*
	 * Prebill Accrual Reversal
	 */

	-- Step 1: determine AccruedExpenseAccountKey
		
	-- Try to get the accrued expense accounts from the pods first		
	Insert #tAccruedExpenseAccount (VoucherDetailKey, GLAccountKey, GLAccountErrRet)
	Select vd.VoucherDetailKey, gl.GLAccountKey, @kErrInvalidPOAccruedExpenseAcct 
	from tVoucherDetail vd (nolock)
	Inner Join tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	Inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	Inner Join tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
	Inner Join tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
	-- validate the GL accounts
	Left Outer join tGLAccount gl (NOLOCK) on pod.AccruedExpenseInAccountKey = gl.GLAccountKey
	Where	vd.VoucherKey = @VoucherKey
	And		po.BillAt in (0,1) 
			
	-- If these are null, then determine from tPreference and tItem
	If @AccrueCostToItemExpenseAccount = 0
	Begin
		Update #tAccruedExpenseAccount
		Set    #tAccruedExpenseAccount.GLAccountKey = @POAccruedExpenseAccountKey
		      ,#tAccruedExpenseAccount.GLAccountErrRet = @kErrInvalidPOAccruedExpenseAcct
		Where ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0 
	End
	Else 
	Begin	
		Update #tAccruedExpenseAccount
		Set    #tAccruedExpenseAccount.GLAccountKey = it.ExpenseAccountKey
		       ,#tAccruedExpenseAccount.GLAccountErrRet = @kErrInvalidExpenseAcct
		From   tVoucherDetail vd (nolock)
			Left Outer Join tItem it (nolock) on vd.ItemKey = it.ItemKey
		Where  ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0 
		And   #tAccruedExpenseAccount.VoucherDetailKey = vd.VoucherDetailKey 
	End
	
	
	-- Step 2: Credits vd.AccruedExpenseOutAccountKey =  pod.AccruedExpenseInAccountKey OR @POAccruedExpenseAccountKey OR item.ExpenseAccountKey
	--, group by office, department, class on the order detail
	SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidPOAccruedExpenseAcct     
			,@Memo = @kMemoPrebillAccruals  + @InvoiceNumber , @Section = @kSectionPrebillAccruals    
			,@DetailLineKey = NULL
			
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		ISNULL(gl.GLAccountKey, 0), 0, ROUND(Sum(vd.PrebillAmount), 2),
		ISNULL(pod.ClassKey, 0),  @Memo,
		i.ClientKey,ISNULL(pod.ProjectKey, 0),@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,ISNULL(pod.OfficeKey, 0),ISNULL(pod.DepartmentKey, 0),@DetailLineKey,@Section,@GLAccountErrRet
	From   tVoucherDetail vd (nolock)
	Inner Join tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	Inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
	Inner Join tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
	Inner Join tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
	Inner Join #tAccruedExpenseAccount gl ON vd.VoucherDetailKey = gl.VoucherDetailKey
	Where	vd.VoucherKey = @VoucherKey 
	And		po.BillAt in (0,1) 
	Group By ISNULL(gl.GLAccountKey, 0), i.ClientKey, ISNULL(pod.ClassKey, 0)
	,ISNULL(pod.ProjectKey, 0) ,ISNULL(pod.OfficeKey, 0),ISNULL(pod.DepartmentKey, 0)

	-- Step 3: Debits, one entry per client and gl class on the order line
	SELECT @PostSide = 'D' , @GLAccountKey = @POPrebillAccrualAccountKey, @GLAccountErrRet = @kErrInvalidPOPrebillAccrualAcct 
			,@Memo = @kMemoPrebillAccruals + @InvoiceNumber, @Section = @kSectionPrebillAccruals   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		@GLAccountKey, Sum(Credit), 0,
		ISNULL(ClassKey, 0), @Memo,
		ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	From   #tTransaction (nolock)
	Where	EntityKey = @EntityKey
	And     Entity = @Entity
	And     Section = @kSectionPrebillAccruals
	And     PostSide = 'C' 
	Group By ClientKey, ISNULL(ClassKey, 0)
	
	 /*
	 * Voucher Lines
	 */

	-- GL Account, office, department, class, project from the line
	SELECT @PostSide = 'D', @GLAccountErrRet = @kErrInvalidLineAcct   
			,@Memo = @kMemoLine + @InvoiceNumber , @Section = @kSectionLine   

	-- One entry per line
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		CASE WHEN vd.WIPPostingOutKey <> 0 AND vd.WIPPostingInKey = -1 THEN vd.OldExpenseAccountKey
		ELSE vd.ExpenseAccountKey END
		, vd.TotalCost, 0,
		vd.ClassKey, Left(@Memo + ' ' + rtrim(ltrim(vd.ShortDescription)), 500),
		vd.ClientKey,vd.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,vd.OfficeKey,vd.DepartmentKey,vd.VoucherDetailKey,@Section,@GLAccountErrRet
	From   tVoucherDetail vd (nolock)
	Where  vd.VoucherKey = @VoucherKey

	 /*
	 * Modification for Media Logic
	 */

	if @WIPRecognizeCostRev = 1
	BEGIN

		-- Production
		SELECT @PostSide = 'D', @GLAccountKey = @WIPExpenseAssetAccountKey, @GLAccountErrRet = @kErrInvalidWIPExpenseAssetAcct   
			,@Memo = @kMemoWIP, @Section = @kSectionWIP, @DetailLineKey = NULL   

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
		
		SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			@WIPExpenseAssetAccountKey, Sum(vd.BillableCost), 0, ISNULL(vd.ClassKey, 0), @Memo,
			ISNULL(vd.ClientKey, 0),ISNULL(vd.ProjectKey, 0),ISNULL(vd.ClientKey, 0),@DepositKey,@PostSide,
			@GLCompanyKey, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0),
			@DetailLineKey,@Section,@GLAccountErrRet
		From	tVoucherDetail vd (nolock)
				left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where	vd.VoucherKey = @VoucherKey
		and		vd.ClientKey is not null
		and		p.NonBillable = 0
		and		i.ItemType = 0
		Group By ISNULL(vd.ClientKey, 0), ISNULL(vd.ProjectKey,0), ISNULL(vd.ClassKey, 0), 
			ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)

		-- Media
		SELECT @PostSide = 'D', @GLAccountKey = @WIPMediaAssetAccountKey, @GLAccountErrRet = @kErrInvalidWIPMediaAssetAcct   
			,@Memo = @kMemoWIP, @Section = @kSectionWIP, @DetailLineKey = NULL   

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
		
		SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			@WIPExpenseAssetAccountKey, Sum(vd.BillableCost), 0, ISNULL(vd.ClassKey, 0), @Memo,
			ISNULL(vd.ClientKey, 0),ISNULL(vd.ProjectKey, 0),ISNULL(vd.ClientKey, 0),@DepositKey,@PostSide,
			@GLCompanyKey, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0),
			@DetailLineKey,@Section,@GLAccountErrRet
		From	tVoucherDetail vd (nolock)
				left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where	vd.VoucherKey = @VoucherKey
		and		vd.ClientKey is not null
		and		p.NonBillable = 0
		and		i.ItemType > 0
		Group By ISNULL(vd.ClientKey, 0), ISNULL(vd.ProjectKey,0), ISNULL(vd.ClassKey, 0), 
			ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)

		-- Credit side by item sales acct
		SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidSalesAcct   
			,@Memo = @kMemoWIP, @Section = @kSectionWIP, @DetailLineKey = NULL   

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
		
		SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			i.SalesAccountKey, 0, Sum(vd.BillableCost), ISNULL(vd.ClassKey, 0), @Memo,
			ISNULL(vd.ClientKey, 0),ISNULL(vd.ProjectKey, 0),ISNULL(vd.ClientKey, 0),@DepositKey,@PostSide,
			@GLCompanyKey, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0),
			@DetailLineKey,@Section,@GLAccountErrRet
		From	tVoucherDetail vd (nolock)
				left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where	vd.VoucherKey = @VoucherKey
		and		vd.ClientKey is not null
		and		p.NonBillable = 0
		Group By i.SalesAccountKey, ISNULL(vd.ClientKey, 0), ISNULL(vd.ProjectKey,0), ISNULL(vd.ClassKey, 0), 
			ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)
	
	END


	-- Correct and prepared data for final insert
	EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
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
	
		-- The data of 2005/2006 may have changed, so the GLAccounts may be missing
		-- Abort if this the case
		IF EXISTS (SELECT 1 FROM #tTransaction
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'D' -- only debits
		AND ISNULL(GLAccountKey, 0) = 0
		)
		RETURN 1
		
		IF EXISTS (SELECT 1 FROM tCashTransactionLine (NOLOCK) where Entity = @Entity and EntityKey = @EntityKey)
			delete  tCashTransactionLine where Entity = @Entity and EntityKey = @EntityKey
		
		INSERT tCashTransactionLine(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, Reversed, Cleared, TempTranLineKey)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, 0, 0, TempTranLineKey	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'D' -- only debits
		  


return 1
GO
