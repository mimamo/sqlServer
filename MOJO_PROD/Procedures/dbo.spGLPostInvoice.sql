USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostInvoice]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostInvoice]
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
|| 03/06/09 GHL 10.020 (48426) Using now tTime.BilledService to get GLAccountKey
|| 03/27/09 GHL 10.022 (49542) Even if OpeningTransaction = 1, save cash basis prep tables
|| 04/09/09 GHL 10.223 (50761) Using now AccruedCost instead of TotalCost since we found at Third Degree
||                      many instances where TotalCost <> AccruedCost and PrebilAmount used in spGLPostVoucher
||                      is calculated from AccruedCost. This creates discrepancies between GL and accrued order report
|| 04/16/09 GHL 10.223  Added support of tTransactionOrderAccrual to help with prebilled order accruals
|| 07/20/09 GHL 10.505  (57521) Corrected source of ClassKey for MC/VC/PO (same as vSaleGLDetail)
|| 09/25/09 GHL 10.505  (61519) Post Prebill Accruals only for parent invoices (not child invoices) or reg inv
|| 09/30/09 GHL 10.5    Using now tInvoiceTax
|| 01/22/10 GHL 10.517  (72848) Getting now the office and department from POD and VD lines instead of from project on lines
||                      or items. Important when linking orders through media estimates
|| 09/16/10 GHL 10.535  Added insert in tTransactionOrderAccrual when OpeningTransaction = 1 or no posting to GL
|| 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
|| 03/26/12 GHL 10.554 Made changes for ICT 
||                     - read tInvoiceLine.TargetCompanyKey (will be null if not ICT)
||                     - call spGLPostCreateDTDF to create Due To/Due From GL trans (level = GLCompanyKey only)
||                     - calc taxes from tInvoiceTax (grouped by GLCompanyKey)
||                     - group accrued order by GLCompanyKey  
|| 03/29/12 GHL 10.554  Added logic for GLCompanySource
|| 06/27/12 GHL 10.557  Added separate errors for header and line gl accounts
|| 07/03/12 GHL 10.557  Removed call to spGLPostICTCreateDTDF (cash basis) and added to cash basis function
|| 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey
|| 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
|| 10/21/12 GWG 10.561  Modified the posting with glcompany source. Added in the getting of class from the person.
|| 10/25/12 GHL 10.561  For line details, if PostSalesUsingDetail = 0, get the GL Company Key from the client invoice
||                      (either from il.TargetGLCompanyKey or i.GLCompanyKey)
||                      only if PostSalesUsingDetail = 1, get the GL Company Key from the transaction detail
||                      only if PostSalesUsingDetail = 1 and time/ERs, take in account p.GLCompanySource
|| 12/13/12 GHL 10.563  (161899) Insert Project in both sides of the accrual gl posting
|| 01/22/13 GHL 10.564 (164475) Added error @kErrICTBlankGLAccount = -103 as a last defense protection
||                     against null gl accounts linked to ICT
|| 01/23/13 GHL 10.564 (166010) Removed deletion on media accruals if one of the corresponding vouchers is posted and
||                     the GL account is null. With multiple voucher details associated to a POD (adjustments? like 5 at Fry Hammond)
||                     there could be gl account null and some not null. Do the accrual no matter what 
|| 02/15/13 GHL 10.565 TrackCash = 1 now 
|| 05/13/13 GHL 10.567 (171627) Instead of closing PO details at Commission Only in a loop, do it in a single shot
|| 06/24/13 GHL 10.569 (182080) Using now #tTransaction.GPFlag (general purpose flag) to validate missing offices and depts 
||                      This is why I execute sptGLValidatePostTemp before exiting in case of preposting
|| 08/05/13 GHL 10.571 Added Multi Currency stuff
|| 01/14/14 GHL 10.576 (201908) When opening transaction = 1, allow payments to be reposted in cash basis  
|| 01/16/14 GHL 10.576 Calling now spGLPostCredit for multicurrency credits
|| 02/06/14 GHL 10.576 (205570) Since there is a department on the misc costs, take it from the misc cost then if null the item
|| 04/11/14 GHL 10.579 (212612) If the Item is null, get #tAccruedExpenseAccount.GLAccountKey from BilledItem
|| 08/28/14 GHL 10.584 (226613) An Adv Bill can be applied to posted regular invoices, need to split AB process
|| 01/05/15 GHL 10.588 Taking in account now tPreference.DefaultDepartmentFromUser for time entries
|| 03/10/15 GHL 10.590 Pick tTime.DepartmentKey instead of taking in account tPreference.DefaultDepartmentFromUser 
||                     The handling of DefaultDepartmentFromUser has been moved to the time entry insert and update
*/
-- Bypass cash basis process or not
DECLARE @TrackCash INT SELECT @TrackCash = 1
	
-- Register all constants
DECLARE @kErrNotApproved INT					SELECT @kErrNotApproved = -1
DECLARE @kErrInvalidARAcct INT					SELECT @kErrInvalidARAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -3
DECLARE @kErrInvalidAdvBillAcct INT				SELECT @kErrInvalidAdvBillAcct = -4
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -5
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -6
DECLARE @kErrInvalidSalesTax3Acct INT			SELECT @kErrInvalidSalesTax3Acct = -7
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -8
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -9
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -10
DECLARE @kErrInvalidOUAcct INT					SELECT @kErrInvalidOUAcct = -11
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -12
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -13

DECLARE @kErrInvalidRoundingDiffAcct int		SELECT @kErrInvalidRoundingDiffAcct = -350
DECLARE @kErrInvalidRealizedGainAcct int		SELECT @kErrInvalidRealizedGainAcct = -351

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrICTBlankGLAccount INT				SELECT @kErrICTBlankGLAccount = -103
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Invoice # '
DECLARE @kMemoAdvBill VARCHAR(100)				SELECT @kMemoAdvBill = 'Advance Billing for Invoice # '
DECLARE @kMemoSalesTax VARCHAR(100)				SELECT @kMemoSalesTax = 'Sales Tax for Invoice # '
DECLARE @kMemoSalesTax2 VARCHAR(100)			SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Invoice # '
DECLARE @kMemoSalesTax3 VARCHAR(100)			SELECT @kMemoSalesTax3 = 'Other Sales Tax for Invoice # '
DECLARE @kMemoPrepayments VARCHAR(100)			SELECT @kMemoPrepayments = 'Prepayment Reversal Check # '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Prebilled Order Accrual for Invoice # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Invoice # '
DECLARE @kMemoRealizedGain VARCHAR(100)			SELECT @kMemoRealizedGain = 'Multi Currency Realized Gain/Loss '
DECLARE @kMemoMCRounding VARCHAR(100)			SELECT @kMemoMCRounding = 'Multi Currency Rounding Diff '

DECLARE @kSectionHeader int						SELECT @kSectionHeader = 1
DECLARE @kSectionLine int						SELECT @kSectionLine = 2
DECLARE @kSectionPrepayments int				SELECT @kSectionPrepayments = 3
DECLARE @kSectionPrebillAccruals int			SELECT @kSectionPrebillAccruals = 4
DECLARE @kSectionSalesTax int					SELECT @kSectionSalesTax = 5
DECLARE @kSectionICT int						SELECT @kSectionICT = 8
DECLARE @kSectionMCRounding int					SELECT @kSectionMCRounding = 9
DECLARE @kSectionMCGain int						SELECT @kSectionMCGain = 10

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
		,@Customizations varchar(1000)
		,@UseMultiCompanyGLCloseDate tinyint
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  
		,@IsCreditInvoice int -- for multi currency, if it is a credit, we need to post the credits
		,@DefaultDepartmentFromUser int

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
		,@AdvBillAmountFromAB money -- added for 226613 AB can apply against posted inv
		,@AdvBillTaxAmountFromAB money
		,@AdvBillNoTaxAmountFromAB money
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
		,@CurrencyID varchar(10)
		,@ExchangeRate decimal(24,7)	

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
		,@PostPrebillAccruals INT
		,@PostBody INT

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
		,@Customizations = ISNULL(Customizations, '')
		,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
		,@MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey
		,@DefaultDepartmentFromUser = isnull(DefaultDepartmentFromUser, 0)  
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey
		
	Select 
		@InvoiceStatus = InvoiceStatus
		,@TransactionDate =  dbo.fFormatDateNoTime(ISNULL(PostingDate, InvoiceDate))
		,@ARAccountKey = ARAccountKey
		,@Amount = InvoiceTotalAmount
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
		,@CurrencyID = CurrencyID
		,@ExchangeRate = isnull(ExchangeRate, 1)
	From vInvoice (nolock)
	Where InvoiceKey = @InvoiceKey

if @Amount <0 
	select @IsCreditInvoice = 1
else
	select @IsCreditInvoice = 0


	if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @GLCompanyKey			

	END

	-- 226613 recalc advbill amounts because RetainerAmount has both IAB applications
	-- we need to split FromAB = 0 and FromAB = 1

	-- Process records where FromAB = 0

	select @AdvBillAmount = sum(Amount)
	from   tInvoiceAdvanceBill (NOLOCK)
	Where  InvoiceKey = @InvoiceKey
	And    isnull(FromAB, 0) = 0

	Select @AdvBillTaxAmount = SUM(iabt.Amount)
	From   tInvoiceAdvanceBillTax iabt (NOLOCK)
		inner join tInvoiceAdvanceBill iab (NOLOCK) on iabt.InvoiceKey = iab.InvoiceKey
		and iabt.AdvBillInvoiceKey = iab.AdvBillInvoiceKey 
	Where  iabt.InvoiceKey = @InvoiceKey
	And    isnull(iab.FromAB, 0) = 0 


	Select @AdvBillAmount = ISNULL(@AdvBillAmount, 0)
	    ,@AdvBillTaxAmount = ISNULL(@AdvBillTaxAmount, 0)
		,@AdvBillNoTaxAmount = ISNULL(@AdvBillAmount, 0) - ISNULL(@AdvBillTaxAmount, 0)
	
	-- Now correct the total amount against AR
	select @Amount = @Amount - @AdvBillAmount

	-- Process records where FromAB = 1

	select @AdvBillAmountFromAB = sum(Amount)
	from   tInvoiceAdvanceBill (NOLOCK)
	Where  AdvBillInvoiceKey = @InvoiceKey
	And    isnull(FromAB, 0) = 1

	Select @AdvBillTaxAmountFromAB = SUM(iabt.Amount)
	From   tInvoiceAdvanceBillTax iabt (NOLOCK)
		inner join tInvoiceAdvanceBill iab (NOLOCK) on iabt.InvoiceKey = iab.InvoiceKey
		and iabt.AdvBillInvoiceKey = iab.AdvBillInvoiceKey 
	Where  iabt.AdvBillInvoiceKey = @InvoiceKey
	And    isnull(iab.FromAB, 0) = 1 


	Select @AdvBillAmountFromAB = ISNULL(@AdvBillAmountFromAB, 0)
	    ,@AdvBillTaxAmountFromAB = ISNULL(@AdvBillTaxAmountFromAB, 0)
		,@AdvBillNoTaxAmountFromAB = ISNULL(@AdvBillAmountFromAB, 0) - ISNULL(@AdvBillTaxAmountFromAB, 0)


	-- Invoice is not approved
	if @InvoiceStatus < 4
		return @kErrNotApproved

	if @Posted = 1
		return @kErrPosted
	/* Allow for the saving of cash basis prep tables	
	if @OpeningTransaction = 1
		Select @PostToGL = 0	
	*/
	
	if @ParentInvoice = 1
	BEGIN
		-- Parent invoices are never posted, only child invoices, execpt for Prebill Accruals
		Select @Percent = 1, @PostPrebillAccruals = 1, @PostBody = 0
	END
	else
	BEGIN
		if @ParentInvoiceKey > 0
			Select	@Percent = @PercentageSplit / 100.0
					,@LineInvoiceKey = @ParentInvoiceKey -- The lines belong to the parent invoice
					,@PostPrebillAccruals = 0,@PostBody = 1
		else
			Select @Percent = 1, @PostPrebillAccruals = 1,@PostBody =1
	END

	IF @PostToGL = 0 And @Prepost = 0
	BEGIN
		-- Case when we do not post to GL
		Update tInvoice
		Set Posted = 1, InvoiceStatus = 4
		Where InvoiceKey = @InvoiceKey
	
		insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, AccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
		select pod.PurchaseOrderDetailKey, @CompanyKey, ROUND(ISNULL(pod.AccruedCost, 0) * @Percent, 2), -1, 'INVOICE', @InvoiceKey, @TransactionDate
		from   tPurchaseOrderDetail pod (nolock)
			inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		Where	il.InvoiceKey = @LineInvoiceKey  -- must point to invoice where lines are
		And po.BillAt in (0,1)

		RETURN 1		
	END

	if @OpeningTransaction = 1 And @Prepost = 0
	begin
		insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, AccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
		select pod.PurchaseOrderDetailKey, @CompanyKey, ROUND(ISNULL(pod.AccruedCost, 0) * @Percent, 2), -1, 'INVOICE', @InvoiceKey, @TransactionDate
		from   tPurchaseOrderDetail pod (nolock)
			inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		Where	il.InvoiceKey = @LineInvoiceKey  -- must point to invoice where lines are
		And po.BillAt in (0,1)

	end

	-- Make sure the invoice is not posted prior to the closing date
	if @Prepost = 0 and @GLClosedDate is not null
		if @GLClosedDate > @TransactionDate
			return @kErrGLClosedDate

	--EXEC @TrackCash = sptCashEnableCashBasis @CompanyKey, @Customizations

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
			
			-- ICT -- need to get the GLCompanyKey and Office from various places
			,Entity varchar(20) null
			,EntityKey int null
			,GLCompanySource int null
			,GLCompanyKey int null
			,UserKey int null
			)
	
	-- create a temp table to hold the accrued expense account Keys
	-- This is for the po where BillAt = 0 and 1  (net/Gross)
	create table #tAccruedExpenseAccount
		(
		PurchaseOrderDetailKey int null
		,GLAccountKey int null
		,GLAccountErrRet int null
		,VoucherPosted int null
		
		-- added for tTransactionOrderAccrual
		,GLCompanyKey int null -- ICT
		,ProjectKey int null
		,ClassKey int null
		,OfficeKey int null
		,DepartmentKey int null
		
		,AccruedCost money null -- straight from POD
		,AccrualAmount money null -- rounded for GL
		,TempTranLineKey int null
		,TransactionKey int null 
		)	
	
	-- This is for the po where BillAt = 2  (commission only)
	create table #tPODCommissionOnly
		(
		PurchaseOrderDetailKey int null
		,PurchaseOrderKey int null
        ,ProjectKey int null
		,UpdateFlag int null
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
	 * Prebill Accruals
	 */

if @PostPrebillAccruals = 1 
begin
	-- Step 1: determine AccruedExpenseAccountKey
	
	-- Capture all pods
	-- because of split billings, where 2 child invoices could be linked to 1 pod
	-- one invoice could already be posted and the other not, so try to get an existing GLAccountKey from the pod 
	-- i.e. from a posted invoice 
	Insert #tAccruedExpenseAccount (PurchaseOrderDetailKey, GLAccountKey, GLAccountErrRet, VoucherPosted
			,AccruedCost, GLCompanyKey, ProjectKey, ClassKey, OfficeKey, DepartmentKey
			)
	Select pod.PurchaseOrderDetailKey, pod.AccruedExpenseInAccountKey
	      , @kErrInvalidPOAccruedExpenseAcct, 0
	      ,ROUND(ISNULL(pod.AccruedCost, 0) * @Percent, 2)
		
		  -- ICT
		 , isnull(po.GLCompanyKey, 0)
		
		  , ISNULL(pod.ProjectKey, 0), ISNULL(pod.ClassKey, 0), ISNULL(pod.OfficeKey, 0), ISNULL(pod.DepartmentKey, 0)
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
	-- removed for 166010: with all these vendor invoices linked to adjustments, some gl accounts could be null and others not
	--Delete #tAccruedExpenseAccount Where VoucherPosted = 1 And ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0
		
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

		-- in case pod.ItemKey is null, pick from BilledItem 
		Update #tAccruedExpenseAccount
		Set    #tAccruedExpenseAccount.GLAccountKey = it.ExpenseAccountKey
		      ,#tAccruedExpenseAccount.GLAccountErrRet = @kErrInvalidExpenseAcct
		From   tPurchaseOrderDetail pod (nolock)
			Left Outer Join tItem it (nolock) ON pod.BilledItem = it.ItemKey
		Where ISNULL(#tAccruedExpenseAccount.GLAccountKey, 0) = 0 
		And   #tAccruedExpenseAccount.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
	End

	UPDATE #tAccruedExpenseAccount SET GLAccountKey = ISNULL(GLAccountKey, 0)
	
	-- Step 2: Debit vd.AccruedExpenseOutKey OR @POAccruedExpenseAccountKey OR it.ExpenseAccountKey
	--, group by office, department, class on the order detail, and project
	SELECT @PostSide = 'D',@Memo = @kMemoPrebillAccruals + @InvoiceNumber , @Section = @kSectionPrebillAccruals    
			,@DetailLineKey = NULL

	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		GLAccountKey, Sum(AccruedCost), 0,ClassKey,  @Memo,
		@ClientKey,ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		GLCompanyKey,OfficeKey,DepartmentKey,@DetailLineKey,@Section, GLAccountErrRet
	From   #tAccruedExpenseAccount  
	Group By GLAccountKey, GLCompanyKey, GLAccountErrRet, ClassKey,ProjectKey,OfficeKey,DepartmentKey

	-- Step 3: Credit @POPrebillAccrualAccountKey, group by class on the order detail
	SELECT @PostSide = 'C', @GLAccountKey = @POPrebillAccrualAccountKey, @GLAccountErrRet = @kErrInvalidPOPrebillAccrualAcct   
			,@Memo = @kMemoPrebillAccruals + @InvoiceNumber , @Section = @kSectionPrebillAccruals    
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per class and project from the pod detail
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		@GLAccountKey, 0, Sum(Debit),
		ISNULL(ClassKey, 0), @Memo,
		@ClientKey,isnull(ProjectKey,0),@SourceCompanyKey,@DepositKey,@PostSide,
		ISNULL(GLCompanyKey,0),@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	From   #tTransaction (nolock)
	Where	EntityKey = @EntityKey
	And     Entity = @Entity
	And     Section = @kSectionPrebillAccruals
	And     PostSide = 'D' 
	Group By  ISNULL(GLCompanyKey, 0), ISNULL(ClassKey, 0), ISNULL(ProjectKey, 0)


	-- Step 4: Save the TempTranLineKey  so that we can use later when saving in tTransactionOrderAccrual
	
	-- we will need a way to update the TransactionKey from TempTranLineKey in #tAccruedExpenseAccount later 
	UPDATE #tTransaction SET DetailLineKey = TempTranLineKey WHERE Section = @kSectionPrebillAccruals
	
	DECLARE @TempTranLineKey int
	DECLARE @AccrualClassKey int, @AccrualGLCompanyKey int, @AccrualProjectKey int 
	
	SELECT @TempTranLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TempTranLineKey = MIN(TempTranLineKey)
		FROM   #tTransaction
		WHERE  Section = @kSectionPrebillAccruals
		AND    TempTranLineKey > @TempTranLineKey
		AND    PostSide = 'C'
		
		IF @TempTranLineKey IS NULL
			BREAK
		
		SELECT @AccrualClassKey = ISNULL(ClassKey, 0)
		      ,@AccrualGLCompanyKey =  ISNULL(GLCompanyKey, 0)
			  ,@AccrualProjectKey = ISNULL(ProjectKey, 0)
		FROM   #tTransaction
		WHERE  TempTranLineKey = @TempTranLineKey
		
		UPDATE #tAccruedExpenseAccount
		SET    TempTranLineKey = @TempTranLineKey
			  ,AccrualAmount = AccruedCost
		WHERE  ClassKey	= @AccrualClassKey 
		AND    GLCompanyKey	= @AccrualGLCompanyKey 
		AND    ProjectKey = @AccrualProjectKey	    	
	END

end -- Prebill Accruals and not a child invoice

if @PostBody = 1
begin	
	/*
	* Insert the header/AR Amount
	*/
	
	SELECT @PostSide = 'D'
		  ,@GLAccountKey = @ARAccountKey
		  ,@GLAccountErrRet = @kErrInvalidARAcct 
		  ,@Memo = @kMemoHeader + @InvoiceNumber, @Section = @kSectionHeader 
		  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
			
	exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID,@ExchangeRate
					
	/* 
	 * Because of ICT, read now tInvoiceTax for sales taxes
	*/

	SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidSalesTaxAcct
			,@Memo = @kMemoSalesTax + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per GL Account
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate)
	
	SELECT @CompanyKey,@TransactionDate,@Entity, @EntityKey,@Reference,
		st.PayableGLAccountKey, 0, Sum(it.SalesTaxAmount), @ClassKey
		, case when it.Type = 1 then @kMemoSalesTax + @InvoiceNumber 
		       when it.Type = 2 then @kMemoSalesTax2 + @InvoiceNumber
			   else @kMemoSalesTax3 + @InvoiceNumber end

		,@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

		-- ICT
		, case when isnull(il.TargetGLCompanyKey, 0) = 0 then isnull(@GLCompanyKey, 0) else il.TargetGLCompanyKey end
		
		,@OfficeKey,@DepartmentKey,st.SalesTaxKey,@Section
		, case when it.Type = 1 then @kErrInvalidSalesTaxAcct else @kErrInvalidSalesTax2Acct end
		,@CurrencyID, @ExchangeRate 
	From   tInvoiceTax it (nolock)
		Inner Join tInvoiceLine il (NOLOCK) ON it.InvoiceLineKey = il.InvoiceLineKey
		Inner Join tSalesTax st (NOLOCK) ON it.SalesTaxKey = st.SalesTaxKey
	Where  it.InvoiceKey = @InvoiceKey	
	Group by it.Type, case when isnull(il.TargetGLCompanyKey, 0) = 0 then isnull(@GLCompanyKey, 0) else il.TargetGLCompanyKey end
		, st.SalesTaxKey,st.PayableGLAccountKey
	
		
	/*		
	* Now take care of Advance Billings (see Billing/Invoice Entry.doc)
	*/
	
	-- Credit AR with InvoiceTotalAmount and Debit Adv Bill Amount @AdvBillAmount
	-- Logically we should do this but because we take BilledAmount for the header
	-- instead of InvoiceTotalAmount, we can skip
	
	---------------------------------
	-- Advance Bills with  FromAB = 0
	---------------------------------

	-- Debit Deferred Revenue
	if @AdvBillNoTaxAmount <> 0
	BEGIN		
		SELECT @PostSide = 'D'
			  ,@GLAccountKey = @AdvBillAccountKey
			  ,@GLAccountErrRet = @kErrInvalidAdvBillAcct 
			  ,@Amount = @AdvBillNoTaxAmount
			  ,@Memo = @kMemoAdvBill  + @InvoiceNumber + ' Debit Deferred Revenue', @Section = @kSectionHeader  
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		/* We need to split this debit to include the possible various ExchangeRate values on the AB invoices
		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, null, 1
		*/
		
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)

		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey, 
			iab.Amount - ISNULL((
				select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock)
				where iabt.InvoiceKey = @InvoiceKey
				and   iabt.AdvBillInvoiceKey = iab.AdvBillInvoiceKey  
			),0)
			, 0, ISNULL(abi.ClassKey, 0),  @Memo ,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,ISNULL(abi.OfficeKey, 0),@DepartmentKey,iab.InvoiceAdvanceBillKey,@Section,@GLAccountErrRet,
			abi.CurrencyID, isnull(abi.ExchangeRate, 1)
		From   tInvoiceAdvanceBill iab (nolock)
			Inner Join tInvoice abi (NOLOCK) ON iab.AdvBillInvoiceKey = abi.InvoiceKey -- go to the AdvBill invoice
		Where  iab.InvoiceKey = @InvoiceKey	-- Real invoice, not like invoice line tax
		And    isnull(iab.FromAB, 0) = 0

	END
	
	-- Debit Advance Bill Sales Taxes
	SELECT @PostSide = 'D',@GLAccountErrRet = @kErrInvalidSalesTax3Acct
			,@Memo = @kMemoAdvBill + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@DepartmentKey = NULL, @DetailLineKey = NULL

	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)
	
	-- group probably by gl account, class, office
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		st.PayableGLAccountKey, Sum(iabt.Amount), 0,
		ISNULL(abi.ClassKey, 0),  @Memo + ' Debit sales tax ',
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,ISNULL(abi.OfficeKey, 0),@DepartmentKey,st.SalesTaxKey,@Section,@GLAccountErrRet,
		abi.CurrencyID, isnull(abi.ExchangeRate, 1)
	From   tInvoiceAdvanceBillTax iabt (nolock)
		Inner Join tInvoiceAdvanceBill iab (nolock) on iabt.AdvBillInvoiceKey = iab.AdvBillInvoiceKey
				and iabt.InvoiceKey = iab.InvoiceKey  
		Inner Join tInvoice abi (NOLOCK) ON iabt.AdvBillInvoiceKey = abi.InvoiceKey -- go to the AdvBill invoice
		Inner Join tSalesTax st (NOLOCK) ON iabt.SalesTaxKey = st.SalesTaxKey
	Where  iabt.InvoiceKey = @InvoiceKey	-- Real invoice, not like invoice line tax
	and    isnull(iab.FromAB, 0) = 0
	Group by st.SalesTaxKey, st.PayableGLAccountKey, ISNULL(abi.ClassKey, 0), ISNULL(abi.OfficeKey, 0) 
			,abi.CurrencyID, isnull(abi.ExchangeRate, 1)

	-- Now process the Realized Gain/Loss for the advance bills
	if @MultiCurrency = 1
	begin
	
		SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
				,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, -- @ClassKey, null it like ICT  
			@Memo + ' Adv Bill ' + abi.InvoiceNumber, 
			@ClientKey,
			null, --@ProjectKey
			@SourceCompanyKey,
			@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,iab.InvoiceAdvanceBillKey,@Section,@GLAccountErrRet, 0,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			0,
			Round(iab.Amount * (isnull(abi.ExchangeRate, 1) - @ExchangeRate), 2)
		From   tInvoiceAdvanceBill iab (nolock)
			Inner Join tInvoice abi (NOLOCK) ON iab.AdvBillInvoiceKey = abi.InvoiceKey -- go to the AdvBill invoice
		Where	iab.InvoiceKey = @InvoiceKey
		And     isnull(iab.FromAB, 0) = 0
	
	end

	---------------------------------
	-- Advance Bills with  FromAB = 1
	-- Again here, since we are dealing with reversals, get ExchangeRate from the other side
	---------------------------------

	-- Credit AR with total applied amount, this is a reversal
	SELECT @PostSide = 'C'
			   ,@GLAccountKey = @ARAccountKey
				,@GLAccountErrRet = @kErrInvalidARAcct 
			  ,@Amount = @AdvBillAmountFromAB
			  ,@Memo = @kMemoAdvBill  + @InvoiceNumber + ' Credit AR', @Section = @kSectionHeader  
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		/* We need to split this debit to include the possible various ExchangeRate values on the AB invoices
		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, null, 1
		*/
		
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)

		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey, 
			0,
			iab.Amount   
			,ISNULL(abi.ClassKey, 0),  @Memo ,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,ISNULL(abi.OfficeKey, 0),@DepartmentKey,iab.InvoiceAdvanceBillKey,@Section,@GLAccountErrRet,
			abi.CurrencyID, @ExchangeRate -- or isnull(abi.ExchangeRate, 1) -- or @ExchangeRate
		From   tInvoiceAdvanceBill iab (nolock)
			Inner Join tInvoice abi (NOLOCK) ON iab.InvoiceKey = abi.InvoiceKey -- go to the Real invoice
		Where  iab.AdvBillInvoiceKey = @InvoiceKey	-- AdvBill invoice
		And    isnull(iab.FromAB, 0) = 1

	-- Debit Deferred Revenue with total NONTAX amount
	if @AdvBillNoTaxAmountFromAB <> 0
	BEGIN		
		SELECT @PostSide = 'D'
			  ,@GLAccountKey = @AdvBillAccountKey
			  ,@GLAccountErrRet = @kErrInvalidAdvBillAcct 
			  ,@Amount = @AdvBillNoTaxAmountFromAB
			  ,@Memo = @kMemoAdvBill  + @InvoiceNumber + ' Debit Deferred Revenue', @Section = @kSectionHeader  
			  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		/* We need to split this debit to include the possible various ExchangeRate values on the AB invoices
		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, null, 1
		*/
		
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)

		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey, 
			iab.Amount - ISNULL((
				select sum(iabt.Amount) from tInvoiceAdvanceBillTax iabt (nolock)
				where iabt.InvoiceKey = iab.InvoiceKey
				and   iabt.AdvBillInvoiceKey = @InvoiceKey  
			),0)
			, 0, ISNULL(abi.ClassKey, 0),  @Memo ,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,ISNULL(abi.OfficeKey, 0),@DepartmentKey,iab.InvoiceAdvanceBillKey,@Section,@GLAccountErrRet,
			abi.CurrencyID, isnull(abi.ExchangeRate, 1)
		From   tInvoiceAdvanceBill iab (nolock)
			Inner Join tInvoice abi (NOLOCK) ON iab.InvoiceKey = abi.InvoiceKey -- go to the Real invoice
		Where  iab.AdvBillInvoiceKey = @InvoiceKey	-- AdvBill invoice
		And    isnull(iab.FromAB, 0) = 1

	END
	
	-- Debit Advance Bill Sales Taxes
	SELECT @PostSide = 'D',@GLAccountErrRet = @kErrInvalidSalesTax3Acct
			,@Memo = @kMemoAdvBill + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@DepartmentKey = NULL, @DetailLineKey = NULL

	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)
	
	-- group probably by gl account, class, office
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		st.PayableGLAccountKey, Sum(iabt.Amount), 0,
		ISNULL(abi.ClassKey, 0),  @Memo + ' Debit sales tax ',
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,ISNULL(abi.OfficeKey, 0),@DepartmentKey,st.SalesTaxKey,@Section,@GLAccountErrRet,
		abi.CurrencyID, isnull(abi.ExchangeRate, 1)
	From   tInvoiceAdvanceBillTax iabt (nolock)
		Inner Join tInvoiceAdvanceBill iab (nolock) on iabt.AdvBillInvoiceKey = iab.AdvBillInvoiceKey
				and iabt.InvoiceKey = iab.InvoiceKey  
		Inner Join tInvoice abi (NOLOCK) ON iabt.InvoiceKey = abi.InvoiceKey -- go to the Real invoice
		Inner Join tSalesTax st (NOLOCK) ON iabt.SalesTaxKey = st.SalesTaxKey
	Where  iabt.AdvBillInvoiceKey = @InvoiceKey	-- AdvBill invoice
	and    isnull(iab.FromAB, 0) = 1
	Group by st.SalesTaxKey, st.PayableGLAccountKey, ISNULL(abi.ClassKey, 0), ISNULL(abi.OfficeKey, 0) 
			,abi.CurrencyID, isnull(abi.ExchangeRate, 1)

	-- Now process the Realized Gain/Loss for the advance bills
	if @MultiCurrency = 1
	begin
	
		SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
				,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, -- @ClassKey, null it like ICT  
			@Memo + ' Adv Bill ' + abi.InvoiceNumber, 
			@ClientKey,
			null, --@ProjectKey
			@SourceCompanyKey,
			@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,iab.InvoiceAdvanceBillKey,@Section,@GLAccountErrRet, 0,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			0,
			Round(iab.Amount * (-1 * @ExchangeRate + isnull(abi.ExchangeRate, 1) ), 2) 
		From   tInvoiceAdvanceBill iab (nolock)
			Inner Join tInvoice abi (NOLOCK) ON iab.InvoiceKey = abi.InvoiceKey -- go to the Real invoice
		Where	iab.AdvBillInvoiceKey = @InvoiceKey
		And     isnull(iab.FromAB, 0) = 1
	
	end


	/*		
	*Reverse the prepayments 
	*/
	
	SELECT @PostSide = 'D' ,@GLAccountErrRet = @kErrInvalidPrepayAcct 
			,@Memo = @kMemoPrepayments , @Section = @kSectionPrepayments   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per payment applied
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		c.PrepayAccountKey, ca.Amount, 0,
		c.ClassKey,  @Memo + c.ReferenceNumber ,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,ca.CheckApplKey,@Section,@GLAccountErrRet, 1,
		c.CurrencyID, isnull(c.ExchangeRate, 1)
	From   tCheckAppl ca (nolock)
		Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
	Where	ca.InvoiceKey = @InvoiceKey
	And		ca.Prepay = 1
	
	-- We must also reverse the AR -- Credit -- Use Class on Invoice Header
	-- One entry for all prepayments
	SELECT @PostSide = 'C', @GLAccountKey = @ARAccountKey, @GLAccountErrRet = @kErrInvalidARAcct 
			,@Memo = @kMemoPrepayments, @Section = @kSectionPrepayments    
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	
	SELECT @Amount = SUM(Debit) FROM #tTransaction WHERE [Section]=@kSectionPrepayments AND Entity = @Entity AND EntityKey = @EntityKey
	UPDATE #tTransaction SET GPFlag = 0 WHERE Entity = @Entity AND EntityKey = @EntityKey

	exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate
	
	-- Now process the Realized Gain/Loss for the prepayments
	if @MultiCurrency = 1
	begin
		SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
				,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, GPFlag, CurrencyID, ExchangeRate, HDebit, HCredit)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, -- @ClassKey, null it like ICT  
			@Memo + ' Check # ' + c.ReferenceNumber ,
			@ClientKey,
			null, -- @ProjectKey,
			@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,ca.CheckApplKey,@Section,@GLAccountErrRet, 0,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			0,
			Round(ca.Amount * (isnull(c.ExchangeRate, 1) - @ExchangeRate), 2)
		From   tCheckAppl ca (nolock)
			Inner Join tCheck c (NOLOCK) ON ca.CheckKey = c.CheckKey
		Where	ca.InvoiceKey = @InvoiceKey
		And		ca.Prepay = 1
		
	end

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
		@ClientKey,il.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

		-- ICT
		, case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end

		,il.OfficeKey,il.DepartmentKey,il.InvoiceLineKey,@Section,@GLAccountErrRet
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
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

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
			,ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end 
			, case when t.DepartmentKey is not null then t.DepartmentKey else
				case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end
			 end
			, ISNULL(t.ProjectKey, 0)
			, ROUND(t.BilledHours * t.BilledRate, 2) 

			,'tTime', null, null 
			
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey -- we will look later at p.GLCompanySource
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, t.UserKey
			
			From tInvoiceLine il (nolock)
				Inner Join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tUser u (nolock) on t.UserKey = u.UserKey
				left outer join tService s (nolock) on t.BilledService = s.ServiceKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- Misc Cost
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(t.DepartmentKey, isnull(it.DepartmentKey,0)), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled

			,'tMiscCost', t.MiscCostKey, null

			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null
			
			From tInvoiceLine il (nolock)
				Inner Join tMiscCost t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- ER
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

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

			,'tExpenseReceipt', t.ExpenseReceiptKey, null
			
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey -- we will look later at p.GLCompanySource
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, t.UserKey
			
			From tInvoiceLine il (nolock)
				Inner Join tExpenseReceipt t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- VI
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(t.OfficeKey, 0), ISNULL(t.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled 

			,'tVoucherDetail', t.VoucherDetailKey, null

			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN case when isnull(t.TargetGLCompanyKey, 0) = 0 then v.GLCompanyKey else t.TargetGLCompanyKey end 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null

			From tInvoiceLine il (nolock)
				Inner Join tVoucherDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail

			-- PO
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			
			,ISNULL(t.OfficeKey, 0), ISNULL(t.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled 

			-- for PO our best bet is to get the GLCompany from the PO (could come from the media estimate) 
			,'tPurchaseOrderDetail', t.PurchaseOrderDetailKey, null
			
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN po.GLCompanyKey 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			
			, null
			
			From tInvoiceLine il (nolock)
				Inner Join tPurchaseOrderDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
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
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

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
			,ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end 
			, case when t.DepartmentKey is not null then t.DepartmentKey else
				case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end
			 end
			, ISNULL(t.ProjectKey, 0)
			, ROUND(t.ActualHours * t.ActualRate, 2) 

			,'tTime', null, null

			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey -- we will look later at p.GLCompanySource
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			
			, t.UserKey
			
			From tInvoiceLine il (nolock)
				Inner Join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tUser u (nolock) on t.UserKey = u.UserKey
				left outer join tService s (nolock) on t.BilledService = s.ServiceKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- Misc Cost
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(t.DepartmentKey, isnull(it.DepartmentKey,0)), ISNULL(t.ProjectKey, 0)
			, t.BillableCost 

			-- for misc costs, we can only take GLCompanyKey from project...so we should be done
			,'tMiscCost', t.MiscCostKey, null
			
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null
			
			From tInvoiceLine il (nolock)
				Inner Join tMiscCost t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- ER
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

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
			
			,'tExpenseReceipt', t.ExpenseReceiptKey, null
			
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey -- we will look later at p.GLCompanySource
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, t.UserKey
			 
			From tInvoiceLine il (nolock)
				Inner Join tExpenseReceipt t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- VI
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(t.OfficeKey, 0), ISNULL(t.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, t.BillableCost 

			,'tVoucherDetail', t.VoucherDetailKey, null
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN case when isnull(t.TargetGLCompanyKey, 0) = 0 then v.GLCompanyKey else t.TargetGLCompanyKey end 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null
			
			From tInvoiceLine il (nolock)
				Inner Join tVoucherDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail

			-- PO
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN ISNULL(it.SalesAccountKey,0) ELSE ISNULL(il.SalesAccountKey, 0) END
			,CASE WHEN il.PostSalesUsingDetail = 1 THEN @kErrInvalidSalesAcct ELSE @kErrInvalidLineAcct END
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(t.OfficeKey, 0), ISNULL(t.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			,CASE 
				WHEN po.BillAt = 0 THEN t.BillableCost
				WHEN po.BillAt = 1 THEN t.TotalCost 
				WHEN po.BillAt = 2 THEN (t.BillableCost - t.TotalCost) 
				ELSE t.BillableCost
			END 
			
			-- for PO our best bet is to get the GLCompany from the PO (could come from the media estimate) 
			,'tPurchaseOrderDetail', t.PurchaseOrderDetailKey, null
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN po.GLCompanyKey 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			
			, null
			
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
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

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
			,ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end 
			, case when t.DepartmentKey is not null then t.DepartmentKey else
				case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end
			 end
			, ISNULL(t.ProjectKey, 0)
			,ROUND(t.BilledHours * t.BilledRate, 2) - ROUND(t.ActualHours * t.ActualRate, 2)
			
			,'tTime', null, null
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey -- we will look later at p.GLCompanySource
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, t.UserKey
			 
			From tInvoiceLine il (nolock)
				Inner Join tTime t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tUser u (nolock) on t.UserKey = u.UserKey
				left outer join tService s (nolock) on t.BilledService = s.ServiceKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- Misc Cost
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(p.OfficeKey, 0), ISNULL(t.DepartmentKey, isnull(it.DepartmentKey,0)), ISNULL(t.ProjectKey, 0)
			, t.AmountBilled - t.BillableCost

			-- for misc costs, we can only take GLCompanyKey from project...so we should be done
			,'tMiscCost', t.MiscCostKey, null
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null

			From tInvoiceLine il (nolock)
				Inner Join tMiscCost t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- ER
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

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

			,'tExpenseReceipt', t.ExpenseReceiptKey, null
			
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN p.GLCompanyKey -- we will look later at p.GLCompanySource
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, t.UserKey

			From tInvoiceLine il (nolock)
				Inner Join tExpenseReceipt t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- VI
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(t.OfficeKey, 0), ISNULL(t.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, (t.AmountBilled - t.BillableCost)

			,'tVoucherDetail', t.VoucherDetailKey, null
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN case when isnull(t.TargetGLCompanyKey, 0) = 0 then v.GLCompanyKey else t.TargetGLCompanyKey end 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null
			
			From tInvoiceLine il (nolock)
				Inner Join tVoucherDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tVoucher v (nolock) on t.VoucherKey = v.VoucherKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
			-- PO
			INSERT 	#tLineDetail(InvoiceLineKey, GLAccountKey, GLAccountErrRet, ClassKey, 
			OfficeKey, DepartmentKey, ProjectKey, Amount
			,Entity, EntityKey, GLCompanySource, GLCompanyKey, UserKey)

			Select il.InvoiceLineKey 
			,ISNULL(@ExpenseOUAccountKey, 0)
			,@kErrInvalidOUAcct
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN 
					CASE WHEN ISNULL(t.ClassKey, 0) > 0 THEN t.ClassKey
					ELSE
						CASE WHEN ISNULL(p.ClassKey, 0) > 0 THEN ISNULL(p.ClassKey, 0) 
							ELSE ISNULL(it.ClassKey, 0) 
						END
					END 
				ELSE 
					ISNULL(il.ClassKey, 0) 
			END
			,ISNULL(t.OfficeKey, 0), ISNULL(t.DepartmentKey, 0), ISNULL(t.ProjectKey, 0)
			, (t.AmountBilled 
			- CASE 
				WHEN po.BillAt = 0 THEN t.BillableCost 
				WHEN po.BillAt = 1 THEN t.TotalCost
				WHEN po.BillAt = 2 THEN t.BillableCost - t.TotalCost
				ELSE t.BillableCost			
			END 
			) 

			-- for PO our best bet is to get the GLCompany from the PO (could come from the media estimate) 
			,'tPurchaseOrderDetail', t.PurchaseOrderDetailKey, null
			,CASE WHEN il.PostSalesUsingDetail = 1 
				THEN po.GLCompanyKey 
				else
					case when isnull(il.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else il.TargetGLCompanyKey end
			end
			, null
			
			From tInvoiceLine il (nolock)
				Inner Join tPurchaseOrderDetail t (nolock) on il.InvoiceLineKey = t.InvoiceLineKey
				Inner Join tPurchaseOrder po (nolock) on t.PurchaseOrderKey = po.PurchaseOrderKey
				left outer join tItem it (nolock) on t.ItemKey = it.ItemKey
				left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			Where  il.InvoiceKey = @LineInvoiceKey -- Point to invoice where the lines are
			And    il.BillFrom = @kLineUseTransactions And il.LineType = @kLineTypeDetail
			
		End

		-- GLCompanySource will only be used for Time/Exp Receipts

		-- correct the GLCompanySource if there is project
		update #tLineDetail
		set    #tLineDetail.GLCompanySource = isnull(p.GLCompanySource, 0)
		from   tProject p (nolock)
		where  #tLineDetail.ProjectKey = p.ProjectKey
		and    isnull(#tLineDetail.ProjectKey, 0) > 0
		
		-- if there is no project, get it from user
		update #tLineDetail
		set    #tLineDetail.GLCompanySource = 1
		where  isnull(#tLineDetail.ProjectKey, 0) = 0
		
		-- but this has to be done only if PostSalesUsingDetail = 1
		-- if PostSalesUsingDetail = 0, we already got it from the invoice line
		update #tLineDetail
		set    #tLineDetail.GLCompanySource = 0 -- do not get from user
		from   tInvoiceLine il (nolock)
		where  #tLineDetail.InvoiceLineKey = il.InvoiceLineKey
		and    isnull(il.PostSalesUsingDetail, 0) = 0
		

		-- by default GLCompanyKey and Office Key were obtained from project
		-- get them from user if GLCompanySource = 1 
		-- Also Added Class
		update #tLineDetail
		set    #tLineDetail.GLCompanyKey = ISNULL(u.GLCompanyKey, #tLineDetail.GLCompanyKey)
		      ,#tLineDetail.OfficeKey = ISNULL(u.OfficeKey, #tLineDetail.OfficeKey)  -- must overwrite the office initially from project
			  ,#tLineDetail.ClassKey = ISNULL(u.ClassKey, #tLineDetail.ClassKey)  
		from   tUser u (nolock)
		where  #tLineDetail.UserKey = u.UserKey
		and    isnull(#tLineDetail.GLCompanySource, 0) = 1 -- From User
		and    #tLineDetail.Entity in ('tTime', 'tExpenseReceipt')

		--no need to deal with the pos, we should be done, so cleanup for groupings

		update #tLineDetail
		set    #tLineDetail.GLCompanyKey = isnull(#tLineDetail.GLCompanyKey, 0)
		      ,#tLineDetail.OfficeKey = isnull(#tLineDetail.OfficeKey, 0)

		SELECT @PostSide = 'C', @Memo = @kMemoLine + @InvoiceNumber , @Section = @kSectionLine   
		
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
				
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			b.GLAccountKey, 0, ROUND(Sum(b.Amount) * @Percent, 2), b.ClassKey,
			Left(@Memo + ' ' + rtrim(ltrim(il.LineSubject)), 500), 
			@ClientKey,b.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide, b.GLCompanyKey, b.OfficeKey
			,b.DepartmentKey,b.InvoiceLineKey,@Section,b.GLAccountErrRet
		From #tLineDetail b
		Inner Join tInvoiceLine il on b.InvoiceLineKey = il.InvoiceLineKey
		Group By b.InvoiceLineKey, il.LineSubject, b.GLAccountKey, b.GLAccountErrRet, b.GLCompanyKey
		,b.ClassKey, b.OfficeKey, b.DepartmentKey, b.ProjectKey
						 
	 End
	 		
	-- on the lines TM or FF, copy currency and exch rate from header			 		
	update #tTransaction
	set    CurrencyID = @CurrencyID
	      ,ExchangeRate = @ExchangeRate
	where  Entity = @Entity
	and    EntityKey = @EntityKey
	and    [Section] = @kSectionLine

	/*
	 * End Invoice Lines
	 */

end -- @PostBody = 1

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
				       ,HCredit = HCredit + @SplitRoundingError
				WHERE  Entity = @Entity
				AND    EntityKey = @EntityKey
				AND    [Section] = 2 -- line
				AND    GPFlag = @SplitDetailLineKey
			
		END
	END


    --select * from #tTransaction

	-- Exit when we are not really posting, but preposting
	--IF @Prepost = 1
	--	RETURN 1
		
	/*
	 * Validations
	 */

	if @MultiCurrency = 1
	begin
		-- Next flip sides to make it positive like Xero does
		update #tTransaction
		set    HDebit = -1 * HCredit
			  ,HCredit = 0
			  ,PostSide = 'D'
		where  Entity = @Entity and EntityKey = @EntityKey  
		and    [Section] = @kSectionMCGain
		and    isnull(HCredit, 0) < 0 

		update #tTransaction
		set    HCredit = -1 * HDebit
			  ,HDebit = 0
			  ,PostSide = 'C'
		where  Entity = @Entity and EntityKey = @EntityKey  
		and    [Section] = @kSectionMCGain
		and    isnull(HDebit, 0) < 0 

		--1 Accrual Basis, 1 Force to Rounding account
		exec spGLPostCalcRoundingDiff @CompanyKey,@Entity,@EntityKey,1,1,@GLCompanyKey,@TransactionDate,@Reference, @RoundingDiffAccountKey,@RealizedGainAccountKey 
		
		if @IsCreditInvoice = 1 and isnull(@CurrencyID, '') <> ''
			exec spGLPostCredit @CompanyKey,@Entity,@EntityKey

		if exists (select 1 from #tTransaction where Section in (@kSectionMCRounding, @kSectionMCGain))
		begin
			-- Correct and prepared data for final insert
			EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
		end
	end
	
	-- Create DT and DF for ICT -- 1 Accrual Basis
	exec spGLPostICTCreateDTDF @CompanyKey,@Entity,@EntityKey,1,@GLCompanyKey,@TransactionDate,@Memo,@Reference 
	if exists (select 1 from #tTransaction where Section = @kSectionICT)
	begin
		-- Correct and prepared data for final insert
		EXEC spGLPostCleanupTemp @Entity, @EntityKey, @TransactionDate 
	end

	Select @TransactionCount = COUNT(*) from #tTransaction Where Entity = @Entity and EntityKey = @EntityKey
	
	EXEC @RetVal = spGLValidatePostTemp @CompanyKey, @Entity, @EntityKey, @kErrBalance, @kErrPosted 

	-- Exit when we are not really posting, but preposting
	IF @Prepost = 1
		RETURN 1

	IF @RetVal <> 1
		RETURN @RetVal
	
	-- once the transaction lines have been validated, store them in #tCashTransactionLine
	INSERT #tCashTransactionLine(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, TempTranLineKey,
		AdvBillAmount, PrepaymentAmount, ReceiptAmount, CurrencyID, ExchangeRate, HDebit, HCredit)
		
	SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, TempTranLineKey,
		0,0,0, CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'C' -- only credits

if @PostBody = 1
begin		 
	-- this will populate #tInvoiceAdvanceBillSale and #tCashTransactionLine.AdvBillAmount	 
	EXEC @RetVal = sptCashPostInvoiceFillABSale @InvoiceKey	
			
	-- and calculate the Prepayment and Receipt amounts
	EXEC @RetVal = sptCashPostInvoiceCalcLineAmounts @InvoiceKey
end	

	If Exists (Select 1 From #tTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
		return @kErrICTBlankGLAccount

	--select * from #tCashTransactionLine
					
	/*
	 * Cash-Basis prep
	 */
	
	IF @TrackCash = 1 --AND @OpeningTransaction = 0  --issue 201908 allow payments to reposted
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
	
	exec @RetVal = sptCashQueue @CompanyKey, @Entity, @EntityKey, @TransactionDate, @Action , @AdvanceBill
	
	--select * from #tCashQueue
	
	INSERT #tCashTransactionUnpost (Entity, EntityKey, Unpost)
	Select Entity, EntityKey, 1
	From   #tCashQueue (NOLOCK)
	Where  Action = 1 -- UnPosting
		 
	if @PostBody = 1
		begin
			 
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
				  	
			End -- PostingOrder loop

			
		end -- PostBody = 1
	
		If Exists (Select 1 From #tCashTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
		return @kErrICTBlankGLAccount

	END -- End Track Cash


	/*
	 * Posting!!
	 */
	
	BEGIN TRAN
	
	Update tInvoice
	Set Posted = 1, InvoiceStatus = 4
	Where InvoiceKey = @InvoiceKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN @kErrUnexpected 	
	END		
	
	-- only do this if @OpeningTransaction = 0
	IF NOT EXISTS (SELECT 1 FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
	AND @OpeningTransaction = 0
	BEGIN
		INSERT tTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey ,Reversed, Cleared, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey , 0, 0, CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tTransaction 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		  
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
		
		UPDATE #tAccruedExpenseAccount
		SET    #tAccruedExpenseAccount.TransactionKey = t.TransactionKey 
		FROM   tTransaction t (NOLOCK)
		WHERE  t.Entity = @Entity AND t.EntityKey = @EntityKey 
		AND    t.Section = @kSectionPrebillAccruals AND t.DetailLineKey = #tAccruedExpenseAccount.TempTranLineKey
		
		INSERT tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, AccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
		SELECT PurchaseOrderDetailKey, @CompanyKey, AccrualAmount, TransactionKey, @Entity, @EntityKey, @TransactionDate 
		FROM   #tAccruedExpenseAccount	 
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
		
	END		
	
	-- This must be done no matter what @OpeningTransaction is 0 or  1	
	--IF @TrackCash = 1 
	--BEGIN
		-- we may not have to do that deletion
		Delete tCashTransactionLine WHERE Entity = @Entity AND EntityKey = @EntityKey
	
		INSERT tCashTransactionLine(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, Reversed, Cleared, TempTranLineKey,
		AdvBillAmount, PrepaymentAmount, ReceiptAmount, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, 0, 0, TempTranLineKey,	
		AdvBillAmount, PrepaymentAmount, ReceiptAmount, CurrencyID, ExchangeRate, HDebit, HCredit
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
	--END
	
	-- only do this if @OpeningTransaction = 0	
	IF @TrackCash = 1 -- AND @OpeningTransaction = 0 --issue 201908 allow payments to be reposted
	BEGIN
		
		DELETE tCashTransaction
		FROM   #tCashTransactionUnpost
		WHERE  tCashTransaction.Entity = #tCashTransactionUnpost.Entity 
		AND    tCashTransaction.EntityKey = #tCashTransactionUnpost.EntityKey
		AND    #tCashTransactionUnpost.Unpost = 1
		AND    (@OpeningTransaction = 0 OR
			tCashTransaction.Entity = 'RECEIPT' -- only payments if OpeningTransaction = 1  
		)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
		
		-- must do 3 updates, one per each entity
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  ctl.Entity = 'INVOICE'
		AND    #tCashTransaction.Entity = 'INVOICE' -- cannot equate Entity from temp to real table
		AND    #tCashTransaction.EntityKey = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  ctl.Entity = 'INVOICE'
		AND    #tCashTransaction.AEntity = 'INVOICE' -- cannot equate Entity from temp to real table
		AND    #tCashTransaction.AEntityKey = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  ctl.Entity = 'INVOICE'
		AND    #tCashTransaction.AEntity2 = 'INVOICE' -- cannot equate Entity from temp to real table
		AND    #tCashTransaction.AEntity2Key = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		--select * from #tCashTransaction
		
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey, Reversed, Cleared
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey, 0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		FROM #tCashTransaction 	
		WHERE   (@OpeningTransaction = 0 OR
			#tCashTransaction.Entity = 'RECEIPT' -- only payments if OpeningTransaction = 1  --issue 201908 allow payments to reposted
		)
		--WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
	
	END
	
	-- only do this if @OpeningTransaction = 0	
	IF @OpeningTransaction = 0
	BEGIN
		-- Protect against double postings
		IF (SELECT COUNT(*) FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
		<> @TransactionCount
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		

		-- save the accrued expense account key, they will be used for the reversals in spGLPostVoucher 					
		-- these are BillAt = Net and Gross
		UPDATE tPurchaseOrderDetail
		SET    tPurchaseOrderDetail.AccruedExpenseInAccountKey = b.GLAccountKey
		FROM   #tAccruedExpenseAccount b
		WHERE  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.PurchaseOrderDetailKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
	
		--now close PO detail lines prebilled at Commission Only since they will 
		--never have vendor invoices applied against them and they were not included
		--in the media prebill accrual posting totals above
		-- same logic as in sptPurchaseOrderSpotChangeClose()
				
		Declare @Today smalldatetime
		Select @Today = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)

		-- capture commission only PODs still open
		insert #tPODCommissionOnly (PurchaseOrderDetailKey, PurchaseOrderKey ,ProjectKey, UpdateFlag)
		select pod.PurchaseOrderDetailKey, pod.PurchaseOrderKey ,pod.ProjectKey, 1
		from   tPurchaseOrderDetail pod (nolock)
		inner join tInvoiceLine il (nolock) on pod.InvoiceLineKey = il.InvoiceLineKey
		inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		where il.InvoiceKey = @LineInvoiceKey
		and po.BillAt = 2  --Commission Only 		
		and pod.Closed = 0

		-- close them
		update tPurchaseOrderDetail
		set    tPurchaseOrderDetail.Closed = 1
				,tPurchaseOrderDetail.DateClosed = @Today 
		from   #tPODCommissionOnly b
		where  tPurchaseOrderDetail.PurchaseOrderDetailKey = b.PurchaseOrderDetailKey

		if @@ERROR <> 0 
		begin
			ROLLBACK TRAN
			RETURN @kErrUnexpected
		end

		-- we will not close POs if there are some open PO details
		update #tPODCommissionOnly
		set    #tPODCommissionOnly.UpdateFlag = 0
		from   tPurchaseOrderDetail pod (nolock)
		where  #tPODCommissionOnly.PurchaseOrderKey = pod.PurchaseOrderKey 
		and    pod.Closed = 0 -- still open

		update tPurchaseOrder 
		set    tPurchaseOrder.Closed = 1 
		from   #tPODCommissionOnly b
		where  tPurchaseOrder.PurchaseOrderKey = b.PurchaseOrderKey
		and    b.UpdateFlag = 1
	
		if @@ERROR <> 0 
		begin
			ROLLBACK TRAN
			RETURN @kErrUnexpected
		end
		
			
	END -- OpeningTransaction = 0
				
	COMMIT TRAN

	-- do this after SQL tran only
	select @ProjectKey = 0
	while (1=1)
	begin
		select @ProjectKey = min(ProjectKey)
		from   #tPODCommissionOnly
		where  ProjectKey > @ProjectKey
		and    isnull(ProjectKey, 0) > 0

		if @ProjectKey is null
			break

        -- Update 
		EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
	end
		 		
	RETURN 1
GO
