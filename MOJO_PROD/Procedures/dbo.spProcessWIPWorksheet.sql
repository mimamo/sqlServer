USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProcessWIPWorksheet]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProcessWIPWorksheet]
	 @ProcessKey int	-- ProjectKey, RetainerKey or ClientKey depending on InvoiceBy
	,@InvoiceBy int		-- 0: Invoice By Project, 1: Invoice By Client, 2: Invoice By Client Parent,
						-- 3: Invoice By Estimate, 4: Invoice By Retainer Per Client,  5: Invoice By Retainer Per Retainer
	,@Rollup int		-- 0: 1 Line Item
						-- 1: 1 Line per Task (only applicable if invoiced by Project) 
						-- 2: 1 Line per Service
						-- 3: 1 line per Billing Item
						-- 4: 1 Line per Project  (only applicable if invoiced by Client or Estimate)  
						-- 5: 1 Line per Estimate (only applicable if invoiced by Client or Project) 
						-- 6: 1 Line per Client   (only applicable if invoiced by Parent Company) 
						-- 7: 1 line per ProjectType + Project (only applicable if invoiced per Client or Parent Client)
						-- 8: 1 line per Billing Item then Item
						-- 9: 1 line per Project then Billing Item then Item
						--10: 1 line per Publication/Station (for new media screens)
						--11: 1 line per title (for Abelson/Taylor)
						--12: 1 line per title/service (for Abelson/Taylor)
						--13: 1 line per service/title (for Abelson/Taylor)
						--14: 1 line per service/item
	,@UserKey int
	,@WriteOffReasonKey int
	,@PercentOfActual decimal(15,8)
	,@InvoiceDate smalldatetime = Null 
	,@PostingDate smalldatetime = Null 
	,@DefaultUIClassKey int = Null			-- Can be changed on screen on UI
	,@InvoiceByClassKey int = NULL			-- class for the entity, project, client, estimate, retainer
	,@GLCompanyKey int = NULL		 
	,@OfficeKey int = NULL		
	,@CreateAsApproved INT = 0	
	,@UILayoutKey int = null                -- only for Invoice By = 1 (Client) and Rollup =9 (Project/BillingItem/Item)
	,@CurrencyID varchar(10) = null
AS --Encrypt

  /*
  || When     Who Rel   What
  || 09/28/06 GHL 8.35  Added validations section
  || 10/11/06 CRG 8.35  Added Emailed column.
  || 02/01/07 GHL 8.4   Added ClassKey parm to allow users to enter class when require classes
  ||                    Bug 8154 Partners Napier
  || 06/06/07 GHL 8.4.3 Bug 9416. Added checking of billing worksheets to validation section
  || 06/29/07 GHL 8.5   Added new parms GLCompanyKey and OfficeKey
  || 08/07/07 GHL 8.5   Added call to Invoice Summary
  || 09/21/07 GHL 8437  Changes for Enh 13169
  ||                    must be able to invoice several retainers by client in one invoice now    
  || 09/26/07 GHL 8.5   Removed invoice summary since it is done in invoice recalc amounts
  || 02/08/08 GHL 8.504 (20788) Added Group by Project Type then Project
  || 04/08/08 GHL 8.508 (23712) Added new logic for classes
  || 06/18/08 GHL 8.513 added opening balance  
  || 03/18/09 GHL 10.021 (37453) Added invoice lines per billing item then item
  || 10/21/09 GHL 10.513 Do not recalculate invoice sales taxes in sptInvoiceLineUpdateTotals since we do it at the end
  || 03/24/10 GHL 10.521 Added LayoutKey 
  || 07/23/10 RLB 10.532 Change subject line to Media Estimane Name when creating invoice by Estimate 
  || 12/27/10 GHL 10.539 (97889) Added rounding of AmountBilled * @PercentOfActual (12.99 * 101 % = 13.1199 = 13.12)
  || 08/12/11 RLB 10.547 (118561) Added a check of the transaction was written off because of the changes on an old issue 56327
  || 08/24/11 GHL 10.547 (118149) When invoicing per estimate, get primary contact info from the client
  || 04/26/12 GHL 10.555 (141647) Added CreateAsApproved param 
  || 09/10/12 RLB 10.560 (87856) Changes made for enhancement...contact on retainer 
  || 10/05/12 GHL 10.560 Added Rollup 9 (Project / Billing Item/Item) and @UILayoutKey
  || 05/22/13 GHL 10.568 (179110) Take Billing Address instead of null (default from company for address)
  || 07/23/13 GHL 10.570 (181721) Added setting of the campaigns when we invoice by project/client
  || 10/01/13 GHL 10.573 Added currency parameter to support multi currency
  || 11/04/13 GHL 10.573 (194532) Fixed query when getting number of campaigns (should be count(distinct ProjectKey))
  || 01/03/14 WDF 10.576 (188500) Pass UserKey to sptInvoiceInsert
  || 10/03/14 GHL 10.584 (230462) Added rollup by Publication/Station
  || 11/11/14 GHL 10.586 Added support for titles for Abelson Taylor
  || 12/03/14 GHL 10.587 (237117) Added rollup by service/item
  || 12/15/14 GHL 10.587 Added RateLevel and BilledComments to #labor (needed because they are edited on the BWS)
  || 01/21/15 GHL 10.588 (243227) Temporary fix to correct Rollup 'by task' from the Project Transactions screen
  ||                     Was incorrectly set to 'by project' on the UI
  || 03/19/15 GHL 10.590 Added setting of Hours on invoice lines for abelson taylor
  || 04/01/15 GHL 10.590 (252013) Added patch against PTotalCost with 3 digits from Media 
 */

declare @CompanyKey int	
declare @ClientKey int
declare @ProjectKey int	
declare @MediaEstimateKey int
declare @RetainerKey int
declare @CampaignKey int
declare @PCurrencyID varchar(10)

-- if we invoice by project and the rollup is by project, change rollup to by task
if @InvoiceBy = 0 and @Rollup = 4
	select @Rollup = 1

if @InvoiceBy = 0
begin
	select @ProjectKey = @ProcessKey
	select @CompanyKey = CompanyKey
		  ,@PCurrencyID = CurrencyID  
	from tProject (nolock) where ProjectKey = @ProjectKey

	-- The CurrencyID field should be set properly when called from the stored procs
	-- But not for the transactions screen, so get it now 
	if @CurrencyID is null
		select @CurrencyID = @PCurrencyID 
end
if @InvoiceBy in (1, 2, 4)
begin
	select @ClientKey = @ProcessKey
	select @CompanyKey = OwnerCompanyKey from tCompany (nolock) where CompanyKey = @ClientKey
end
if @InvoiceBy = 3
begin
	select @MediaEstimateKey = @ProcessKey
	select @CompanyKey = CompanyKey from tMediaEstimate (nolock) where MediaEstimateKey = @MediaEstimateKey
end
if @InvoiceBy = 5
begin
	-- we now point to retainer not the client because (87856)
	select @ClientKey = ClientKey from tRetainer (nolock) where RetainerKey = @ProcessKey
	select @CompanyKey = OwnerCompanyKey from tCompany (nolock) where CompanyKey = @ClientKey
end


-- Assume done in calling sp or web page
-- create table #tProcWIPKeys (EntityType varchar(20), EntityKey varchar(50), Action int) OR
-- create table #tProcWIPKeys (ProjectKey int, EntityType varchar(20), EntityKey varchar(50), Action int)
declare @NewInvoiceKey int	
declare @BillingContact varchar(100)
declare @PrimaryContactKey int 
declare @DefaultSalesAccountKey int
declare @RetVal int
declare @TodaysDate smalldatetime
declare @DueDate smalldatetime
declare @DueDays int
declare @LineSubject varchar(100)
declare @WorkTypeKey int
declare @DefaultARAccountKey int
Declare @SalesGLAccountKey int 
Declare @PostSalesUsingDetail tinyint
Declare @InvoiceTemplateKey int
Declare @SalesTaxKey int, @SalesTax2Key int, @PaymentTermsKey int
Declare @RequireClasses tinyint
Declare @DefaultClassKey int
Declare @LayoutKey int
Declare @BillingAddressKey int
Declare @UseBillingTitles int -- this will indicate the Abelson Taylor company

	/*		
	|| Validations
	*/	
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tTime b (NOLOCK) ON b.TimeKey = cast(a.EntityKey as uniqueidentifier)
				WHERE a.EntityType = 'Time'
				AND   b.InvoiceLineKey > 0
				)
			RETURN -100
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tMiscCost b (NOLOCK) ON b.MiscCostKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'MiscExpense'
				AND   b.InvoiceLineKey > 0
				)
			RETURN -100
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tExpenseReceipt b (NOLOCK) ON b.ExpenseReceiptKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'Expense'
				AND   b.InvoiceLineKey > 0
				)
			RETURN -100		
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tVoucherDetail b (NOLOCK) ON b.VoucherDetailKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'Voucher'
				AND   b.InvoiceLineKey > 0
				)
			RETURN -100		
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tPurchaseOrderDetail b (NOLOCK) ON b.PurchaseOrderDetailKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'Order'
				AND   b.InvoiceLineKey > 0
				)
			RETURN -100		

	-- Check if anything is on a billing worksheet
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tBillingDetail bd (NOLOCK) ON bd.EntityGuid = cast(a.EntityKey as uniqueidentifier)
					INNER JOIN tBilling b (NOLOCK) ON b.BillingKey = bd.BillingKey
				WHERE a.EntityType = 'Time'
				AND   bd.Entity = 'tTime'
				AND   b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				)
			RETURN -101
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tBillingDetail bd (NOLOCK) ON bd.EntityKey = cast(a.EntityKey as integer)
					INNER JOIN tBilling b (NOLOCK) ON b.BillingKey = bd.BillingKey
				WHERE a.EntityType = 'MiscExpense'
				AND   bd.Entity = 'tMiscCost'
				AND   b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				)
			RETURN -101			
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tBillingDetail bd (NOLOCK) ON bd.EntityKey = cast(a.EntityKey as integer)
					INNER JOIN tBilling b (NOLOCK) ON b.BillingKey = bd.BillingKey
				WHERE a.EntityType = 'Expense'
				AND   bd.Entity = 'tExpenseReceipt'
				AND   b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				)
			RETURN -101	
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tBillingDetail bd (NOLOCK) ON bd.EntityKey = cast(a.EntityKey as integer)
					INNER JOIN tBilling b (NOLOCK) ON b.BillingKey = bd.BillingKey
				WHERE a.EntityType = 'Voucher'
				AND   bd.Entity = 'tVoucherDetail'
				AND   b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				)
			RETURN -101								
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tBillingDetail bd (NOLOCK) ON bd.EntityKey = cast(a.EntityKey as integer)
					INNER JOIN tBilling b (NOLOCK) ON b.BillingKey = bd.BillingKey
				WHERE a.EntityType = 'Order'
				AND   bd.Entity = 'tPurchaseOrderDetail'
				AND   b.CompanyKey = @CompanyKey
				AND   b.Status < 5
				)
			RETURN -101	
			
	-- Check if any transaction are written off
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tTime b (NOLOCK) ON b.TimeKey = cast(a.EntityKey as uniqueidentifier)
				WHERE a.EntityType = 'Time'
				AND   b.WriteOff = 1
				)
			RETURN -102
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tMiscCost b (NOLOCK) ON b.MiscCostKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'MiscExpense'
				AND  b.WriteOff = 1
				)
			RETURN -102
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tExpenseReceipt b (NOLOCK) ON b.ExpenseReceiptKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'Expense'
				AND  b.WriteOff = 1
				)
			RETURN -102		
	IF EXISTS (SELECT 1
				FROM  #tProcWIPKeys  a
					INNER JOIN tVoucherDetail b (NOLOCK) ON b.VoucherDetailKey = cast(a.EntityKey as integer)
				WHERE a.EntityType = 'Voucher'
				AND  b.WriteOff = 1
				)
			RETURN -102		

-- patch for SmartPlus and Strata sending 3 digits after decimal point
update tPurchaseOrderDetail
set    tPurchaseOrderDetail.PTotalCost = round(tPurchaseOrderDetail.PTotalCost, 2)
from   #tProcWIPKeys a
where  a.EntityType = 'Order'
and    tPurchaseOrderDetail.PurchaseOrderDetailKey = cast(a.EntityKey as integer)

	/*		
	|| Date Inits
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
	
	/*		
	|| Process actions which do not require invoices
	*/
	exec @RetVal = spProcessWIPWorksheetNoInvoice @TodaysDate, @WriteOffReasonKey
	if @RetVal < 0
	  begin
		return @RetVal
	  end
	 	
	-- Determine if there are any billable charges (greg)
	if not exists(select 1 from #tProcWIPKeys)
	  begin
		return 1
	  end

	/*		
	|| Get Invoice defaults
	*/
	
	-- If Invoice By Project
	if @InvoiceBy = 0
	begin
		--get client key
		select @ClientKey = ClientKey
		from tProject (nolock)
		where ProjectKey = @ProjectKey
		if ISNULL(@ClientKey, 0) = 0
		begin
			return -25
		end

		--get invoice defaults from project
		select @CompanyKey = p.CompanyKey
				,@BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
				,@PrimaryContactKey = u.UserKey
				,@LineSubject = p.ProjectName
				,@CampaignKey = p.CampaignKey
		from tProject p (nolock) 
				left outer join tUser u (nolock) on p.BillingContact = u.UserKey
		where p.ProjectKey = @ProjectKey

	end
		
	-- If Invoice By Client or By Client Parent
	if @InvoiceBy in (1, 2, 4)
	begin
				
		-- get invoice defaults from client
		SELECT @CompanyKey = OwnerCompanyKey
			,@LineSubject = CompanyName
		FROM   tCompany (NOLOCK)
		WHERE  CompanyKey = @ClientKey	

		-- Get the billing contact as the primary contact from the client
		select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
				,@PrimaryContactKey = u.UserKey
		from tCompany cl (nolock) 
			left outer join tUser u (nolock) on cl.PrimaryContact = u.UserKey
		Where cl.CompanyKey = @ClientKey
		
		-- For Davis, track a for a possible campaign, only if we have a single campaign
		if @InvoiceBy = 1
		begin
			if (select count(distinct p.CampaignKey) 
				from tProject p (nolock)
				inner join #tProcWIPKeys b on p.ProjectKey = b.ProjectKey
				) = 1
			select @CampaignKey = p.CampaignKey 
			from tProject p (nolock)
			inner join #tProcWIPKeys b on p.ProjectKey = b.ProjectKey
		end
		
	end
		
	-- by estimate
	if @InvoiceBy = 3
	begin
		--get client key
		select @ClientKey = ClientKey
			,@LineSubject = EstimateName
		from tMediaEstimate (nolock)
		where MediaEstimateKey = @MediaEstimateKey
		if ISNULL(@ClientKey, 0) = 0
		begin
			return -25
		end
		
		-- Get the billing contact as the primary contact from the client
		select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
				,@PrimaryContactKey = u.UserKey
		from tCompany cl (nolock) 
			left outer join tUser u (nolock) on cl.PrimaryContact = u.UserKey
		Where cl.CompanyKey = @ClientKey
		
		-- get invoice defaults from client
		SELECT @CompanyKey = OwnerCompanyKey
		FROM   tCompany (nolock)
		WHERE  CompanyKey = @ClientKey	
	end

		-- If Invoice Retainer Per Retainer
	if @InvoiceBy = 5
	begin
				
		-- get invoice defaults from client
		SELECT @CompanyKey = OwnerCompanyKey
			,@LineSubject = CompanyName
		FROM   tCompany (NOLOCK)
		WHERE  CompanyKey = @ClientKey	

		-- Get the billing contact as the primary contact from the retainer
		select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
				,@PrimaryContactKey = u.UserKey
		from tRetainer r (nolock) 
			left outer join tUser u (nolock) on r.ContactKey = u.UserKey
		Where r.RetainerKey = @ProcessKey

		if ISNULL(@PrimaryContactKey, 0) = 0
			select @BillingContact = Left(u.FirstName + ' ' + u.LastName, 100)
				,@PrimaryContactKey = u.UserKey
			from tCompany cl (nolock) 
			left outer join tUser u (nolock) on cl.PrimaryContact = u.UserKey
			Where cl.CompanyKey = @ClientKey


	end
	
	-- get other client defaults  
	Select @InvoiceTemplateKey = ISNULL(InvoiceTemplateKey, 0)
			, @SalesTaxKey = SalesTaxKey
			, @SalesTax2Key = SalesTax2Key
			, @DefaultSalesAccountKey = ISNULL(DefaultSalesAccountKey, 0)
			, @PaymentTermsKey = ISNULL(PaymentTermsKey, 0)
			, @LayoutKey = LayoutKey
			, @BillingAddressKey = BillingAddressKey
	from tCompany (nolock)
	Where CompanyKey = @ClientKey

	-- be careful in this case (Invoice By Client and By Project/Billing Item/Item)
	-- the user can pick a layout
	if @InvoiceBy = 1 And @Rollup = 9
	begin
		if isnull(@UILayoutKey, 0) > 0
			select @LayoutKey = @UILayoutKey
		else
			select @LayoutKey = null 
	end

	-- get preferences
	if @DefaultSalesAccountKey = 0
		Select @DefaultSalesAccountKey = DefaultSalesAccountKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey
		
	if @PaymentTermsKey = 0
		Select @PaymentTermsKey = PaymentTermsKey
		From tPreference (nolock)
		Where CompanyKey = @CompanyKey

	Select @PostSalesUsingDetail  = ISNULL(PostSalesUsingDetail, 0)
			,@DefaultARAccountKey = DefaultARAccountKey
			,@WorkTypeKey         = AdvBillItemKey
			,@RequireClasses      = ISNULL(RequireClasses, 0)
			,@DefaultClassKey     = DefaultClassKey
			,@UseBillingTitles	   = ISNULL(UseBillingTitles, 0)
	From tPreference (nolock)
		Where CompanyKey = @CompanyKey
			
	IF ISNULL(@PaymentTermsKey, 0) > 0
	BEGIN
		SELECT @DueDays = ISNULL(DueDays, 0)  -- Why are they NULL in the database ???
		FROM   tPaymentTerms (NOLOCK)
		WHERE  PaymentTermsKey = @PaymentTermsKey
		 	
		SELECT @DueDate = DATEADD(d, @DueDays, @InvoiceDate) 	
	END
	ELSE
		SELECT @DueDate = @TodaysDate
				
	-- Logic for classes
	Declare @HeaderClassKey int
	
	IF ISNULL(@DefaultUIClassKey, 0) = 0
	BEGIN
		IF @RequireClasses = 1
			SELECT @DefaultUIClassKey = @DefaultClassKey 
		IF @DefaultUIClassKey = 0
			SELECT @DefaultUIClassKey = NULL	
			
	END
	IF ISNULL(@InvoiceByClassKey, 0) > 0
		SELECT @HeaderClassKey = @InvoiceByClassKey 
	ELSE
		SELECT @HeaderClassKey = @DefaultUIClassKey
			   ,@InvoiceByClassKey = NULL 
	
									 
	/*		
	|| Create Invoice
	*/
				 
	exec @RetVal = sptInvoiceInsert
						@CompanyKey
						,@ClientKey
						,@BillingContact
						,@PrimaryContactKey
						,@BillingAddressKey						-- AddressKey						
						,0										-- AdvanceBill
						,null               					--InvoiceNumber
						,@InvoiceDate        					--InvoiceDate
						,@DueDate				        		--Due Date
						,@PostingDate				        	--Posting Date
						,@PaymentTermsKey  						--TermsKey
						,@DefaultARAccountKey					--Default AR Account
						,@HeaderClassKey						--ClassKey
						,@ProjectKey							--Project Key
						,null  									--HeaderComment
						,@SalesTaxKey					 		--SalesTaxKey 
						,@SalesTax2Key					 		--SalesTax2Key 
						,@InvoiceTemplateKey					--Invoice Template Key
						,@UserKey								--ApprovedBy Key -- not really used by sptInvoiceInsert
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
						,@UserKey								--CreatedByKey
						,@GLCompanyKey
						,@OfficeKey
						,0                                      --OpeningBalance
						,@LayoutKey
						,@CurrencyID							
						,1 -- exch rate
						,1 -- set exch rate
						,@NewInvoiceKey output
	if @RetVal <> 1 
	 begin
		return -5					   	
	  end
	if @@ERROR <> 0 
	  begin
		return -5					  	
	  end

	--update campaign key if needed (Invoice by project/client and there is a campaign on the project)	
	if @InvoiceBy in ( 0, 1) and isnull(@CampaignKey, 0) > 0 
	begin
		update tInvoice
		set    CampaignKey = @CampaignKey
		where  InvoiceKey = @NewInvoiceKey

		if @@ERROR <> 0 
		  begin
			return -5					   	
		  end
	end

	declare @NextTranNo varchar(100)
	declare @InvoiceStatus int
	declare @ApprovedByKey int

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
		set	  ApprovedByKey = @UserKey
			 ,InvoiceStatus = 4 -- Approved
			 ,InvoiceNumber = @NextTranNo 
		where InvoiceKey = @NewInvoiceKey

		if @@ERROR <> 0 
		begin
			return -5					   	
		end
	END
	ELSE
	BEGIN
		
		select @InvoiceStatus = InvoiceStatus
		      ,@ApprovedByKey = ApprovedByKey
		from   tInvoice (nolock)
		where  InvoiceKey = @NewInvoiceKey

		-- only if not already approved and the approver is valid, submit
		if @InvoiceStatus <> 4 And isnull(@ApprovedByKey, 0) > 0
		update tInvoice
		set    InvoiceStatus = 2
		where InvoiceKey = @NewInvoiceKey

		if @@ERROR <> 0 
		begin
			return -5					   	
		end
	END


	/*
	|| Handle single invoice line
	*/	
	if @Rollup = 0
	begin
		exec @RetVal = spProcessWIPWorksheetOneLine @NewInvoiceKey ,@ProjectKey ,@LineSubject 
			,@DefaultSalesAccountKey, @HeaderClassKey, @WorkTypeKey ,@PostSalesUsingDetail 
		if @RetVal < 0
		begin
			return @RetVal
		end
	 end

	/*
	|| Handle invoice lines by Task
	*/		
	if @Rollup = 1
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerTask @NewInvoiceKey ,@ProjectKey 
			,@DefaultSalesAccountKey , @HeaderClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end
		  
	/*
	|| Handle invoice lines by Service, expenses are on a single 'Expenses' line
	*/		
	if @Rollup = 2
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerService @NewInvoiceKey ,@ProjectKey 
			,@DefaultSalesAccountKey ,@DefaultUIClassKey, @InvoiceByClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end
		
	/*
	|| Handle invoice lines by Billing Item or WorkType
	*/		
	if @Rollup = 3
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerBillingItem @CompanyKey, @NewInvoiceKey ,@ProjectKey 
			,@DefaultSalesAccountKey ,@DefaultUIClassKey, @InvoiceByClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end
	
	/*
	|| Handle invoice lines by Project (When Invoiced By Client)
	*/		
	if @Rollup = 4
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerProject @NewInvoiceKey  
			,@DefaultSalesAccountKey ,@HeaderClassKey, @WorkTypeKey ,@PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end
	
	-- handle invoice lines by Estimate (when invoiced by Project, Client, Client Parent)
	if @Rollup = 5
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerEstimate @NewInvoiceKey  
			,@DefaultSalesAccountKey ,@HeaderClassKey, @WorkTypeKey ,@PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end	

	-- handle invoice lines by Client (when invoiced by Client Parent)
	if @Rollup = 6
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerClient @NewInvoiceKey  
			,@DefaultSalesAccountKey ,@HeaderClassKey, @WorkTypeKey ,@PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end	

	-- handle invoice lines by ProjectType + Project (when invoiced by Client)
	if @Rollup = 7
	begin
		exec @RetVal = spProcessWIPWorksheetProjectTypeProject @NewInvoiceKey  
			,@DefaultSalesAccountKey ,@HeaderClassKey, @WorkTypeKey ,@PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end	
	
	/*
	|| Handle special case of retainers
	|| Rollup will be determined in sp below
	*/
	if @InvoiceBy in (4, 5)
	begin
		exec @RetVal = spProcessWIPWorksheetRetainer @NewInvoiceKey  
			,@DefaultSalesAccountKey ,@HeaderClassKey, @WorkTypeKey ,@PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end		 
	end	
	
	/*
	|| Handle invoice lines by Billing Item or WorkType THEN Item
	*/		
	if @Rollup = 8
	begin
		exec @RetVal = spProcessWIPWorksheetOneLinePerBillingItemItem @CompanyKey, @NewInvoiceKey ,@ProjectKey 
			,@DefaultSalesAccountKey ,@DefaultUIClassKey, @InvoiceByClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end
	
	/*
	|| Handle invoice lines by Project then Billing Item or WorkType THEN Item
	|| The design is different here because we are leveraging what we did for the billing worksheets
	*/		


declare @LoopProjectKey int
declare @LoopProjectID int
declare @ParentInvoiceLineKey int

-- Layout display options
DECLARE @kDisplayOptionNoDetail INT			SELECT @kDisplayOptionNoDetail = 1
DECLARE @kDisplayOptionSubItemDetail INT	SELECT @kDisplayOptionSubItemDetail = 2
DECLARE @kDisplayOptionTransactions INT		SELECT @kDisplayOptionTransactions = 3

declare @LayoutProjectDisplayOption int

-- If by Billing Item/Item or By Service/Item, we use a core function, place transactions in this temp table
-- In Billing WS we will convert from tBillingDetail to #tran
-- Mass Billing will convert from #ProcWIPKeys to #tran
if @Rollup in (9, 14)
begin
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
		
		-- Use this for simpler grouping (Service/Item)
		GroupEntity varchar(25) null,
		GroupEntityKey int null,
		GroupName varchar(250) null,

		InvoiceLineKey int null,
		LineID int null,
		
		UpdateFlag int null
		)
	end

	if @Rollup = 9
	begin
		-- create all temp tables used by the billing worksheet subroutines

		/*
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
		
		InvoiceLineKey int null,
		LineID int null,
		
		UpdateFlag int null
		)
		*/

		CREATE TABLE #line(
		LineID int identity(1,1),
		ParentLineID int null,
		InvoiceLineKey int null,
		ParentLineKey int null,
		
		BilledAmount money null,
		Quantity decimal(24,4) null,
		UnitCost money null,
		
		Subject VARCHAR(200) null,
		Description text null,
		Taxable int null,
		Taxable2 int null,
		ClassKey int null,
		SalesAccountKey int null,
		
		WorkTypeKey int null,
		ItemKey int null, 
		ServiceKey int null,
		
		LayoutOrder int null, -- just for initial pull
		
		DisplayOption int null,
		
		UpdateFlag int null
		)

		create table #allitems (Entity varchar(20) null, EntityKey int, WorkTypeKey int
	    , EntityName varchar(200) null, Description text null
	    , StdEntityName varchar(200) null, StdDescription text null
	    , DisplayOrder int null, SalesAccountKey int null,ClassKey int null, Taxable int null, Taxable2 int null
		)

		create table #project (ProjectID int identity(1,1), ProjectKey int null, ProjectName varchar(100) null)
		
		-- cleanup ProjectKey in #tProcWIPKeys, because we are going to loop on ProjectKey 
		update #tProcWIPKeys
		set ProjectKey = isnull(ProjectKey, 0)

		if exists (select 1 from  #tProcWIPKeys where ProjectKey = 0)
			insert #project (ProjectKey, ProjectName)
			values (0, '[No Project]')
			
		insert #project (ProjectKey, ProjectName)
		select distinct isnull(a.ProjectKey, 0), p.ProjectName
		from   #tProcWIPKeys a
			inner join tProject p (nolock) on a.ProjectKey = p.ProjectKey
		order by p.ProjectName -- Will look better on the invoice if by aphabetical order

		select @LayoutKey = isnull(@LayoutKey, 0)

		SELECT @LayoutProjectDisplayOption = DisplayOption
		FROM   tLayoutBilling (nolock)
		WHERE  LayoutKey = @LayoutKey
		AND    Entity = 'tProject'
		AND    EntityKey = 0

		select @LayoutProjectDisplayOption = isnull(@LayoutProjectDisplayOption, @kDisplayOptionSubItemDetail)

		-- Get all the items/services/billing items
		-- this will populate #allitems
		exec spBillingLinesGetItems @CompanyKey, null, 0 
 
		--select * from #tProcWIPKeys
			
		select @LoopProjectID = -1
		while (1=1)
		begin
			select @LoopProjectID = min(ProjectID)
			from  #project
			where ProjectID > @LoopProjectID

			if @LoopProjectID is null
				break

			select @LineSubject = ProjectName
			      ,@LoopProjectKey = ProjectKey 
			from #project
			where ProjectID = @LoopProjectID	

			--create single invoice line for the project
			exec @RetVal = sptInvoiceLineInsertMassBilling
						   @NewInvoiceKey				-- Invoice Key
														-- (GHL 6/29/06, set to NULL instead of @ProjectKey)
														-- (GHL 4/23/10 put it back for custom fields)
						  ,@LoopProjectKey					-- ProjectKey 
						  ,NULL							-- TaskKey
						  ,@LineSubject					-- Line Subject
						  ,NULL                 		-- Line description
						  ,0		      				-- Bill From 
						  ,0							-- Quantity
						  ,0							-- Unit Amount
						  ,0							-- Line Amount
						  ,1							-- line type = Summary
						  ,0							-- parent line key
						  ,null -- @SalesAccountKey				-- Default Sales AccountKey (because displayed on screen)
						  ,null				             -- Class Key
						  ,0							-- Taxable
						  ,0							-- Taxable2
						  ,@WorkTypeKey					-- Work TypeKey???
						  ,@PostSalesUsingDetail
						  ,NULL							-- Entity
						  ,NULL							-- EntityKey
						  ,NULL							-- OfficeKey
						  ,NULL							-- DepartmentKey
						  ,@ParentInvoiceLineKey output

			if @@ERROR <> 0 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -1 -- check error returns later				 	
			  end			   		     		 
			if @RetVal <> 1 
			  begin
				exec sptInvoiceDelete @NewInvoiceKey
				return -1					 	
			  end

			  -- DisplayOption from tLayoutBilling must be set for the project
			update tInvoiceLine 
			set    DisplayOption = @LayoutProjectDisplayOption
			where  InvoiceLineKey = @ParentInvoiceLineKey

			-- apply custom billing item descriptions
			exec spBillingLinesUpdateItems 'tProject', @LoopProjectKey
				
			-- this will populate #tran
			truncate table #tran
			exec spProcessWIPWorksheetGetTrans @LoopProjectKey	  
 
			-- this will populate #line from #tran and #allitems and the layout
			exec spBillingLinesGetFromLayout @CompanyKey,@LayoutKey, 'tProject', @LoopProjectKey
				,@DefaultSalesAccountKey,@DefaultUIClassKey,@InvoiceByClassKey, 0 --@GetItemInfo 
		
			--select * from #tran
			--select * from #line

			-- this will create tInvoiceLine recs from #line
			exec @RetVal = spBillingLinesInsert @CompanyKey,@NewInvoiceKey,@LoopProjectKey ,@DefaultSalesAccountKey ,@DefaultUIClassKey
				,@ParentInvoiceLineKey,@PostSalesUsingDetail, 0

			IF @RetVal < 0
			BEGIN
				EXEC sptInvoiceDelete @NewInvoiceKey
				RETURN -1
			END
	
		end -- project loop

		-- DisplayOption is null if LayoutKey = 0 
		-- by default
		-- I apply the SubItemDetail disp option to summary tasks
		-- I apply the NoDetail disp option to detail tasks
	
		update tInvoiceLine
		set    DisplayOption = 2 --@kDisplayOptionSubItemDetail
		where  InvoiceKey = @NewInvoiceKey
		and    LineType = 1 -- @kLineTypeSummary
		and    isnull(DisplayOption, 0) = 0
    	
		update tInvoiceLine
		set    DisplayOption = 1 -- @kDisplayOptionNoDetail
		where  InvoiceKey = @NewInvoiceKey
		and    LineType = 2 -- @kLineTypeDetail
		and    isnull(DisplayOption, 0) = 0

	end -- rollup =9
	

	/*
	|| Handle invoice lines by Publication/Station
	*/		
	if @Rollup = 10
	begin
		-- This will also copy the taxes from orders/vouchers to invoices
		exec @RetVal = spProcessWIPWorksheetOneLinePerPublication @NewInvoiceKey ,@ProjectKey 
			,@DefaultSalesAccountKey ,@DefaultUIClassKey, @InvoiceByClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end
	end

	/*
	|| Handle invoice lines by title for Abelson/Taylor
	*/		
	if @Rollup in (11, 12, 13)
	begin
		-- Use a stored proc created for both mass billing and billing worksheet
		
		 CREATE TABLE #labor (TimeKey uniqueidentifier null
		  , ActualRate decimal(24,4) null
		  , ActualHours decimal(24,4) null
		  , BillAmount money null
		  , ServiceKey int null
		  , TitleKey int null 
		  , RateLevel int null
          , Comments varchar(2000) null

		  , GroupEntity varchar(50) null
		  , GroupEntityKey int null
		  , SubGroupEntity varchar(50) null
		  , SubGroupEntityKey int null

		  , InvoiceLineKey int null
		  )
  
		  CREATE TABLE #expense (Entity varchar(25) null
			, EntityKey int null
			, BillAmount money  null
	
			, GroupEntity varchar(50) null
			, GroupEntityKey int null
			, SubGroupEntity varchar(50) null
			, SubGroupEntityKey int null

			, InvoiceLineKey int null
		  )              
		  
		-- load labor
		insert #labor (TimeKey, ActualRate, ActualHours, ServiceKey, TitleKey)
		select cast(#tProcWIPKeys.EntityKey as uniqueidentifier), tTime.ActualRate, tTime.ActualHours, tTime.ServiceKey, tTime.TitleKey 
		from #tProcWIPKeys, tTime (nolock)
			where #tProcWIPKeys.EntityType = 'Time'
			and tTime.TimeKey = cast(#tProcWIPKeys.EntityKey as uniqueidentifier)
			and #tProcWIPKeys.Action = 1
			 
		update #labor set BillAmount = Round ( isnull(ActualRate, 0) * isnull(ActualHours, 0), 2 ) 

		-- load expenses
		insert #expense (Entity, EntityKey)
		select EntityType, cast(EntityKey as integer)
		from #tProcWIPKeys
		where #tProcWIPKeys.EntityType <> 'Time'
		and #tProcWIPKeys.Action = 1
		
		update #expense
		set    #expense.BillAmount = t.BillableCost
		from   tExpenseReceipt t (nolock)
		where  #expense.Entity = 'Expense'
		and    t.ExpenseReceiptKey = #expense.EntityKey		 

		update #expense
		set    #expense.BillAmount = t.BillableCost
		from   tMiscCost t (nolock)
		where  #expense.Entity = 'MiscExpense'
		and    t.MiscCostKey = #expense.EntityKey		 

		update #expense
		set    #expense.BillAmount = t.BillableCost
		from   tVoucherDetail t (nolock)
		where  #expense.Entity = 'Voucher'
		and    t.VoucherDetailKey = #expense.EntityKey		 

		update #expense
		set    #expense.BillAmount = case po.BillAt
			When 0 then isnull(BillableCost,0)
			When 1 then isnull(PTotalCost,isnull(TotalCost,0))
			When 2 then isnull(BillableCost,0) - isnull(PTotalCost,isnull(TotalCost,0)) 
			Else isnull(BillableCost,0)
			end 
		from   tPurchaseOrderDetail t (nolock)
		      ,tPurchaseOrder po (nolock)
		where  #expense.Entity = 'Order'
		and    t.PurchaseOrderDetailKey = #expense.EntityKey		 
		and    t.PurchaseOrderKey = po.PurchaseOrderKey

		declare @TitleRollup varchar(25)
		if @Rollup = 11
			select @TitleRollup = 'TitleOnly'
		else if @Rollup = 12
			select @TitleRollup = 'TitleService'
		else if @Rollup = 13
			select @TitleRollup = 'ServiceTitle'

		exec @RetVal = spBillingPerTitle @NewInvoiceKey , @TitleRollup, @ProjectKey 
			,@DefaultSalesAccountKey ,@DefaultUIClassKey, @InvoiceByClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end

		update tInvoiceLine
		set    DisplayOption = case when LineType =1 then 2 else 1 end
		where  InvoiceKey = @NewInvoiceKey
		and    DisplayOption is null

	end

	/*
	|| Handle invoice lines by Service/Item, expenses are grouped by item (ie. not a single line)
	*/		
	if @Rollup = 14
	begin
		-- Copy keys from #procwipkeys to #tran, no need to specify project (pass a null)
		exec spProcessWIPWorksheetGetTrans null

		-- call core function to create lines per service or item
		exec @RetVal = spBillingPerServiceItem @NewInvoiceKey ,@ProjectKey 
			,@DefaultSalesAccountKey ,@DefaultUIClassKey, @InvoiceByClassKey, @PostSalesUsingDetail 
	  	if @RetVal < 0
		begin
			return @RetVal
		end

		update tInvoiceLine
		set    DisplayOption = case when LineType =1 then 2 else 1 end
		where  InvoiceKey = @NewInvoiceKey
		and    DisplayOption is null
	end

	--Update Lines for the percent of actual billing amount
	Declare @CurKey int
	if @PercentOfActual <> 1
	begin
		Select @CurKey = -1
		while 1=1
		begin
			Select @CurKey = min(InvoiceLineKey) from tInvoiceLine (nolock) Where InvoiceKey = @NewInvoiceKey and InvoiceLineKey > @CurKey
			if @CurKey is null
				break
				
			Update tTime Set BilledRate = ROUND(Cast(BilledRate as decimal) * @PercentOfActual, 2) Where InvoiceLineKey = @CurKey
			Update tExpenseReceipt Set AmountBilled = ROUND(AmountBilled * @PercentOfActual, 2) Where InvoiceLineKey = @CurKey
			Update tMiscCost Set AmountBilled = ROUND(AmountBilled * @PercentOfActual, 2) Where InvoiceLineKey = @CurKey
			Update tVoucherDetail Set AmountBilled = ROUND(AmountBilled * @PercentOfActual, 2) Where InvoiceLineKey = @CurKey
			Update tPurchaseOrderDetail Set AmountBilled = ROUND(AmountBilled * @PercentOfActual, 2) Where InvoiceLineKey = @CurKey
			
			-- do not recalc sales taxes at the invoice level or the invoice line level since we do it at the end (pass 2 zeroes)
			exec sptInvoiceLineUpdateTotals @CurKey, 0, 0
		end
	end
	
	-- before we leave, better to recalc the amounts in the header  
	if @Rollup = 10
		-- If by publication, rollup taxes
		exec sptInvoiceRollupAmounts @NewInvoiceKey
	else
		-- else we only set the Taxable fields, so recalc 
		exec sptInvoiceRecalcAmounts @NewInvoiceKey 
	
	-- Calculate the line order and position
	exec sptInvoiceOrder @NewInvoiceKey, 0, 0, 0

	-- this is for Abelson Taylor, rollup hours on invoicelines
	exec  sptInvoiceLineSetHours @NewInvoiceKey

	return @NewInvoiceKey
GO
