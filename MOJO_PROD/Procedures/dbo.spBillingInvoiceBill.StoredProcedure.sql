USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spBillingInvoiceBill]    Script Date: 12/10/2015 12:30:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBillingInvoiceBill]
	(
	@TopBillingKey INT
	,@UserKey INT
	,@BillingStatusKey INT
	,@InvoiceDate smalldatetime = Null 
	,@PostingDate smalldatetime = Null
	,@CreateAsApproved INT 
	)
AS

  /*
  || When     Who Rel   What
  || 06/29/06 GHL 8.35  Removed ProjectKey on extra summary lines. Was showing  
  ||                    on grids and users expected Project # and name on invoice
  ||                    when template was set to show project # and name and
  ||                    By Top Lines (Bug 5850 Ervin and Smith)
  || 07/28/06 GHL 8.4   Added TrackBudget in task temp tables
  || 09/05/06 CRG 8.35	Removed the check for SetInvoiceNumberOnApproval when auto-approving the invoice.
  ||					(Bug 6437)
  || 09/27/06 GHL 8.4   Added support of fixed fee billing by billing item  
  || 10/11/06 CRG 8.35  Added Emailed column.
  || 02/22/07 GHL 8.4   Added Project Rollup section
  || 07/09/07 GHL 8.5   Added logic for company/office
  || 07/27/07 GHL 8.43  (Bug 9987) Taking in account now tPrefs settings for Invoice Approver
  || 08/07/07 GHL 8.5   Added Invoice Rollup
  || 08/09/07 GHL 8.5   Added Office/Department for extra project line
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts
  || 03/27/08 GHL 8.507 (21598) Changing the billing status only if > 0 (i.e. not if null, or 0)
  || 04/08/08 GHL 8.508 (23712) New logic for classes, remove reading of FixedFeeBillingClassDetail  
  || 06/18/08 GHL 8.513 Added OpeningBalance
  || 07/14/08 GHL 8.515 (30094) Added call to sptInvoiceOrder
  || 08/12/08 GHL 10.006 (32051) Moved invoice recalc amounts before creation of advance bills
  ||                     because InvoiceTotalAmount was not set yet
  || 08/13/08 GHL 10.008 (32232) Using now sptInvoiceLineInsertMassBilling when creating invoice lines for projects
  ||                     This sp bypasses validations and recalcs not necessary here
  || 10/08/08 GHL 10.010 (36927) Taking now default line format for Fixed Fee as One line instead of Service/item
  ||                     This is a problem if FixedFeeDisplay is null (sptBillingInsert has been fixed though)
  || 10/13/08 GHL 10.010 (37465) If tTask.ShowDescOnEst = 1 bring over task description
  || 03/18/09 GHL 10.021 Added generation of invoices per billing item then item
  || 06/01/09 GHL 10.026 (52904) Moved position of BI/Item call inside the Ws/Project loop (was outside) 
  || 07/09/09 GHL 10.503 (56803) Using now the class from individual WS rather than from the master WS
  ||                     The class on the master WS goes to the invoice header
  ||                     The class on the individual WSs go to the invoice lines
  || 07/29/09 GHL 10.505 (57778) Do not prevent the users from creating an invoice with 0 amount  
  || 08/14/09 GHL 10.507 (60305) Prevent the users from creating an invoice if there are no billing detail records
  || 08/24/09 GHL 10.507 (60195) For Fixed Fee projects, check if tBillingFixedFee.Amount > 0 before creating invoice 
  || 08/25/09 GHL 10.508 (60144) Account for retainer projects when deciding on creating the invoice
  || 09/10/09 GHL 10.509 (62127) Changed BillingCount definition to = COUNT(*) from #tBilling where BillingCount <> 0 
  ||                      Instead of = SUM(BillingCount) from #tBilling
  ||                      because we need an exact count of projects with anything to bill
  || 09/11/09 GHL 10.509  Get only child billing worksheets which have not been invoiced yet
  || 01/22/10 GHL 10.517 (69011) Changed retainer amount logic since we can have amounts <0  
  || 03/24/10 GHL 10.521 Added LayoutKey
  || 04/23/10 GHL 10.521 Added ProjectKey on Project summary lines for custom fields
  || 06/10/10 GHL 10.530 (82735) For AdvBill overwrite the SalesAccountKey on the lines to the Adv Bill Account 
  ||                     that has already been set on the Billing WS
  || 12/22/10 GHL 10.539  Added seeding of DisplayOption
  || 05/18/11 GHL 10.544  (111527) Only add an extra line for FF projects if this is more than a single FF line 
  || 01/03/12 GHL 10.551  (130049) Recovering now when Rollup/LineFormat = 9 by Billing Item/Item 
  ||                      (only in spBillingInvoiceBillLayout) set Rollup = 0, 1 line per project
  || 05/21/12 GHL 10.556 Added reading of ShowTransactionsOnInvoices (customization for Etna)
  ||                     Most of the projects will be No Details
  ||                     Expense project will be Transactions
  || 05/23/12 GHL 10.556 (144563) If we group by campaign but there was only one project (i.e. no masters)
  ||                     we must also set the campaign key on the invoice
  || 08/10/12 GHL 10.558 (150858) If the new invoice is completely covered by an advance bill, set Printed = 1
  || 09/27/12 GHL 10.560 Added update of billing group on invoice for HMI request
  || 10/15/12 GHL 10.561 (156926) Added FixedFeeRollup 
  ||                     Initially we only had one Rollup (For Fixed Fee the TM trans were rolled up into 1 line)
  ||                     But Enlighten wants to control the TM rollup on FF projects
  ||                     Decided to have 2 rollups (one TM and one FF)
  ||                     Note: The TM rollup for FF projects can only be changed on master BWS 
  || 02/26/13 GHL 10.565 (167798) When applying advance bills, add taxes to the applied amount.
  ||                     The original amount does not include taxes and users have to manually add taxes
  || 04/04/13 GHL 10.566 (173907) Added checking of ProjectName not null before inserting line for project in case of multi projects
  || 10/01/13 GHL 10.573 Added multi currency logic
  || 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
  || 08/07/14 GHL 10.583 (225414) Do not create an invoice if there is an invoice on the billing WS already or Status = 5
  || 10/10/14 GHL 10.584 (232654) Rather than using tBilling.InvoiceKey from being used to detect duplicates,
  ||                     use tInvoice.BillingKey because I noticed that duplicates had lines intertwined.
  ||                     Better to set tInvoice.BillingKey at the beginning of the process, than tBilling.InvoiceKey at the
  ||                     end of the process  
  || 11/12/14 GHL 10.586 Added support of titles for Abelson Tayor
  || 12/02/14 GHL 10.587 Renamed spBillingInvoiceOneLinePerServiceItem to spBillingInvoiceOneLinePerServiceItemFF 
  ||                     Added support for line format rollup: By Service OR Item
  || 03/20/15 GHL 10.591 Added setting of hours on Time lines
 */

	SET NOCOUNT ON

-- Variables to capture tBilling record
	DECLARE @BillingCount INT
			,@BillingMethod INT
			,@FixedFeeDisplay INT
			,@BillingKey INT
			,@DisplayOrder INT
			,@Status INT
			,@BillingApprover INT -- This is the Approver on the Billing WS (defaulted from AE on Project)		
			,@InvoiceApprover INT -- Final approver on Invoice, will depend on transaction preferences
			,@NewInvoiceKey INT
			,@ParentInvoiceLineKey INT
			,@AdvanceBill INT
			,@RetVal INT
			,@ShowExtraProjectLine INT
			,@PrimaryContactKey INT
			,@AddressKey INT
			,@GLCompanyKey INT
			,@OfficeKey INT
			,@CurrencyID VARCHAR(10)

-- Clone variables from spProcessWIPWorksheet	
declare @CompanyKey int
declare @ClientKey int
declare @ProjectKey int
declare @EstimateKey int	
declare @Rollup int
declare @FixedFeeRollup int
declare @BillingContact varchar(100) 
declare @DefaultSalesAccountKey int
declare @SalesAccountKey int 
declare @RequireGLAccounts tinyint
declare @TodaysDate smalldatetime
declare @DueDate smalldatetime
declare @DueDays int
declare @InvoiceComment varchar(500)
declare @ProjectName varchar(500)
declare @WorkTypeKey int
declare @DefaultARAccountKey int
declare @DefaultARApprover int
declare @DefaultARApproverKey int
declare @PostSalesUsingDetail tinyint
declare @InvoiceTemplateKey int
declare @SalesTaxKey int, @SalesTax2Key int, @PaymentTermsKey int
declare @RequireClasses tinyint
declare @TopBillingClassKey int
declare @BillingClassKey int
declare @DefaultClassKey int
declare @LayoutKey int
declare @ShowTransactionsOnInvoices int -- Etna
declare @SetInvoiceNumberOnApproval tinyint
declare	@NextTranNo varchar(100)
declare @OldInvoiceKey int
declare @OldStatus int
declare @UseBillingTitles int -- this will indicate the Abelson Taylor company
		
declare @TopEntity varchar(50)
declare @TopEntityKey int
declare @TopGroupEntity varchar(50)
declare @TopGroupEntityKey int

select @LayoutKey = isnull(LayoutKey, 0)
      ,@OldInvoiceKey = isnull(InvoiceKey, 0) 
	  ,@OldStatus = Status
from tBilling (nolock) where BillingKey = @TopBillingKey

-- Is it a valid invoice?
if not exists (select 1 from tInvoice (nolock) where InvoiceKey = @OldInvoiceKey)
	select @OldInvoiceKey = 0

-- If already invoiced, abort
if @OldInvoiceKey > 0 
	return -1001
if @OldStatus = 5
	return -1001
-- this way to check for duplicates should be stronger because tInvoice is set earlier
if exists (select 1 from tInvoice (nolock) where BillingKey = @TopBillingKey)
    return -1001 

if @LayoutKey > 0
begin 
	exec @NewInvoiceKey = spBillingInvoiceBillLayout @TopBillingKey,@UserKey,@BillingStatusKey,@InvoiceDate,@PostingDate,@CreateAsApproved
	return @NewInvoiceKey
end
						
	/*		
	|| Inits
	*/
	If @PostingDate IS NOT NULL
		select @TodaysDate = cast(cast(DATEPART(m,@PostingDate) as varchar(5))+'/'+cast(DATEPART(d,@PostingDate) as varchar(5))+'/'+cast(DATEPART(yy,@PostingDate)as varchar(5)) as smalldatetime)
	ELSE
	BEGIN
		select @TodaysDate = cast(cast(DATEPART(m,getdate()) as varchar(5))+'/'+cast(DATEPART(d,getdate()) as varchar(5))+'/'+cast(DATEPART(yy,getdate())as varchar(5)) as smalldatetime)
		Select @PostingDate = @TodaysDate
	END
	if @InvoiceDate is null
		Select @InvoiceDate = @TodaysDate
	
	-- Reset error
	update tBilling 
	set ErrorMsg = NULL 
	where BillingKey = @TopBillingKey 
					
	/*				
	|| Prep temp tables
	*/
	CREATE TABLE #tBilling(BillingKey INT NULL, DisplayOrder INT NULL, BillingCount INT NULL)
			
	IF (SELECT ParentWorksheet FROM tBilling (NOLOCK) WHERE BillingKey = @TopBillingKey) = 0
		INSERT #tBilling (BillingKey) VALUES (@TopBillingKey)
	ELSE
		INSERT #tBilling (BillingKey) 
		SELECT BillingKey 
		FROM   tBilling (NOLOCK) 
		WHERE  ParentWorksheetKey = @TopBillingKey
		AND    Status <> 5 -- do not take if already invoiced during approval
		ORDER BY DisplayOrder
	
	-- do we have some T&M to bill?
	UPDATE #tBilling
	SET    #tBilling.BillingCount = ISNULL((
		SELECT COUNT (bd.BillingDetailKey) FROM tBillingDetail bd (NOLOCK) 
		WHERE bd.BillingKey = #tBilling.BillingKey AND bd.Action = 1
		-- even if Amount = 0, we have to create a $0 invoice 
	),0)

	-- do we have some FF to bill?
	UPDATE #tBilling
	SET    #tBilling.BillingCount = ISNULL(#tBilling.BillingCount, 0) + ISNULL((
		SELECT COUNT (bff.BillingFixedFeeKey) FROM tBillingFixedFee bff (NOLOCK) 
		WHERE bff.BillingKey = #tBilling.BillingKey 
		AND bff.Amount > 0 -- Added this because one tBillingFixedFee rec is created automatically with Amount = 0  
	),0)
		
	-- do we have retainer amounts to bill?
	UPDATE #tBilling
	SET    #tBilling.BillingCount = ISNULL(#tBilling.BillingCount, 0) + 1
	FROM   tBilling b (NOLOCK)
	WHERE  #tBilling.BillingKey = b.BillingKey
	--AND    ISNULL(b.RetainerAmount, 0) > 0
	AND    b.Entity = 'Retainer' -- because now b.RetainerAmount can be <0, =0, >0
		
	-- Do not bill if no count
	SELECT @BillingCount = COUNT(*) FROM #tBilling WHERE ISNULL(BillingCount, 0) <> 0 
	
	-- No Amount to bill, mark BWS as Invoiced 	
	IF @BillingCount = 0
	BEGIN
		UPDATE 	tBilling 
		SET     tBilling.Status = 5
		FROM    #tBilling b
		WHERE   tBilling.BillingKey = b.BillingKey
		
		UPDATE 	tBilling 
		SET tBilling.Status = 5
		WHERE   tBilling.BillingKey = @TopBillingKey
			
		RETURN 1
	END
	
	-- Do not trust tBilling.DisplayOrder, setup our own
	SELECT @DisplayOrder = 1
	UPDATE #tBilling 
	SET    #tBilling.DisplayOrder = @DisplayOrder
	      ,@DisplayOrder = @DisplayOrder + 1
					
	SELECT  bd.* 
	INTO    #tBillingDetail
	FROM	tBillingDetail bd (NOLOCK)
		INNER JOIN #tBilling b ON bd.BillingKey = b.BillingKey
	WHERE   bd.Action = 1 -- Only trans to bill, others are handled on ws approval

				
	--create temp tables needed for task management
	create table #tInvcTask
                (
                 TaskKey int null
                ,SummaryTaskKey int null
                ,TaskType smallint null
                ,DisplayOrder int null
                ,Taxable tinyint null 
                ,Taxable2 tinyint null 
                ,WorkTypeKey int null 
                ,TrackBudget int null
                ,TaskName varchar(500) null
                ,Description varchar(6000) null
      )	
	create table #tInvcRootTask
     (
				TaskKey int null
				,SummaryTaskKey int null
                ,TaskType smallint null
                ,DisplayOrder int null
                ,Taxable tinyint null 
                ,Taxable2 tinyint null 
                ,WorkTypeKey int null               
                ,TrackBudget int null
                ,TaskName varchar(500) null
                ,Description varchar(6000) null
                )                
	
	--create temp tables needed for some other groupings	
	 CREATE TABLE #tran(
		Entity varchar(20) null,		-- like in tBillingDetail, tMiscCost, tTime, etc.... 
		EntityKey varchar(50) null,     -- transaction key
		EntityGuid uniqueidentifier null,
		
		BilledAmount money null,
		Quantity decimal(24,4) null,
		RateLevel int null,
		Rate money null,
		BilledComment varchar(2000),
		
		LayoutEntityKey int null,       -- ItemKey or ServiceKey depending on LayoutEntity

		-- All fields above should be set before this SP 
			
		LayoutEntity varchar(50) null,   -- like in tLayoutBilling, tItem, tService
		LayoutOrder int null,	
		WorkTypeLayoutOrder int null,
			
		WorkTypeKey int null,
		WorkTypeName varchar(200) null, 
		ItemName varchar(200) null,     -- will come from item or service
		
		-- Use this vars for a simpler grouping (like Service/Item)
		GroupEntity varchar(25) null,
		GroupEntityKey int null,
		GroupName varchar(250) null,

		InvoiceLineKey int null,
		LineID int null,
		
		UpdateFlag int null
		)

	/*				
	|| Get defaults from top billing worksheet or Pref or client
	*/
	SELECT @CompanyKey = CompanyKey
		   ,@ClientKey = ClientKey
		   ,@ProjectKey = ProjectKey
		   ,@TopBillingClassKey = ISNULL(ClassKey, 0)
		   ,@SalesTaxKey = SalesTaxKey
		   ,@SalesTax2Key = SalesTax2Key
		   ,@PaymentTermsKey = ISNULL(TermsKey, 0) 
		   ,@DefaultSalesAccountKey = ISNULL(DefaultSalesAccountKey, 0) -- It is NULL or 0 in table tBilling
		   ,@BillingApprover = ISNULL(Approver, @UserKey)	
     	   ,@InvoiceComment = InvoiceComment
		   ,@Status = Status
		   ,@AdvanceBill = ISNULL(AdvanceBill, 0) -- only FF and will be on their own ws	
		   ,@PrimaryContactKey = PrimaryContactKey -- NULL is fine
		   ,@AddressKey = AddressKey -- NULL is fine
		   ,@GLCompanyKey = GLCompanyKey
		   ,@OfficeKey = OfficeKey	
		   ,@CurrencyID = CurrencyID

		   ,@TopEntity = Entity							-- Will indicate Campaign
	       ,@TopEntityKey = EntityKey
		   ,@TopGroupEntity = GroupEntity				-- Will indicate Campaign on single projects
	       ,@TopGroupEntityKey = GroupEntityKey

	FROM   tBilling (NOLOCK)
	WHERE  BillingKey = @TopBillingKey

	-- Already invoiced
	IF @Status = 5
	BEGIN
		update tBilling set ErrorMsg = 'The billing worksheet was already invoiced'
		where BillingKey = @TopBillingKey 
			
		RETURN -1
	END

	-- Make sure that no vendor invoice have been applied against POs
	IF EXISTS (SELECT 1
				FROM  tPurchaseOrderDetail pod (NOLOCK)
				INNER JOIN tPurchaseOrder po (NOLOCK) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
				INNER JOIN #tBillingDetail bd (NOLOCK) ON pod.PurchaseOrderDetailKey = bd.EntityKey
														AND bd.Entity = 'tPurchaseOrderDetail'
				WHERE po.CompanyKey = @CompanyKey
				AND	ISNULL(pod.AppliedCost, 0) > 0
				)
	BEGIN
		update tBilling set ErrorMsg = 'Vendor Invoices have been applied to POs involved on this billing worksheet'
		where BillingKey = @TopBillingKey 
		
		RETURN -1			
	END
	
	IF @PrimaryContactKey IS NOT NULL
		select @BillingContact = Left(FirstName + ' ' + LastName, 100)
		from   tUser (nolock) 
		Where  UserKey = @PrimaryContactKey
		
	-- get other client defaults  
	Select @InvoiceTemplateKey = ISNULL(InvoiceTemplateKey, 0)
	from tCompany (nolock)
	Where CompanyKey = @ClientKey
		
	if @PaymentTermsKey = 0
		Select @PaymentTermsKey = PaymentTermsKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey

	Select @PostSalesUsingDetail  = ISNULL(PostSalesUsingDetail, 0)
			,@DefaultARAccountKey = DefaultARAccountKey
			,@WorkTypeKey         = AdvBillItemKey
			,@RequireClasses      = ISNULL(RequireClasses, 0)
			,@RequireGLAccounts   = ISNULL(RequireGLAccounts, 0)
			,@SetInvoiceNumberOnApproval = ISNULL(SetInvoiceNumberOnApproval,0)
			,@DefaultARApprover   = ISNULL(DefaultARApprover, 0)
			,@DefaultARApproverKey = ISNULL(DefaultARApproverKey, 0)			
			,@DefaultClassKey      = DefaultClassKey
			,@UseBillingTitles	   = ISNULL(UseBillingTitles, 0)
	From tPreference (nolock)
	Where CompanyKey = @CompanyKey
			
	-- validation of classes
	if @RequireClasses = 1 AND ISNULL(@TopBillingClassKey, 0) = 0 AND ISNULL(@DefaultClassKey, 0) = 0
	BEGIN
		update tBilling set ErrorMsg = 'There is no class for this worksheet, but your company requires classes on transactions'
		where BillingKey = @TopBillingKey 
		
		RETURN -1			
	END
	
	if @RequireClasses = 1 AND ISNULL(@TopBillingClassKey, 0) = 0
		SELECT @TopBillingClassKey = @DefaultClassKey
	
	-- validation of GL accounts
	if @DefaultSalesAccountKey = 0
		Select @DefaultSalesAccountKey = ISNULL(DefaultSalesAccountKey, 0)
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey
	
	if not exists (select 1 from tGLAccount (NOLOCK) where CompanyKey = @CompanyKey and GLAccountKey = @DefaultSalesAccountKey )
		Select @DefaultSalesAccountKey = 0
		
	if @RequireGLAccounts = 1 AND @DefaultSalesAccountKey = 0
	BEGIN
		update tBilling set ErrorMsg = 'There is no Default Sales Account for this worksheet and for your company'
		where BillingKey = @TopBillingKey 
		
		RETURN -1			
	END
	
	IF ISNULL(@PaymentTermsKey, 0) > 0
	BEGIN
		SELECT @DueDays = ISNULL(DueDays, 0)
		FROM   tPaymentTerms (NOLOCK)
		WHERE  PaymentTermsKey = @PaymentTermsKey
		 	
		SELECT @DueDate = DATEADD(d, @DueDays, @InvoiceDate) 	
	END
	ELSE
		SELECT @DueDate = @TodaysDate

-- DefaultARApprover 
-- 0 Person Entering the Invoice
-- 1 AE From project
-- 2 Automatically approved ==> set invoice # when SetInvoiceNumberOnApproval = 1
-- 3 Default Approver in tPrefs

IF @DefaultARApprover = 0
	SELECT @InvoiceApprover = @UserKey
-- If AE From project, it was already copied to the WS, so take it from WS	
IF @DefaultARApprover = 1
	SELECT @InvoiceApprover = @BillingApprover
-- If default approver from tPrefs
IF @DefaultARApprover = 3
BEGIN
	IF @DefaultARApproverKey > 0 
		SELECT @InvoiceApprover = @DefaultARApproverKey
	ELSE
		SELECT @InvoiceApprover = @UserKey 
END
-- Automatically approved, set to current user
IF @DefaultARApprover = 2
	SELECT @InvoiceApprover = @UserKey 
				   	
	/*				
	|| Create an invoice
	*/
	exec @RetVal = sptInvoiceInsert
						@CompanyKey
						,@ClientKey
						,@BillingContact
						,@PrimaryContactKey
						,@AddressKey
						,@AdvanceBill							--AdvanceBill 
						,null               					--InvoiceNbumber
						,@InvoiceDate        					--InvoiceDate
						,@DueDate					  			--Due Date
						,@PostingDate				 			--Posting Date
						,@PaymentTermsKey  						--TermsKey
						,@DefaultARAccountKey					--Default AR Account
						,@TopBillingClassKey						--ClassKey
						,@ProjectKey							--Project Key
						,@InvoiceComment  						--HeaderComment
						,@SalesTaxKey					 		--SalesTaxKey 
						,@SalesTax2Key					 		--SalesTax2Key 
						,@InvoiceTemplateKey					--Invoice Template Key
						,@InvoiceApprover						--ApprovedBy Key
						,NULL									--User Defined 1
						,NULL									--User Defined 2
						,NULL									--User Defined 3
						,NULL									--User Defined 4
						,NULL									--User Defined 5
						,NULL									--User Defined 6
						,NULL									--User Defined 7
						,NULL									--User Defined 8
						,NULL									--User Defined 9
						,NULL									--User Defined 10
						,0
						,0
						,0
						,0										--Emailed
						,@UserKey                               --CreatedByKey
						,@GLCompanyKey
						,@OfficeKey
						,0										-- OpeningBalance
						,@LayoutKey
						,@CurrencyID
						,1										-- Exch Rate
						,1										-- @RequestExchangeRate
						,@NewInvoiceKey output
	if @@ERROR <> 0 
	  begin
		update tBilling set ErrorMsg = 'An error occurred when creating the invoice' 
		where BillingKey = @TopBillingKey 
		
		return -5					   	
	  end
	if @RetVal <> 1 
	 begin
		update tBilling set ErrorMsg = 'An error occurred when creating the invoice' 
		where BillingKey = @TopBillingKey 
		
		return -5					   	
	  end
	  	
	-- used in search for duplicates at the top of the sp
	update tInvoice set BillingKey = @TopBillingKey where InvoiceKey = @NewInvoiceKey

	if @TopEntity = 'Campaign'
	begin
		update tInvoice
		set    CampaignKey = @TopEntityKey
		where  InvoiceKey = @NewInvoiceKey
	end
	else
	begin
		-- If there is only 1 project for the campaign, there will be no master
		-- so get campaign from the group info on the single billing WS instead
		if @TopGroupEntity = 'Campaign'
		begin
			update tInvoice
			set    CampaignKey = @TopGroupEntityKey
			where  InvoiceKey = @NewInvoiceKey
		end
	end
		
	if @TopEntity = 'BillingGroup'
	begin
		update tInvoice
		set    BillingGroupKey = @TopEntityKey
		where  InvoiceKey = @NewInvoiceKey
	end
	else
	begin
		-- If there is only 1 project for the campaign, there will be no master
		-- so get campaign from the group info on the single billing WS instead
		if @TopGroupEntity = 'BillingGroup'
		begin
			update tInvoice
			set    BillingGroupKey = @TopGroupEntityKey
			where  InvoiceKey = @NewInvoiceKey
		end
	end
		   
	--update AR account key
	--also bypass normal approval process since it went thru billing ws approval process
	If @CreateAsApproved = 1
	BEGIN
	
		--Check to see if the tInvoice Insert SP set the Invoice Number
		SELECT	@NextTranNo = InvoiceNumber
		FROM	tInvoice (nolock)
		WHERE	InvoiceKey = @NewInvoiceKey
	
		IF @NextTranNo IS NULL
		BEGIN
			--If the InvoiceNumber has not been set yet, get the next number
			EXEC spGetNextTranNo
				@CompanyKey,
				'AR',		-- TranType
				@RetVal		  OUTPUT,
				@NextTranNo   OUTPUT
		
			IF @RetVal <> 1
				RETURN -5
		END
	
		update tInvoice
		set ARAccountKey = @DefaultARAccountKey
			,ApprovedByKey = @InvoiceApprover
			,InvoiceStatus = 4 -- Approved
			,InvoiceNumber = @NextTranNo 
		where InvoiceKey = @NewInvoiceKey

		if @@ERROR <> 0 
		begin
			update tBilling set ErrorMsg = 'An error occurred when updating the invoice' 
			where BillingKey = @TopBillingKey 
			exec sptInvoiceDelete @NewInvoiceKey

			return -5					   	
		end
	END
	ELSE
	BEGIN
		update tInvoice
		set ARAccountKey = @DefaultARAccountKey
			,ApprovedByKey = @InvoiceApprover
		where InvoiceKey = @NewInvoiceKey

		if @@ERROR <> 0 
		begin
			update tBilling set ErrorMsg = 'An error occurred when updating the invoice' 
			where BillingKey = @TopBillingKey 
			exec sptInvoiceDelete @NewInvoiceKey

			return -5					   	
		end
	END
		
	/*				
	|| Add child billing worksheets
	*/
  		 	
	SELECT @DisplayOrder = -1
	WHILE (1=1)
	BEGIN
		SELECT @DisplayOrder = MIN(DisplayOrder)
		FROM   #tBilling WHERE DisplayOrder > @DisplayOrder
				
		IF @DisplayOrder IS NULL
			BREAK
		
		SELECT @BillingKey = BillingKey
		FROM   #tBilling (NOLOCK)
		WHERE  DisplayOrder = @DisplayOrder
			
		SELECT @ParentInvoiceLineKey = 0
			
		SELECT @ProjectKey = b.ProjectKey
			   ,@Rollup = ISNULL(b.DefaultARLineFormat, 0) -- Default is 1 line per Project 
	    	   ,@BillingMethod = b.BillingMethod
			   ,@ProjectName = p.ProjectName
			   ,@ShowTransactionsOnInvoices = isnull(p.ShowTransactionsOnInvoices, 0) -- for Etna customization
			   ,@FixedFeeDisplay = ISNULL(b.FixedFeeDisplay, 1) -- Default is ONE invoice line
			   ,@SalesAccountKey = ISNULL(b.DefaultSalesAccountKey, 0) -- Can be null or 0	
			   ,@EstimateKey = b.EstimateKey -- For FF
		       ,@BillingClassKey = ISNULL(b.ClassKey, 0)
		FROM   tBilling b (NOLOCK)
			LEFT OUTER JOIN tProject p (NOLOCK) ON b.ProjectKey = p.ProjectKey
		WHERE  b.BillingKey = @BillingKey

		if not exists (select 1 from tGLAccount (NOLOCK) where CompanyKey = @CompanyKey and GLAccountKey = @SalesAccountKey )
			Select @SalesAccountKey = @DefaultSalesAccountKey 

		if @RequireClasses = 1 AND @BillingClassKey = 0 AND ISNULL(@DefaultClassKey, 0) > 0 
			SELECT @BillingClassKey = @DefaultClassKey

		-- If retainer, ignore line format/rollup and set up a dummy rollup
		IF @BillingMethod = 3
			SELECT @Rollup = 4
		
		-- If FF, it will depend on FixedFeeDisplay	
		IF @BillingMethod = 2
		BEGIN
			IF @FixedFeeDisplay = 1
				SELECT @FixedFeeRollup = 0	-- There is just a line in tBillingFixedFee for Entity = 'tEstimate'  
			ELSE IF @FixedFeeDisplay = 2 
				SELECT @FixedFeeRollup = 5	-- By Task
			ELSE IF @FixedFeeDisplay = 3
				SELECT @FixedFeeRollup = 6	-- By Service Item or by Billing Item
			ELSE IF @FixedFeeDisplay = 4
				SELECT @FixedFeeRollup = 6	-- By Billing Item
			ELSE
				SELECT @FixedFeeRollup = 6
						
		END	
 	
		-- Rollup 9 is only valid in spBillingInvoiceLayout
		-- recover by selecting One Line Per Project
		if @Rollup = 9
			select @Rollup = 0

 		-- Rollup possible values: 
		-- If by Project			If by Client or other
		-- 0 1 Line					0 =1 line per project
		-- 1 Task					1 =1 line per project and Task
		-- 2 Service				2 =1 line per project and Service
		-- 3 Billing Item			3 =1 line per project and Billing Item 
		-- 8 Billing Item the Item  8 =1 line per project and Billing Item and Item
		
		-- For Abelson and Taylor only
		-- 11 Title
		-- 12 Title and Service
		-- 13 Service and Title

		-- New billing method
		-- 14 Service/Item ( not Service and Item, but Service or Item)

		-- Additional values
		-- 4 Retainer
		-- 5 FF By Task
		-- 6 FF By Service/Item or Billing Item

		/* This is how it should display when we have several projects
		
		Project 1
			Task 1		100
			Task 2		200
			Task 3		100
		Project 2
			BI 1		200
			BI 2		100
			BI 3		100
		Project 3
			S 1			10
			S 2			100
			S 3			100
			Exp			200
		Project 4		8000
		Retainer		1000
		
		If we only have one project, display normally
		
		Task 1
		Task 2
		Task 3
		
		i.e. without project line
		
		*/
		
		SELECT @ShowExtraProjectLine = 0
		IF @BillingCount > 1 
		BEGIN
			IF @BillingMethod = 1 -- TM
				IF @Rollup IN (1, 2, 3, 8, 11, 12, 13, 14) -- 11, 12, 13 by title, for Abelson Taylor only
					SELECT @ShowExtraProjectLine = 1
					
			IF @BillingMethod = 2 -- FF, will display lines by Estimate (FFDisplay=1), Tasks (=2) or Service/Items (=3)
				IF @FixedFeeRollup > 0 -- if not one line per project
				SELECT @ShowExtraProjectLine = 1
					
			-- Not necessary for Retainers
		END
		
		
		IF @ShowExtraProjectLine = 1 And @ProjectName is not null
		BEGIN
			-- Create summary line for project
			
			--create single invoice line
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
														-- (GHL 6/29/06, set to NULL instead of @ProjectKey)
														-- (GHL 4/23/10, set it back to @ProjectKey)
						  ,@ProjectKey					-- ProjectKey 
						  ,NULL							-- TaskKey
						  ,@ProjectName					-- Line Subject
						  ,NULL                 		-- Line description
						  ,0		      				-- Bill From 
						  ,0							-- Quantity
						  ,0							-- Unit Amount
						  ,0							-- Line Amount
						 ,1							-- line type = Summary
						  ,0							-- parent line key
						  ,NULL --@SalesAccountKey				-- Default Sales AccountKey -- displayed on screen
						  ,@BillingClassKey             -- Class Key
						  ,0							-- Taxable
						  ,0							-- Taxable2
						  ,@WorkTypeKey					-- Work TypeKey
						  ,@PostSalesUsingDetail
						  ,NULL							-- Entity
						  ,NULL							-- EntityKey
						  ,NULL							-- OfficeKey
						  ,NULL							-- DepartmentKey
						  ,@ParentInvoiceLineKey output

			if @@ERROR <> 0 
			  begin

				update tBilling set ErrorMsg = 'An error occurred when inserting an invoice line for a worksheet' 
				where BillingKey = @TopBillingKey 

				exec sptInvoiceDelete @NewInvoiceKey
				return -17					 	
			  end			   		     		 
			if @RetVal <> 1 
			  begin
				update tBilling set ErrorMsg = 'An error occurred when inserting an invoice line for a worksheet' 
				where BillingKey = @TopBillingKey 

				exec sptInvoiceDelete @NewInvoiceKey
				return -17					 	
			  end
		END
		

		/*
		|| Handle single invoice line
		*/	
		IF @Rollup <= 0						
		BEGIN
			-- pass 1 as BillingMethod to indicate tBillingDetail
			EXEC @RetVal = spBillingInvoiceOneLine @NewInvoiceKey, @BillingKey, 1, @ProjectKey 
			,@ProjectName ,@SalesAccountKey, @BillingClassKey, @WorkTypeKey , @ParentInvoiceLineKey, @PostSalesUsingDetail
			,@EstimateKey	

			IF @RetVal < 0
			BEGIN
				update tBilling set ErrorMsg = 'An error occurred when inserting the invoice line for a worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				RETURN @RetVal
			END	

			-- Customization for Etna
			IF @RetVal > 0 and @ShowTransactionsOnInvoices = 1
			begin
				update tInvoiceLine
				set    DisplayOption = 3-- @kDisplayOptionTransactions
				where  InvoiceLineKey = @RetVal
			end

		END	
		
		/*
		|| Handle invoice lines by Task
		*/		
		if @Rollup = 1
		begin
			exec @RetVal = spBillingInvoiceOneLinePerTask @NewInvoiceKey ,@BillingKey, @BillingMethod, @ProjectKey 
				,@SalesAccountKey , @BillingClassKey, @ParentInvoiceLineKey, @PostSalesUsingDetail 
				
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per task for a worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end
	

		/*
		|| Handle invoice lines by Service (One line for expenses)
		*/		
		if @Rollup = 2
		begin
			exec @RetVal = spBillingInvoiceOneLinePerService @NewInvoiceKey ,@BillingKey, @BillingMethod, @ProjectKey 
				,@SalesAccountKey , @DefaultClassKey, @BillingClassKey, @ParentInvoiceLineKey, @PostSalesUsingDetail 
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per service for a worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end
			  	
		/*
		|| Handle invoice lines by Service/Item (One line per item for expenses) 
		*/		
		if @Rollup = 14
		begin
			exec @RetVal = spBillingInvoiceOneLinePerServiceItem @NewInvoiceKey ,@BillingKey, @BillingMethod, @ProjectKey 
				,@SalesAccountKey , @DefaultClassKey, @BillingClassKey, @ParentInvoiceLineKey, @PostSalesUsingDetail 
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per service/item for a worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end

		/*
		|| Handle invoice lines by Billing Item
		*/		
		if @Rollup = 3
		begin
			exec @RetVal = spBillingInvoiceOneLinePerBillingItem @CompanyKey, @NewInvoiceKey ,@BillingKey, @BillingMethod, @ProjectKey 
				,@SalesAccountKey , @DefaultClassKey, @BillingClassKey, @ParentInvoiceLineKey, @PostSalesUsingDetail 
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per billing item for a worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end			  	

		/*
		|| Handle invoice line for the retainer amount
		*/		
		if @Rollup = 4
		begin
			exec @RetVal = spBillingInvoiceRetainer @NewInvoiceKey ,@BillingKey, @BillingMethod 
				,@SalesAccountKey , @BillingClassKey, @WorkTypeKey, @InvoiceDate
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting the invoice line for a retainer' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end			  	

		/*
		|| Fixed Fee by Task
		*/		
		if @BillingMethod = 2 and @FixedFeeRollup = 5
		begin
			exec @RetVal = spBillingInvoiceOneLinePerTaskFF @CompanyKey, @NewInvoiceKey ,@BillingKey, @BillingMethod 
				,@ProjectKey, @SalesAccountKey , @BillingClassKey, @WorkTypeKey, @ParentInvoiceLineKey
				,@EstimateKey
				
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per task for a fixed fee worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end			  	

		/*
		|| Fixed Fee by Service/Item
		*/		
		if @BillingMethod = 2 And @FixedFeeRollup = 6
		begin
			exec @RetVal = spBillingInvoiceOneLinePerServiceItemFF @CompanyKey, @NewInvoiceKey ,@BillingKey, @BillingMethod 
				,@ProjectKey, @SalesAccountKey , @DefaultClassKey, @BillingClassKey, @WorkTypeKey, @ParentInvoiceLineKey, @EstimateKey
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per service/item for a fixed fee worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end			  	
		  		

		/*
		|| FF on one invoice line
		*/	
		
		IF @BillingMethod = 2 And @FixedFeeRollup = 0						
		BEGIN
			-- Pass 2 instead of @BillingMethod to indicate tBillingFixedFee records
			EXEC @RetVal = spBillingInvoiceOneLine @NewInvoiceKey, @BillingKey, 2, @ProjectKey 
			,@ProjectName ,@SalesAccountKey, @BillingClassKey, @WorkTypeKey , @ParentInvoiceLineKey, @PostSalesUsingDetail	
			,@EstimateKey

			IF @RetVal < 0
			BEGIN
				update tBilling set ErrorMsg = 'An error occurred when inserting the invoice line for a fixed fee worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				RETURN @RetVal
			END	
		END	
		  		
		/*
		|| Handle invoice lines by Billing Item AND Item
		*/		
		if @Rollup = 8
		begin
			exec @RetVal = spBillingInvoiceOneLinePerBillingItemItem @CompanyKey, @NewInvoiceKey ,@BillingKey, @BillingMethod, @ProjectKey 
				,@SalesAccountKey , @DefaultClassKey, @BillingClassKey, @ParentInvoiceLineKey, @PostSalesUsingDetail 
	  		if @RetVal < 0
			begin
				update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per billing item and Item for a worksheet' 
				where BillingKey = @TopBillingKey 

				EXEC sptInvoiceDelete @NewInvoiceKey
				return @RetVal
			end
		end			  	

		/*
		|| Handle invoice lines by Title for Abelson Taylor
		*/		
		if @Rollup in ( 11, 12, 13)
		begin
			EXEC @RetVal = spBillingInvoiceOneLinePerTitle @NewInvoiceKey, @BillingKey, @Rollup, @ProjectKey 
				,@SalesAccountKey , @DefaultClassKey, @BillingClassKey, @PostSalesUsingDetail, @ParentInvoiceLineKey

				IF @RetVal < 0
				BEGIN
					update tBilling set ErrorMsg = 'An error occurred when inserting invoice lines per title for a worksheet'  
					where BillingKey = @TopBillingKey 

					EXEC sptInvoiceDelete @NewInvoiceKey
					RETURN @RetVal
				END	
		end			  	

		IF ISNULL(@BillingStatusKey, 0) > 0
		BEGIN
			UPDATE tProject
			SET    ProjectBillingStatusKey = @BillingStatusKey
			WHERE  ProjectKey = @ProjectKey
		END
					
	END -- DisplayOrder or BillingKey

	
select @OldInvoiceKey = isnull(InvoiceKey, 0) 
	  ,@OldStatus = Status
from tBilling (nolock) where BillingKey = @TopBillingKey

-- If already invoiced, abort
if @OldInvoiceKey > 0 Or @OldStatus = 5 
begin
	EXEC sptInvoiceDelete @NewInvoiceKey
	return -1001
end		
	-- if summary line, display option = Sub Item Details
	-- if detail line, display option = No detail
	update tInvoiceLine
	set    DisplayOption = case when LineType =1 then 2 else 1 end
	where  InvoiceKey = @NewInvoiceKey
	and    DisplayOption is null

	exec sptInvoiceOrder @NewInvoiceKey, 0, 0, 0 -- added because we do not do it in sptInvoiceLineInsertMassBilling
	exec sptInvoiceRecalcAmounts @NewInvoiceKey 

	-- this is for Abelson Taylor, rollup hours on invoicelines
	exec  sptInvoiceLineSetHours @NewInvoiceKey

	-- If the user wanted an advance bill, tBilling.DefaultSalesAccountKey should already be set to the AdvBill account so set it now on the lines
	IF @AdvanceBill = 1
		UPDATE tInvoiceLine SET SalesAccountKey = @DefaultSalesAccountKey WHERE InvoiceKey = @NewInvoiceKey AND LineType = 2 

	-- Handle Advance Payments
	DECLARE @AdvBillInvoiceKey INT
			,@AdvanceBillAmount MONEY
			,@SalesTaxAmount money
			,@UnappliedAmount money
			,@AdvanceBillTaxAmount MONEY
			,@AdvanceBillCurrencyID varchar(10)

	select @SalesTaxAmount = SalesTaxAmount from tInvoice (nolock) where InvoiceKey = @NewInvoiceKey
 	select @SalesTaxAmount = isnull(@SalesTaxAmount, 0)		
	
	IF @SalesTaxAmount = 0
	BEGIN
		IF (SELECT COUNT(*) FROM tBillingPayment (NOLOCK)
			WHERE  BillingKey = @TopBillingKey) > 0
		BEGIN
			SELECT @AdvBillInvoiceKey = -1
			WHILE (1 = 1)
			BEGIN
				SELECT @AdvBillInvoiceKey = MIN(EntityKey)
				FROM   tBillingPayment (NOLOCK)
				WHERE  BillingKey = @TopBillingKey
				AND    EntityKey > @AdvBillInvoiceKey
				AND    Entity = 'INVOICE'				
		
				IF @AdvBillInvoiceKey IS NULL
					BREAK
				
				SELECT @AdvanceBillAmount = Amount
				FROM   tBillingPayment (NOLOCK)
				WHERE  BillingKey = @TopBillingKey
				AND    EntityKey = @AdvBillInvoiceKey
				AND    Entity = 'INVOICE'				
				
				select @AdvanceBillCurrencyID = CurrencyID
				from   tInvoice (nolock)
				where  InvoiceKey = @AdvBillInvoiceKey

				if isnull(@CurrencyID, '') = isnull(@AdvanceBillCurrencyID, '') 
					EXEC sptInvoiceAdvanceBillInsert @NewInvoiceKey, @AdvBillInvoiceKey, @AdvanceBillAmount	
				
			END
		END
	END
	ELSE
	BEGIN
		-- try to apply sales tax amount
		IF (SELECT COUNT(*) FROM tBillingPayment (NOLOCK)
			WHERE  BillingKey = @TopBillingKey) > 0
		BEGIN
			SELECT @AdvBillInvoiceKey = -1
			WHILE (1 = 1)
			BEGIN
				SELECT @AdvBillInvoiceKey = MIN(EntityKey)
				FROM   tBillingPayment (NOLOCK)
				WHERE  BillingKey = @TopBillingKey
				AND    EntityKey > @AdvBillInvoiceKey
				AND    Entity = 'INVOICE'				
		
				IF @AdvBillInvoiceKey IS NULL
					BREAK
				
				SELECT @AdvanceBillAmount = Amount
				FROM   tBillingPayment (NOLOCK)
				WHERE  BillingKey = @TopBillingKey
				AND    EntityKey = @AdvBillInvoiceKey
				AND    Entity = 'INVOICE'				
				
				select @AdvanceBillTaxAmount = 0

				if @SalesTaxAmount > 0
				begin
					-- Start with the total amount on the adv bill
					select @UnappliedAmount = InvoiceTotalAmount from tInvoice (nolock) where InvoiceKey = @AdvBillInvoiceKey

					-- subtract what is applied to other invoices
					select @UnappliedAmount = isnull(@UnappliedAmount,0) - ISNULL((Select Sum(Amount) from tInvoiceAdvanceBill (nolock) 
						Where tInvoiceAdvanceBill.AdvBillInvoiceKey = @AdvBillInvoiceKey), 0)

					-- subtract what is applied to other WS
					select @UnappliedAmount = isnull(@UnappliedAmount,0) - ISNULL((Select Sum(Amount) from tBillingPayment (nolock) 
						inner join tBilling (nolock) on tBilling.BillingKey = tBillingPayment.BillingKey
						Where tBillingPayment.Entity = 'INVOICE' 
						and tBilling.Status < 5
						and tBillingPayment.EntityKey = @AdvBillInvoiceKey
						and tBilling.BillingKey <> @TopBillingKey
						), 0)

					if @UnappliedAmount > @AdvanceBillAmount
					begin
						-- we could apply more than the applied amount
						select @AdvanceBillTaxAmount = @UnappliedAmount - @AdvanceBillAmount

						-- but that must be less than the tax on the regular invoice
						if @AdvanceBillTaxAmount > @SalesTaxAmount
							select @AdvanceBillTaxAmount = @SalesTaxAmount

					end

				end

				select @AdvanceBillAmount = isnull(@AdvanceBillAmount, 0) + isnull(@AdvanceBillTaxAmount, 0)
				select @SalesTaxAmount = isnull(@SalesTaxAmount, 0) - isnull(@AdvanceBillTaxAmount, 0)

				select @AdvanceBillCurrencyID = CurrencyID
				from   tInvoice (nolock)
				where  InvoiceKey = @AdvBillInvoiceKey

				if isnull(@CurrencyID, '') = isnull(@AdvanceBillCurrencyID, '')
					EXEC sptInvoiceAdvanceBillInsert @NewInvoiceKey, @AdvBillInvoiceKey, @AdvanceBillAmount	
				
			END
		END
	END


	-- If the invoice is completely paid by the advance bills, set Printed = 1 
	declare @InvoiceOpenAmount money
	declare @InvoiceTotalAmount money
	select @InvoiceOpenAmount = isnull(InvoiceTotalAmount, 0) - isnull(RetainerAmount, 0)  
	     ,@InvoiceTotalAmount = isnull(InvoiceTotalAmount, 0)
	from tInvoice (nolock)
	where InvoiceKey = @NewInvoiceKey

	if @InvoiceOpenAmount = 0 and @InvoiceTotalAmount <> 0
		update tInvoice
		set    Printed = 1
		where  InvoiceKey = @NewInvoiceKey

	-- This processing below involves the master as well
	-- Make sure that the master is in there too
	IF (SELECT COUNT(*) FROM #tBilling WHERE BillingKey = @TopBillingKey) = 0 		
		INSERT #tBilling (BillingKey) VALUES (@TopBillingKey) 

			
	UPDATE tBilling 
	SET    tBilling.InvoiceKey = @NewInvoiceKey 
		  ,tBilling.Status = 5
	FROM #tBilling
	WHERE  tBilling.BillingKey = #tBilling.BillingKey	
	IF @@ERROR <> 0
	BEGIN
		update tBilling set ErrorMsg = 'An error occurred when changing the status of the billing worksheet to invoiced' 
		where BillingKey = @TopBillingKey 

		EXEC sptInvoiceDelete @NewInvoiceKey
		RETURN -1000
	END
		

	EXEC sptProjectRollupUpdateEntity 'tInvoice', @NewInvoiceKey	
		
	RETURN @NewInvoiceKey
GO
