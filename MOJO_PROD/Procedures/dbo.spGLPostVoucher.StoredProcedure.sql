USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostVoucher]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostVoucher]
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
  || 03/27/09 GHL 10.022 (49542) Even if OpeningTransaction = 1, save cash basis prep tables
  || 04/16/09 GHL 10.223 Added support of tTransactionOrderAccrual to help with prebilled order accruals  
  || 08/10/09 GHL 10.507 (59265) Deleting now records created by spFixOrderAccrual
  || 09/21/09 GHL 10.5  Added support of other sales taxes
  || 09/15/10 RLB 10.535 (90100) moved checks for GL Close Date and Transaction Date up
  || 09/16/10 GHL 10.535  Added insert in tTransactionOrderAccrual when OpeningTransaction = 1 or no posting to GL
  || 05/03/11 GHL 10.544 Corrected pulling of GL accounts when SalesTaxKey = 0
  || 07/15/11 GWG 10.546 Added a check to make sure posting date does not have a time component
  || 10/13/11 GHL 10.459 Added new entity CREDITCARD 
  || 10/18/11 GHL 10.459 Added new section 7 for vouchers applied to credit cards
  || 11/7/11  GHL 10.549 Taking in account tVoucherCC + tVoucherDetail to determine PostToGL
  ||                      Not only tVoucherDetail
  || 03/26/12 GHL 10.554 Made changes for ICT 
  || 04/03/12 GHL 10.554 Getting now GLCompanyKey from real vouchers for tVoucherCC records (rather than @GLCompanyKey)
  || 06/27/12 GHL 10.557  Added separate errors for header and line gl accounts
  || 07/03/12 GHL 10.557  Removed call to spGLPostICTCreateDTDF (cash basis) and added to cash basis function
  || 07/03/12 GHL 10.557  Added tTransaction.ICTGLCompanyKey
  || 08/06/12 GHL 10.558  (150869) Do not post transferred voucher details
  || 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
  || 12/10/12 GHL 10.562  (162037) Memo for AP/Header is InvoiceDescription for credit card charges
  ||                       because InvoiceNumber could be null
  || 12/13/12 GHL 10.563  (161899) Insert Project in both sides of the accrual gl posting
  || 12/19/12 GHL 10.563  (162352) Labor line shoud be posted by Office and Class on the project
  ||                       GLCompany should be the same as on the voucher (sptTimeGetUnpaid was modified to achieve this)
  ||                       Also since CoreCreative require offices, I use office on the line if missing on the project  
  || 01/22/13 GHL 10.564 (164475) Added error @kErrICTBlankGLAccount = -103 as a last defense protection
  ||                     against null gl accounts linked to ICT
  || 02/05/13 GHL 10.564 (166819) Add BoughtFrom to memo (Credit Card only) on header and lines
  || 02/15/13 GHL 10.565 TrackCash = 1 now 
  || 04/08/13 GHL 10.566 (163359) Checking now if all vouchers are posted if there are some prepayments
  ||                     because I use tCashTransactionLine in sptCashPostVoucher (this could be alleviated if 
  ||                     we read tVoucherDetail directly)
  || 06/24/13 GHL 10.569 (182080) Using now #tTransaction.GPFlag (general purpose flag) to validate missing offices and depts 
  ||                      This is why I execute sptGLValidatePostTemp before exiting in case of preposting
  || 08/05/13 GHL 10.571 Added Multi Currency stuff
  || 11/01/13 GHL 10.573 (195153) Update CashTransactionLineKey from tCashTransactionLine for credit cards
  ||                     Was not updated on payments when reposting credit cards applied to these payments
  || 01/14/14 GHL 10.576 (201908) When opening transaction = 1, allow payments to be reposted in cash basis  
  || 01/16/14 GHL 10.576 Calling now spGLPostCredit for multicurrency credits
  || 09/23/14 GHL 10.584 (230068) Do not include the client for labor lines
  || 11/25/14 GHL 10.586 (237442) Do not post the vendor invoice if the APAccount has the wrong currency
  */
 
-- Bypass cash basis process or not
DECLARE @TrackCash INT SELECT @TrackCash = 1
 
-- Register all constants
DECLARE @kErrInvalidAPAcct INT					SELECT @kErrInvalidAPAcct = -2
DECLARE @kErrInvalidLineAcct INT				SELECT @kErrInvalidLineAcct = -3
DECLARE @kErrInvalidPOPrebillAccrualAcct INT	SELECT @kErrInvalidPOPrebillAccrualAcct = -4
DECLARE @kErrInvalidPOAccruedExpenseAcct INT	SELECT @kErrInvalidPOAccruedExpenseAcct = -5
DECLARE @kErrInvalidWIPExpenseAssetAcct INT		SELECT @kErrInvalidWIPExpenseAssetAcct = -6
DECLARE @kErrInvalidWIPMediaAssetAcct INT		SELECT @kErrInvalidWIPMediaAssetAcct = -7
DECLARE @kErrInvalidExpenseAcct INT				SELECT @kErrInvalidExpenseAcct = -8
DECLARE @kErrInvalidSalesAcct INT				SELECT @kErrInvalidSalesAcct = -9
DECLARE @kErrInvalidPrepayAcct INT				SELECT @kErrInvalidPrepayAcct = -10
DECLARE @kErrInvalidSalesTaxAcct INT			SELECT @kErrInvalidSalesTaxAcct = -11
DECLARE @kErrInvalidSalesTax2Acct INT			SELECT @kErrInvalidSalesTax2Acct = -12
DECLARE @kErrTranDateMissing INT				SELECT @kErrTranDateMissing = -13
DECLARE @kErrRealVoucherUnposted INT			SELECT @kErrRealVoucherUnposted = -14

DECLARE @kErrInvalidRoundingDiffAcct int		SELECT @kErrInvalidRoundingDiffAcct = -350
DECLARE @kErrInvalidRealizedGainAcct int		SELECT @kErrInvalidRealizedGainAcct = -351

DECLARE @kErrGLClosedDate INT					SELECT @kErrGLClosedDate = -100
DECLARE @kErrPosted INT							SELECT @kErrPosted = -101
DECLARE @kErrBalance INT						SELECT @kErrBalance = -102
DECLARE @kErrICTBlankGLAccount INT				SELECT @kErrICTBlankGLAccount = -103
DECLARE @kErrUnexpected INT						SELECT @kErrUnexpected = -1000

DECLARE @kMemoHeader VARCHAR(100)				SELECT @kMemoHeader = 'Voucher # '
DECLARE @kMemoSalesTax VARCHAR(100)				SELECT @kMemoSalesTax = 'Sales Tax for Voucher # '
DECLARE @kMemoSalesTax2 VARCHAR(100)			SELECT @kMemoSalesTax2 = 'Sales Tax 2 for Voucher # '
DECLARE @kMemoSalesTax3 VARCHAR(100)			SELECT @kMemoSalesTax3 = 'Other Sales Tax for Voucher # '
DECLARE @kMemoPrepayments VARCHAR(100)			SELECT @kMemoPrepayments = 'Reverse Prepayment Accrual '
DECLARE @kMemoPrebillAccruals VARCHAR(100)		SELECT @kMemoPrebillAccruals = 'Reverse Order Accrual for Voucher # '
DECLARE @kMemoLine VARCHAR(100)					SELECT @kMemoLine = 'Voucher # '
DECLARE @kMemoWIP VARCHAR(100)					SELECT @kMemoWIP = 'VI Post WIP Sales'
DECLARE @kMemoRealizedGain VARCHAR(100)			SELECT @kMemoRealizedGain = 'Multi Currency Realized Gain/Loss '
DECLARE @kMemoMCRounding VARCHAR(100)			SELECT @kMemoMCRounding = 'Multi Currency Rounding Diff '

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

DECLARE @kLaborLineDesc varchar(500)			select @kLaborLineDesc = '**Labor Line**'

/*
Flow of data for credit cards
tCCEntry.Memo-->tVoucher.Description-->tTransaction.Memo
tCCEntry.FITID-->tVoucher.InvoiceNumber-->tTransaction.Reference
tCCEntry.PayeeName-->tVoucher.BoughtFrom

issue 166819: Etna does not use the Credit Card Connector
then tTransaction.Memo and Reference are null
They want to have BoughtFrom in tTransaction.Memo
Decided to add it to tTransaction.Memo (i.e. not overwrite because of people using the connector)

-- Final decision
tCCEntry.Memo-->tVoucher.Description-->tTransaction.Memo
tCCEntry.FITID-->tVoucher.InvoiceNumber-->
tCCEntry.PayeeName-->tVoucher.BoughtFrom--> tTransaction.Reference
*/

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
Declare @Customizations varchar(1000)
Declare @UseMultiCompanyGLCloseDate tinyint
		,@MultiCurrency tinyint
		,@RoundingDiffAccountKey int -- for rounding errors
		,@RealizedGainAccountKey int -- for realized gains after applications of checks to invoices, invoices to invoices etc..  
		,@IsCreditInvoice int -- for multi currency, if it is a credit, we need to post the credits

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
		,@InvoiceDescription varchar(500)
		,@BoughtFrom varchar(250)
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
		,@Customizations = ISNULL(Customizations, '')
		,@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0)
		,@MultiCurrency = ISNULL(MultiCurrency, 0)
		,@RoundingDiffAccountKey = RoundingDiffAccountKey
		,@RealizedGainAccountKey = RealizedGainAccountKey  
	From
		tPreference (nolock)
	Where
		CompanyKey = @CompanyKey

	-- patch to block Factory Labs from posting their bad vouchers, created from expense report with wrong currency
	if @MultiCurrency = 1
	begin
		if exists (select 1 
					from  tVoucher v (nolock)
					inner join tGLAccount gla (nolock) on v.APAccountKey = gla.GLAccountKey
					where isnull(v.CurrencyID, '') <> isnull(gla.CurrencyID, '')
					and  v.VoucherKey = @VoucherKey
					)
			return -9999  
	end

	Select 
		@GLCompanyKey = v.GLCompanyKey
		,@VendorID = rtrim(ltrim(c.VendorID))
		,@TransactionDate = dbo.fFormatDateNoTime(PostingDate)
		,@APAccountKey = ISNULL(APAccountKey, 0)
		,@Amount = ISNULL(VoucherTotal, 0)
		,@ClassKey = v.ClassKey
		,@InvoiceNumber = rtrim(ltrim(isnull(InvoiceNumber, ''))) -- InvoiceNumber is not required for Credit Card Charges
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
		-- convert text to 450 chars (memo is 500), possible extra chars
		-- this is mostly null for vouchers
		,@InvoiceDescription = isnull(cast(v.Description as varchar(450)), '')
		,@BoughtFrom = isnull(BoughtFrom, '')
		,@CurrencyID = v.CurrencyID
		,@ExchangeRate = isnull(v.ExchangeRate, 1)
	From tVoucher v (nolock)
		inner join tCompany c (nolock) on v.VendorKey = c.CompanyKey
		left outer join tProject p (nolock) on v.ProjectKey = p.ProjectKey
	Where v.VoucherKey = @VoucherKey

if @Amount <0 
	select @IsCreditInvoice = 1
else
	select @IsCreditInvoice = 0

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

	Select @PrepaymentAmount = Sum(Amount) from tPaymentDetail (nolock) Where VoucherKey = @VoucherKey and Prepay = 1
	Select @PrepaymentAmount = ISNULL(@PrepaymentAmount, 0)

	if exists(Select 1 from tVoucher Where VoucherKey = @VoucherKey and Posted = 1)
		return @kErrPosted
	
	/* Allow for the saving of cash basis prep tables
	if @OpeningTransaction = 1
		Select @PostToGL = 0	
	*/		
	
	if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@GLCompanyKey, 0) > 0
	BEGIN
		Select @GLClosedDate = GLCloseDate
		From   tGLCompany (nolock)
		Where  GLCompanyKey = @GLCompanyKey			
	END
			
	declare @DetailCount int
	select @DetailCount = count(*) from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey
	select @DetailCount = @DetailCount + count(*) from tVoucherCC (nolock) Where VoucherCCKey = @VoucherKey

	if @DetailCount = 0
		Select @PostToGL = 0


	declare @PrepaymentCount int, @UnpostedVoucherCount int
	if @CreditCard = 1
	begin
		select @PrepaymentCount = count(*) from tPaymentDetail (nolock) where VoucherKey = @VoucherKey and isnull(Prepay, 0) = 1
		select @UnpostedVoucherCount = count(*) 
		from tVoucherCC (nolock) 
		Where VoucherCCKey = @VoucherKey
	
		select @UnpostedVoucherCount = count(*) 
		from tVoucherCC vcc (nolock) 
		inner join tVoucher v (nolock) on vcc.VoucherKey = v.VoucherKey
		Where vcc.VoucherCCKey = @VoucherKey
		and v.Posted = 0

		-- if we have some prepayments and there are some unposted vouchers, abort
		-- because we are using records in tCashTransactionLine
		if @PrepaymentCount > 0 and @UnpostedVoucherCount > 0
			return @kErrRealVoucherUnposted
	end

	

	-- Try to find a client on the lines when null before starting SQL transaction
	Declare @VoucherDetailKey int, @LineItemKey int, @LineClientKey int, @LineProjectKey int,  @PurchaseOrderDetailKey int
	Select @VoucherDetailKey = -1
	While 1=1
	BEGIN
		Select @VoucherDetailKey = Min(VoucherDetailKey) 
		from tVoucherDetail (nolock) 
		Where VoucherKey = @VoucherKey 
		and VoucherDetailKey > @VoucherDetailKey
		and isnull(ClientKey, 0) = 0
		
		if @VoucherDetailKey is null
			break
			
		Select @LineProjectKey = ProjectKey, @LineItemKey = ItemKey, @PurchaseOrderDetailKey = ISNULL(PurchaseOrderDetailKey, 0)	
		From tVoucherDetail (nolock)
		Where VoucherDetailKey = @VoucherDetailKey
			 	
		select @LineClientKey = null
			 	
		EXEC sptVoucherDetailFindClient @LineProjectKey, @LineItemKey, @PurchaseOrderDetailKey, @IOClientLink ,@BCClientLink 
			,@LineClientKey output	

		if isnull(@LineClientKey, 0) > 0
			Update tVoucherDetail Set ClientKey = @LineClientKey Where VoucherDetailKey = @VoucherDetailKey 
	end

	-- Make sure the invoice is not posted prior to the closing date
	if @Prepost = 0
		if not @GLClosedDate is null and @CheckClosedDate = 1
			if @GLClosedDate > @TransactionDate
				return @kErrGLClosedDate

	if @TransactionDate is null
		return @kErrTranDateMissing

	IF @PostToGL = 0 And @Prepost = 0
	BEGIN
		-- Case when we do not post to GL
		Update tVoucher
		Set Posted = 1, Status = 4
		Where VoucherKey = @VoucherKey

		insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, UnaccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
		Select vd.PurchaseOrderDetailKey, @CompanyKey, vd.VoucherDetailKey, ROUND(ISNULL(vd.PrebillAmount, 0), 2), -1, 'VOUCHER', @VoucherKey, @TransactionDate 
		from tVoucherDetail vd (nolock)
		Inner Join tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		Inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		Inner Join tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
		Where	vd.VoucherKey = @VoucherKey
		And		po.BillAt in (0,1) 

		RETURN 1		
	END

	if @OpeningTransaction = 1 And @Prepost = 0
	begin
		insert tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, UnaccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
		Select vd.PurchaseOrderDetailKey, @CompanyKey, vd.VoucherDetailKey, ROUND(ISNULL(vd.PrebillAmount, 0), 2), -1, 'VOUCHER', @VoucherKey, @TransactionDate 
		from tVoucherDetail vd (nolock)
		Inner Join tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		Inner Join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
		Inner Join tInvoiceLine il (NOLOCK) ON pod.InvoiceLineKey = il.InvoiceLineKey
		Where	vd.VoucherKey = @VoucherKey
		And		po.BillAt in (0,1) 
	end

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
	
	-- create a temp table to hold the accrued expense account Keys
	create table #tAccruedExpenseAccount
		(
		VoucherDetailKey int null
		,GLAccountKey int null
		,GLAccountErrRet int null
		
		-- added for tTransactionOrderAccrual
		,GLCompanyKey int null -- ICT
		,ClientKey int null
		,ProjectKey int null
		,ClassKey int null
		,OfficeKey int null
		,DepartmentKey int null
		
		,PurchaseOrderDetailKey int null
		,PrebillAmount money null -- straight from VD
		,UnaccrualAmount money null -- rounded for GL
		,TempTranLineKey int null
		,TransactionKey int null 
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

	CREATE TABLE #tVoucherCCDetail (
		VoucherKey int null
		,VoucherCCKey int null
		,CashTransactionLineKey int null
		,Amount money null
		,TempTranLineKey int NULL
		)	
	
	If exists(Select 1 from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey And ShortDescription = @kLaborLineDesc)
		-- create a temp table to hold the Keys and amounts
		create table #tLineDetail
			(
			VoucherDetailKey int null
			,ClassKey int null
			,OfficeKey int null
			,Amount money null 
			)
							
	-- These should not change
	IF @CreditCard = 1
		SELECT @Entity = 'CREDITCARD'
	ELSE
		SELECT @Entity = 'VOUCHER'

	Select	@EntityKey = @VoucherKey
			,@Reference = @InvoiceNumber
			,@SourceCompanyKey = @VendorKey			
			,@DepositKey = NULL 
	-- TransactionDate, ProjectKey, GLCompanyKey, ClientKey already set
	 	
	if @CreditCard = 1
	begin
		select @Reference = isnull(@BoughtFrom, '')
	end

	/*
	* Insert the header/AP Amount
	*/
	
	SELECT @PostSide = 'C'
		  ,@GLAccountKey = @APAccountKey
		  ,@GLAccountErrRet = @kErrInvalidAPAcct 
		  ,@Memo = @kMemoHeader + @InvoiceNumber
		  ,@Section = @kSectionHeader 
		  ,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
			
	-- for credit card charges, InvoiceNumber is null in DB or '' here
	-- so replace by InvoiceDescription
	if @CreditCard = 1
	begin
		select @Memo = isnull(@InvoiceDescription, '')
	end

	exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID,@ExchangeRate
	
/*	-- Changed because of ICT
		
	-- Sales Tax Amount
	
	if @SalesTaxAmount <> 0
	BEGIN
		-- this GL account will be validated later
		IF isnull(@SalesTaxKey, 0) > 0 
			SELECT @GLAccountKey = APPayableGLAccountKey 
				  ,@GLAccountErrRet = @kErrInvalidSalesTaxAcct
			FROM   tSalesTax (nolock) Where SalesTaxKey = @SalesTaxKey
		ELSE
			SELECT @GLAccountKey = 0 
				  ,@GLAccountErrRet = @kErrInvalidSalesTaxAcct
						
		SELECT @PostSide = 'D', @Amount = @SalesTaxAmount
			   ,@Memo = @kMemoSalesTax + @InvoiceNumber, @Section = @kSectionSalesTax  
			   ,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
				
	END		
	
	-- Sales Tax 2 Amount
	
	if @SalesTax2Amount <> 0
	BEGIN
		-- this GL account will be validated later
		IF isnull(@SalesTax2Key, 0) > 0 
			SELECT @GLAccountKey = APPayableGLAccountKey 
				  ,@GLAccountErrRet = @kErrInvalidSalesTax2Acct
			FROM   tSalesTax (nolock) Where SalesTaxKey = @SalesTax2Key
		ELSE
			SELECT @GLAccountKey = 0 
				  ,@GLAccountErrRet = @kErrInvalidSalesTax2Acct
				
		SELECT @PostSide = 'D', @Amount = @SalesTax2Amount
				,@Memo = @kMemoSalesTax2 + @InvoiceNumber, @Section = @kSectionSalesTax  
				,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

		exec spGLInsertTranTemp @CompanyKey,@PostSide,@TransactionDate,@Entity,@EntityKey,@Reference,@GLAccountKey,@Amount,@ClassKey,@Memo, 
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	END
	
	-- Other Sales Taxes
	
	SELECT @PostSide = 'D', @GLAccountErrRet = @kErrInvalidSalesTax2Acct
			,@Memo = @kMemoSalesTax3 + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per GL Account
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity, @EntityKey,@Reference,
		st.APPayableGLAccountKey, Sum(vdt.SalesTaxAmount), 0, @ClassKey, @Memo,
		@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		@GLCompanyKey,@OfficeKey,@DepartmentKey,st.SalesTaxKey,@Section,@GLAccountErrRet
	From   tVoucherDetailTax vdt (nolock)
		Inner Join tVoucherDetail vd (NOLOCK) ON vdt.VoucherDetailKey = vd.VoucherDetailKey
		Inner Join tSalesTax st (NOLOCK) ON vdt.SalesTaxKey = st.SalesTaxKey
	Where  vd.VoucherKey = @VoucherKey	
	Group by st.SalesTaxKey,st.APPayableGLAccountKey
*/	

	/* 
	 * Because of ICT, read now tVoucherTax for sales taxes
	*/

	SELECT @PostSide = 'D', @GLAccountErrRet = @kErrInvalidSalesTaxAcct
			,@Memo = @kMemoSalesTax + @InvoiceNumber, @Section = @kSectionSalesTax  
			,@OfficeKey = @HeaderOfficeKey, @DepartmentKey = NULL, @DetailLineKey = NULL

	-- One entry per GL Account
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID,ExchangeRate)
	
	SELECT @CompanyKey,@TransactionDate,@Entity, @EntityKey,@Reference,
		st.APPayableGLAccountKey, Sum(vt.SalesTaxAmount), 0, @ClassKey
		, case when vt.Type = 1 then @kMemoSalesTax + @InvoiceNumber 
		       when vt.Type = 2 then @kMemoSalesTax2 + @InvoiceNumber
			   else @kMemoSalesTax3 + @InvoiceNumber end

		,@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide

		-- ICT
		, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(@GLCompanyKey, 0) else vd.TargetGLCompanyKey end
		
		,@OfficeKey,@DepartmentKey,st.SalesTaxKey,@Section
		, case when vt.Type = 1 then @kErrInvalidSalesTaxAcct else @kErrInvalidSalesTax2Acct end
		,@CurrencyID,@ExchangeRate 
	From   tVoucherTax vt (nolock)
		Left Join tVoucherDetail vd (NOLOCK) ON vt.VoucherDetailKey = vd.VoucherDetailKey -- left join because we did not convert old recs
		Inner Join tSalesTax st (NOLOCK) ON vt.SalesTaxKey = st.SalesTaxKey
	Where  vt.VoucherKey = @VoucherKey	
	Group by vt.Type, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(@GLCompanyKey, 0) else vd.TargetGLCompanyKey end
		, st.SalesTaxKey,st.APPayableGLAccountKey
	

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
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@GLCompanyKey,@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet,
			@CurrencyID, @ExchangeRate

		-- One entry per class, GL account...and Exchange  Rate
		SELECT @PostSide = 'C' , @GLAccountErrRet = @kErrInvalidPrepayAcct 
				,@Memo = @kMemoPrepayments, @Section = @kSectionPrepayments   
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID,ExchangeRate)
		
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			p.UnappliedPaymentAccountKey, 0, SUM(pd.Amount),
			ISNULL(p.ClassKey, 0),  @Memo,
			@ClientKey,@ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,pd.PaymentDetailKey,@Section,@GLAccountErrRet,p.CurrencyID,isnull(p.ExchangeRate, 1)
		From   tPaymentDetail pd (nolock)
			Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
		Where	pd.VoucherKey = @VoucherKey
		And		pd.Prepay = 1
		Group By p.UnappliedPaymentAccountKey,pd.PaymentDetailKey, ISNULL(p.ClassKey, 0), p.CurrencyID,isnull(p.ExchangeRate, 1) 
		
		-- Now process the Realized Gain/Loss for the prepayments
		if @MultiCurrency = 1
		begin
	
			SELECT @PostSide = 'D', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
				,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
				,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
			INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
				Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
				DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate, HDebit, HCredit)
		
			SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
				@GLAccountKey, 0, 0,
				null, --@ClassKey,  
				@Memo,
				null, --@ClientKey,
				null, --@ProjectKey,
				@SourceCompanyKey,@DepositKey,@PostSide,
				@GLCompanyKey,@OfficeKey,@DepartmentKey,pd.PaymentDetailKey,@Section,@GLAccountErrRet,
				null, -- Home Currency
				1, -- Exchange Rate = 1
				Round(pd.Amount * (isnull(p.ExchangeRate, 1) - @ExchangeRate), 2), 0
			From   tPaymentDetail pd (nolock)
				Inner Join tPayment p (NOLOCK) ON pd.PaymentKey = p.PaymentKey
			Where	pd.VoucherKey = @VoucherKey
			And		pd.Prepay = 1
		
		end

	END
	
	/*
	 * Prebill Accrual Reversal
	 */

	-- Step 1: determine AccruedExpenseAccountKey
		
	-- Try to get the accrued expense accounts from the pods first		
	Insert #tAccruedExpenseAccount (VoucherDetailKey, GLAccountKey, GLAccountErrRet
			,PurchaseOrderDetailKey,PrebillAmount,GLCompanyKey, ClientKey,ProjectKey,ClassKey,OfficeKey,DepartmentKey 
		)
	Select vd.VoucherDetailKey, gl.GLAccountKey, @kErrInvalidPOAccruedExpenseAcct 
		,vd.PurchaseOrderDetailKey,ROUND(ISNULL(vd.PrebillAmount, 0), 2)
		
		-- ICT
		, isnull(po.GLCompanyKey, 0)
		
		,ISNULL(i.ClientKey, 0),ISNULL(pod.ProjectKey, 0),ISNULL(pod.ClassKey, 0),ISNULL(pod.OfficeKey, 0),ISNULL(pod.DepartmentKey, 0)
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
	
	UPDATE #tAccruedExpenseAccount SET GLAccountKey = ISNULL(GLAccountKey, 0)
	
	-- Step 2: Credits vd.AccruedExpenseOutAccountKey =  pod.AccruedExpenseInAccountKey OR @POAccruedExpenseAccountKey OR item.ExpenseAccountKey
	--, group by office, department, class on the order detail
	SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidPOAccruedExpenseAcct     
			,@Memo = @kMemoPrebillAccruals  + @InvoiceNumber , @Section = @kSectionPrebillAccruals    
			,@DetailLineKey = NULL
			
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		GLAccountKey, 0, ROUND(Sum(PrebillAmount), 2), ClassKey,  @Memo,
		ClientKey,ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide,
		GLCompanyKey,OfficeKey,DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	From    #tAccruedExpenseAccount   
	Group By GLAccountKey, GLCompanyKey, ClientKey, ClassKey, ProjectKey, OfficeKey, DepartmentKey


	
	-- Step 3: Debits, one entry per client and gl class and project on the order line + GLCompanyKey because of ICT
	SELECT @PostSide = 'D' , @GLAccountKey = @POPrebillAccrualAccountKey, @GLAccountErrRet = @kErrInvalidPOPrebillAccrualAcct 
			,@Memo = @kMemoPrebillAccruals + @InvoiceNumber, @Section = @kSectionPrebillAccruals   
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		@GLAccountKey, Sum(Credit), 0,
		ISNULL(ClassKey, 0), @Memo,
		ISNULL(ClientKey, 0),ISNULL(ProjectKey,0),@SourceCompanyKey,@DepositKey,@PostSide,
		ISNULL(GLCompanyKey, 0),@OfficeKey,@DepartmentKey,@DetailLineKey,@Section,@GLAccountErrRet
	From   #tTransaction (nolock)
	Where	EntityKey = @EntityKey
	And     Entity = @Entity
	And     Section = @kSectionPrebillAccruals
	And     PostSide = 'C' 
	Group By ISNULL(ClientKey, 0), ISNULL(GLCompanyKey, 0), ISNULL(ClassKey, 0), ISNULL(ProjectKey, 0) -- use ISNULL because of loop below


	-- Step 4: Save the TempTranLineKey  so that we can use later when saving in tTransactionOrderAccrual

	-- we will need a way to update the TransactionKey from TempTranLineKey in #tAccruedExpenseAccount later 
	UPDATE #tTransaction SET DetailLineKey = TempTranLineKey WHERE Section = @kSectionPrebillAccruals
	
	DECLARE @TempTranLineKey int
	DECLARE @AccrualClientKey int, @AccrualClassKey int, @AccrualGLCompanyKey int,@AccrualProjectKey int 
	
	SELECT @TempTranLineKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @TempTranLineKey = MIN(TempTranLineKey)
		FROM   #tTransaction
		WHERE  Section = @kSectionPrebillAccruals
		AND    TempTranLineKey > @TempTranLineKey
		AND    PostSide = 'D'
				
		IF @TempTranLineKey IS NULL
			BREAK
		
		SELECT 	@AccrualClientKey = ClientKey
			    ,@AccrualClassKey = ClassKey
				,@AccrualGLCompanyKey = GLCompanyKey
				,@AccrualProjectKey = ProjectKey
		FROM  #tTransaction
		WHERE TempTranLineKey = @TempTranLineKey
		
		UPDATE #tAccruedExpenseAccount
		SET    TempTranLineKey = @TempTranLineKey
			  ,UnaccrualAmount = PrebillAmount
		WHERE  ClientKey =@AccrualClientKey
		AND    ClassKey	= @AccrualClassKey 
		AND    GLCompanyKey	= @AccrualGLCompanyKey 
		AND    ProjectKey =@AccrualProjectKey
		    	
	END
		
	 /*
	 * Voucher Lines
	 */

	-- GL Account, office, department, class, project from the line
	SELECT @PostSide = 'D', @GLAccountErrRet = @kErrInvalidLineAcct   
			,@Memo = @kMemoLine + @InvoiceNumber , @Section = @kSectionLine   

	if @CreditCard = 1
	begin
		select @Memo = @Memo + ' ' + isnull(@BoughtFrom, '')
	end

	-- One entry per line
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
		CASE WHEN vd.WIPPostingOutKey <> 0 AND vd.WIPPostingInKey = -1 THEN vd.OldExpenseAccountKey
		ELSE vd.ExpenseAccountKey END
		, vd.TotalCost, 0,
		vd.ClassKey, Left(@Memo + ' ' + rtrim(ltrim(isnull(vd.ShortDescription, ''))), 500),
		vd.ClientKey,vd.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide
		
		-- ICT
		, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then @GLCompanyKey else vd.TargetGLCompanyKey end
		
		,vd.OfficeKey,vd.DepartmentKey,vd.VoucherDetailKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate
	From   tVoucherDetail vd (nolock)
	Where  vd.VoucherKey = @VoucherKey
	And    vd.TransferToKey is null -- filter out transferred transactions
	And    isnull(vd.ShortDescription, '') <> @kLaborLineDesc

	-- Labor Line

	If exists(Select 1 from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey And ShortDescription = @kLaborLineDesc)
	begin
		Declare @LaborVoucherDetailKey int
		select @LaborVoucherDetailKey = VoucherDetailKey from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey And ShortDescription = @kLaborLineDesc

		insert #tLineDetail(VoucherDetailKey, ClassKey, OfficeKey, Amount)
		select @LaborVoucherDetailKey, isnull(p.ClassKey,0), isnull(p.OfficeKey,0), SUM(round(t.ActualHours * t.CostRate, 2)) 
		from   tTime t (nolock)
			left outer join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	    where  t.VoucherKey = @VoucherKey  
		group by isnull(p.ClassKey,0), isnull(p.OfficeKey,0)

		-- One entry per line/Class/Office
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,  CurrencyID, ExchangeRate)
	
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference
			,CASE WHEN vd.WIPPostingOutKey <> 0 AND vd.WIPPostingInKey = -1 THEN vd.OldExpenseAccountKey
			ELSE vd.ExpenseAccountKey END
			, b.Amount, 0
			,case when b.ClassKey = 0 then vd.ClassKey else b.ClassKey end 
			,Left(@Memo + ' ' + rtrim(ltrim(vd.ShortDescription)), 500)
			,null -- ,vd.ClientKey (issue 230068)
			,vd.ProjectKey,@SourceCompanyKey,@DepositKey,@PostSide
		
			-- No ICT, GLCompany on Time entries should be the same as Voucher 
			, @GLCompanyKey
		
			,case when b.OfficeKey = 0 then vd.OfficeKey else b.OfficeKey end
			,vd.DepartmentKey,vd.VoucherDetailKey,@Section,@GLAccountErrRet,  @CurrencyID, @ExchangeRate -- TODO: double check...project currency = vendor currency???
		From   tVoucherDetail vd (nolock)
			inner join #tLineDetail b (nolock) on vd.VoucherDetailKey = b.VoucherDetailKey
		Where  vd.VoucherKey = @VoucherKey
		And    vd.TransferToKey is null -- filter out transferred transactions
		And    vd.ShortDescription = @kLaborLineDesc

	end

	/*
	Now the tVoucherCC records. These are regular vouchers applied to/paid by Credit Cards 
	*/
	
	-- PostSide = D

	-- One entry per line in ....this is a new section 7...will not be in tCashTransactionLine
	INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate)
	
	SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference
		,v.APAccountKey, vcc.Amount, 0
		,v.ClassKey, Left(@Memo + ' ' + rtrim(ltrim(v.InvoiceNumber)), 500)
		,NULL,v.ProjectKey,v.VendorKey,@DepositKey,@PostSide
		--,@GLCompanyKey
		,isnull(v.GLCompanyKey, 0) -- Safer to get it from the real vouchers
		,v.OfficeKey,null,vcc.VoucherKey,@kSectionVoucherCC,@kErrInvalidAPAcct ,  v.CurrencyID, isnull(v.ExchangeRate, 1)
	From   tVoucherCC vcc (nolock)
	inner join tVoucher v (nolock) on vcc.VoucherKey = v.VoucherKey
 	Where  vcc.VoucherCCKey = @VoucherKey

	-- Now process the Realized Gain/Loss for the tVoucherCC
	if @MultiCurrency = 1
	begin
	
		SELECT @PostSide = 'C', @GLAccountKey = @RealizedGainAccountKey, @GLAccountErrRet = @kErrInvalidRealizedGainAcct 
			,@Memo = @kMemoRealizedGain, @Section = @kSectionMCGain    
			,@OfficeKey = NULL, @DepartmentKey = NULL, @DetailLineKey = NULL
	
		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet, CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT @CompanyKey,@TransactionDate,@Entity,@EntityKey,@Reference,
			@GLAccountKey, 0, 0,
			null, --@ClassKey,  
			@Memo,
			null, --@ClientKey,
			null, --@ProjectKey,
			@SourceCompanyKey,@DepositKey,@PostSide,
			@GLCompanyKey,@OfficeKey,@DepartmentKey,
			vcc.VoucherKey, -- problem is that the application does not have an identity primary key
			@Section,@GLAccountErrRet,
			null, -- Home Currency
			1, -- Exchange Rate = 1
			0,
			Round(vcc.Amount * (isnull(v.ExchangeRate, 1) - @ExchangeRate), 2)
		From   tVoucherCC vcc (nolock)
			Inner Join tVoucher v (NOLOCK) on vcc.VoucherKey = v.VoucherKey
		Where	vcc.VoucherCCKey = @VoucherKey

		
	end


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
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)
		
		SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			@WIPExpenseAssetAccountKey, Sum(vd.BillableCost), 0, ISNULL(vd.ClassKey, 0), @Memo,
			ISNULL(vd.ClientKey, 0),ISNULL(vd.ProjectKey, 0),ISNULL(vd.ClientKey, 0),@DepositKey,@PostSide
			,@GLCompanyKey, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0),
			@DetailLineKey,@Section,@GLAccountErrRet, @CurrencyID, @ExchangeRate
		From	tVoucherDetail vd (nolock)
				left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where	vd.VoucherKey = @VoucherKey
		and		vd.ClientKey is not null
		and		p.NonBillable = 0
		and		i.ItemType = 0
		And    vd.TransferToKey is null -- filter out transferred transactions

		Group By ISNULL(vd.ClientKey, 0), ISNULL(vd.ProjectKey,0), ISNULL(vd.ClassKey, 0), 
			ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)

		-- Media
		SELECT @PostSide = 'D', @GLAccountKey = @WIPMediaAssetAccountKey, @GLAccountErrRet = @kErrInvalidWIPMediaAssetAcct   
			,@Memo = @kMemoWIP, @Section = @kSectionWIP, @DetailLineKey = NULL   

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)
		
		SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			@WIPExpenseAssetAccountKey, Sum(vd.BillableCost), 0, ISNULL(vd.ClassKey, 0), @Memo,
			ISNULL(vd.ClientKey, 0),ISNULL(vd.ProjectKey, 0),ISNULL(vd.ClientKey, 0),@DepositKey,@PostSide,
			@GLCompanyKey, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0),
			@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID, @ExchangeRate
		From	tVoucherDetail vd (nolock)
				left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where	vd.VoucherKey = @VoucherKey
		and		vd.ClientKey is not null
		and		p.NonBillable = 0
		and		i.ItemType > 0
		And    vd.TransferToKey is null -- filter out transferred transactions

		Group By ISNULL(vd.ClientKey, 0), ISNULL(vd.ProjectKey,0), ISNULL(vd.ClassKey, 0), 
			ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)

		-- Credit side by item sales acct
		SELECT @PostSide = 'C', @GLAccountErrRet = @kErrInvalidSalesAcct   
			,@Memo = @kMemoWIP, @Section = @kSectionWIP, @DetailLineKey = NULL   

		INSERT #tTransaction(CompanyKey,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
			Memo,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
			DepartmentKey,DetailLineKey,Section,GLAccountErrRet,CurrencyID, ExchangeRate)
		
		SELECT @CompanyKey, @TransactionDate, @Entity, @EntityKey, @Reference,
			i.SalesAccountKey, 0, Sum(vd.BillableCost), ISNULL(vd.ClassKey, 0), @Memo,
			ISNULL(vd.ClientKey, 0),ISNULL(vd.ProjectKey, 0),ISNULL(vd.ClientKey, 0),@DepositKey,@PostSide,
			@GLCompanyKey, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0),
			@DetailLineKey,@Section,@GLAccountErrRet,@CurrencyID, @ExchangeRate
		From	tVoucherDetail vd (nolock)
				left outer join tProject p (nolock) on vd.ProjectKey = p.ProjectKey
				inner join tItem i (nolock) on vd.ItemKey = i.ItemKey
		Where	vd.VoucherKey = @VoucherKey
		and		vd.ClientKey is not null
		and		p.NonBillable = 0
		And    vd.TransferToKey is null -- filter out transferred transactions

		Group By i.SalesAccountKey, ISNULL(vd.ClientKey, 0), ISNULL(vd.ProjectKey,0), ISNULL(vd.ClassKey, 0), 
			ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)
	
	END

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
		

		-- 1 Accrual, 1 Rounding acct
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
		AND   PostSide = 'D' -- only debits
	 
	-- this will populate #tInvoiceAdvanceBillSale and #tCashTransactionLine.AdvBillAmount	 
	EXEC @RetVal = sptCashPostVoucherFillCCDetail @VoucherKey	
			
	-- and calculate the Prepayment and Receipt amounts in #tCashTransactionLine
	EXEC @RetVal = sptCashPostVoucherCalcLineAmounts @VoucherKey

	If Exists (Select 1 From #tTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
		return @kErrICTBlankGLAccount


	/*
	 * Cash-Basis prep
	 */
	
	-- only if @OpeningTransaction = 0
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
	
	exec @RetVal = sptCashQueue @CompanyKey, @Entity, @EntityKey, @TransactionDate, @Action 

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
	
	If Exists (Select 1 From #tCashTransaction Where [Section] = @kSectionICT and isnull(GLAccountKey, 0) = 0)
	return @kErrICTBlankGLAccount


	END -- End Track Cash
		

	/*
	 * Posting!!
	 */
		
	BEGIN TRAN
	
	Update tVoucher
	Set Posted = 1, Status = 4
	Where VoucherKey = @VoucherKey
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN @kErrUnexpected 	
	END		
	
	-- only if @OpeningTransaction = 0
	IF NOT EXISTS (SELECT 1 FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
	AND @OpeningTransaction = 0
	BEGIN
		INSERT tTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,Reversed, Cleared ,CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,0, 0,CurrencyID, ExchangeRate, HDebit, HCredit	
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
		
		INSERT tTransactionOrderAccrual (PurchaseOrderDetailKey, CompanyKey, VoucherDetailKey, UnaccrualAmount, TransactionKey, Entity, EntityKey, PostingDate)
		SELECT PurchaseOrderDetailKey, @CompanyKey, VoucherDetailKey, UnaccrualAmount, TransactionKey, @Entity, @EntityKey, @TransactionDate 
		FROM   #tAccruedExpenseAccount	 
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
	
		-- Delete records created by spFixOrderAccrual
		-- Issues 54904 and 59265		
		DELETE tTransactionOrderAccrual
		FROM   #tAccruedExpenseAccount b
		WHERE  tTransactionOrderAccrual.PurchaseOrderDetailKey = b.PurchaseOrderDetailKey
		AND    tTransactionOrderAccrual.VoucherDetailKey = -1
		 
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		
		 	
	END
	
	-- do this no matter what @OpeningTransaction is 0 or 1
	--IF @TrackCash = 1
	--BEGIN
		-- we may not have to do that deletion
		Delete tCashTransactionLine WHERE Entity = @Entity AND EntityKey = @EntityKey
	
		INSERT tCashTransactionLine(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, Reversed, Cleared, TempTranLineKey,
		AdvBillAmount, PrepaymentAmount, ReceiptAmount,CurrencyID, ExchangeRate, HDebit, HCredit)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, 0, 0, TempTranLineKey,	
		AdvBillAmount, PrepaymentAmount, ReceiptAmount,CurrencyID, ExchangeRate, HDebit, HCredit	
		FROM #tCashTransactionLine 	
		WHERE Entity = @Entity AND EntityKey = @EntityKey
		AND   [Section] IN (2, 5) -- line or sales taxes
		AND   PostSide = 'D' -- only debits
		  
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END	
		
		UPDATE #tVoucherCCDetail
		SET    #tVoucherCCDetail.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  ctl.Entity = 'VOUCHER'
		AND    ctl.EntityKey = @VoucherKey  
		AND    #tVoucherCCDetail.TempTranLineKey = ctl.TempTranLineKey
		
		DELETE #tVoucherCCDetail WHERE CashTransactionLineKey IS NULL
			
		INSERT tVoucherCCDetail (VoucherKey,VoucherCCKey,CashTransactionLineKey,Amount)		
		SELECT VoucherKey,VoucherCCKey,CashTransactionLineKey,Amount
		FROM   #tVoucherCCDetail
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
		
			
	--END
	
	-- only if @OpeningTransaction = 0
	IF @TrackCash = 1 --AND @OpeningTransaction = 0 --issue 201908 allow payments to be reposted
	BEGIN
		DELETE tCashTransaction
		FROM   #tCashTransactionUnpost
		WHERE  tCashTransaction.Entity = #tCashTransactionUnpost.Entity 
		AND    tCashTransaction.EntityKey = #tCashTransactionUnpost.EntityKey
		AND    #tCashTransactionUnpost.Unpost = 1
		AND    (@OpeningTransaction = 0 OR
			tCashTransaction.Entity = 'PAYMENT' -- only payments if OpeningTransaction = 1  
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
		WHERE  #tCashTransaction.Entity = 'VOUCHER' -- cannot equate varchar from temp to permanent table due to collation errors
		AND    ctl.Entity = 'VOUCHER'
		AND    #tCashTransaction.EntityKey = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  #tCashTransaction.Entity = 'CREDITCARD' -- cannot equate varchar from temp to permanent table due to collation errors
		AND    ctl.Entity = 'CREDITCARD'
		AND    #tCashTransaction.EntityKey = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		--- then AEntity
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  #tCashTransaction.AEntity = 'VOUCHER' -- cannot equate varchar from temp to permanent table due to collation errors
		AND    ctl.Entity = 'VOUCHER'
		AND    #tCashTransaction.AEntityKey = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  #tCashTransaction.AEntity = 'CREDITCARD' -- cannot equate varchar from temp to permanent table due to collation errors
		AND    ctl.Entity = 'CREDITCARD'
		AND    #tCashTransaction.AEntityKey = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		-- then AEntity2
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  #tCashTransaction.AEntity2 = 'VOUCHER' -- cannot equate varchar from temp to permanent table due to collation errors
		AND    ctl.Entity = 'VOUCHER'
		AND    #tCashTransaction.AEntity2Key = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		UPDATE #tCashTransaction
		SET    #tCashTransaction.CashTransactionLineKey = ctl.CashTransactionLineKey
		FROM   tCashTransactionLine ctl (NOLOCK)
		WHERE  #tCashTransaction.AEntity2 = 'CREDITCARD' -- cannot equate varchar from temp to permanent table due to collation errors
		AND    ctl.Entity = 'CREDITCARD'
		AND    #tCashTransaction.AEntity2Key = ctl.EntityKey
		AND    #tCashTransaction.CashTransactionLineKey = ctl.TempTranLineKey
		AND    #tCashTransaction.UpdateTranLineKey = 1
		
		INSERT tCashTransaction(CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,Reversed, Cleared
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		)
		
		SELECT CompanyKey,DateCreated,TransactionDate,Entity,EntityKey,Reference,GLAccountKey,Debit,Credit,ClassKey,
		Memo,PostMonth,PostYear,ClientKey,ProjectKey,SourceCompanyKey,DepositKey,PostSide,GLCompanyKey,OfficeKey,
		DepartmentKey,DetailLineKey,Section, Overhead, ICTGLCompanyKey,0, 0	
		,UIDCashTransactionKey,AEntity,AEntityKey,AReference,AEntity2,AEntity2Key,AReference2,AAmount, LineAmount,CashTransactionLineKey
		,CurrencyID, ExchangeRate, HDebit, HCredit
		FROM #tCashTransaction 	
		WHERE   (@OpeningTransaction = 0 OR
			#tCashTransaction.Entity = 'PAYMENT' -- only payments if OpeningTransaction = 1  --issue 201908 allow payments to reposted
		)
		--WHERE Entity = @Entity AND EntityKey = @EntityKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END
	
	END

	-- only if @OpeningTransaction = 0
	
	IF @OpeningTransaction = 0
	BEGIN
		-- Protect against double postings
		IF (SELECT COUNT(*) FROM tTransaction (NOLOCK) WHERE Entity = @Entity AND EntityKey = @EntityKey)
		<> @TransactionCount
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		

		Declare @PurchaseOrderKey int, @LineAmount money, @OpenAmount money, @AppliedAmount money		
		Select @VoucherDetailKey = -1
		While (1=1)
		BEGIN
			Select @VoucherDetailKey = Min(VoucherDetailKey) from tVoucherDetail (nolock) Where VoucherKey = @VoucherKey and VoucherDetailKey > @VoucherDetailKey
			if @VoucherDetailKey is null
				break
				
			Select @PurchaseOrderKey = ISNULL(pod.PurchaseOrderKey, 0) from tVoucherDetail vd (nolock)
				inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				Where vd.VoucherDetailKey = @VoucherDetailKey
				
			if @PurchaseOrderKey > 0
			BEGIN
				Select @LineAmount = ISNULL(Sum(TotalCost), 0) from tPurchaseOrderDetail pod (nolock)
				Where PurchaseOrderKey = @PurchaseOrderKey
				
				Select @AppliedAmount = ISNULL(Sum(vd.TotalCost) , 0) from tVoucherDetail vd (nolock)
					inner join tVoucher v (nolock) on v.VoucherKey = vd.VoucherKey
					inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
					Where pod.PurchaseOrderKey = @PurchaseOrderKey 
					and	v.Status = 4
				
				Select @OpenAmount = @LineAmount - @AppliedAmount
				
				If @OpenAmount = 0
					Update tPurchaseOrder
					Set Closed = 1
					Where PurchaseOrderKey = @PurchaseOrderKey
			
			END
		END			

		-- save the accrued expense account key, they will be used for the reversals in spGLPostInvoice 					
		UPDATE tVoucherDetail
		SET    tVoucherDetail.AccruedExpenseOutAccountKey = b.GLAccountKey
		FROM   #tAccruedExpenseAccount b
		WHERE  tVoucherDetail.VoucherDetailKey = b.VoucherDetailKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN @kErrUnexpected 	
		END		

	END -- @OpeningTransaction = 0
				
	COMMIT TRAN
	
return 1
GO
