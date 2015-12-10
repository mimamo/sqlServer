USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdate]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdate]
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
	@CampaignSegmentKey int,
	@TeamKey int,
	@LeadKey int,
	@AutoIDTask smallint = -1, --smallint so we can default to -1
	@SimpleSchedule smallint = -1, --smallint so we can default to -1
	@NonBillable smallint = -1, --smallint so we can default to -1
	@BillingGroupKey int = null,
	@ModelYear varchar(10) = null,
	@Template smallint = -1
 
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
  || 3/2/10   CRG 10.5.1.9  Added @AutoIDTask and @SimpleSchedule
  || 04/05/10 RLB 10.5.2.1  Added Campaign Segments
  || 5/13/10  CRG 10.5.2.2  (80503) Now returning an error if the campaign client is not the same as the project client and the campaign's BillBy is not set to Project.
  || 5/27/11  CRG 10.5.4.4  Added @NonBillable
  || 10/13/11 GHL 10.4.5.9  Added new entity CREDITCARD 
  || 02/11/13 GHL 10.5.6.5  (167830) Added Billing Group Code
  || 02/12/13 GHL 10.5.6.5  (167857) Added ModelYear for a customization for Spark44
  || 05/10/13 MFT 10.5.6.7  (177949) Added @Template
  */
  
Declare @Active tinyint
Declare @CurClosed tinyint
Declare @BillingMethod int
Declare @RetainerKey int
Declare @RetainerGLCompanyKey int
Declare @OldClientKey int,
		@CurNonBillable tinyint,
		@CurTemplate tinyint

DECLARE	@CurAutoIDTask tinyint,
		@CurSimpleSchedule tinyint

IF EXISTS(
	SELECT 1 FROM tProject (NOLOCK) 
	WHERE
		ProjectNumber = @ProjectNumber AND
		CompanyKey = @CompanyKey AND
		ProjectKey <> @ProjectKey AND
		Deleted = 0
		)
	RETURN -1

	SELECT @Active = IsActive
	FROM tProjectStatus (NOLOCK) 
	WHERE ProjectStatusKey = @ProjectStatusKey
	
	IF @Active IS NULL RETURN -6
	
	IF @Closed = 1 and @Active = 1
		return -2
	
	Select @CurClosed = Closed
		  ,@BillingMethod = BillingMethod 
		  ,@RetainerKey = RetainerKey
		  ,@OldClientKey = ClientKey
		  ,@CurAutoIDTask = AutoIDTask
		  ,@CurSimpleSchedule = SimpleSchedule
		  ,@CurNonBillable = NonBillable
		  ,@CurTemplate = Template
	from tProject (nolock) 
	Where ProjectKey = @ProjectKey
	
	IF @AutoIDTask = -1
		SELECT @AutoIDTask = @CurAutoIDTask
		
	IF @SimpleSchedule = -1
		SELECT @SimpleSchedule = @CurSimpleSchedule

	IF @NonBillable = -1
		SELECT @NonBillable = @CurNonBillable
	
	IF @Template = -1
		SELECT @Template = @CurTemplate
	
	if @Closed = 1 and @CurClosed = 0
	BEGIN
		If Exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0)
			return -3
		If Exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0 and VoucherDetailKey is null)
			return -3
		If Exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0)
			return -3
		If Exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey is null and WriteOff = 0)
			return -3
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
	
Declare @LockCompany int, @UseCompany tinyint, @UseOffice tinyint
Select @LockCompany = 0

	if exists(Select 1 from tInvoiceLine (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
		
	if exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
		
	if exists(Select 1 from tTime (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		
	if exists(Select 1 from tMiscCost (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		
	if exists(Select 1 from tExpenseReceipt (nolock) Where ProjectKey = @ProjectKey and (InvoiceLineKey > 0 or WIPPostingInKey > 0 or WIPPostingOutKey > 0))
		Select @LockCompany = 1
		
	if exists(Select 1 from tVoucherDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey > 0)
		Select @LockCompany = 1
		
	if exists(Select 1 from tPurchaseOrderDetail (nolock) Where ProjectKey = @ProjectKey and InvoiceLineKey > 0)
		Select @LockCompany = 1

	if exists(Select 1 from tBilling (nolock) Where ProjectKey = @ProjectKey)
		Select @LockCompany = 1
	
	Select @UseCompany = UseGLCompany, @UseOffice = UseOffice from tPreference (nolock) Where CompanyKey = @CompanyKey
	if @LockCompany = 1
	BEGIN
		if @UseCompany = 1
			Select @GLCompanyKey = GLCompanyKey from tProject (nolock) Where ProjectKey = @ProjectKey
		if @UseOffice = 1
			Select @OfficeKey = OfficeKey from tProject (nolock) Where ProjectKey = @ProjectKey
	END
	

	

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

	-- if billing by retainer
	If @BillingMethod = 3
	Begin
		Select @RetainerGLCompanyKey = GLCompanyKey
		From tRetainer (NOLOCK) 
		Where RetainerKey = @RetainerKey
		
		If isnull(@RetainerGLCompanyKey, 0) <> isnull(@GLCompanyKey, 0)
			Return -5
	End
	
	IF ISNULL(@CampaignKey, 0) > 0
	BEGIN
		DECLARE @CampaignClientKey int,
				@BillBy smallint
		
		SELECT	@CampaignClientKey = ClientKey,
				@BillBy = BillBy
		FROM	tCampaign (nolock)
		WHERE	CampaignKey = @CampaignKey
		
		IF @ClientKey <> @CampaignClientKey AND @BillBy <> 1
			RETURN -7 --The campaign must be for the same client, unless the campaign's BillBy is set to "Project" (1)
	END	
	
	DECLARE @IOClientLink int
	DECLARE @BCClientLink int
	
	SELECT @IOClientLink = ISNULL(IOClientLink, 1),@BCClientLink = ISNULL(BCClientLink, 1)
	FROM   tPreference (nolock)
	WHERE  CompanyKey = @CompanyKey
	
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
		ClassKey = @ClassKey,
		AccountManager = @AccountManager,
		Closed = @Closed,
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
		CampaignSegmentKey = @CampaignSegmentKey,
		AutoIDTask = @AutoIDTask,
		SimpleSchedule = @SimpleSchedule,
		NonBillable = @NonBillable,
		BillingGroupKey = @BillingGroupKey,
		ModelYear = @ModelYear,
		Template = @Template
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
