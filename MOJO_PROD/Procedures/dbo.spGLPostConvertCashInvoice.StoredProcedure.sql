USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertCashInvoice]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertCashInvoice]
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
|| 09/30/09 GHL 10.5    Using now tInvoiceTax
*/
	
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

	-- Invoice is not approved
	/*
	if @InvoiceStatus < 4
		return @kErrNotApproved

	if @Posted = 1
		return @kErrPosted
	
	*/
		
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
		-- Case when we do not post to GL
		/*
		Update tInvoice
		Set Posted = 1, InvoiceStatus = 4
		Where InvoiceKey = @InvoiceKey
	*/
	
		RETURN 1		
	END

/*
	-- Make sure the invoice is not posted prior to the closing date
	if @Prepost = 0 and @GLClosedDate is not null
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
	
	If exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @LineInvoiceKey And BillFrom = @kLineUseTransactions)
		-- create a temp table to hold the Keys and amounts
		create table #tLineDetail
			(
			InvoiceLineKey int null
			,GLAccountKey int null
			,GLAccountErrRet int null
			,ClassKey int null
			,OfficeKey int null
			,DepartmentKey int null
			,ProjectKey int null
			,Amount money null 
			)
	
	-- create a temp table to hold the accrued expense account Keys
	create table #tAccruedExpenseAccount
		(
		PurchaseOrderDetailKey int null
		,GLAccountKey int null
		,GLAccountErrRet int null
		,VoucherPosted int null
		)	
		
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
	
	/*
	* Insert the header/AR Amount
	*/
	
	SELECT @PostSide = 'D'
		  ,@GLAccountKey = @ARAccountKey
		  ,@GLAccountErrRet = @kErrInvalidARAcct 
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
		SELECT @GLAccountKey = PayableGLAccountKey 
			  ,@GLAccountErrRet = @kErrInvalidSalesTaxAcct
		FROM   tSalesTax (nolock) Where SalesTaxKey = @SalesTaxKey
						
		SELECT @PostSide = 'C', @Amount = @SalesTaxAmount
			   ,@Memo = @kMemoSalesTax + @InvoiceNumber, @Section = @kSectionSalesTax  
			   ,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = @SalesTaxKey

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
				
	END		
	
	/*
	* Sales Tax 2 Amount
	*/
	
	if @SalesTax2Amount <> 0
	BEGIN
		-- this GL account will be validated later
		SELECT @GLAccountKey = PayableGLAccountKey 
			  ,@GLAccountErrRet = @kErrInvalidSalesTax2Acct
		FROM   tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key
				
		SELECT @PostSide = 'C', @Amount = @SalesTax2Amount
				,@Memo = @kMemoSalesTax2 + @InvoiceNumber, @Section = @kSectionSalesTax  
				,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = @SalesTax2Key

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	END
	
	/*
	* Other Sales Taxes
	*/
	
	SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidSalesTax3Acct
			,@Memo = @kMemoSalesTax3 + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per GL Account
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	/* Query now tInvoiceTax because they could be edited on child invoices
	SELECT @CompanyKey,@TransactionDate,@Entity, @EntityKey,@Reference,
		st.PayableGLAccountKey, 0, ROUND(Sum(ilt.SalesTaxAmount) * @Percent, 2), @ClassKey, @Memo,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,st.SalesTaxKey,@Section,@GLAccountErrRet
	From   tInvoiceLineTax ilt (nolock)
		Inner Join tInvoiceLine il (NOLOCK) ON ilt.InvoiceLineKey = il.InvoiceLineKey
		Inner Join tSalesTax st (NOLOCK) ON ilt.SalesTaxKey = st.SalesTaxKey
	Where  il.InvoiceKey = @LineInvoiceKey	-- Use the invoice key were the lines are !!!
	Group by st.SalesTaxKey,st.PayableGLAccountKey
	*/
	
	SELECT @CompanyKey,@TransactionDate,@Entity, @EntityKey,@Reference,
		st.PayableGLAccountKey, 0, Sum(it.SalesTaxAmount) , @ClassKey, @Memo,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,st.SalesTaxKey,@Section,@GLAccountErrRet
	From   tInvoiceTax it (nolock)
		Inner Join tSalesTax st (NOLOCK) ON it.SalesTaxKey = st.SalesTaxKey
	Where  it.InvoiceKey = @InvoiceKey	
	And    it.Type = 3 -- Other taxes
	Group by st.SalesTaxKey,st.PayableGLAccountKey
	
			
	/*		
	* Now take care of Advance Billings (see Billing/Invoice Entry.doc)
	*/
	
	-- Credit AR with Adv Bill Amount @AdvBillAmount
	-- Logically we should do this but because we take BilledAmount for the header
	-- instead of InvoiceTotalAmount, we can skip
	
	-- Debit Deferred Revenue
	if @AdvBillNoTaxAmount <> 0
	BEGIN		
		SELECT @PostSide = 'D'
			  ,@GLAccountKey = @AdvBillAccountKey
			  ,@GLAccountErrRet = @kErrInvalidAdvBillAcct 
			  ,@Amount = @AdvBillNoTaxAmount
			  ,@Memo = @kMemoAdvBill  + @InvoiceNumber + ' Debit Deferred Revenue', @Section = @kSectionHeader  
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	END
	
	-- Debit Advance Bill Sales Taxes
	SELECT @PostSide = 'D',@GLAccountErrRet = @kErrInvalidSalesTax3Acct
			,@Memo = @kMemoAdvBill + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@DepartmentKey = NULL, @DetailLineKey = NULL

	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	-- group probably by gl account, class, office
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		st.PayableGLAccountKey, Sum(iabt.Amount), 0,
		ISNULL(abi.ClassKey, 0),  @Memo + ' Debit sales tax ',
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,ISNULL(abi.OfficeKey, 0),@DepartmentKey,st.SalesTaxKey,@Section,@GLAccountErrRet
	From   tInvoiceAdvanceBillTax iabt (nolock)
		Inner Join tInvoice abi (NOLOCK) ON iabt.AdvBillInvoiceKey = abi.InvoiceKey -- go to the AdvBill invoice
		Inner Join tSalesTax st (NOLOCK) ON iabt.SalesTaxKey = st.SalesTaxKey
	Where  iabt.InvoiceKey = @InvoiceKey	-- Real invoice, not like invoice line tax
	Group by st.SalesTaxKey, st.PayableGLAccountKey, ISNULL(abi.ClassKey, 0), ISNULL(abi.OfficeKey, 0) 
			
	/*		
	*Reverse the prepayments (only for those checks that have not been posted)
	*/
	
	SELECT @PostSide = 'D' ,@GLAccountErrRet = @kErrInvalidPrepayAcct 
			,@Memo = @kMemoPrepayments , @Section = @kSectionPrepayments   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per payment applied
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		c.PrepayAccountKey, ca.Amount, 0,
		c.ClassKey,  @Memo + c.ReferenceNumber ,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, 1
	From   tCheckAppl ca (nolock)
		Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
	Where	ca.InvoiceKey = @InvoiceKey
	And		ca.Prepay = 1
	
	-- We must also reverse the AR -- Credit -- Use Class on Invoice Header
	-- One entry for all prepayments
	SELECT @PostSide = 'C', @GLAccountKey = @ARAccountKey, @GLAccountErrRet = @kErrInvalidARAcct 
			,@Memo = @kMemoPrepayments, @Section = @kSectionPrepayments    
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	SELECT @Amount = SUM(Debit) FROM #tTransaction WHERE GPFlag = 1 AND Entity = @Entity AND EntityKey = @EntityKey
	UPDATE #tTransaction SET GPFlag = 0 WHERE Entity = @Entity AND EntityKey = @EntityKey

	exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	
	 /*
	 * Prebill Accruals
	 */

	-- Step 1: determine AccruedExpenseAccountKey
	
	-- Capture all pods
	-- because of split billings, where 2 child invoices could be linked to 1 pod
	-- one invoice could already be posted and the other not, so try to get an existing GLAccountKey from the pod 
	-- i.e. from a posted invoice 
	Insert #tAccruedExpenseAccount (PurchaseOrderDetailKey, GLAccountKey, GLAccountErrRet, VoucherPosted)
	Select pod.PurchaseOrderDetailKey, pod.AccruedExpenseInAccountKey
	      , @kErrInvalidPOAccruedExpenseAcct, 0
	From   tPurchaseOrderDetail pod (nolock)
		Inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		Inner Join tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
	Where	il.InvoiceKey = @LineInvoiceKey  -- must point to invoice where lines are
	And po.BillAt in (0,1)
	
	-- Then look for a valid Accrued Expense Account on a voucher detail
	-- we could have several vds associated to each pod, I suggest we take anyone
	-- Having AccruedExpenseOutAccountKey could happen but should be rare
	-- I would think they bill the clients first, unless they delete client invoices like Brothers Co
	Update #tAccruedExpenseAccount
	Set    #tAccruedExpenseAccount.GLAccountKey = 
			Case When ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0 
			     Then vd.AccruedExpenseOutAccountKey
                 Else #tAccruedExpenseAccount.GLAccountKey
            End
          ,#tAccruedExpenseAccount.VoucherPosted = v.Posted 
	From   tVoucherDetail vd (NOLOCK)
		Inner Join tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
	Where  #tAccruedExpenseAccount.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
	
	-- If the voucher is posted AND there is no accrued expense account
	-- do not try to set a prebill accrual, we will not be able to reverse the accrual
	Delete #tAccruedExpenseAccount Where VoucherPosted = 1 And ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0
		
	-- Now set the prebill accrual accounst based on preferences	
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
		From   tPurchaseOrderDetail pod (nolock)
			Left Outer Join tItem it (nolock) ON pod.ItemKey = it.ItemKey
		Where ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0 
		And   #tAccruedExpenseAccount.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
	End

	-- Step 2: Debit vd.AccruedExpenseOutKey OR @POAccruedExpenseAccountKey OR it.ExpenseAccountKey
	--, group by office, department, class on the order detail, and project
	SELECT @PostSide = 'D',@Memo = @kMemoPrebillAccruals + @InvoiceNumber , @Section = @kSectionPrebillAccruals    
			,@DetailLineKey = NULL

	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		ISNULL(gl.GLAccountKey, 0), ROUND(Sum(pod.TotalCost) * @Percent, 2), 0,
		ISNULL(pod.ClassKey, 0),  @Memo,
		@ClientKey,ISNULL(pod.ProjectKey, 0),@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,ISNULL(pod.OfficeKey, 0),ISNULL(pod.DepartmentKey, 0),@DetailLineKey,@Section, gl.GLAccountErrRet
	From   tPurchaseOrderDetail pod (nolock)
		Inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		Inner Join tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
		Inner Join #tAccruedExpenseAccount gl ON gl.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
	Where	il.InvoiceKey = @LineInvoiceKey  -- must point to invoice where lines are
	And po.BillAt in (0,1) 
	Group By ISNULL(gl.GLAccountKey, 0), gl.GLAccountErrRet, ISNULL(pod.ClassKey, 0),ISNULL(pod.ProjectKey, 0),ISNULL(pod.OfficeKey, 0),ISNULL(pod.DepartmentKey, 0)

	
	-- Step 3: Credit @POPrebillAccrualAccountKey, group by class on the order detail
	SELECT @PostSide = 'C', @GLAccountKey = @POPrebillAccrualAccountKey, @GLAccountErrRet = @kErrInvalidPOPrebillAccrualAcct   
			,@Memo = @kMemoPrebillAccruals + @InvoiceNumber , @Section = @kSectionPrebillAccruals    
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per class from the pod detail
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		@GLAccountKey, 0, Sum(Debit),
		ISNULL(ClassKey, 0), @Memo,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	From   #tTransaction (nolock)
	Where	EntityKey = @EntityKey
	And     Entity = @Entity
	And     Section = @kSectionPrebillAccruals
	And     PostSide = 'D' 
	Group By ISNULL(ClassKey, 0)

	 /*
	 * Invoice Lines
	 */

	-- If No Transactions, just look at the invoice lines, not the detail transactions
	-- GL Sales Account, office, department, class, project from the line
	SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidLineAcct   
			,@Memo = @kMemoLine + @InvoiceNumber , @Section = @kSectionLine   

	-- One entry per line
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		il.SalesAccountKey, 0, ROUND(il.TotalAmount * @Percent, 2),
		il.ClassKey, Left(@Memo + ' ' + rtrim(ltrim(il.LineSubject)), 500),
		@ClientKey,il.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,il.OfficeKey,il.DepartmentKey,il.InvoiceLineKey,@Section,@GLAccountErrRet
	From  tInvoiceLine il (nolock)
	Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
	And    il.BillFrom = @kLineNoTransactions
	And    il.LineType = @kLineTypeDetail

	-- If Use Transactions, look at the detail transactions for some fields, not the invoice lines 
	-- If PostSalesUsingDetail = 1 get GL Sales Account + class from transactions
	-- If PostSalesUsingDetail = 0 get GL Account + class from lines
	-- Office, Department, project from the transactions
	If exists(Select 1 from tInvoiceLine (nolock) Where InvoiceKey = @LineInvoiceKey 
				and BillFrom = @kLineUseTransactions And LineType = @kLineTypeDetail)
	Begin			
	
		If @TrackOverUnder = 0
		Begin 		
			-- we do not care about standard, over under amount, just take amount	
			/*
			
			-- This View takes too long on APP/APP2!!!!!
			
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(v.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(v.ClassKey,0) ELSE ISNULL(il.ClassKey, 0) END
			,ISNULL(v.OfficeKey, 0), ISNULL(v.DepartmentKey, 0), ISNULL(v.ProjectKey, 0)
			, v.Amount * @Percent
			From tInvoiceLine il (nolock)
				Inner Join vSalesGLDetail v (nolock) on il.InvoiceLineKey = v.InvoiceLineKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			*/
			
			-- Labor
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(s.GLAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(s.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, ROUND(t.BilledHours * t.BilledRate, 2) 
			From tInvoiceLine il (nolock)
				Inner Join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- Misc Cost
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled
			From tInvoiceLine il (nolock)
				Inner Join tMiscCost t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- ER
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled 
			From tInvoiceLine il (nolock)
				Inner Join tExpenseReceipt t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- VI
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled 
			From tInvoiceLine il (nolock)
				Inner Join tVoucherDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail

			-- PO
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled 
			From tInvoiceLine il (nolock)
				Inner Join tPurchaseOrderDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail

						
		End -- @TrackOverUnder = 0

		If @TrackOverUnder = 1
		Begin
			/*
			-- Standard Part
			
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(v.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(v.ClassKey,0) ELSE ISNULL(il.ClassKey, 0) END
			,ISNULL(v.OfficeKey, 0), ISNULL(v.DepartmentKey, 0), ISNULL(v.ProjectKey, 0)
			,v.Standard * @Percent
			From tInvoiceLine il (nolock)
				Inner Join vSalesGLDetail v (nolock) on il.InvoiceLineKey = v.InvoiceLineKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
	
			*/
			
			-- Standard Part
			
			-- Labor
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(s.GLAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 
						THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(s.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, ROUND(t.ActualHours * t.ActualRate, 2) 
			From tInvoiceLine il (nolock)
				Inner Join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- Misc Cost
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.BillableCost 
			From tInvoiceLine il (nolock)
				Inner Join tMiscCost t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- ER
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.BillableCost 
			From tInvoiceLine il (nolock)
				Inner Join tExpenseReceipt t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- VI
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.BillableCost 
			From tInvoiceLine il (nolock)
				Inner Join tVoucherDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail

			-- PO
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			,CASE 
				WHEN po.BillAt = 0 THEN t.BillableCost
				WHEN po.BillAt = 1 THEN t.TotalCost 
				WHEN po.BillAt = 2 THEN (t.BillableCost - t.TotalCost) 
				ELSE t.BillableCost
			END 
			
			From tInvoiceLine il (nolock)
				Inner Join tPurchaseOrderDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail

			
			/*
			
			-- Over Under Part
			
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,CASE WHEN v.Type = 'L' THEN ISNULL(@LaborOUAccountKey, 0) ELSE ISNULL(@ExpenseOUAccountKey, 0) END
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(v.ClassKey,0) ELSE ISNULL(il.ClassKey, 0) END
			,ISNULL(v.OfficeKey, 0), ISNULL(v.DepartmentKey, 0), ISNULL(v.ProjectKey, 0)
			, (v.Amount - v.Standard) * @Percent
			From tInvoiceLine il (nolock)
				Inner Join vSalesGLDetail v (nolock) on il.InvoiceLineKey = v.InvoiceLineKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			*/
			
			-- Over Under Part
			
			-- Labor
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,ISNULL(@LaborOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 
						THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(s.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			,ROUND(t.BilledHours * t.BilledRate, 2) - ROUND(t.ActualHours * t.ActualRate, 2) 
			From tInvoiceLine il (nolock)
				Inner Join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tService s (nolock) on t.ServiceKey = s.ServiceKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- Misc Cost
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled - t.BillableCost
			From tInvoiceLine il (nolock)
				Inner Join tMiscCost t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- ER
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			,(t.AmountBilled - t.BillableCost)
			From tInvoiceLine il (nolock)
				Inner Join tExpenseReceipt t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- VI
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, (t.AmountBilled - t.BillableCost)
			From tInvoiceLine il (nolock)
				Inner Join tVoucherDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- PO
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount)
			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
						ELSE ISNULL(it.ClassKey, 0) 
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, (t.AmountBilled 
			- CASE 
				WHEN po.BillAt = 0 THEN t.BillableCost 
				WHEN po.BillAt = 1 THEN t.TotalCost
				WHEN po.BillAt = 2 THEN t.BillableCost - t.TotalCost
				ELSE t.BillableCost			
			END 
			) 
			From tInvoiceLine il (nolock)
				Inner Join tPurchaseOrderDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
		End

		
		SELECT @PostSide = 'C', @Memo = @kMemoLine + @InvoiceNumber , @Section = @kSectionLine   
		
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
				
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			b.GLAccountKey, 0, ROUND(Sum(b.Amount) * @Percent, 2), b.ClassKey,
			Left(@Memo + ' ' + rtrim(ltrim(il.LineSubject)), 500), 
			@ClientKey,b.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,b.OfficeKey,b.DepartmentKey,b.InvoiceLineKey,@Section,b.GLAccountErrRet
		From #tLineDetail b
		Inner Join tInvoiceLine il on b.InvoiceLineKey = il.InvoiceLineKey
		Group By b.InvoiceLineKey, il.LineSubject, b.GLAccountKey, b.GLAccountErrRet,
		b.ClassKey, b.OfficeKey, b.DepartmentKey, b.ProjectKey
						 
	 End
	 			 		
	/*
	 * End Invoice Lines
	 */

	-- Correct and prepared data for final insert
	EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	
	-- Patch To fix rounding errors with split billing
	If @Percent <> 1 -- or @Percentage <> 100 
	BEGIN
		DECLARE @SplitDetailLineKey INT
		DECLARE @SplitRoundingError MONEY
		DECLARE @SplitMaxAmount MONEY
		
		--select * from #tTransaction
		
		SELECT @SplitRoundingError = 
		(SELECT SUM(Debit - Credit)
		FROM   #tTransaction
		WHERE  Entity = @Entity
		AND    EntityKey = @EntityKey
		)
		
		--select @SplitRoundingError
		
		-- If there is a rounding error, add it to one line		
		IF @SplitRoundingError <> 0
		BEGIN
			-- use our general purpose flag to identify each line
			SELECT @SplitDetailLineKey = 0
			UPDATE #tTransaction
			SET    #tTransaction.GPFlag = @SplitDetailLineKey
			       ,@SplitDetailLineKey = @SplitDetailLineKey + 1
			WHERE  Entity = @Entity
			AND    EntityKey = @EntityKey
			AND    [Section] = 2 -- line
			
			-- We will modify the line with the max amount
			SELECT @SplitMaxAmount = MAX(ABS(Debit - Credit))
			FROM   #tTransaction
			WHERE  Entity = @Entity
			AND    EntityKey = @EntityKey
			AND    [Section] = 2 -- line
			
			SELECT @SplitDetailLineKey = NULL
			
			SELECT @SplitDetailLineKey = GPFlag
			FROM   #tTransaction
			WHERE  Entity = @Entity
			AND    EntityKey = @EntityKey
			AND    [Section] = 2 -- line
			AND    ABS(Debit - Credit) = @SplitMaxAmount
			
			IF @SplitDetailLineKey IS NOT NULL
				UPDATE #tTransaction
				SET    Credit = Credit + @SplitRoundingError
				WHERE  Entity = @Entity
				AND    EntityKey = @EntityKey
				AND    [Section] = 2 -- line
				AND    GPFlag = @SplitDetailLineKey
			
		END
	END

    --select * from #tTransaction

	-- Exit when we are not really posting, but preposting
	IF @Prepost = 1
		RETURN 1
		
	/*
	 * Validations
	 */

	--Select @TransactionCount = COUNT(*) from #tTransaction Where Entity = @Entity and EntityKey = @EntityKey
	
	/*
	EXEC @RetVal = spGLValidatePostTemp @CompanyKey, @Entity, @EntityKey, @kErrBalance, @kErrPosted 
	
	IF @RetVal <> 1
		RETURN @RetVal
	*/
	
	
	/*
	 * Posting!!
	 */
	 
		--select * from #tTransaction
		
		-- The data of 2005/2006 may have changed, so the GLAccounts may be missing
		-- Abort if this the case
		IF EXISTS (SELECT 1 FROM #tTransaction
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'C' -- only credits
		AND ISNULL(GLAccountKey, 0) = 0
		)
		RETURN 1
		
		
		
		
		-- once the transaction lines have been validated, store them in #tCashTransactionLine
	INSERT #tCashTransactionLine(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, TempTranLineKey,
		AdvBillAmount, PrepaymentAmount, ReceiptAmount)
		
	SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, TempTranLineKey,
		0,0,0	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'C' -- only credits
		 
	-- this will populate #tInvoiceAdvanceBillSale and #tCashTransactionLine.AdvBillAmount	 
	EXEC @RetVal = sptCashPostInvoiceFillABSale @InvoiceKey	
			
	-- and calculate the Prepayment and Receipt amounts
	EXEC @RetVal = sptCashPostInvoiceCalcLineAmounts @InvoiceKey
	
	
	BEGIN TRAN
	
		INSERT tCashTransactionLine(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, Reversed, Cleared, TempTranLineKey,
		AdvBillAmount, PrepaymentAmount, ReceiptAmount)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, 0, 0, TempTranLineKey,	
		AdvBillAmount, PrepaymentAmount, ReceiptAmount
		FROM #tCashTransactionLine 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'C' -- only credits
		  
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
	
		UPDATE #tInvoiceAdvanceBillSale
		SET    #tInvoiceAdvanceBillSale.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  ctl.Entity = 'INVOICE'
		AND    ctl.EntityKey = @InvoiceKey  
		AND    #tInvoiceAdvanceBillSale.TempTranLineKey = ctl.TempTranLineKey
		
		DELETE #tInvoiceAdvanceBillSale WHERE CashTransactionLineKey IS NULL
			
		INSERT tInvoiceAdvanceBillSale (InvoiceKey,AdvBillInvoiceKey,CashTransactionLineKey,Amount)		
		SELECT InvoiceKey,AdvBillInvoiceKey,CashTransactionLineKey,Amount
		FROM   #tInvoiceAdvanceBillSale
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
		
		
		COMMIT TRAN	
		 		
		 		
	RETURN 1
GO
