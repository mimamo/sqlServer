USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateSetup]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateSetup]
	@ProjectKey int,
	@CompanyKey int,
	@ProjectName varchar(100),
	@ProjectNumber varchar(50),
	@ProjectTypeKey int,
	@ClientDivisionKey int,
	@ClientProductKey int,
	@ClientKey int,
	@CampaignKey int,
	@ClientProjectNumber varchar(200),
	@RequestKey int,
	@BillingContact int, 
	@CustomFieldKey int,
	@OfficeKey int,
	@GLCompanyKey int,
	@GLCompanySource smallint,
	@ClassKey int,
	@AccountManager int,
	@Closed tinyint,
	@ProjectStatusKey int,
	@ProjectBillingStatusKey int,
	@StatusNotes varchar(100),
	@DetailedNotes varchar(4000),
	@ClientNotes varchar(4000),
	@Description text,
	@ImageFolderKey int,
	@KeyPeople1 int,
	@KeyPeople2 int,
	@KeyPeople3 int,
	@KeyPeople4 int,
	@KeyPeople5 int,
	@KeyPeople6 int,
	@StartDate smalldatetime,
	@CompleteDate smalldatetime,
	@WorkMon tinyint,
	@WorkTue tinyint,
	@WorkWed tinyint,
	@WorkThur tinyint,
	@WorkFri tinyint,
	@WorkSat tinyint,
	@WorkSun tinyint,
	@ScheduleDirection smallint,
	@FlightStartDate smalldatetime,
	@FlightEndDate smalldatetime,
	@FlightInterval tinyint,
	@ProjectColor varchar(10),
	@CampaignBudgetKey int,
	@TeamKey int,
	@LeadKey int,
	@LayoutKey int,
	@CampaignSegmentKey int,
	
	@GetRateFrom smallint,
	@HourlyRate money,
	@TimeRateSheetKey int,
	@TitleRateSheetKey int,
	@OverrideRate tinyint,
	@NonBillable tinyint,
	@UtilizationType varchar(50),
	@GetMarkupFrom smallint,
	@ItemRateSheetKey int,
	@ItemMarkup decimal(24,4),
	@IOCommission decimal(24,4),
	@BCCommission decimal(24,4),
	@Template tinyint,
	@RetainerKey int,
	@BillingMethod smallint,
	@ExpensesNotIncluded tinyint,
	@AutoIDTask smallint = -1, --smallint so we can default to -1
	@SimpleSchedule smallint = -1, --smallint so we can default to -1

	@ClientBHours tinyint = 1,
	@ClientBLabor tinyint = 1,
	@ClientBCO tinyint = 1,
	@ClientBExpenses tinyint = 1,
	@ClientAHours tinyint = 1,
	@ClientALabor tinyint = 1,
	@ClientAPO tinyint = 1,
	@ClientAExpenses tinyint = 1,

	@ShowTransactionsOnInvoices tinyint = 0,
	@DoNotPostWIP tinyint = 0,
	@BillingGroupKey int = null,
	@ModelYear varchar(10) = null,
	@BillingManagerKey int = null,
	@CurrencyID varchar(10) = null,
	@AnyoneChargeTime tinyint = 0
 
AS --Encrypt

  /*
  || When     Who Rel      What
  || 10/13/06 GHL 8.4      Limited validation of Start/Complete dates against Scheduled tasks only  
  || 12/13/06 GHL 8.4      Removed validation of Start/Complete dates at user's request
  || 04/18/07 QMD 8.4.2    Added Project Color
  || 05/22/07 CRG 8.4.3    Added CampaignBudgetKey  
  || 07/05/07 GHL 8.5      Added check of tRetainer.GLCompanyKey       
  || 11/16/07 GHL 8.5      Added checking of client in tTransaction       
  || 12/10/07 GWG 8.5      Changed locking logic on office and company to be more selective based on the show options. 
  || 12/29/08 CRG 10.0.1.5 (39387) Added TeamKey parameter.
  || 01/10/09 GWG 10.0.1.6 Commented out the update to custom field key, should never be updated except by custom field routines.
  || 01/27/09 MFT 10.0.1.8 (45458) Trim leading and trailing spaces from ProjectNumber; Replace same strings from ProjectNumber as in sptProjectCreate
  || 01/29/09 MFT 10.0.1.8 (45145) (45415) Added RETURN -6 to trap for missing ProjectStatusKey record
  || 03/16/09 QMD 10.5	   Remove User Defined Fields
  || 07/14/09 GHL 10.505   (56909) Allowing now change of client even if there are some posted transactions
  ||                        Also updating now CASH basis GL transactions
  || 12/20/09 GWG 10.5.1.5 Added Segment and layout keys (cmp updated as well with hidden fields) Also Merged the update acct routine to make one call and sperate from cmp
  || 3/2/10   CRG 10.5.1.9  Added @AutoIDTask and @SimpleSchedule
  || 5/13/10  CRG 10.5.2.2  (80503) Now returning an error if the campaign client is not the same as the project client and the campaign's BillBy is not set to Project.
  || 8/19/10  GHL 10.5.3.4  If we changed the campaign, make sure that the project is not on an approved campaign estimate
  || 12/7/10  RLB 10.5.3.9  (96122) IF Campaign was removed update any Campaign Estimates by Project to reflect that the project was removed
  || 1/17/11  RLB 10.5.4.0  (100586) Added some validation on project status when closing a project
  || 09/21/11 RLB 10.5.4.8  (119193) Added for this enhancement
  || 10/13/11 GHL 10.4.5.9 Added new entity CREDITCARD 
  || 10/27/11 GWG 10.5.4.9  Added flags for setting columns in client budget grid
  || 04/02/11 GWG 10.5.5.4  Added GLCompanySource
  || 05/02/12 RLB 10.5.5.5  (125332) Added check for any unbilled PO's that are not closed when closing a project
  || 05/21/12 GHL 10.5.5.6  Added @ShowTransactionsOnInvoices for a customization at Etna
  || 05/23/12 GWG 10.5.5.6  Added more error return codes on closing so people can tell why it will not close
  || 05/29/12 RLB 10.5.5.6  (143337) Fixed to only null the project close date if the project closed was unchecked
  || 07/05/12 RLB 10.5.5.7  (148224) if there was a projectclosedate it was not getting  set on the update
  || 07/17/12 GHL 10.5.5.8  Added DoNotPostWIP and BillingGroupCode for customizations for HMI
  || 09/26/12 GHL 10.5.6.0  Changed BillingGroupCode to BillingGroupKey (new table tBillingGroup)
  || 02/12/13 GHL 10.5.6.5  (167857) Added ModelYear for a customization for Spark44
  || 06/15/13 GWG 10.5.6.9  Added code to remap offices if it is different
  || 08/26/13 RLB 10.5.7.1  (170225) Adding BillingManagerKey update
  || 09/12/13 GHL 10.5.7.2  Added currency ID
  || 02/13/14 PLC 10.5.7.7  Added TransferOutDate is null to open items logic
  || 09/24/14 MAS 10.5.8.4  Added TitleRateSheetKey for Abelson & Taylor
  || 11/05/14 RLB 10.5.8.6  Added AnyoneChargeTime for Abelson & Taylor
  || 02/02/15 GHL 10.5.8.8  Added validation of change of division/product for Abelson & Taylor
  || 02/27/15  GHL 10.5.8.9 For Abelson, do not consider transferred transactions when setting the lock of divisions
    */
  
Declare @Active tinyint
Declare @AllowTime tinyint
Declare @AllowExpense tinyint
Declare @CurClosed tinyint
Declare @RetainerGLCompanyKey int
Declare @RetainerCurrencyID varchar(10)
Declare @CampaignCurrencyID varchar(10)
Declare @BillingGroupGLCompanyKey int
Declare @OldClientKey int, @OldOfficeKey int
Declare @OldClientDivisionKey int, @OldClientProductKey int

DECLARE	@CurAutoIDTask tinyint,
		@CurSimpleSchedule tinyint,
		@CurCampaignKey int,
		@CurCurrencyID varchar(10),
		@ProjectCloseDate smalldatetime

Declare @LockCompany int, @UseGLCompany tinyint, @UseOffice tinyint, @MultiCurrency int, @LockDivisionProduct int
DECLARE @IOClientLink int, @BCClientLink int
	
IF EXISTS(
	SELECT 1 FROM tProject (NOLOCK) 
	WHERE
		ProjectNumber = @ProjectNumber AND
		CompanyKey = @CompanyKey AND
		ProjectKey <> @ProjectKey AND
		Deleted = 0
		)
	RETURN -1

	SELECT @Active = IsActive, @AllowTime = TimeActive, @AllowExpense = ExpenseActive
	FROM tProjectStatus (NOLOCK) 
	WHERE ProjectStatusKey = @ProjectStatusKey
	
	IF @Active IS NULL RETURN -6
	
	IF @Closed = 1 and @Active = 1 
		return -2

	if @Closed = 1 and @Active = 0 and (@AllowTime = 1 OR @AllowExpense = 1)
		return -9
	
	Select @CurClosed = Closed
		  ,@OldClientKey = ClientKey
		  ,@OldOfficeKey = ISNULL(OfficeKey, 0)
		  ,@CurAutoIDTask = AutoIDTask
		  ,@CurSimpleSchedule = SimpleSchedule
		  ,@CurCampaignKey = CampaignKey
		  ,@CurCurrencyID = CurrencyID
		  ,@ProjectCloseDate = ProjectCloseDate
		  ,@OldClientProductKey = ClientProductKey
		  ,@OldClientDivisionKey = ClientDivisionKey
	from tProject (nolock) 
	Where ProjectKey = @ProjectKey

	IF @AutoIDTask = -1
		SELECT @AutoIDTask = @CurAutoIDTask
		
	IF @SimpleSchedule = -1
		SELECT @SimpleSchedule = @CurSimpleSchedule
	
	if @Closed = 1 and @CurClosed = 0
	BEGIN
		If Exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0 and TransferOutDate is null)
			return -301
		If Exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0 and VoucherDetailKey is null  and TransferOutDate is null)
			return -302
		If Exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0 and TransferOutDate is null)
			return -303
		If Exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0 and TransferOutDate is null)
			return -304
		If Exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and Closed = 0 and TransferOutDate is null)
			return -305
	END
	
	/*	
	IF @ScheduleDirection = 1
	BEGIN	
		If Exists (Select 1 From tTask (NOLOCK) 
					Where ProjectKey = @ProjectKey
					And   (ConstraintDate < @StartDate Or ActStart < @StartDate	
						   Or ActComplete < @StartDate
						   )
					And   ScheduleTask = 1
					)
			return -4	
	END
	ELSE
	BEGIN
		If Exists (Select 1 From tTask (NOLOCK) 
					Where ProjectKey = @ProjectKey
					And   (ConstraintDate > @CompleteDate Or ActStart > @CompleteDate
						   Or ActComplete > @CompleteDate
						   )
					And   ScheduleTask = 1
					)
			return -4
			
	END		
	*/

Select @UseGLCompany = ISNULL(UseGLCompany, 0)
      ,@UseOffice = ISNULL(UseOffice, 0) 
	  ,@IOClientLink = ISNULL(IOClientLink, 1)
	  ,@BCClientLink = ISNULL(BCClientLink, 1)
	  ,@MultiCurrency = ISNULL(MultiCurrency, 0)
from tPreference (nolock) 
Where CompanyKey = @CompanyKey

Select @LockCompany = 0
Select @LockDivisionProduct = 0

	if exists(Select 1 from tInvoiceLine (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
	
	if @LockCompany = 0 And exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
			
	if exists(Select 1 from tBilling (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
			  ,@LockDivisionProduct = 1

	if @LockDivisionProduct = 0 And exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		      ,@LockDivisionProduct = 1

	if @LockDivisionProduct = 0 And exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		      ,@LockDivisionProduct = 1

	if @LockDivisionProduct = 0 And exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		      ,@LockDivisionProduct = 1

	if @LockDivisionProduct = 0 And exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey > 0)
		Select @LockCompany = 1
		      ,@LockDivisionProduct = 1

	if @LockDivisionProduct = 0 And exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
			,@LockDivisionProduct = 1

	if @LockCompany = 1
	BEGIN
		if @UseGLCompany = 1
			Select @GLCompanyKey = GLCompanyKey, @GLCompanySource = GLCompanySource from tProject (nolock) Where ProjectKey = @ProjectKey
		--if @UseOffice = 1
			--Select @OfficeKey = OfficeKey from tProject (nolock) Where ProjectKey = @ProjectKey
	END
	

	if exists (select 1 from tPreference pref (nolock)
			inner join tProject p (nolock) on pref.CompanyKey = p.CompanyKey 
            where p.ProjectKey = @ProjectKey
			and   lower(pref.Customizations) like '%abelson%' 
		  )
	begin
		-- if allready locked, no need to check further, so only do this if @LockDivisionProduct = 0 
		if @LockDivisionProduct = 0
		begin
			-- we have already checked if transactions were billed or in WIP
			-- we need to check now if transactions where marked as billed or written off  
			if exists (Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1))
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1)
				and TransferToKey is null)
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1)
				and TransferToKey is null)
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey >= 0
				and TransferToKey is null)
				Select @LockDivisionProduct = 1

			if @LockDivisionProduct = 0 and exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey = 0 or WriteOff = 1)
				and TransferToKey is null)
				Select @LockDivisionProduct = 1

		end

		if @LockDivisionProduct = 1 and isnull(@ClientDivisionKey, 0) <> isnull(@OldClientDivisionKey, 0)
			select @ClientDivisionKey = @OldClientDivisionKey

		if @LockDivisionProduct = 1 and isnull(@ClientProductKey, 0) <> isnull(@OldClientProductKey, 0)
			select @ClientProductKey = @OldClientProductKey

	end


	IF ISNULL(@OldClientKey, 0) > 0 AND ISNULL(@OldClientKey, 0) <> ISNULL(@ClientKey, 0)
	BEGIN 	
		If EXISTS (SELECT 1 FROM tTransaction (NOLOCK) 
					WHERE CompanyKey = @CompanyKey
					AND   Entity NOT IN ('VOUCHER', 'CREDITCARD')       -- do not include vouchers
					AND   ProjectKey = @ProjectKey
					AND   ClientKey = @OldClientKey
					)
					Return -4
	END	
	
	IF ISNULL(@OldOfficeKey, 0) <> ISNULL(@OfficeKey, 0)
	BEGIN 	
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tCashTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tCashTransactionLine Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tVoucher Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tVoucherDetail Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tInvoice Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tInvoiceLine Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tInvoiceSummary Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tJournalEntryDetail Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tQuoteDetail Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tPurchaseOrderDetail Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tProject Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
		Update tTransaction Set OfficeKey = @OfficeKey Where ProjectKey = @ProjectKey
	END			

	-- if billing by retainer
	If @BillingMethod = 3
	Begin
		Select @RetainerGLCompanyKey = GLCompanyKey
		      ,@RetainerCurrencyID = CurrencyID
		From tRetainer (NOLOCK) 
		Where RetainerKey = @RetainerKey
		
		If isnull(@RetainerGLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
			Return -5

		if @MultiCurrency = 1 And isnull(@RetainerCurrencyID, '')  <> isnull(@CurrencyID, '') 
			Return -11
	End

	-- if billing by Billing Group 
	If isnull(@BillingGroupKey, 0) > 0
	Begin
		Select @BillingGroupGLCompanyKey = GLCompanyKey
		From tBillingGroup (NOLOCK) 
		Where BillingGroupKey = @BillingGroupKey
		
		If isnull(@BillingGroupGLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
			Return -10
	End
	 
	-- if billing by campaign, unfortunately, the campaigns initially had no GLCompanyKey, so it is difficult to validate GL comps
	IF ISNULL(@CampaignKey, 0) > 0
	BEGIN
		DECLARE @CampaignClientKey int,
				@BillBy smallint
		
		SELECT	@CampaignClientKey = ClientKey,
				@BillBy = BillBy,
				@CampaignCurrencyID = CurrencyID 
		FROM	tCampaign (nolock)
		WHERE	CampaignKey = @CampaignKey
		
		IF @ClientKey <> @CampaignClientKey AND @BillBy <> 1
			RETURN -7 --The campaign must be for the same client, unless the campaign's BillBy is set to "Project" (1)
	
		if @MultiCurrency = 1 And isnull(@CampaignCurrencyID, '')  <> isnull(@CurrencyID, '') 
			Return -12
	END	
	
	If @MultiCurrency = 1 And isnull(@CurCurrencyID, '') <> isnull(@CurrencyID, '')
	begin
		-- A currency must be as tight as a company
		-- so if the company is locked and the currency is changed, return an error
		if @LockCompany = 1
			 RETURN -13
	end 
	 
	-- If we changed the campaign, make sure that the project is not on an approved campaign estimate 
	IF ISNULL(@CurCampaignKey, 0) > 0 And ISNULL(@CampaignKey, 0) <> ISNULL(@CurCampaignKey, 0)
	BEGIN
		declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY

		declare @EstimateTotal money
		declare @LaborGross money
		declare @ExpenseGross money
		declare @TaxableTotal money
		declare @ContingencyTotal money
		declare @LaborNet money
		declare @ExpenseNet money
		declare @Hours decimal(24,4)
		declare @CampaignEstimateKey int

		if exists (select 1 
					from tEstimate e (nolock)
					inner join tEstimateProject ep (nolock) on  e.EstimateKey = ep.EstimateKey
					where e.CompanyKey = @CompanyKey
					and   e.InternalStatus = 4
					and   ep.ProjectKey = @ProjectKey)
			RETURN -8
			
			-- Added to update any Campaign Estimates by project this project was on
			select @CampaignEstimateKey = -1
			while (1=1)
				begin
					select @CampaignEstimateKey = min(e.EstimateKey) 
					from   tEstimate e (nolock)
					inner join tEstimateProject ep (nolock) on e.EstimateKey = ep.EstimateKey
					where  e.CampaignKey = @CurCampaignKey
					and    ep.ProjectKey = @ProjectKey
					and    e.EstimateKey > @CampaignEstimateKey 

						if @CampaignEstimateKey is null
						break
							DELETE tEstimateProject 
							WHERE  ProjectKey = @ProjectKey
							and    EstimateKey = @CampaignEstimateKey
							 
							select @EstimateTotal = sum(e.EstimateTotal)
								  ,@LaborGross = sum(e.LaborGross)
								  ,@ExpenseGross = sum(e.ExpenseGross)
								  ,@SalesTax1Amount = sum(e.SalesTaxAmount)
								  ,@SalesTax2Amount = sum(e.SalesTax2Amount)
								  ,@TaxableTotal = sum(e.TaxableTotal)
								  ,@ContingencyTotal = sum(e.ContingencyTotal)
								  ,@LaborNet = sum(e.LaborNet)
								  ,@ExpenseNet = sum(e.ExpenseNet)
								  ,@Hours = sum(e.Hours)

							from  tEstimateProject ep (nolock)
								inner join tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey 
							where ep.EstimateKey = @CampaignEstimateKey
	
							UPDATE tEstimate
								SET    EstimateTotal	= ISNULL(@EstimateTotal, 0) 
									  ,LaborGross		= ISNULL(@LaborGross, 0)
									  ,ExpenseGross		= ISNULL(@ExpenseGross, 0)
									  ,SalesTaxAmount   = ISNULL(@SalesTax1Amount, 0)
									  ,SalesTax2Amount  = ISNULL(@SalesTax2Amount, 0)
									  ,TaxableTotal		= ISNULL(@TaxableTotal, 0)
									  ,ContingencyTotal	= ISNULL(@ContingencyTotal, 0)
									  ,LaborNet			= ISNULL(@LaborNet, 0)
									  ,ExpenseNet		= ISNULL(@ExpenseNet, 0)	
									  ,Hours			= ISNULL(@Hours, 0)	
								WHERE EstimateKey		= @CampaignEstimateKey
				end
	END

	if @Closed = 1 and @CurClosed = 0
	
		Select @ProjectCloseDate = GETUTCDATE()
	
	if @Closed = 0 and @CurClosed = 1
		Select @ProjectCloseDate = NULL

	BEGIN TRAN
	
	UPDATE
		tProject
	SET
		ClientKey = @ClientKey,
		CampaignKey = @CampaignKey,
		ProjectName = @ProjectName,
		ProjectNumber = LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(@ProjectNumber, '&', ''), ',', ''), '"', ''), '''', ''))),
		ProjectTypeKey = @ProjectTypeKey,
		ClientDivisionKey = @ClientDivisionKey,
		ClientProductKey = @ClientProductKey,
		ClientProjectNumber = @ClientProjectNumber,
		RequestKey = @RequestKey,
		BillingContact = @BillingContact,
		--CustomFieldKey = @CustomFieldKey,
		OfficeKey = @OfficeKey,
		GLCompanyKey = @GLCompanyKey,
		GLCompanySource = @GLCompanySource,
		ClassKey = @ClassKey,
		AccountManager = @AccountManager,
		Closed = @Closed,
		ProjectCloseDate = @ProjectCloseDate,
		ProjectStatusKey = @ProjectStatusKey,
		ProjectBillingStatusKey = @ProjectBillingStatusKey,
		ImageFolderKey = @ImageFolderKey,
		Active = @Active,
		KeyPeople1 = @KeyPeople1,
		KeyPeople2 = @KeyPeople2,
		KeyPeople3 = @KeyPeople3,
		KeyPeople4 = @KeyPeople4,
		KeyPeople5 = @KeyPeople5,
		KeyPeople6 = @KeyPeople6,
		StatusNotes = @StatusNotes,
		DetailedNotes = @DetailedNotes,
		ClientNotes = @ClientNotes,
		Description = @Description,
		StartDate = @StartDate,
		CompleteDate = @CompleteDate,
		WorkMon = @WorkMon,
		WorkTue = @WorkTue,
		WorkWed = @WorkWed,
		WorkThur = @WorkThur,
		WorkFri = @WorkFri,
		WorkSat = @WorkSat,
		WorkSun = @WorkSun,
		ScheduleDirection = @ScheduleDirection,
		FlightStartDate = @FlightStartDate,
		FlightEndDate = @FlightEndDate,
		FlightInterval = @FlightInterval,
		ProjectColor = @ProjectColor,
		CampaignBudgetKey = @CampaignBudgetKey,
		TeamKey = @TeamKey,
		LeadKey = @LeadKey,
		LayoutKey = @LayoutKey,
		CampaignSegmentKey = @CampaignSegmentKey,
		
		GetRateFrom = @GetRateFrom,
		HourlyRate = @HourlyRate,
		TimeRateSheetKey = @TimeRateSheetKey,
		TitleRateSheetKey = @TitleRateSheetKey,
		OverrideRate = @OverrideRate,
		NonBillable = @NonBillable,
		UtilizationType = @UtilizationType,
		GetMarkupFrom = @GetMarkupFrom,
		ItemRateSheetKey = @ItemRateSheetKey,
		ItemMarkup = @ItemMarkup,
		IOCommission = @IOCommission,
		BCCommission = @BCCommission,
		Template = @Template,
		RetainerKey = CASE WHEN @BillingMethod = 3 THEN @RetainerKey ELSE NULL END,
		BillingMethod = @BillingMethod,
		ExpensesNotIncluded = @ExpensesNotIncluded,
		AutoIDTask = @AutoIDTask,
		SimpleSchedule = @SimpleSchedule,

		ClientBHours = @ClientBHours,
		ClientBLabor = @ClientBLabor,
		ClientBCO = @ClientBCO,
		ClientBExpenses = @ClientBExpenses,
		ClientAHours = @ClientAHours,
		ClientALabor = @ClientALabor,
		ClientAPO = @ClientAPO,
		ClientAExpenses = @ClientAExpenses,

		ShowTransactionsOnInvoices = @ShowTransactionsOnInvoices,
		DoNotPostWIP = @DoNotPostWIP,
		BillingGroupKey = @BillingGroupKey,
		ModelYear = @ModelYear,
		BillingManagerKey = @BillingManagerKey,
		CurrencyID = @CurrencyID,
		AnyoneChargeTime = @AnyoneChargeTime
		 
	WHERE
		ProjectKey = @ProjectKey 
		
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -100
	END
	
	IF @ProjectKey > 0  AND ISNULL(@OldClientKey, 0) <> ISNULL(@ClientKey, 0)
	BEGIN 	
		UPDATE tVoucherDetail
		SET    ClientKey = @ClientKey
		WHERE  ProjectKey = @ProjectKey	 
		--AND    ClientKey = @OldClientKey
		AND    isnull(ItemKey, 0) = 0

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
	
		UPDATE tVoucherDetail
		SET    tVoucherDetail.ClientKey = @ClientKey
		FROM   tItem i (nolock)  
		WHERE  tVoucherDetail.ProjectKey = @ProjectKey	 
		--AND    tVoucherDetail.ClientKey = @OldClientKey
		AND    tVoucherDetail.ItemKey = i.ItemKey
        AND    i.ItemType IN (0, 3)

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
       
        IF @IOClientLink = 1  
		BEGIN
			UPDATE tVoucherDetail
			SET    tVoucherDetail.ClientKey = @ClientKey
			FROM   tItem i (nolock)  
			WHERE  tVoucherDetail.ProjectKey = @ProjectKey	 
			--AND    tVoucherDetail.ClientKey = @OldClientKey
			AND    tVoucherDetail.ItemKey = i.ItemKey
			AND    i.ItemType = 1 -- IO
        
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -100
			END
	       
        END
        
		IF @BCClientLink = 1  
		BEGIN
			UPDATE tVoucherDetail
			SET    tVoucherDetail.ClientKey = @ClientKey
			FROM   tItem i (nolock)  
			WHERE  tVoucherDetail.ProjectKey = @ProjectKey	 
			--AND    tVoucherDetail.ClientKey = @OldClientKey
			AND    tVoucherDetail.ItemKey = i.ItemKey
			AND    i.ItemType = 2 -- BC

			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRAN
				RETURN -100
			END
        
        END

		-- update ACCRUAL GL Transactions where the section is not 'LINE'        
		UPDATE tTransaction
		SET    ClientKey = @ClientKey
		WHERE  CompanyKey = @CompanyKey
		AND    Entity IN ('VOUCHER','CREDITCARD')	 
		AND    ProjectKey = @ProjectKey	 
		--AND    ClientKey = @OldClientKey
		AND    Section <> 2

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
		
		UPDATE tCashTransactionLine
		SET    ClientKey = @ClientKey
		WHERE  CompanyKey = @CompanyKey
		AND    Entity IN ('VOUCHER','CREDITCARD')	 
		AND    ProjectKey = @ProjectKey	 
		--AND    ClientKey = @OldClientKey
		AND    Section <> 2

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
		
		-- update ACCRUAL GL Transactions where the section is 'LINE'        
		-- must join with voucher detail
		UPDATE tTransaction
		SET    tTransaction.ClientKey = vd.ClientKey
		FROM   tVoucherDetail vd (nolock)
		WHERE  tTransaction.CompanyKey = @CompanyKey
		AND    tTransaction.Entity IN ('VOUCHER','CREDITCARD')	 
		AND    tTransaction.ProjectKey = @ProjectKey	 
		--AND    tTransaction.ClientKey = @OldClientKey
		AND    tTransaction.Section = 2
		AND    tTransaction.DetailLineKey = vd.VoucherDetailKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END

		UPDATE tCashTransactionLine
		SET    tCashTransactionLine.ClientKey = vd.ClientKey
		FROM   tVoucherDetail vd (nolock)
		WHERE  tCashTransactionLine.CompanyKey = @CompanyKey
		AND    tCashTransactionLine.Entity IN ('VOUCHER','CREDITCARD')	 
		AND    tCashTransactionLine.ProjectKey = @ProjectKey	 
		--AND    tCashTransactionLine.ClientKey = @OldClientKey
		AND    tCashTransactionLine.Section = 2
		AND    tCashTransactionLine.DetailLineKey = vd.VoucherDetailKey
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END

		-- update CASH GL Transactions
		
		UPDATE tCashTransaction
		SET    tCashTransaction.ClientKey = @ClientKey
		WHERE  tCashTransaction.CompanyKey = @CompanyKey
		AND    tCashTransaction.Entity = 'PAYMENT'	 
		AND    tCashTransaction.AEntity IN ('VOUCHER','CREDITCARD')	 
		AND    tCashTransaction.ProjectKey = @ProjectKey	 
		--AND    tCashTransaction.ClientKey = @OldClientKey
		AND    tCashTransaction.Section <> 2
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
		
		UPDATE tCashTransaction
		SET    tCashTransaction.ClientKey = vd.ClientKey
		FROM   tVoucherDetail vd (nolock)
		WHERE  tCashTransaction.CompanyKey = @CompanyKey
		AND    tCashTransaction.Entity = 'PAYMENT'	 
		AND    tCashTransaction.AEntity IN ('VOUCHER','CREDITCARD')	 
		AND    tCashTransaction.ProjectKey = @ProjectKey	 
		--AND    tCashTransaction.ClientKey = @OldClientKey
		AND    tCashTransaction.Section = 2
		AND    tCashTransaction.DetailLineKey = vd.VoucherDetailKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
		
		UPDATE tCashTransaction
		SET    tCashTransaction.ClientKey = @ClientKey
		WHERE  tCashTransaction.CompanyKey = @CompanyKey
		AND    tCashTransaction.Entity IN ('VOUCHER','CREDITCARD')	 
		AND    tCashTransaction.ProjectKey = @ProjectKey	 
		--AND    tCashTransaction.ClientKey = @OldClientKey
		AND    tCashTransaction.Section <> 2
		
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
		
		UPDATE tCashTransaction
		SET    tCashTransaction.ClientKey = vd.ClientKey
		FROM   tVoucherDetail vd (nolock)
		WHERE  tCashTransaction.CompanyKey = @CompanyKey
		AND    tCashTransaction.Entity IN ('VOUCHER','CREDITCARD') 
		AND    tCashTransaction.ProjectKey = @ProjectKey	 
		--AND    tCashTransaction.ClientKey = @OldClientKey
		AND    tCashTransaction.Section = 2
		AND    tCashTransaction.DetailLineKey = vd.VoucherDetailKey

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN
			RETURN -100
		END
		
	END
		
	COMMIT TRAN
		 
 RETURN 1
GO
