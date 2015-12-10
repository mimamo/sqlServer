USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostWIP]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGLPostWIP]
(
	@CompanyKey int,
	@PostingDate smalldatetime,
	@ThroughDate smalldatetime,
	@Comment varchar(300),
	@HeaderGLCompanyKey int,
	@OpeningTransaction tinyint = 0,
	@PrePost int = 0, -- if we pre post, do not insert into GL and do not create temp table
	@oErrICTGLCompanyKey int output -- in case of error with ICT GL Companies, get the gl company creating the problem
) 
AS --Encrypt

  /*
  || When     Who Rel   What
  || 03/21/07 GHL 8.4   Corrected tPref query 
  || 03/26/07 GHL 8.41  Removed nested loops by account/class/client and replaced by temp table
  ||					Also reversal of the logic in spGLPostVoucher for @WIPRecognizeCostRev
  || 04/05/07 GHL 8.41  Modified validation of GLAccountKeys
  || 04/05/07 GHL 8.41  Getting the client from voucher detail rather than the project for vouchers
  || 05/17/07 GHL 8.422 For vouchers for media take in account IO/BCClientLink 
  ||                    If 1 (Project) check if project is billable
  ||                    If 2 (Media Estimate), no project, always billable
  || 05/30/07 GHL 8.422 Rolled back changes made for Media Logic 2 weeks ago 
  ||                    i.e vouchers to Bill and to Mark As Billed should not be on prebilled POs
  || 06/18/07 GHL 8.5   Added OfficeKey, DepartmentKey, GLCompanyKey
  || 06/22/07 GHL 8.43  Excluding now projects on retainers for labor, misc cost, exp receipts
  || 07/11/07 GHL 8.5   ER are not going in, Vouchers are going in, retainer items logic
  ||                    Using now items instead of expense types. Added 2 new GL accounts for vouchers
  || 07/29/07 GHL 8.5   Added grouping by project
  || 08/13/07 GHL 8.5   Added correction of GLAccountKeys for vouchers which are not prebilled
  || 09/17/07 GHL 8.5   Added overhead
  || 09/18/07 GHL 8.5   Added HeaderGLCompany parameter
  || 11/01/07 GHL 8.5   Delete voucher details if covered by a retainer and if we link through project
  || 01/28/08 GHL 8.502 Changed the way expense reports are processed
  || 03/10/08 GHL 8.506 (21947) Added patch for expense receipts that are out of wip but not in
  || 04/07/08 GWG 8.509 Modified posting out of labor, ER and MC to not look at the non bill status so that if it was posted in, it gets posted out regardless
  ||					This can leave transactions in wip that should not be there.
  || 05/06/08 GHL 8.5   (25498) Taking now voucher details if WOK > 0 and WIK = 0 and expense acct key not in wip asset accts
  || 05/14/08 GHL 8.510 (26690) After review of the source of the class, corrected ClassKey for ERs
  ||                    Was 0 instead of tItem.ClassKey
  ||                    Also added tWIPPostingDetail.Amount
  || 06/06/08 GHL 8.512 (27510) Old vouchers being posted into WIP. Limiting now to WIK=0, WOK=0
  ||                    Also do not try to correct the situation WIK=0, WOK>0 for vouchers
  ||                    This situation should not happen since we put restrictions on unposting WIP
  || 06/18/08 GHL 8.513 Added opening transaction logic
  || 12/01/09 GHL 10.514 Added update and use of WIPAmount on the actual transactions
  || 02/24/10 GHL 10.519 (75170) Changed intitial query in tTime to benefit form IX_tTime_9 index
  || 02/25/10 GHL 10.519 Added logic with TransferInDate
  || 03/16/10 GHL 10.520 (76265) Pulling now time entries into a temp table rather than doing separate queries from tTime 
  || 09/09/10 GHL 10.535 (89273) Added better validation of GL accounts
  || 10/29/10 GHL 10.537 Added voucher income fields and logic (WIPBookVoucherToRevenue + media/voucher income accts)
  || 11/10/10 GHL 10.537 (93344?) Added logic for WIPExpensesAtGross
  || 11/10/10 GHL 10.537 (93562) Added clause on DateBilled when getting unbilled labor to reduce the # of records
  ||                      Added DateBilled to IX_tTime_24
  || 12/21/10 GWG/GHL 10.539 (97467) Need to capture the write offs within time widnow 
  || 03/11/11 GHL 10.542 (82259) Added PrePost parameter so that we can run the WIP process without inserting in GL
  || 03/30/12 GHL 10.554 Added ICT and GLCompany Source support
  || 07/06/12 GHL 10.557 Added DueTo DueFrom GL transactions after talk with HMI
  || 07/16/12 GHL 10.558 Added logic for tProject.DoNotPostWip
  || 08/14/12 GHL 10.558 (150809) Placed creation of #tICT at the top of SP (outside of IF PostToGL THEN block)
  ||                      Also added pulling of SourceGLCompanyKey for WO voucher details
  || 08/22/12 GHL 10.558 (152342) Changed SourceGLCompanyKey to IncomeGLCompanyKey for clarity and changed
  ||                     inserts in #tGL because the balance sheet at HMI was not balanced
  || 09/28/12 RLB 10.560  Add MultiCompanyGLClosingDate preference check
  || 10/22/12 GHL 10.560  (157272)(157699) Added ClassKey to follow same logic as GLCompanyKey/OfficeKey when tProject.GLCompanySource = 1 
  || 01/29/13 GHL 10.564 (166773) Added patch to unpost the WIP batch if the last update of tTime.WIPPostingInKey fails
  || 08/16/13 GHL 10.571 Added logic for multi currency
  || 09/25/13 GHL 10.572 Added multi currency parameters to spGLInsertTran - WIP is saved in Home Currency 
  || 11/08/13 GHL 10.574 For vouchers with prebilled PO, subtract vd.PrebillAmount
  || 03/18/14 RLB 10.578 (205574) Added WIP MiscCost At Gross enhancement
  || 09/03/14 GHL 10.584 (228361) Getting now tMiscCost.DepartmentKey instead of tItem.DepartmentKey
  || 09/11/14 GHL 10.584 (228192) Getting now voucher details even if pod.InvoiceLineKey is >=0 
  ||                     Note: there is another good reason to remove where clause pod.InvoiceLineKey is null
  ||                     it is because when we close a PO, we mark as billed now
  || 10/04/14 GHL 10.585 (235228) After removing where clause pod.InvoiceLineKey is null, I am picking up too many old VIs
  ||                     For this reason I am rolling back changes made for 228192
  ||                     Changed pod.InvoiceLineKey is null to isnull(pod.InvoiceLineKey, 0) = 0 to pick pod marked as billed
  || 11/07/14 RLB 10.586 Added check for Abelson Taylor WIP Transactions on Hold Not Posted
  || 01/05/15 GHL 10.588 Taking in account now tPreference.DefaultDepartmentFromUser for time entries
  || 02/09/15 GHL 10.588 Fixed problem when getting tTime.OnHold for tPreference.WIPHoldTransactionNotPosted  
  || 03/10/15 GHL 10.590 Pick tTime.DepartmentKey instead of taking in account tPreference.DefaultDepartmentFromUser 
  ||                     The handling of DefaultDepartmentFromUser has been moved to the time entry insert and update
  || 03/16/15 GHL 10.590 (249599) For expense reports, only put in WIP if WOK = 0, also do not try to correct the situation
  ||                     WIK = 0, WOK <>0. That was placed at a time when users could unpost any WIP batch (now they can only 
  ||                     unpost the last one) 
  || 03/30/15 GHL 10.590 If PrePost = 1 do not insert ICT records in tTransaction
  || 03/31/15 GHL 10.590 (240132) If a VI is marked as billed, do not check pod.InvoiceLineKey
  ||                     If in WIP, get it out of WIP no matter what
  || 05/06/15 GHL 10.591 (255753) Changed vd.WIPPostingInKey <> 0 to vd.WIPPostingInKey > 0 because I am picking up
  ||                      2007 invoices with WIK = -1 at Media Logic for marked as billed case 
  */  
 
Declare @GLClosedDate smalldatetime
Declare @PostToGL tinyint
Declare @PostingKey int
Declare @WIPLaborAssetAccountKey int
Declare @WIPLaborIncomeAccountKey int
Declare @WIPLaborWOAccountKey int
Declare @WIPExpenseAssetAccountKey int
Declare @WIPExpenseIncomeAccountKey int
Declare @WIPExpenseWOAccountKey int
Declare @WIPMediaAssetAccountKey int
Declare @WIPMediaIncomeAccountKey int
Declare @WIPMediaWOAccountKey int
Declare @WIPVoucherAssetAccountKey int
Declare @WIPVoucherIncomeAccountKey int
Declare @WIPVoucherWOAccountKey int
Declare @WIPClassFromDetail int
Declare @WIPBookVoucherToRevenue int
Declare @WIPExpensesAtGross int
Declare @WIPMiscCostAtGross int
Declare @RetVal int
Declare @Error int
Declare @GLAccountKey int
Declare @ClassKey int
Declare @ClientKey int
Declare @ProjectKey int
Declare @GLCompanyKey int
Declare @OfficeKey int
Declare @DepartmentKey int
Declare @TransactionKey int
Declare @Debit money
Declare @Credit money
Declare @ItemType int
Declare @RowNum int
Declare @Reference varchar(50)
Declare @IncludeGLAccount int
Declare @IOClientLink int -- 1 Link by project, 2 by Media Estimate
Declare @BCClientLink int
Declare @Overhead tinyint
Declare @UseGLCompany tinyint
Declare @UseMultiCompanyGLCloseDate tinyint
Declare @MultiCurrency int
Declare @WIPHoldTransactionNotPosted tinyint
Declare @DefaultDepartmentFromUser int

-- My Constants
DECLARE @kLaborIn				VARCHAR(50)	SELECT	@kLaborIn			= 'WIP LABOR IN'
DECLARE @kLaborBill				VARCHAR(50)	SELECT	@kLaborBill			= 'WIP LABOR BILL'
DECLARE @kLaborMB				VARCHAR(50)	SELECT	@kLaborMB			= 'WIP LABOR MB'
DECLARE @kLaborWO				VARCHAR(50)	SELECT	@kLaborWO			= 'WIP LABOR WO'
DECLARE @kLaborInWO				VARCHAR(50)	SELECT	@kLaborInWO			= 'WIP LABOR IN/WO' -- difference for grouping

DECLARE @kExpReceiptIn			VARCHAR(50)	SELECT	@kExpReceiptIn		= 'WIP EXPENSE REPORT IN'
DECLARE @kExpReceiptBill		VARCHAR(50)	SELECT	@kExpReceiptBill	= 'WIP EXPENSE REPORT BILL'
DECLARE @kExpReceiptMB			VARCHAR(50)	SELECT	@kExpReceiptMB		= 'WIP EXPENSE REPORT MB'
DECLARE @kExpReceiptWO			VARCHAR(50)	SELECT	@kExpReceiptWO		= 'WIP EXPENSE REPORT WO'
DECLARE @kExpReceiptInWO		VARCHAR(50)	SELECT	@kExpReceiptInWO	= 'WIP EXPENSE REPORT IN/WO' 

DECLARE @kMiscCostIn			VARCHAR(50)	SELECT	@kMiscCostIn		= 'WIP MISC COST IN'
DECLARE @kMiscCostBill			VARCHAR(50)	SELECT	@kMiscCostBill		= 'WIP MISC COST BILL'
DECLARE @kMiscCostMB			VARCHAR(50)	SELECT	@kMiscCostMB		= 'WIP MISC COST MB'
DECLARE @kMiscCostWO			VARCHAR(50)	SELECT	@kMiscCostWO		= 'WIP MISC COST WO'
DECLARE @kMiscCostInWO			VARCHAR(50)	SELECT	@kMiscCostInWO		= 'WIP MISC COST IN/WO'

DECLARE @kVendorInvoiceIn		VARCHAR(50)	SELECT	@kVendorInvoiceIn	= 'WIP VENDOR INVOICE IN'
DECLARE @kVendorInvoiceBill		VARCHAR(50)	SELECT	@kVendorInvoiceBill	= 'WIP VENDOR INVOICE BILL'
DECLARE @kVendorInvoiceMB		VARCHAR(50)	SELECT	@kVendorInvoiceMB	= 'WIP VENDOR INVOICE MB'
DECLARE @kVendorInvoiceWO		VARCHAR(50)	SELECT	@kVendorInvoiceWO	= 'WIP VENDOR INVOICE WO'
DECLARE @kVendorInvoiceInWO		VARCHAR(50)	SELECT	@kVendorInvoiceInWO	= 'WIP VENDOR INVOICE IN/WO'

DECLARE @kVendorInvoiceInER		VARCHAR(50)	SELECT	@kVendorInvoiceInER	= 'WIP ER VENDOR INVOICE IN'
DECLARE @kVendorInvoiceBillER	VARCHAR(50)	SELECT	@kVendorInvoiceBillER = 'WIP ER VENDOR INVOICE BILL'
DECLARE @kVendorInvoiceMBER		VARCHAR(50)	SELECT	@kVendorInvoiceMBER	= 'WIP ER VENDOR INVOICE MB'
DECLARE @kVendorInvoiceWOER		VARCHAR(50)	SELECT	@kVendorInvoiceWOER	= 'WIP ER VENDOR INVOICE WO'
DECLARE @kVendorInvoiceInWOER	VARCHAR(50)	SELECT	@kVendorInvoiceInWOER = 'WIP ER VENDOR INVOICE IN/WO'

DECLARE @kMediaInvoiceIn		VARCHAR(50)	SELECT	@kMediaInvoiceIn	= 'WIP MEDIA INVOICE IN'
DECLARE @kMediaInvoiceBill		VARCHAR(50)	SELECT	@kMediaInvoiceBill	= 'WIP MEDIA INVOICE BILL'
DECLARE @kMediaInvoiceMB		VARCHAR(50)	SELECT	@kMediaInvoiceMB	= 'WIP MEDIA INVOICE MB'
DECLARE @kMediaInvoiceWO		VARCHAR(50)	SELECT	@kMediaInvoiceWO	= 'WIP MEDIA INVOICE WO'
DECLARE @kMediaInvoiceInWO		VARCHAR(50)	SELECT	@kMediaInvoiceInWO	= 'WIP MEDIA INVOICE IN/WO'

DECLARE @kSectionWIP			int			SELECT	@kSectionWIP = 6
DECLARE @kSectionICT			int			SELECT	@kSectionICT = 8

DECLARE @kErrNoWIP				int			SELECT @kErrNoWIP = -1
DECLARE @kErrClosingDate		int			SELECT @kErrClosingDate = -2
DECLARE @kErrWIPAccounts		int			SELECT @kErrWIPAccounts = -3
DECLARE @kErrExpenseAccounts	int			SELECT @kErrExpenseAccounts = -4
DECLARE @kErrSalesAccounts		int			SELECT @kErrSalesAccounts = -5
DECLARE @kErrICTAccounts		int			SELECT @kErrICTAccounts = -6
DECLARE @kErrUnexpected			int			SELECT @kErrUnexpected = @kErrUnexpected

-- Reduce data set and also use IX_tTime_9
Update tTime 
Set    tTime.DateBilled = NULL
From   tProject p (nolock)
Where  p.CompanyKey = @CompanyKey
and    p.ProjectKey = tTime.ProjectKey
and    tTime.InvoiceLineKey is null 
and    tTime.WriteOff = 0 
and    tTime.DateBilled is not null

Update tMiscCost
Set DateBilled = NULL
Where InvoiceLineKey is null and WriteOff = 0 and DateBilled is not null

Update tExpenseReceipt
Set DateBilled = NULL
Where InvoiceLineKey is null and WriteOff = 0 and DateBilled is not null

Update tVoucherDetail
Set    tVoucherDetail.DateBilled = NULL
From   tVoucher v (nolock)
Where  v.CompanyKey = @CompanyKey
and    v.VoucherKey = tVoucherDetail.VoucherKey
and    tVoucherDetail.InvoiceLineKey is null 
and    tVoucherDetail.WriteOff = 0 
and    tVoucherDetail.DateBilled is not null

-- Get the Preference Settings
Select
	@GLClosedDate = GLClosedDate,
	
	-- Labor accounts
	@WIPLaborAssetAccountKey = ISNULL(WIPLaborAssetAccountKey, 0),
	@WIPLaborIncomeAccountKey = ISNULL(WIPLaborIncomeAccountKey, 0),
	@WIPLaborWOAccountKey = ISNULL(WIPLaborWOAccountKey, 0),
	
	-- Misc Costs and ERs accounts
	@WIPExpenseAssetAccountKey = ISNULL(WIPExpenseAssetAccountKey, 0),
	@WIPExpenseIncomeAccountKey = ISNULL(WIPExpenseIncomeAccountKey, 0),
	@WIPExpenseWOAccountKey = ISNULL(WIPExpenseWOAccountKey, 0),
	
	@WIPBookVoucherToRevenue = ISNULL(WIPBookVoucherToRevenue, 0),
	@WIPExpensesAtGross = ISNULL(WIPExpensesAtGross,0),
	@WIPMiscCostAtGross = ISNULL(WIPMiscCostAtGross,0),

	-- Media Voucher accounts
	@WIPMediaAssetAccountKey = ISNULL(WIPMediaAssetAccountKey, 0),
	@WIPMediaIncomeAccountKey = ISNULL(WIPMediaIncomeAccountKey, 0),
	@WIPMediaWOAccountKey = ISNULL(WIPMediaWOAccountKey, 0),
	
	-- Production Voucher accounts
	@WIPVoucherAssetAccountKey = ISNULL(WIPVoucherAssetAccountKey, 0),
	@WIPVoucherIncomeAccountKey = ISNULL(WIPVoucherIncomeAccountKey, 0),
	@WIPVoucherWOAccountKey = ISNULL(WIPVoucherWOAccountKey, 0),
	
	-- Flags
	@PostToGL = ISNULL(PostToGL, 0),
	@WIPClassFromDetail = ISNULL(WIPClassFromDetail, 0),
	@IOClientLink = ISNULL(IOClientLink, 1),
	@BCClientLink = ISNULL(BCClientLink, 1),
	@UseGLCompany = ISNULL(UseGLCompany, 0),
	@UseMultiCompanyGLCloseDate = ISNULL(MultiCompanyClosingDate, 0),
	@MultiCurrency = ISNULL(MultiCurrency, 0),
	@WIPHoldTransactionNotPosted = ISNULL(WIPHoldTransactionNotPosted, 0),
	@DefaultDepartmentFromUser = isnull(DefaultDepartmentFromUser, 0)  
from tPreference  (nolock)
Where CompanyKey = @CompanyKey

if @UseMultiCompanyGLCloseDate = 1 And ISNULL(@HeaderGLCompanyKey, 0) > 0
	BEGIN
		Select 
			@GLClosedDate = GLCloseDate
		From 
			tGLCompany (nolock)
		Where
			GLCompanyKey = @HeaderGLCompanyKey			
	END

if @OpeningTransaction = 1
	select @PostToGL = 0
	
if @PostToGL = 1
begin
	-- Verify that posting WIP to GL is an option
	If Not Exists(Select 1 from tPreference (nolock) Where CompanyKey = @CompanyKey and TrackWIP = 1)
		Return @kErrNoWIP 
	
if @PrePost = 0
begin		
	if @GLClosedDate is not null
		If @GLClosedDate > @PostingDate
			Return @kErrClosingDate 
end

	if @WIPLaborAssetAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPLaborAssetAccountKey) 
		return @kErrWIPAccounts 

	if @WIPLaborIncomeAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPLaborIncomeAccountKey) 
		return @kErrWIPAccounts 

	if @WIPExpenseAssetAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPExpenseAssetAccountKey) 
		return @kErrWIPAccounts 

	if @WIPExpenseIncomeAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPExpenseIncomeAccountKey) 
		return @kErrWIPAccounts 

	if @WIPLaborWOAccountKey = 0
		return @kErrWIPAccounts 		
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPLaborWOAccountKey) 
		return @kErrWIPAccounts 

	if @WIPExpenseWOAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPExpenseWOAccountKey) 
		return @kErrWIPAccounts 

	if @WIPMediaAssetAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPMediaAssetAccountKey) 
		return @kErrWIPAccounts 

	if @WIPBookVoucherToRevenue = 1 and 
	not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPMediaIncomeAccountKey) 
		return @kErrWIPAccounts 

	if @WIPMediaWOAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPMediaWOAccountKey) 
		return @kErrWIPAccounts 

	if @WIPVoucherAssetAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPVoucherAssetAccountKey) 
		return @kErrWIPAccounts 

	if @WIPBookVoucherToRevenue = 1 and 
	not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPVoucherIncomeAccountKey) 
		return @kErrWIPAccounts 

	if @WIPVoucherWOAccountKey = 0
		return @kErrWIPAccounts 
    if not exists (select 1 from tGLAccount (nolock) where GLAccountKey = @WIPVoucherWOAccountKey) 
		return @kErrWIPAccounts 

end

-- For actual transactions
CREATE TABLE #tWIP (
	Entity varchar(100) null,
	EntityKey int null,
	UIDEntityKey uniqueidentifier null,
	NetAmount money null,
	
	RetainerKey int null,	 -- to handle the items for retainers
	ItemKey int null,		 -- to handle the items for retainers
	
	PostInWriteOff int null, -- when writing off in one shot, we will both set WIPPostingInKey and WIPPostingOutKey 
	
	ItemType int null,       -- to determine billable status for vouchers
	NonBillable int null,    -- to determine billable status for vouchers
		
	GLAccountKey int null,  -- Debit account, to tie with #tGL for vouchers
	ClassKey int null,		-- to tie with #tGL
	ClientKey int null,		-- to tie with #tGL
	ProjectKey int null,	-- to tie with #tGL 
	GLCompanyKey int null,	-- to tie with #tGL  -- for Asset accounts
	OfficeKey int null,		-- to tie with #tGL  -- for Asset accounts
	DepartmentKey int null,	-- to tie with #tGL

	Reference varchar(100) null, -- to tie with #tGL
	
	IncomeGLCompanyKey int null, -- added 7/5/12 for ICT Due To/Due From logic -- for Income/WO accounts
	IncomeOfficeKey int null, -- added 7/5/12 for ICT Due To/Due From logic    -- for Income/WO accounts  
	IncomeClassKey int null, -- added 7/5/12 for ICT Due To/Due From logic    -- for Income/WO accounts  
	
	PurchaseOrderDetailKey int null, -- to determine the proper GL account for vouchers 
	PODAmountBilled money null	-- to determine the proper GL account for vouchers
	)

-- tTime entries are numerous, create index to speed up loops
CREATE  INDEX temp_tWIP_ind ON #tWIP(Reference, GLAccountKey, ClientKey, GLCompanyKey, ClassKey, OfficeKey, DepartmentKey, ProjectKey)

-- For GL transactions
-- these tables are created in spRptGLPrePostWIP if @PrePost = 1
IF @PrePost = 0
BEGIN
	CREATE TABLE #tGL (
		RowNum int NOT NULL IDENTITY(1,1),
		GLAccountKey int null,  
		Debit money null,
		Credit money null,
		ClassKey int null,
		ClientKey int null,
		ProjectKey int null,
		GLCompanyKey int null,	
		OfficeKey int null,		
		DepartmentKey int null,
		Reference varchar(100) null, 
		IncludeGLAccount smallint null,
		ItemType smallint null,
		Overhead tinyint null,
		IncomeType int null
		)

	CREATE CLUSTERED INDEX temp_tGL_ind ON #tGL(RowNum)

	-- To associate GL Transactions with entities
	CREATE TABLE #tWIPPostingDetail(
		WIPPostingKey int null, 
		Entity varchar(100) null,
		EntityKey int null,
		UIDEntityKey uniqueidentifier null,
		TransactionKey int null,
		Amount money null
		)

	-- For ICT Inter Company Transactions
	CREATE TABLE #tICT (
		GLCompanyKey int null
		,ICTGLCompanyKey int null 
		,InOrOut varchar(5) null -- IN / OUT
		,DueToOrDueFrom varchar(5) null -- DT / DF
		,GLAccountKey int null
		,Debit money null
		,Credit money null
	)

END

/**************************************
 *  STEP 1: CAPTURE ACTUAL TRANSACTIONS
 *************************************/

/*
WPIK = WIPPostingInKey
WPOK = WIPPostingOutKey

WPIK	|	WPOK
------------------
0		|	0
0		|	>0		==> This is the anomaly that we will try to correct by creating a Post In
>0		|	0
>0		|	>0					

Note: the anomaly could happen when we unpost a prior batch 

we do 6 passes

1) WPIK=0
DateBilled null or > AsOfDate 
GL Accounts= Asset/Income	
UPDATE WPIK

2) WPIK=0
WO=1	
DateBilled null <= AsOfDate 
GL Accounts= WO/Income	
UPDATE WPIK AND WPOK !!!!!!!!!!!!!!!!

3) Patch to correct anomaly
WPIK=0
WPOK>1
GL Accounts= Asset/Income	
UPDATE WPIK

4) WPIK>0
WPOK=0
WO=0
DateBilled <=AsOfDate
GL Accounts= Income/Asset	
UPDATE WPOK

May consider 2 cases: Billed / Mark As Billed

5) WPIK>0
WPOK=0
WO=1
DateBilled <=AsOfDate
GL Accounts= WO/Asset	
UPDATE WPOK

*/

-- First Type = Labor

create table #tTime (
	ProjectKey int null
	, RetainerKey int null
	, TimeKey uniqueidentifier
	, WIPPostingInKey int null    -- initial query index IX_tTime_24
	, WIPPostingOutKey int null   -- initial query index IX_tTime_24
	, InvoiceLineKey int null     -- initial query index IX_tTime_24
	, DateBilled smalldatetime null   -- initial query index IX_tTime_24
	
	, ServiceKey int null             -- later query index PK_tTime, then IX_tTime_9
	, ActualHours decimal(24, 4) null -- later query index PK_tTime, then IX_tTime_9
	, ActualRate money null           -- later query index PK_tTime, then IX_tTime_9
	, WriteOff int null               -- later query index PK_tTime, then IX_tTime_9

	, WorkDate smalldatetime null         -- later query index PK_tTime, then let SQL decides
	, TransferInDate smalldatetime null   -- later query index PK_tTime, then let SQL decides
	, WIPAmount money null                -- later query index PK_tTime, then let SQL decides
	
	, TimeSheetStatus int null  -- index PK_tTime, then IX_tTime_13   
	, InvoiceStatus int null
	
	, UserKey int null -- added 3/30/12 for ICT/GLCompanySource
	, ExchangeRate decimal(24,7) -- added 8/16/13 for Multi Currency
	, OnHold int null
    , UpdateFlag int null
	, DepartmentKey int null -- added 9/10/15 for Abelson because the Department is on tTime now
	)

-- insert first the time entries that never went IN WIP
insert #tTime (ProjectKey, RetainerKey, TimeKey, WIPPostingInKey, WIPPostingOutKey, InvoiceLineKey, DateBilled, UpdateFlag, ExchangeRate)
select t.ProjectKey, isnull(p.RetainerKey, 0), t.TimeKey, t.WIPPostingInKey, t.WIPPostingOutKey, t.InvoiceLineKey, t.DateBilled, 0, 1
from tTime t with (index=IX_tTime_24, nolock) 
	inner join tProject p  (nolock) on t.ProjectKey = p.ProjectKey
where p.CompanyKey = @CompanyKey
and   p.NonBillable = 0
and   t.WIPPostingInKey = 0
AND	 (t.DateBilled IS NULL OR t.DateBilled > @ThroughDate)    -- important to reduce # of records upfront (93562)
       
-- insert the time entries written off for in out reversal
-- capture writeoffs during time window (97467)
insert #tTime (ProjectKey, RetainerKey, TimeKey, WIPPostingInKey, WIPPostingOutKey, InvoiceLineKey, DateBilled, UpdateFlag, ExchangeRate)
select t.ProjectKey, isnull(p.RetainerKey, 0), t.TimeKey, t.WIPPostingInKey, t.WIPPostingOutKey, t.InvoiceLineKey, t.DateBilled, 0, 1
from tTime t with (index=IX_tTime_24, nolock) 
	inner join tProject p  (nolock) on t.ProjectKey = p.ProjectKey
where p.CompanyKey = @CompanyKey
and   p.NonBillable = 0
and   t.WIPPostingInKey = 0
and   t.WriteOff = 1
AND	 (t.DateBilled <= @ThroughDate)

--  now take everything that when IN WIP but not OUT      
insert #tTime (ProjectKey, RetainerKey, TimeKey, WIPPostingInKey, WIPPostingOutKey, InvoiceLineKey, DateBilled, UpdateFlag, ExchangeRate)
select t.ProjectKey, 0, t.TimeKey, t.WIPPostingInKey, t.WIPPostingOutKey, t.InvoiceLineKey, t.DateBilled, 0, 1
from tTime t with (index=IX_tTime_24, nolock) 
	inner join tProject p  (nolock) on t.ProjectKey = p.ProjectKey
where p.CompanyKey = @CompanyKey
and   t.WIPPostingInKey <> 0
and   t.WIPPostingOutKey = 0


-- update work date/tranfer date and WIPAmount....there is no index for that
update #tTime
set    #tTime.WorkDate = t.WorkDate
      ,#tTime.TransferInDate = t.TransferInDate
      ,#tTime.WIPAmount = t.WIPAmount
from   tTime t with (index=PK_tTime, nolock)
where  #tTime.TimeKey = t.TimeKey

-- check time sheet status
-- index PK_tTime, then IX_tTime_13
update #tTime
set    #tTime.TimeSheetStatus = ts.Status 
       ,#tTime.UserKey = ts.UserKey -- for ICT
from   tTime t with (index=PK_tTime, nolock)
      ,tTimeSheet ts (nolock)
where  #tTime.TimeKey = t.TimeKey
and    t.TimeSheetKey = ts.TimeSheetKey

-- check invoice status
update #tTime
set    #tTime.InvoiceStatus = i.InvoiceStatus
from   tInvoiceLine il (nolock)
      ,tInvoice i (nolock)
where  #tTime.InvoiceLineKey = il.InvoiceLineKey
and    il.InvoiceKey = i.InvoiceKey

-- pull other data needed
-- index PK_tTime, then IX_tTime_9
update #tTime
set    #tTime.WriteOff = t.WriteOff
      ,#tTime.ActualHours = t.ActualHours
      ,#tTime.ActualRate = t.ActualRate
      ,#tTime.ServiceKey = t.ServiceKey
	  ,#tTime.DepartmentKey = t.DepartmentKey
from   tTime t with (index=PK_tTime, nolock)
where  #tTime.TimeKey = t.TimeKey

-- we could not seed t.DepartmentKey (takes too long) so fill it now if null
if @DefaultDepartmentFromUser = 1
	update #tTime
	set    #tTime.DepartmentKey = u.DepartmentKey
	from   tUser u (nolock)
	where  #tTime.UserKey = u.UserKey
	and    #tTime.DepartmentKey is null
else
	update #tTime
	set    #tTime.DepartmentKey = s.DepartmentKey
	from   tService s (nolock)
	where  #tTime.ServiceKey = s.ServiceKey
	and    #tTime.DepartmentKey is null


-- now that we have a service key, we can remove services covered by retainer
DELETE #tTime FROM tRetainerItems ri (NOLOCK) 
WHERE  #tTime.RetainerKey > 0
AND    #tTime.RetainerKey = ri.RetainerKey 
AND    ri.EntityKey = #tTime.ServiceKey 
AND    ri.Entity = 'tService'
AND    ISNULL(#tTime.WIPPostingInKey, 0) = 0 -- added 7/16/12 only remove in never in WIP
AND    ISNULL(#tTime.WIPPostingOutKey, 0) = 0-- added 7/16/12 only remove in never in WIP

-- Also take in account DoNotPostWIP 
DELETE #tTime 
FROM    tProject p (NOLOCK) 
WHERE  #tTime.ProjectKey = p.ProjectKey 
AND    isnull(p.DoNotPostWIP, 0) = 1
AND    ISNULL(#tTime.WIPPostingInKey, 0) = 0 -- only remove in never in WIP
AND    ISNULL(#tTime.WIPPostingOutKey, 0) = 0-- only remove in never in WIP


if @MultiCurrency = 1
begin
	update #tTime
	set    #tTime.ExchangeRate = isnull(t.ExchangeRate, 1)
	from   tTime t (nolock)
	where  #tTime.TimeKey = t.TimeKey
	and    #tTime.WIPPostingInKey = 0
end

if @WIPHoldTransactionNotPosted = 1
begin
	update #tTime
	set    #tTime.OnHold = 1
	from   tTime t (nolock)
	where  #tTime.TimeKey = t.TimeKey
	and    #tTime.WIPPostingInKey = 0
	and    #tTime.WIPPostingOutKey = 0 
	and    t.OnHold = 1	-- only if on hold
end

-- Labor In
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
--SELECT		'tTime', 0, t.TimeKey, ROUND(t.ActualHours * t.ActualRate * t.ExchangeRate, 2), p.RetainerKey, t.ServiceKey, 0
SELECT		'tTime', 0, t.TimeKey, ROUND(ROUND(t.ActualHours * t.ActualRate,2) * t.ExchangeRate, 2), p.RetainerKey, t.ServiceKey, 0
			, @WIPLaborAssetAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end
			,isnull(t.DepartmentKey, 0)
			, t.ProjectKey, @kLaborIn 
FROM		#tTime t (NOLOCK)
INNER JOIN tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN tUser u (nolock) ON t.UserKey = u.UserKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey 
WHERE		t.TimeSheetStatus = 4
AND         isnull(t.TransferInDate, t.WorkDate) <= @ThroughDate
AND  		ISNULL(t.WIPPostingInKey, 0) = 0
AND			(t.DateBilled IS NULL OR t.DateBilled > @ThroughDate)

/* Initial Query
-- Labor In
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, ROUND(ActualHours * ActualRate, 2), p.RetainerKey, t.ServiceKey, 0
			, @WIPLaborAssetAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0)
			, t.ProjectKey, @kLaborIn 
FROM		tTime t (NOLOCK)
INNER JOIN	tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		ts.CompanyKey = @CompanyKey
AND			ts.Status = 4
AND			p.NonBillable = 0
AND			isnull(t.TransferInDate, t.WorkDate) <= @ThroughDate
AND  		ISNULL(t.WIPPostingInKey, 0) = 0
AND			p.CompanyKey = @CompanyKey -- Use indexes better
-- Has not been billed at the time 
AND			(t.DateBilled IS NULL OR t.DateBilled > @ThroughDate)
*/

-- Labor In + WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, ROUND(ROUND(t.ActualHours * t.ActualRate, 2) * t.ExchangeRate, 2), p.RetainerKey, t.ServiceKey, 1
			, @WIPLaborWOAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end 
			,isnull(t.DepartmentKey, 0)
			, t.ProjectKey, @kLaborInWO 
FROM		#tTime t (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN  tUser u (nolock) on t.UserKey = u.UserKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		t.TimeSheetStatus = 4
AND			t.DateBilled <= @ThroughDate
AND  		t.WIPPostingInKey = 0
AND			t.WriteOff = 1

/* Initial Query
-- Labor In + WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, ROUND(t.ActualHours * t.ActualRate, 2), p.RetainerKey, t.ServiceKey, 1
			, @WIPLaborWOAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0) 
			, t.ProjectKey, @kLaborInWO 
FROM		tTime t (NOLOCK)
INNER JOIN	tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		ts.CompanyKey = @CompanyKey
AND			ts.Status = 4
AND			p.NonBillable = 0
AND			t.DateBilled <= @ThroughDate
AND  		t.WIPPostingInKey = 0
AND			t.WriteOff = 1
AND			p.CompanyKey = @CompanyKey -- Use indexes better
*/

/* Already done
-- delete if covered by a retainer
DELETE #tWIP FROM tRetainerItems ri (NOLOCK) WHERE  #tWIP.Entity = 'tTime' AND ISNULL(#tWIP.RetainerKey, 0) > 0
AND    #tWIP.RetainerKey = ri.RetainerKey AND ri.EntityKey = #tWIP.ItemKey AND ri.Entity = 'tService'
*/

/* Removed because that was the time when we could delete ANY WIP batch (not the last one)
-- Patch for anomalies regardless of all conditions
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, ROUND(ActualHours * ActualRate, 2), 0
			, @WIPLaborAssetAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0) 
			, ISNULL(t.ProjectKey, 0), @kLaborIn 
FROM		tTime t (NOLOCK)
INNER JOIN	tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
LEFT OUTER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		t.WIPPostingInKey = 0
AND			t.WIPPostingOutKey > 0
AND			ts.CompanyKey = @CompanyKey 
AND         t.TimeKey NOT IN (SELECT UIDEntityKey FROM #tWIP)
*/

-- Labor Bill
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, t.WIPAmount, 0
			, @WIPLaborIncomeAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end 
			, isnull(t.DepartmentKey, 0)
			, t.ProjectKey, @kLaborBill 
FROM		#tTime t (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN  tUser u (NOLOCK) ON t.UserKey = u.UserKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		t.TimeSheetStatus = 4
AND			t.InvoiceStatus = 4
AND			t.DateBilled <= @ThroughDate
AND  		t.WIPPostingInKey <> 0		-- Post Out Only if Posted In
AND  		t.WIPPostingOutKey = 0
AND			t.WriteOff = 0


/* Initial Query
-- Labor Bill
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, t.WIPAmount, 0
			, @WIPLaborIncomeAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0) 
			, t.ProjectKey, @kLaborBill 
FROM		tTime t (NOLOCK)
INNER JOIN	tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN  tInvoiceLine il (NOLOCK) ON t.InvoiceLineKey = il.InvoiceLineKey
INNER JOIN  tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		ts.CompanyKey = @CompanyKey
AND			ts.Status = 4
AND			i.InvoiceStatus = 4
--AND			p.NonBillable = 0
AND			t.DateBilled <= @ThroughDate
AND  		t.WIPPostingInKey <> 0		-- Post Out Only if Posted In
AND  		t.WIPPostingOutKey = 0
AND			t.WriteOff = 0
AND			p.CompanyKey = @CompanyKey -- Use indexes better
*/

-- Labor MB (only difference is that we do not check client invoices)
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, t.WIPAmount, 0
			, @WIPLaborIncomeAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end 
			,isnull(t.DepartmentKey, 0)
			, t.ProjectKey, @kLaborMB 
FROM		#tTime t (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN  tUser u (NOLOCK) ON t.UserKey = u.UserKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		t.TimeSheetStatus = 4
AND			t.DateBilled <= @ThroughDate
AND			t.InvoiceLineKey = 0
AND  		t.WIPPostingInKey <> 0		-- Post Out Only if Posted In
AND  		t.WIPPostingOutKey = 0
AND			t.WriteOff = 0

/* Initial Query
-- Labor MB (only difference is that we do not check client invoices)
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, t.WIPAmount, 0
			, @WIPLaborIncomeAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0) 
			, t.ProjectKey, @kLaborMB 
FROM		tTime t (NOLOCK)
INNER JOIN	tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		ts.CompanyKey = @CompanyKey
AND			ts.Status = 4
--AND			p.NonBillable = 0
AND			t.DateBilled <= @ThroughDate
AND			t.InvoiceLineKey = 0
AND  		t.WIPPostingInKey <> 0		-- Post Out Only if Posted In
AND  		t.WIPPostingOutKey = 0
AND			t.WriteOff = 0
AND			p.CompanyKey = @CompanyKey -- Use indexes better
*/

-- Labor WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, t.WIPAmount, 0
			, @WIPLaborWOAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0)
			--, case when @DefaultDepartmentFromUser = 0 then ISNULL(s.DepartmentKey, 0) else ISNULL(u.DepartmentKey, 0) end  
			,isnull(t.DepartmentKey, 0)
			, t.ProjectKey, @kLaborWO 
FROM		#tTime t (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
INNER JOIN  tUser u (NOLOCK) ON t.UserKey = u.UserKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		t.TimeSheetStatus = 4
AND			t.DateBilled <= @ThroughDate
AND  		t.WIPPostingInKey <> 0		-- Post Out Only if Posted In
AND  		t.WIPPostingOutKey = 0
AND			t.WriteOff = 1

/* Initial Query
-- Labor WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tTime', 0, t.TimeKey, t.WIPAmount, 0
			, @WIPLaborWOAccountKey, ISNULL(s.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(s.DepartmentKey, 0) 
			, t.ProjectKey, @kLaborWO 
FROM		tTime t (NOLOCK)
INNER JOIN	tTimeSheet ts (NOLOCK) ON t.TimeSheetKey = ts.TimeSheetKey
INNER JOIN	tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tService s (NOLOCK) ON t.ServiceKey = s.ServiceKey
WHERE		ts.CompanyKey = @CompanyKey
AND			ts.Status = 4
--AND			p.NonBillable = 0
AND			t.DateBilled <= @ThroughDate
AND  		t.WIPPostingInKey <> 0		-- Post Out Only if Posted In
AND  		t.WIPPostingOutKey = 0
AND			t.WriteOff = 1
AND			p.CompanyKey = @CompanyKey -- Use indexes better
*/

-- Second Type = Misc Costs

-- Misc Cost In, get the class now
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tMiscCost', mc.MiscCostKey, NULL
			, case when @WIPMiscCostAtGross = 0 
				then ROUND(mc.TotalCost * mc.ExchangeRate, 2) 
				else ROUND(mc.BillableCost * mc.ExchangeRate, 2) 
			end 
			, p.RetainerKey, mc.ItemKey, 0
			, @WIPExpenseAssetAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(mc.DepartmentKey, 0) 
			, mc.ProjectKey, @kMiscCostIn 
FROM		tMiscCost mc (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
WHERE		p.CompanyKey = @CompanyKey
AND			p.NonBillable = 0
AND			isnull(mc.TransferInDate, mc.ExpenseDate) <= @ThroughDate
AND 		mc.WIPPostingInKey = 0
-- Has not been billed at the time 
AND			(mc.DateBilled IS NULL OR mc.DateBilled > @ThroughDate)

-- MiscCost In + WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tMiscCost', mc.MiscCostKey, NULL
			, case when @WIPMiscCostAtGross = 0 
				then ROUND(mc.TotalCost * mc.ExchangeRate, 2) 
				else ROUND(mc.BillableCost * mc.ExchangeRate, 2) 
			end 
			, p.RetainerKey, mc.ItemKey, 1
			, @WIPExpenseWOAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(mc.DepartmentKey, 0) 
			, mc.ProjectKey, @kMiscCostInWO 
FROM		tMiscCost mc (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
WHERE		p.CompanyKey = @CompanyKey
AND			p.NonBillable = 0
AND			mc.DateBilled <= @ThroughDate
AND  		mc.WIPPostingInKey = 0
AND			mc.WriteOff = 1			

-- delete if covered by a retainer
DELETE #tWIP FROM tRetainerItems ri (NOLOCK) WHERE  #tWIP.Entity = 'tMiscCost' AND ISNULL(#tWIP.RetainerKey, 0) > 0
AND    #tWIP.RetainerKey = ri.RetainerKey AND ri.EntityKey = #tWIP.ItemKey AND ri.Entity = 'tItem'

-- Also take in account DoNotPostWIP (These are the items that go IN WIP, i.e. not OUT of WIP)
DELETE #tWIP 
FROM    tProject p (NOLOCK) 
WHERE  #tWIP.ProjectKey = p.ProjectKey 
AND    isnull(p.DoNotPostWIP, 0) = 1
AND    #tWIP.Entity = 'tMiscCost'


-- Patch for anomalies regardless of all conditions
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tMiscCost', mc.MiscCostKey, NULL
			, case when @WIPMiscCostAtGross = 0 
				then ROUND(mc.TotalCost * mc.ExchangeRate, 2) 
				else ROUND(mc.BillableCost * mc.ExchangeRate, 2) 
			end 
			, 0, @WIPExpenseAssetAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(mc.DepartmentKey, 0) 
			, mc.ProjectKey, @kMiscCostIn 
FROM		tMiscCost mc (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
WHERE		p.CompanyKey = @CompanyKey
AND 		mc.WIPPostingInKey = 0
AND 		mc.WIPPostingOutKey > 0
AND         mc.MiscCostKey NOT IN (SELECT EntityKey FROM #tWIP WHERE Entity = 'tMiscCost' )

-- MiscCost to Bill
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff,
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tMiscCost', mc.MiscCostKey, NULL, mc.WIPAmount, 0
			, @WIPExpenseIncomeAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(mc.DepartmentKey, 0) 
			, mc.ProjectKey, @kMiscCostBill 
FROM		tMiscCost mc (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
INNER JOIN  tInvoiceLine il (NOLOCK) ON mc.InvoiceLineKey = il.InvoiceLineKey
INNER JOIN tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
WHERE		p.CompanyKey = @CompanyKey
AND			i.InvoiceStatus = 4
--AND			p.NonBillable = 0
AND			mc.DateBilled <= @ThroughDate
AND  		mc.WIPPostingInKey <> 0
AND  		mc.WIPPostingOutKey = 0
AND			mc.WriteOff = 0			

-- MiscCost MB
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey ,NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tMiscCost', mc.MiscCostKey, NULL ,mc.WIPAmount, 0
			, @WIPExpenseIncomeAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(mc.DepartmentKey, 0) 
			, mc.ProjectKey, @kMiscCostMB 
FROM		tMiscCost mc (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
WHERE		p.CompanyKey = @CompanyKey
--AND			p.NonBillable = 0
AND			mc.DateBilled <= @ThroughDate
AND			mc.InvoiceLineKey = 0
AND  		ISNULL(mc.WIPPostingInKey, 0) <> 0
AND  		ISNULL(mc.WIPPostingOutKey, 0) = 0
AND			mc.WriteOff = 0			

-- MiscCost WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tMiscCost', mc.MiscCostKey, NULL, mc.WIPAmount, 0
			, @WIPExpenseWOAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(mc.DepartmentKey, 0) 
			, mc.ProjectKey, @kMiscCostWO 
FROM		tMiscCost mc (NOLOCK)
INNER JOIN	tProject p (NOLOCK) ON mc.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON mc.ItemKey = it.ItemKey
WHERE		p.CompanyKey = @CompanyKey
--AND			p.NonBillable = 0
AND			mc.DateBilled <= @ThroughDate
AND  		mc.WIPPostingInKey <> 0
AND  		mc.WIPPostingOutKey = 0
AND			mc.WriteOff = 1			

-- Third Type = Exp Receipts


-- Exp Receipts In

/*
tExpenseEnvelope.VoucherKey = EE_VK
tExpenseReceipt.VoucherDetailKey = ER_VDK

EE_VK | ER_VDK
--------------
NULL  |  NULL	Nothing has been done on the expense receipt
>0    |  NULL   Old Method to create VI
>0    |  > 0    New method to create VI  EE_VK is not accurate since you could have diff VI on the lines

in spGLUnPostWIP we set WIK = -1 when unposting WIP this simply means that it was posted at some time 

Under the new rules in 85, they should not go in WIP unless a voucher was created
*/

-- was posted at some point
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL
			, case when @WIPExpensesAtGross = 0 
				then ROUND(er.ActualCost * ee.ExchangeRate, 2) 
				else ROUND(er.BillableCost * er.PExchangeRate, 2) 
			end 
			, 0, @WIPExpenseAssetAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptIn 
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND			ee.Status = 4
AND			p.NonBillable = 0
AND			isnull(er.TransferInDate, er.ExpenseDate) <= @ThroughDate
AND  		ISNULL(er.WIPPostingInKey, 0) = -1 -- Was posted to wip some time, then unposted
-- Has not been billed at the time 
AND			(er.DateBilled IS NULL OR er.DateBilled > @ThroughDate)


-- IN
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL
			, case when @WIPExpensesAtGross = 0 
				then ROUND(er.ActualCost * ee.ExchangeRate, 2) 
				else ROUND(er.BillableCost * er.PExchangeRate, 2) 
			end 
			, 0, @WIPExpenseAssetAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptIn 
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND			ee.Status = 4
AND			p.NonBillable = 0
AND			isnull(er.TransferInDate,er.ExpenseDate) <= @ThroughDate
AND  		ISNULL(er.WIPPostingInKey, 0) = 0 
AND  		ISNULL(er.WIPPostingOutKey, 0) = 0 -- added 3/11/2015 because some went in after being out
-- Has not been billed at the time 
AND			(er.DateBilled IS NULL OR er.DateBilled > @ThroughDate)
-- we have created a VI the old way
AND         ee.VoucherKey > 0
AND         er.VoucherDetailKey IS NULL 
-- they should be all null 
AND         NOT EXISTS (SELECT 1 FROM tExpenseReceipt er2 (NOLOCK) WHERE er2.ExpenseEnvelopeKey
			= ee.ExpenseEnvelopeKey AND er2.VoucherDetailKey > 0)

-- IN +WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL
			, case when @WIPExpensesAtGross = 0 
				then ROUND(er.ActualCost * ee.ExchangeRate, 2) 
				else ROUND(er.BillableCost * er.PExchangeRate, 2) 
			end 
			, 1, @WIPExpenseAssetAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptInWO 
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND			ee.Status = 4
AND			p.NonBillable = 0
AND			er.ExpenseDate <= @ThroughDate
AND  		ISNULL(er.WIPPostingInKey, 0) = 0 
-- WO 
AND			er.DateBilled <= @ThroughDate
AND			er.WriteOff = 1			
-- we have created a VI the old way
AND         ee.VoucherKey > 0
AND         er.VoucherDetailKey IS NULL 
-- they should be all null 
AND         NOT EXISTS (SELECT 1 FROM tExpenseReceipt er2 (NOLOCK) WHERE er2.ExpenseEnvelopeKey
			= ee.ExpenseEnvelopeKey AND er2.VoucherDetailKey > 0)


-- Also take in account DoNotPostWIP (These are the items that go IN WIP, i.e. not OUT of WIP)
DELETE #tWIP 
FROM    tProject p (NOLOCK) 
WHERE  #tWIP.ProjectKey = p.ProjectKey 
AND    isnull(p.DoNotPostWIP, 0) = 1
AND    #tWIP.Entity = 'tExpenseReceipt'

-- Patch for anomalies regardless of all conditions
/*
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL
			, case when @WIPExpensesAtGross = 0 
				then ROUND(er.ActualCost * ee.ExchangeRate, 2) 
				else ROUND(er.BillableCost * er.PExchangeRate, 2) 
			end 
			, 0, @WIPExpenseAssetAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptIn
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND 		er.WIPPostingInKey IN (-1, 0) -- was never in
AND 		er.WIPPostingOutKey > 0		  -- but is out	
AND         er.ExpenseReceiptKey NOT IN (SELECT EntityKey FROM #tWIP WHERE Entity = 'tExpenseReceipt' )
*/

-- Expense Receipts to Bill
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff, GLAccountKey, 
			ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL, er.WIPAmount, p.RetainerKey, er.ItemKey, 0
			, @WIPExpenseIncomeAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptBill 
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
INNER JOIN  tInvoiceLine il (NOLOCK) ON er.InvoiceLineKey = il.InvoiceLineKey
INNER JOIN  tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND			ee.Status = 4
AND			i.InvoiceStatus = 4
--AND			p.NonBillable = 0
AND			er.DateBilled <= @ThroughDate
AND  		er.WIPPostingInKey <> 0
AND  		er.WIPPostingOutKey = 0
AND			er.WriteOff = 0			

-- Expense Receipts MB
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff, GLAccountKey, 
			ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL, er.WIPAmount, p.RetainerKey, er.ItemKey, 0
			, @WIPExpenseIncomeAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptMB 
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND			ee.Status = 4
--AND			p.NonBillable = 0
AND			er.DateBilled <= @ThroughDate
AND			er.InvoiceLineKey = 0
AND  		er.WIPPostingInKey <> 0
AND  		er.WIPPostingOutKey = 0
AND			er.WriteOff = 0			

-- Expense Receipts WO
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, RetainerKey, ItemKey, PostInWriteOff, GLAccountKey, 
			ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference)
SELECT		'tExpenseReceipt', er.ExpenseReceiptKey, NULL, er.WIPAmount, p.RetainerKey, er.ItemKey, 0
			, @WIPExpenseWOAccountKey, ISNULL(it.ClassKey, 0), ISNULL(p.ClientKey, 0)
			, ISNULL(p.GLCompanyKey, 0), ISNULL(p.OfficeKey, 0), ISNULL(it.DepartmentKey, 0)
			, ISNULL(er.ProjectKey, 0), @kExpReceiptWO 
FROM		tExpenseReceipt er (NOLOCK)
INNER JOIN	tExpenseEnvelope ee (NOLOCK) ON er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
INNER JOIN	tProject p (NOLOCK) ON er.ProjectKey = p.ProjectKey
LEFT OUTER JOIN tItem it (NOLOCK) ON er.ItemKey = it.ItemKey 
WHERE		ee.CompanyKey = @CompanyKey
AND			ee.Status = 4
--AND			p.NonBillable = 0
AND			er.DateBilled <= @ThroughDate
AND  		er.WIPPostingInKey <> 0
AND  		er.WIPPostingOutKey = 0
AND			er.WriteOff = 1			

-- No Need to not remove if on retainer.

-- Fourth Type: Voucher
/*
WIK = -1 means old voucher details that were posted directly to WIP accounts
This is a different meaning from ERs
*/

--Vouchers In, take them in with Expense accounts from the line
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey , NetAmount, PostInWriteOff, 
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference, 
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL
			, case when @WIPExpensesAtGross = 0 
				then  
					case when pod.InvoiceLineKey > 0  
						then ROUND(vd.TotalCost * po.ExchangeRate, 2) - isnull(vd.PrebillAmount, 0)
						else ROUND(vd.TotalCost * v.ExchangeRate, 2)
                    end
				else ROUND(vd.BillableCost * vd.PExchangeRate, 2) 
			end 
			,0, p.RetainerKey, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1) 
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			
			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0) 
			
			--, ISNULL(vd.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(vd.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END
			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceIn 
			       WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceInER
			       ELSE @kMediaInvoiceIn END
			,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
LEFT  JOIN	tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
AND         isnull(vd.TransferInDate,v.PostingDate) <= @ThroughDate 
--AND			p.NonBillable = 0
AND  		vd.WIPPostingInKey = 0
AND  		vd.WIPPostingOutKey = 0 -- Only allow new voucher details, do not take old ones
--AND         (vd.ExpenseAccountKey NOT IN (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey,@WIPMediaAssetAccountKey)) -- If the expense acct is a WIP asset, they are already in WIP
-- the POD can be unbilled or marked as billed, but not prebilled
AND			isnull(pod.InvoiceLineKey,0) = 0 -- No PreBill PO ??????? --Removed for 228192, Rolledback for 235228
--AND			(it.ItemType = 0 Or (@IOClientLink = 1 AND it.ItemType = 1) Or (@BCClientLink = 1 AND it.ItemType = 2))  
-- Has not been billed at the time 
AND			(vd.DateBilled IS NULL OR vd.DateBilled > @ThroughDate)
--AND          vd.BillableCost <> 0 -- for 235228 ?

-- Voucher In/WriteOff
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey , NetAmount, PostInWriteOff, 
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL
			, case when @WIPExpensesAtGross = 0 
				then  
					case when pod.InvoiceLineKey > 0  
						then ROUND(vd.TotalCost * po.ExchangeRate, 2) - isnull(vd.PrebillAmount, 0)
						else ROUND(vd.TotalCost * v.ExchangeRate, 2)
                    end
				else ROUND(vd.BillableCost * vd.PExchangeRate, 2) 
			end 
			,1, p.RetainerKey, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1) 
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			
			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0) 
			
			--, ISNULL(vd.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(vd.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END
			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceInWO
				   WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceInWOER 
			ELSE @kMediaInvoiceInWO END
			,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT  JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
LEFT  JOIN	tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
--AND			p.NonBillable = 0
AND  		vd.WIPPostingInKey = 0
AND  		vd.WIPPostingOutKey = 0 -- so that we do not pick up old vouchers who never got in
--AND         (vd.ExpenseAccountKey NOT IN (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey,@WIPMediaAssetAccountKey)) -- If the expense acct is a WIP asset, they are already in WIP
-- the POD can be unbilled or marked as billed, but not prebilled
AND			isnull(pod.InvoiceLineKey,0) = 0 -- No PreBill PO ??????? --Removed for 228192, Rolledback for for 235228
--AND			(it.ItemType = 0 Or (@IOClientLink = 1 AND it.ItemType = 1) Or (@BCClientLink = 1 AND it.ItemType = 2))  
AND			vd.DateBilled <= @ThroughDate
AND			vd.WriteOff = 1	
--AND          vd.BillableCost <> 0 -- for 235228 ?

--Link By project and check p.NonBillable = 0
--Link By Media always billable

-- removes lines tied to non billable projects. 
DELETE	#tWIP
WHERE	#tWIP.Entity = 'tVoucherDetail'
AND		(#tWIP.ItemType IN (0,3) Or (@IOClientLink = 1 AND #tWIP.ItemType = 1) Or (@BCClientLink = 1 AND #tWIP.ItemType = 2)) 
AND		#tWIP.NonBillable = 1

-- if tied to a media item, and get client through estimate, then remove if no PO
DELETE #tWIP 
WHERE #tWIP.Entity = 'tVoucherDetail'
AND		((@IOClientLink = 2 AND #tWIP.ItemType = 1) Or (@BCClientLink = 2 AND #tWIP.ItemType = 2))
AND		#tWIP.PurchaseOrderDetailKey is null

-- delete if covered by a retainer
-- only if we link through project
DELETE #tWIP FROM tRetainerItems ri (NOLOCK) 
WHERE  #tWIP.Entity = 'tVoucherDetail' AND ISNULL(#tWIP.RetainerKey, 0) > 0
AND    #tWIP.RetainerKey = ri.RetainerKey AND ri.EntityKey = #tWIP.ItemKey AND ri.Entity = 'tItem'
AND	   (#tWIP.ItemType IN (0,3) Or (@IOClientLink = 1 AND #tWIP.ItemType = 1) Or (@BCClientLink = 1 AND #tWIP.ItemType = 2)) 


-- Also take in account DoNotPostWIP (These are the items that go IN WIP, i.e. not OUT of WIP)
-- same logic as p.NonBillable
DELETE #tWIP 
FROM    tProject p (NOLOCK) 
WHERE  #tWIP.ProjectKey = p.ProjectKey 
AND    isnull(p.DoNotPostWIP, 0) = 1
AND    #tWIP.Entity = 'tVoucherDetail'
AND		(#tWIP.ItemType IN (0,3) Or (@IOClientLink = 1 AND #tWIP.ItemType = 1) Or (@BCClientLink = 1 AND #tWIP.ItemType = 2)) 


-- Patch for anomalies regardless of all conditions

/* with the new restriction on unposting WIP, the situation WIK = 0, WOK > 0 should not happen

INSERT		#tWIP (Entity, EntityKey, UIDEntityKey , NetAmount, PostInWriteOff, 
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL, vd.TotalCost, 0
			,NULL, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), 0 --Billable project always here
			, ISNULL(vd.ExpenseAccountKey, 0), ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			, ISNULL(v.GLCompanyKey, 0), ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0) 
			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceIn 
			    WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceInER
			  ELSE @kMediaInvoiceIn END
			,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT OUTER JOIN tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT OUTER JOIN tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey 
WHERE		v.CompanyKey = @CompanyKey
AND 		vd.WIPPostingInKey = 0
AND 		vd.WIPPostingOutKey > 0
AND         (vd.ExpenseAccountKey NOT IN (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey,@WIPMediaAssetAccountKey)) -- If the expense acct is a WIP asset, they are already in WIP
AND         vd.VoucherDetailKey NOT IN (SELECT EntityKey FROM #tWIP WHERE Entity = 'tVoucherDetail' )
*/

--Vouchers To Bill (Posted to a non WIP Account)	
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL, vd.WIPAmount, 0
			, NULL, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1) 
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			
			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)

			--, ISNULL(vd.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(vd.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END
			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceBill
				   WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceBillER	 
				ELSE @kMediaInvoiceBill 
			 END
			 ,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT  JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
INNER JOIN  tInvoiceLine il (NOLOCK) ON vd.InvoiceLineKey = il.InvoiceLineKey
INNER JOIN  tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
AND			i.InvoiceStatus = 4
--AND			p.NonBillable = 0
AND			vd.DateBilled <= @ThroughDate
AND  		vd.WIPPostingInKey <> 0
AND  		vd.WIPPostingOutKey = 0
AND			vd.WriteOff = 0	
-- We could remove this check below, because if it is in WIP, it has to get out
-- I do not remove it because they might already have entered some JEs
AND			isnull(pod.InvoiceLineKey,0) = 0 -- No PreBill PO --Removed for 228192, Rolledback for for 235228
AND		    vd.ExpenseAccountKey not in (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
--AND          vd.BillableCost <> 0 -- for 235228


--Vouchers To Bill (Posted to a WIP Account)	
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff, 
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL,vd.WIPAmount, 0
			, NULL, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1) 
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			
			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)
			
			--, ISNULL(it.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(it.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END

			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceBill
				WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceBillER 
				ELSE @kMediaInvoiceBill 
			 END
			 ,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT  JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
INNER JOIN  tInvoiceLine il (NOLOCK) ON vd.InvoiceLineKey = il.InvoiceLineKey
INNER JOIN  tInvoice i (NOLOCK) ON il.InvoiceKey = i.InvoiceKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
AND			i.InvoiceStatus = 4
--AND			p.NonBillable = 0
AND			vd.DateBilled <= @ThroughDate
AND  		vd.WIPPostingInKey <> 0
AND  		vd.WIPPostingOutKey = 0
AND			vd.WriteOff = 0	
-- We could remove this check below, because if it is in WIP, it has to get out
-- I do not remove it because they might already have entered some JEs
AND			isnull(pod.InvoiceLineKey,0) = 0 -- No PreBill PO --Removed for 228192, Rolledback for for 235228
AND		    vd.ExpenseAccountKey in (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
--AND          vd.BillableCost <> 0 -- for 235228

--Vouchers MB (Posted to a WIP Account			
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey , NetAmount, PostInWriteOff,
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL, vd.WIPAmount, 0
			, NULL, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1)
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			
			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0) 

			--, ISNULL(vd.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(vd.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END

			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceMB
					WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceMBER 
					ELSE @kMediaInvoiceMB 
			 END
			 ,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT  JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
--AND			p.NonBillable = 0
AND			vd.DateBilled <= @ThroughDate
AND			vd.InvoiceLineKey = 0		
AND  		vd.WIPPostingInKey > 0 -- used to be vd.WIPPostingInKey <> 0, but I am picking 2007 invoices with WIK = -1 at Media Logic issue 255753
AND  		vd.WIPPostingOutKey = 0
AND			vd.WriteOff = 0	
-- We could remove this check below, because if it is in WIP, it has to get out
-- I do not remove it because they might already have entered some JEs
--AND			isnull(pod.InvoiceLineKey,0) = 0 -- No PreBill PO --Removed for 228192, Rolledback for for 235228, Removed again for 240132
AND		    vd.ExpenseAccountKey not in (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
--AND          vd.BillableCost <> 0 -- for 235228

--Vouchers MB ( Posted to a WIP Account)			
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey , NetAmount, PostInWriteOff,
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL, vd.WIPAmount, 0
			, NULL, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1)
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)
			
			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0) 
			
			--, ISNULL(it.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(it.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END

			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceMB
					WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceMBER 
					ELSE @kMediaInvoiceMB 
			 END
			 ,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT  JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
--AND			p.NonBillable = 0
AND			vd.DateBilled <= @ThroughDate
AND			vd.InvoiceLineKey = 0		
AND  		vd.WIPPostingInKey > 0 -- used to be vd.WIPPostingInKey <> 0, but I am picking 2007 invoices with WIK = -1 at Media Logic  issue 255753
AND  		vd.WIPPostingOutKey = 0
AND			vd.WriteOff = 0	
-- We could remove this check below, because if it is in WIP, it has to get out
-- I do not remove it because they might already have entered some JEs
--AND			isnull(pod.InvoiceLineKey,0) = 0 -- No PreBill PO --Removed for 228192, Rolledback for for 235228, Removed again for 240132
AND		    vd.ExpenseAccountKey in (@WIPVoucherAssetAccountKey, @WIPExpenseAssetAccountKey, @WIPMediaAssetAccountKey)
--AND          vd.BillableCost <> 0 -- for 235228

--Vouchers WO (Does not matter if posted directly as WO bypasses the expense account and goes to WO Account
INSERT		#tWIP (Entity, EntityKey, UIDEntityKey, NetAmount, PostInWriteOff,
			RetainerKey, ItemKey, ItemType, ProjectKey, NonBillable, 
			ClassKey, ClientKey, GLCompanyKey, IncomeGLCompanyKey, OfficeKey, DepartmentKey, GLAccountKey, Reference,
			PurchaseOrderDetailKey, PODAmountBilled)
SELECT		'tVoucherDetail', vd.VoucherDetailKey, NULL, vd.WIPAmount, 0
			, NULL, vd.ItemKey, ISNULL(it.ItemType, 0), ISNULL(vd.ProjectKey, 0), ISNULL(p.NonBillable, 1)
			, ISNULL(vd.ClassKey, 0), ISNULL(vd.ClientKey, 0)

			, isnull(v.GLCompanyKey, 0) 
			, case when isnull(vd.TargetGLCompanyKey, 0) = 0 then isnull(v.GLCompanyKey, 0) else vd.TargetGLCompanyKey end
			
			, ISNULL(vd.OfficeKey, 0), ISNULL(vd.DepartmentKey, 0)
			
			--, ISNULL(vd.ExpenseAccountKey, 0) -- changed logic to handle @WIPBookVoucherToRevenue
			,CASE WHEN @WIPBookVoucherToRevenue = 0 THEN ISNULL(vd.ExpenseAccountKey, 0)
			      WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (0,3) THEN @WIPVoucherIncomeAccountKey
				  WHEN @WIPBookVoucherToRevenue = 1 AND ISNULL(it.ItemType, 0) in (1,2) THEN  @WIPMediaIncomeAccountKey
				  END 
			, CASE WHEN ISNULL(it.ItemType, 0) = 0 THEN @kVendorInvoiceWO
				   WHEN ISNULL(it.ItemType, 0) = 3 THEN @kVendorInvoiceWOER	 
				ELSE @kMediaInvoiceWO 
			 END
			,vd.PurchaseOrderDetailKey, isnull(pod.AmountBilled, 0)
FROM		tVoucherDetail vd (NOLOCK)
INNER JOIN	tVoucher v (NOLOCK) ON vd.VoucherKey = v.VoucherKey
LEFT  JOIN	tProject p (NOLOCK) ON vd.ProjectKey = p.ProjectKey
LEFT  JOIN	tItem it (NOLOCK) ON vd.ItemKey = it.ItemKey
LEFT  JOIN	tPurchaseOrderDetail pod (NOLOCK) ON vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
WHERE		v.CompanyKey = @CompanyKey
AND			v.Status = 4
--AND			p.NonBillable = 0
AND			vd.DateBilled <= @ThroughDate
AND  		vd.WIPPostingInKey <> 0
AND  		vd.WIPPostingOutKey = 0
AND			vd.WriteOff = 1	


-- Validate the account keys for vouchers 
IF @PostToGL = 1
BEGIN
/*

	SELECT gl.AccountNumber, a.*
	from #tWIP a
	LEFT JOIN tGLAccount gl (NOLOCK) ON a.GLAccountKey = gl.GLAccountKey
		-- Must be here and not in Where Clause otherwise will be like an inner join  
		AND  gl.CompanyKey = @CompanyKey 
	WHERE a.Reference IN 
	(@kVendorInvoiceIn, @kVendorInvoiceInWO, @kVendorInvoiceBill, @kVendorInvoiceMB 
	,@kMediaInvoiceIn, @kMediaInvoiceInWO, @kMediaInvoiceBill, @kMediaInvoiceMB)
	
*/	
	IF EXISTS (SELECT gl.AccountNumber
				FROM #tWIP a
					LEFT JOIN tGLAccount gl (NOLOCK) ON a.GLAccountKey = gl.GLAccountKey
					-- Must be here and not in Where Clause otherwise will be like an inner join  
					AND  gl.CompanyKey = @CompanyKey 
				WHERE a.Reference IN 
				(@kVendorInvoiceIn, @kVendorInvoiceInWO, @kVendorInvoiceBill, @kVendorInvoiceMB 
				,@kVendorInvoiceInER, @kVendorInvoiceInWOER, @kVendorInvoiceBillER, @kVendorInvoiceMBER 
				,@kMediaInvoiceIn, @kMediaInvoiceInWO, @kMediaInvoiceBill, @kMediaInvoiceMB)
				 
				AND   gl.AccountNumber IS NULL)
				RETURN @kErrExpenseAccounts 

END

-- Now take care of the class
If @WIPClassFromDetail = 1	
Begin
	-- the class comes from the service by default
	-- get the class from employee
	UPDATE #tWIP
	SET    #tWIP.ClassKey = ISNULL(u.ClassKey, 0)
	FROM   tUser u (NOLOCK)
		  ,tTime t (NOLOCK)
	WHERE  #tWIP.Entity = 'tTime'
	AND    #tWIP.UIDEntityKey = t.TimeKey
	AND    t.UserKey = u.UserKey
	AND	   #tWIP.Reference IN (@kLaborIn, @kLaborBill, @kLaborMB, @kLaborWO, @kLaborInWO ) -- just for index
		
	-- the class comes from item by default	
	-- get the class from employee
	UPDATE #tWIP
	SET    #tWIP.ClassKey = ISNULL(u.ClassKey, 0)
	FROM   tUser u (NOLOCK)
		  ,tExpenseReceipt er (NOLOCK)
	WHERE  #tWIP.Entity = 'tExpenseReceipt'
	AND    #tWIP.EntityKey = er.ExpenseReceiptKey
	AND er.UserKey = u.UserKey
	AND	   #tWIP.Reference IN (@kExpReceiptIn, @kExpReceiptBill, @kExpReceiptMB, @kExpReceiptWO, @kExpReceiptInWO ) -- just for index
	
	-- The class by default was obtained from tItem
	-- get the class from tMiscCost now
	UPDATE #tWIP
	SET #tWIP.ClassKey = ISNULL(mc.ClassKey, 0)
	FROM   tMiscCost mc (NOLOCK)
	WHERE  #tWIP.Entity = 'tMiscCost'
	AND    #tWIP.EntityKey = mc.MiscCostKey
	AND	   #tWIP.Reference IN (@kMiscCostIn, @kMiscCostBill, @kMiscCostMB, @kMiscCostWO, @kMiscCostInWO ) -- just for index
		
	-- The class always comes from the voucher line		
End


-- save the SourceGLCompanyKey, because we will recalculate the GL Company Key (i.e. this is the TargetGLCompanyKey)
update #tWIP 
set    IncomeGLCompanyKey = GLCompanyKey
where  Entity <> 'tVoucherDetail' -- Cause it was already set during our queries above

update #tWIP 
set    IncomeOfficeKey = OfficeKey
      ,IncomeClassKey = ClassKey

-- delete records which do not match 
IF @UseGLCompany = 1
	DELETE #tWIP WHERE ISNULL(GLCompanyKey, 0) <> ISNULL(@HeaderGLCompanyKey, 0)

-- Now modify GLCompanyKey and OfficeKey based on GLCompanySource
-- old projects have GLCompanySource = 0 (from project)

-- #tTime should have a project and user, so no need to look at the case when ProjectKey is null
update #tWIP
set    #tWIP.IncomeGLCompanyKey = ISNULL(u.GLCompanyKey, #tWIP.IncomeGLCompanyKey)
      ,#tWIP.IncomeOfficeKey = ISNULL(u.OfficeKey, #tWIP.IncomeOfficeKey)
	  ,#tWIP.IncomeClassKey = ISNULL(u.ClassKey, #tWIP.IncomeClassKey)
from   #tTime t
inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
inner join tUser u (nolock) on t.UserKey = u.UserKey
where  t.TimeKey = #tWIP.UIDEntityKey
and    #tWIP.Entity = 'tTime'
and    isnull(p.GLCompanySource, 0) = 1 -- from user

-- for ERs we should have a project too, so no need to look at the case when ProjectKey is null
update #tWIP
set    #tWIP.IncomeGLCompanyKey = ISNULL(u.GLCompanyKey, #tWIP.IncomeGLCompanyKey)
      ,#tWIP.IncomeOfficeKey = ISNULL(u.OfficeKey, #tWIP.IncomeOfficeKey)
	  ,#tWIP.IncomeClassKey = ISNULL(u.ClassKey, #tWIP.IncomeClassKey)
from   tExpenseReceipt er (nolock)
inner join tExpenseEnvelope ee (nolock) on er.ExpenseEnvelopeKey = ee.ExpenseEnvelopeKey
inner join tProject p (nolock) on er.ProjectKey = p.ProjectKey
inner join tUser u (nolock) on ee.UserKey = u.UserKey
where  er.ExpenseReceiptKey = #tWIP.EntityKey
and    #tWIP.Entity = 'tExpenseReceipt'
and    isnull(p.GLCompanySource, 0) = 1 -- from user

-- Also take in account Transactions On Hold Not Posted Abelson Taylor change
IF @WIPHoldTransactionNotPosted = 1
BEGIN

	DELETE #tWIP 
	FROM   #tTime t (NOLOCK) -- Use temp table rather than tTime to minimize stress on DB 
	WHERE  #tWIP.Entity = 'tTime'
	AND    #tWIP.UIDEntityKey = t.TimeKey
	AND    isnull(t.OnHold, 0) = 1
	AND    ISNULL(t.WIPPostingInKey, 0) = 0 -- only remove in never in WIP
	AND    ISNULL(t.WIPPostingOutKey, 0) = 0-- only remove in never in WIP
	
	DELETE #tWIP 
	FROM    tMiscCost mc (NOLOCK) 
	WHERE  #tWIP.Entity = 'tMiscCost'
	AND    #tWIP.EntityKey = mc.MiscCostKey
	AND    isnull(mc.OnHold, 0) = 1
	AND    ISNULL(mc.WIPPostingInKey, 0) = 0 -- only remove in never in WIP
	AND    ISNULL(mc.WIPPostingOutKey, 0) = 0-- only remove in never in WIP
	
	DELETE #tWIP 
	FROM    tExpenseReceipt er (NOLOCK) 
	WHERE  #tWIP.Entity = 'tExpenseReceipt'
	AND    #tWIP.EntityKey = er.ExpenseReceiptKey
	AND    isnull(er.OnHold, 0) = 1
	AND    ISNULL(er.WIPPostingInKey, 0) = 0 -- only remove in never in WIP
	AND    ISNULL(er.WIPPostingOutKey, 0) = 0-- only remove in never in WIP
	
	DELETE #tWIP 
	FROM    tVoucherDetail vd (NOLOCK) 
	WHERE  #tWIP.Entity = 'tVoucherDetail'
	AND    #tWIP.EntityKey = vd.VoucherDetailKey
	AND    isnull(vd.OnHold, 0) = 1
	AND    ISNULL(vd.WIPPostingInKey, 0) = 0 -- only remove in never in WIP
	AND    ISNULL(vd.WIPPostingOutKey, 0) = 0-- only remove in never in WIP

END








UPDATE #tWIP SET NetAmount = ISNULL(NetAmount, 0)

/**************************************
*  STEP 2: BUILD GL TRANSACTIONS
 *************************************/

IF @PostToGL = 1
BEGIN

-- First Type = Labor

-- Labor In: Debit @WIPLaborAssetAccountKey + Credit @WIPLaborIncomeAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, @WIPLaborAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 0 
FROM  #tWIP
WHERE  Reference = @kLaborIn  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey 

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, SUM(NetAmount), @WIPLaborIncomeAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM  #tWIP
WHERE  Reference = @kLaborIn  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey 

/* could not do because we are using IncomeGLCompanyKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPLaborIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE  Reference = @kLaborIn
*/
-- Labor In + WO: Debit @WIPLaborWOAccountKey + Credit @WIPLaborIncomeAccountKey 
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount,IncomeType)
SELECT SUM(NetAmount), 0, @WIPLaborWOAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tWIP
WHERE  Reference = @kLaborInWO   
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount,IncomeType)
SELECT 0, Debit, @WIPLaborIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tGL
WHERE  Reference = @kLaborInWO

-- Labor Bill/ MB: Debit @WIPLaborIncomeAccountKey + Credit @WIPLaborAssetAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, @WIPLaborIncomeAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tWIP
WHERE  Reference IN ( @kLaborBill, @kLaborMB)  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount,IncomeType)
SELECT 0, SUM(NetAmount), @WIPLaborAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 0 
FROM   #tWIP
WHERE  Reference IN ( @kLaborBill, @kLaborMB)  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

/*
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPLaborAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM  #tGL
WHERE  Reference IN ( @kLaborBill, @kLaborMB)  
*/

-- Labor WO: Debit @WIPLaborWOAccountKey + Credit @WIPLaborAssetAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount,IncomeType)
SELECT SUM(NetAmount), 0, @WIPLaborWOAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0,1 
FROM  #tWIP
WHERE  Reference = @kLaborWO  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount,IncomeType)
SELECT 0, SUM(NetAmount), @WIPLaborAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 0 
FROM  #tWIP
WHERE  Reference = @kLaborWO  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

/*
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPLaborAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE  Reference = @kLaborWO
*/

-- Second Type = Misc Cost >>>>>> NO NEED TO DEAL WITH INCOME GLCOMPANYKEY

-- Misc Cost In: Debit @WIPExpenseAssetAccountKey + Credit @WIPExpenseIncomeAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT SUM(NetAmount), 0, @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tWIP
WHERE  Reference = @kMiscCostIn  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE  Reference = @kMiscCostIn

-- Misc Cost In + To WO: Debit @WIPExpenseWOAccountKey + Credit @WIPExpenseIncomeAccountKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT SUM(NetAmount), 0, @WIPExpenseWOAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tWIP
WHERE  Reference = @kMiscCostInWO  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE Reference = @kMiscCostInWO

-- Misc Cost To Bill: Debit @WIPExpenseIncomeAccountKey + Credit @WIPExpenseAssetAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT SUM(NetAmount), 0, @WIPExpenseIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tWIP
WHERE  Reference IN ( @kMiscCostBill, @kMiscCostMB)  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM #tGL
WHERE  Reference IN ( @kMiscCostBill, @kMiscCostMB)  

-- Misc Cost To WO: Debit @WIPExpenseWOAccountKey + Credit @WIPExpenseAssetAccountKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT SUM(NetAmount), 0, @WIPExpenseWOAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tWIP
WHERE  Reference = @kMiscCostWO  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE  Reference = @kMiscCostWO

-- Third Type = Exp Receipts

-- ER In: Debit @WIPExpenseAssetAccountKey + Credit @WIPExpenseIncomeAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 0 
FROM   #tWIP
WHERE  Reference = @kExpReceiptIn  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, SUM(NetAmount), @WIPExpenseIncomeAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tWIP
WHERE  Reference = @kExpReceiptIn  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

/*
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE  Reference = @kExpReceiptIn
*/
-- ER In + To WO: Debit @WIPExpenseWOAccountKey + Credit @WIPExpenseIncomeAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, @WIPExpenseWOAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tWIP
WHERE  Reference = @kExpReceiptInWO  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, Debit, @WIPExpenseIncomeAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1
FROM   #tGL
WHERE  Reference = @kExpReceiptInWO

-- Exp Receipts To Bill: Debit @WIPExpenseIncomeAccountKey + Credit @WIPExpenseAssetAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, @WIPExpenseIncomeAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tWIP
WHERE  Reference IN ( @kExpReceiptBill, @kExpReceiptMB)  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, SUM(NetAmount), @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 0 
FROM   #tWIP
WHERE  Reference IN ( @kExpReceiptBill, @kExpReceiptMB)  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

/*
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM #tGL
WHERE  Reference IN ( @kExpReceiptBill, @kExpReceiptMB)  
*/
-- Exp Receipts To WO: Debit @WIPExpenseWOAccountKey + Credit @WIPExpenseAssetAccountKey
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, @WIPExpenseWOAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, 1 
FROM   #tWIP
WHERE  Reference IN ( @kExpReceiptWO)  
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, SUM(NetAmount), @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, 0 
FROM   #tWIP
WHERE  Reference IN ( @kExpReceiptWO)  
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey

/*
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount)
SELECT 0, Debit, @WIPExpenseAssetAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0 
FROM   #tGL
WHERE  Reference IN ( @kExpReceiptWO)  
*/

-- Fourth Type: Vouchers

-- Vouchers In
-- Debit WIP Voucher Asset OR WIP Media Asset, Credit Expense Account on the line
-- do Credits first 
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, SUM(NetAmount), GLAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 1, 1
FROM   #tWIP
WHERE  Reference IN ( @kVendorInvoiceIn, @kVendorInvoiceInER, @kMediaInvoiceIn) 
GROUP BY Reference, GLAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

-- then Debits
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, ItemType, IncomeType)
SELECT SUM(NetAmount), 0, 
	Case When ItemType in (1, 2) then @WIPMediaAssetAccountKey
	     When ItemType = 3 then @WIPExpenseAssetAccountKey
	     else @WIPVoucherAssetAccountKey end
	, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, ItemType, 0
FROM #tWIP
WHERE  Reference IN ( @kVendorInvoiceIn, @kVendorInvoiceInER, @kMediaInvoiceIn) 
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, ItemType


-- Vouchers In + WriteOff
-- Debit WIP Expense Write Off OR WIP Media Write Off, Credit Expense Account on the line
-- do Credit first 
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT 0, SUM(NetAmount), GLAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 1, 1
FROM   #tWIP
WHERE  Reference IN ( @kVendorInvoiceInWO, @kVendorInvoiceInWOER, @kMediaInvoiceInWO)
GROUP BY Reference, GLAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

-- then Debit, sum the credits 
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, ItemType, IncomeType)
SELECT SUM(NetAmount), 0, 
	Case When ItemType in (1, 2) then @WIPMediaWOAccountKey
	     When ItemType = 3 then @WIPExpenseWOAccountKey
	   else @WIPVoucherWOAccountKey end
	, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, ItemType, 0
FROM   #tWIP
WHERE  Reference IN ( @kVendorInvoiceInWO, @kVendorInvoiceInWOER, @kMediaInvoiceInWO)
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, ItemType


-- Vouchers to Bill/MB
-- Debit Expense account on the line, credit WIP Expense/Media Asset account
-- Do debits first 
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, IncomeType)
SELECT SUM(NetAmount), 0, GLAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 1, 1 
FROM   #tWIP
WHERE  Reference IN ( @kVendorInvoiceBill, @kVendorInvoiceMB, @kVendorInvoiceBillER, @kVendorInvoiceMBER, @kMediaInvoiceBill, @kMediaInvoiceMB)    
GROUP BY Reference, GLAccountKey, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey

-- then credits
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, ItemType, IncomeType)
SELECT 0, SUM(NetAmount),  
	Case When ItemType in (1, 2) then @WIPMediaAssetAccountKey
	     When ItemType = 3 then @WIPExpenseAssetAccountKey
	     else @WIPVoucherAssetAccountKey end
	, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, ItemType, 0 
FROM   #tWIP
WHERE  Reference IN ( @kVendorInvoiceBill, @kVendorInvoiceMB, @kVendorInvoiceBillER, @kVendorInvoiceMBER, @kMediaInvoiceBill, @kMediaInvoiceMB)    
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, ItemType

-- Vouchers WO
-- Debit Expense/Media Write Off account, credit WIP Expense/Media Asset account
INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, ItemType, IncomeType)
SELECT SUM(NetAmount), 0, 
	Case When ItemType in (1, 2) then @WIPMediaWOAccountKey
	     When ItemType = 3 then @WIPExpenseWOAccountKey
	     else @WIPVoucherWOAccountKey end
, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, Reference, 0, ItemType, 1
FROM   #tWIP
WHERE  Reference IN( @kVendorInvoiceWO, @kVendorInvoiceWOER, @kMediaInvoiceWO) 
GROUP BY Reference, IncomeClassKey, ClientKey, IncomeGLCompanyKey, IncomeOfficeKey, DepartmentKey, ProjectKey, ItemType

INSERT #tGL (Debit, Credit, GLAccountKey, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, IncludeGLAccount, ItemType )
SELECT 0, SUM(NetAmount), 
	Case When ItemType in (1, 2) then @WIPMediaAssetAccountKey
	     When ItemType = 3 then @WIPExpenseAssetAccountKey
	     else @WIPVoucherAssetAccountKey end
, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, Reference, 0, ItemType  
FROM   #tWIP
WHERE  Reference IN( @kVendorInvoiceWO, @kVendorInvoiceWOER, @kMediaInvoiceWO) 
GROUP BY Reference, ClassKey, ClientKey, GLCompanyKey, OfficeKey, DepartmentKey, ProjectKey, ItemType

DELETE #tGL WHERE Debit = 0 AND Credit = 0


--select Sum(Debit ) from #tGL 
--select * from #tGL 

UPDATE #tGL SET Overhead = 0

UPDATE #tGL 
SET    #tGL.Overhead = 1
FROM   tCompany c (NOLOCK)
WHERE  c.OwnerCompanyKey = @CompanyKey
AND    #tGL.ClientKey = c.CompanyKey
AND    ISNULL(c.Overhead, 0) = 1

 If @UseGLCompany = 1
 begin

	-- Do not do InWO because they are going to cancel out

	-- IN WIP
	insert #tICT (GLCompanyKey, ICTGLCompanyKey, InOrOut, DueToOrDueFrom, Debit, Credit)
	select IncomeGLCompanyKey, GLCompanyKey, 'IN', 'DF', SUM(NetAmount), 0
	from   #tWIP
	where  IncomeGLCompanyKey <> GLCompanyKey
	and    Reference in (
					@kLaborIn, @kExpReceiptIn, @kMiscCostIn
					,@kVendorInvoiceIn,@kVendorInvoiceInER
					,@kMediaInvoiceIn
					)
	GROUP BY IncomeGLCompanyKey, GLCompanyKey

	-- Just flip the side
	insert #tICT (GLCompanyKey, ICTGLCompanyKey, InOrOut, DueToOrDueFrom, Debit, Credit)
	select ICTGLCompanyKey, GLCompanyKey, 'IN', 'DT', 0, Debit
	from   #tICT
	where  InOrOut = 'IN'
	and    DueToOrDueFrom = 'DF'

	-- Now OUT OF WIP
	insert #tICT (GLCompanyKey, ICTGLCompanyKey, InOrOut, DueToOrDueFrom, Debit, Credit)
	select IncomeGLCompanyKey, GLCompanyKey, 'OUT', 'DF', 0, SUM(NetAmount)
	from   #tWIP
	where  GLCompanyKey <> IncomeGLCompanyKey
	and    Reference in (
					@kLaborBill, @kLaborMB, @kLaborWO
					,@kExpReceiptBill, @kExpReceiptMB, @kExpReceiptWO
					,@kMiscCostBill, @kMiscCostMB, @kMiscCostWO
					,@kVendorInvoiceBill,@kVendorInvoiceMB, @kVendorInvoiceWO
					,@kVendorInvoiceBillER,@kVendorInvoiceMBER,@kVendorInvoiceWOER
					,@kMediaInvoiceBill, @kMediaInvoiceMB, @kMediaInvoiceWO
					)
	GROUP BY IncomeGLCompanyKey, GLCompanyKey

	-- Just flip the side
	insert #tICT (GLCompanyKey, ICTGLCompanyKey, InOrOut, DueToOrDueFrom, Debit, Credit)
	select ICTGLCompanyKey, GLCompanyKey, 'OUT', 'DT', Credit,  0
	from   #tICT
	where  InOrOut = 'OUT'
	and    DueToOrDueFrom = 'DF'

	-- now delete where GLCompanyKey or ICTGLCompanyKey is blank
	delete #tICT where isnull(GLCompanyKey, 0) = 0 or isnull(ICTGLCompanyKey, 0) = 0
	DELETE #tICT WHERE Debit = 0 AND Credit = 0

	-- Now get the GL accounts

	update #tICT
	set    #tICT.GLAccountKey = glcm.ARDueFromAccountKey
	from   tGLCompanyMap glcm (nolock)
	where  #tICT.GLCompanyKey = glcm.TargetGLCompanyKey 
	and    #tICT.ICTGLCompanyKey = glcm.SourceGLCompanyKey
	--and    #tICT.InOrOut = 'IN'
	and    #tICT.DueToOrDueFrom = 'DF'

	update #tICT
	set    #tICT.GLAccountKey = glcm.ARDueToAccountKey
	from   tGLCompanyMap glcm (nolock)
	where  #tICT.GLCompanyKey = glcm.SourceGLCompanyKey 
	and    #tICT.ICTGLCompanyKey = glcm.TargetGLCompanyKey
	--and    #tICT.InOrOut = 'IN'
	and    #tICT.DueToOrDueFrom = 'DT'

	--select * from #tWIP 
	--select * from #tGL
	--select * from #tICT

	-- TODO: is that going to be enough??
	IF EXISTS (SELECT 1 FROM #tICT where isnull(GLAccountKey, 0) = 0)
	begin
		-- we need to bring back the GL company that is causing the problem
		select @oErrICTGLCompanyKey = GLCompanyKey
		from   #tICT
		where  DueToOrDueFrom = 'DF'
		and    isnull(GLAccountKey, 0) = 0 
			 
		return @kErrICTAccounts  
	end
end -- @UseGLCompany = 1

END -- @PostToGL = 1


/********************************************
 *  STEP 3: START INSERTS IN PERMANENT TABLES
 ********************************************/
--select * from #tWIP 
--select * from #tGL
--select * from #tICT
--return 1

if @PrePost = 0
begin

	begin transaction

	-- Create the posting batch
	INSERT tWIPPosting
		(
		CompanyKey,
		PostingDate,
		SelectThroughDate,
		Comment,
		GLCompanyKey,
		OpeningTransaction
		)
	VALUES
		(
		@CompanyKey,
		@PostingDate,
		@ThroughDate,
		@Comment,
		@HeaderGLCompanyKey,
		@OpeningTransaction
		)

	Select @PostingKey = @@IDENTITY, @Error = @@ERROR
	IF @Error <> 0
	begin
		rollback transaction 
		return @kErrUnexpected
	end
end

-- Create GL transactions
DECLARE @DebitOrCredit CHAR(1), @Amount money, @IncomeType int

SELECT @RowNum = -1
WHILE @PostToGL = 1
BEGIN
	SELECT @RowNum = MIN(RowNum)
	FROM   #tGL WHERE RowNum > @RowNum
	
	IF @RowNum IS NULL
		BREAK
	
	SELECT @Reference = Reference, @GLAccountKey = GLAccountKey
		, @ClassKey = ClassKey, @ClientKey = ClientKey, @ProjectKey = ProjectKey
		, @GLCompanyKey = GLCompanyKey, @OfficeKey = OfficeKey, @DepartmentKey = DepartmentKey
		, @Debit = Debit, @Credit = Credit, @IncludeGLAccount = IncludeGLAccount, @ItemType = ItemType
		, @Overhead = Overhead, @IncomeType = isnull(IncomeType, 0)
	FROM  #tGL WHERE RowNum = @RowNum	
	
	IF @Debit <> 0 
		SELECT @DebitOrCredit = 'D', @Amount = @Debit
	ELSE
		SELECT @DebitOrCredit = 'C', @Amount = @Credit
		 
	if @PrePost = 0
	begin
		exec @TransactionKey = spGLInsertTran @CompanyKey, @DebitOrCredit, @PostingDate, 'WIP', 
			@PostingKey, @Reference, @GLAccountKey, @Amount, @ClassKey,
			@Comment, @ClientKey, @ProjectKey, NULL, NULL, @GLCompanyKey, @OfficeKey, @DepartmentKey, NULL, @kSectionWIP, @Overhead, null, 1, @Amount
		
		if @@ERROR <> 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end	 
	end
	else
	begin
		-- pre posting
		select @TransactionKey = @RowNum
	end
	
	if @IncomeType = 0

	-- join with GLCompanyKey/OfficeKey
	insert #tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
	select @PostingKey, Entity, EntityKey, UIDEntityKey, @TransactionKey, NetAmount
	from   #tWIP b
	where  b.Reference = @Reference
	and    b.ClassKey = @ClassKey
	and    b.ClientKey = @ClientKey
	and    b.OfficeKey = @OfficeKey
	and    b.DepartmentKey = @DepartmentKey
	and    b.GLCompanyKey = @GLCompanyKey
	and    b.ProjectKey = @ProjectKey
	-- For vouchers to Bill and MB and WO+In, the debit gl account comes from the line 
	and    (@IncludeGLAccount = 0 OR b.GLAccountKey = @GLAccountKey)
	-- Also take in account ItemType for vouchers
	and    (@ItemType IS NULL OR b.ItemType = @ItemType)
 
	else

	-- join with IncomeGLCompanyKey/IncomeOfficeKey/IncomeClassKey
	insert #tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
	select @PostingKey, Entity, EntityKey, UIDEntityKey, @TransactionKey, NetAmount
	from   #tWIP b
	where  b.Reference = @Reference
	and    b.ClassKey = @ClassKey
	and    b.ClientKey = @ClientKey
	and    b.IncomeOfficeKey = @OfficeKey
	and    b.DepartmentKey = @DepartmentKey
	and    b.IncomeGLCompanyKey = @GLCompanyKey
	and    b.IncomeClassKey = @ClassKey
	and    b.ProjectKey = @ProjectKey
	-- For vouchers to Bill and MB and WO+In, the debit gl account comes from the line 
	and    (@IncludeGLAccount = 0 OR b.GLAccountKey = @GLAccountKey)
	-- Also take in account ItemType for vouchers
	and    (@ItemType IS NULL OR b.ItemType = @ItemType)
 
END -- While Loop on @RowNum

if @PostToGL = 1 And  @UseGLCompany = 1 And (Select Count(*) from #tICT) > 0  And @PrePost = 0
begin
		INSERT tTransaction(
			CompanyKey
			,TransactionDate
			,Entity
			,EntityKey
			,Reference
			,GLAccountKey
			,Debit
			,Credit
			,ClassKey
			,Memo
			,PostMonth
			,PostYear
			,PostSide
			,ClientKey
			,ProjectKey
			,SourceCompanyKey
			,DepositKey
			,GLCompanyKey
			,OfficeKey
			,DepartmentKey
			,DetailLineKey
			,Section
			,Overhead
			,ICTGLCompanyKey
			,HDebit
			,HCredit
			)
		select 
			@CompanyKey
			,@PostingDate
			,'WIP' -- @Entity
			,@PostingKey -- @EntityKey
			,'WIP ICT' -- @Reference
			,GLAccountKey
			,Debit 
			,Credit 
			,NULL --ClassKey
			,@Comment -- Memo
			,cast(DatePart(mm, @PostingDate) as int) -- PostMonth
			,cast(DatePart(yyyy, @PostingDate) as int) -- PostYear
			,case when Debit <> 0 then 'D' else 'C' end  --PostSide
			,NULL -- ClientKey
			,NULL -- ProjectKey
			,NULL ---SourceCompanyKey
			,NULL --DepositKey
			,GLCompanyKey
			,NULL --OfficeKey
			,NULL --DepartmentKey
			,NULL --DetailLineKey
			,@kSectionICT --Section
			,0 -- Overhead
			,ICTGLCompanyKey
		    -- for H values, pass regular Debit and Credit because this is in Home Currency
			,Debit 
			,Credit 
		from  #tICT

		if @@ERROR <> 0 
		begin
			rollback transaction 
			return @kErrUnexpected
		end
end


-- If we are pre posting now, abort
if @PrePost = 1
	return 1

exec @RetVal = spGLValidatePost 'WIP', @PostingKey
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end
If @RetVal < 0
begin
	rollback transaction
	return @kErrUnexpected
end

INSERT tWIPPostingDetail(WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount)
SELECT WIPPostingKey, Entity, EntityKey, UIDEntityKey, TransactionKey, Amount
FROM   #tWIPPostingDetail
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

-- Transactions IN
UPDATE tTime
SET    tTime.WIPPostingInKey = @PostingKey
      ,tTime.WIPAmount = ISNULL(#tWIP.NetAmount, 0) 
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tTime'
AND    #tWIP.UIDEntityKey = tTime.TimeKey
AND  #tWIP.Reference = @kLaborIn
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

UPDATE tExpenseReceipt
SET    tExpenseReceipt.WIPPostingInKey = @PostingKey
      ,tExpenseReceipt.WIPAmount = ISNULL(#tWIP.NetAmount, 0) 
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tExpenseReceipt'
AND    #tWIP.EntityKey = tExpenseReceipt.ExpenseReceiptKey
AND    #tWIP.Reference = @kExpReceiptIn
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

UPDATE tMiscCost
SET    tMiscCost.WIPPostingInKey = @PostingKey
      ,tMiscCost.WIPAmount = ISNULL(#tWIP.NetAmount, 0) 
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tMiscCost'
AND    #tWIP.EntityKey = tMiscCost.MiscCostKey
AND    #tWIP.Reference = @kMiscCostIn
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

UPDATE tVoucherDetail
SET    tVoucherDetail.WIPPostingInKey = @PostingKey
      ,tVoucherDetail.WIPAmount = ISNULL(#tWIP.NetAmount, 0) 
FROM   #tWIP 
WHERE #tWIP.Entity = 'tVoucherDetail'
AND    #tWIP.EntityKey = tVoucherDetail.VoucherDetailKey
AND    #tWIP.Reference IN ( @kVendorInvoiceIn, @kVendorInvoiceInER, @kMediaInvoiceIn)
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

-- Transactions OUT
UPDATE tTime
SET    tTime.WIPPostingInKey = 
	      CASE WHEN #tWIP.PostInWriteOff = 1 THEN @PostingKey 
		       ELSE tTime.WIPPostingInKey END
	  ,tTime.WIPPostingOutKey = @PostingKey
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tTime'
AND    #tWIP.UIDEntityKey = tTime.TimeKey
AND    #tWIP.Reference IN ( @kLaborBill, @kLaborMB, @kLaborWO, @kLaborInWO) 
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

UPDATE tExpenseReceipt
SET    tExpenseReceipt.WIPPostingInKey = 
	      CASE WHEN #tWIP.PostInWriteOff = 1 THEN @PostingKey 
		  ELSE tExpenseReceipt.WIPPostingInKey END
	  ,tExpenseReceipt.WIPPostingOutKey = @PostingKey
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tExpenseReceipt'
AND    #tWIP.EntityKey = tExpenseReceipt.ExpenseReceiptKey
AND    #tWIP.Reference IN (@kExpReceiptBill, @kExpReceiptMB, @kExpReceiptWO, @kExpReceiptInWO)
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

UPDATE tMiscCost
SET    tMiscCost.WIPPostingInKey = 
	      CASE WHEN #tWIP.PostInWriteOff = 1 THEN @PostingKey 
		       ELSE tMiscCost.WIPPostingInKey END
	  ,tMiscCost.WIPPostingOutKey = @PostingKey
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tMiscCost'
AND    #tWIP.EntityKey = tMiscCost.MiscCostKey
AND    #tWIP.Reference IN ( @kMiscCostBill, @kMiscCostMB, @kMiscCostWO, @kMiscCostInWO) 
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end

UPDATE tVoucherDetail
SET   tVoucherDetail.WIPPostingInKey = 
	      CASE WHEN #tWIP.PostInWriteOff = 1 THEN @PostingKey 
		       ELSE tVoucherDetail.WIPPostingInKey END
	  ,tVoucherDetail.WIPPostingOutKey = @PostingKey
FROM   #tWIP 
WHERE  #tWIP.Entity = 'tVoucherDetail'
AND    #tWIP.EntityKey = tVoucherDetail.VoucherDetailKey
AND    #tWIP.Reference IN ( @kVendorInvoiceBill, @kVendorInvoiceMB, @kVendorInvoiceWO, @kVendorInvoiceInWO
							,@kVendorInvoiceBillER, @kVendorInvoiceMBER, @kVendorInvoiceWOER, @kVendorInvoiceInWOER
							,@kMediaInvoiceBill, @kMediaInvoiceMB, @kMediaInvoiceWO, @kMediaInvoiceInWO ) 
if @@ERROR <> 0 
begin
	rollback transaction 
	return @kErrUnexpected
end
		
Commit Transaction

-- Patch to fight problems at Micromass where the last updates of tTime.WIPPostingInKey fails
-- if a failure is detected, I unpost WIP

declare @LaborInCount int
declare @RealLaborInCount int

if @OpeningTransaction = 0
begin
	select @LaborInCount = count(*)
	from   #tWIP
	where  Entity = 'tTime'
	and    Reference =  @kLaborIn

	-- cannot do count(t.TimeKey) because of old versions of SQL server
	-- should be ok to check the coount of users because I test if this 0 
	select @RealLaborInCount = count(t.UserKey) 
	from   tTime t (nolock)
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	where p.CompanyKey = @CompanyKey
	and   t.WIPPostingInKey = @PostingKey

	if @LaborInCount >0 and @RealLaborInCount = 0
	begin
		exec spGLUnPostWIP @PostingKey
		return @kErrUnexpected	
	end
end
	

return 1
GO
