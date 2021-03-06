USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptExpenseEnvelopeCreateVoucher]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptExpenseEnvelopeCreateVoucher]

	@ExpenseEnvelopeKey int,
	@LoggedUserKey int, --Pass in the logged in user, not the UserKey on the ExpenseEnvelope.
	@VoucherKeyList varchar(1000) OUTPUT --Returns a list of VoucherKeys created so that the UI can display them

AS --Encrypt

/*
|| When     Who Rel      What
|| 09/17/07 CRG 8.5	     Completely rewritten for 8.5
|| 10/30/07 CRG 8.5      Modified to update the InvoiceLineKey and DateBilled on the newly inserted VoucherDetail line.
|| 01/31/08 GHL 8.503    (20244) Added sptVoucherDetailInsert.CheckProject parameter so that the checking of the project 
||                       can be bypassed when creating vouchers from expense receipts
|| 02/06/08 CRG 1.0.0.0  Added VoucherKeyList
|| 04/17/08 GHL 8.508    (25147) Take AP account from the vendor first, then AP account from preferences  
|| 06/18/08 GHL 8.513    Added OpeningTransaction
|| 09/19/08 RTC 10.0.0.9 (35297) Cannot check GL Account for null since it sometimes has zero value
|| 09/26/08 GHL 10.0.0.9 (35976) The logic for the class is:
||                        1) Try to get it from the project
||                        2) If null, get from the person or the item 
||                        depending on UseExpenseTypeClassOnVoucher 
|| 10/17/08 GHL 10.010   (37490) Users want to see tExpenseReceipt.ExpenseDate
||                       on tVoucherDetail.SourceDate after they create vouchers 
|| 03/19/09 RLB 10.0.2.1 (49161) Vendor Invoice status = 2 when voucher created so that it will appear on approval list
|| 06/22/09 RLB 10.5.0.0 (55382) Setting Vendor Invoice to status = 4 if option to auto approve Vouchers is selected in Pref
|| 08/25/09 GHL 10.5.0.7 (60853) Added project rollup update
|| 10/14/09 GHL 10.5.1.2 (65433) Added call of sptVoucherRecalcAmounts because the VoucherTotal should be set
|| 02/07/10 GWG 10.5.1.8 Limited the creation of the voucher to not include transfered transactions
|| 08/31/10 RLB 10.5.3.4 (88154) Changed to Default Voucher approval
|| 03/07/11 RLB 10.5.4.2 (100772) Added sales taxs from expense report
|| 05/07/11 GWG 10.5.4.3 Added a fix for a missing where clause on the update of taxes
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert
|| 01/6/12  GWG 10.5.5.1 The select of lines was picking up transferred transactions.
|| 01/06/12 GHL 10.5.5.1 Changed VoucherType to 0 after reviewing logic for voucher types in Voucher.vb
|| 03/30/12 GHL 10.5.5.4 Taking in account GLCompanySource when setting GLCompanyKey and OfficeKey
|| 04/23/12 GHL 10.5.5.4 (141283) fixed logic for GLCompanySource, if there is no project, get it from the user
|| 05/04/12 GHL 10.5.5.5 (142508) Added validation of class on the header when RequireClass = 1
|| 04/29/13 RLB 10.5.6.7 (176226) Set the Default Expense Account if none is set. 
|| 08/07/13 GHL 10.5.7.0 (186159) Do not use tProject.GLCompanySource, just use tProject.GLCompanyKey
|| 10/16/13 GHL 10.5.7.3 Added GrossAmount and Commission when calling sptInvoiceDetailInsert
|| 11/06/13 GHL 10.5.7.4 Added fields for multi currency on voucher and details
|| 11/27/13 GHL 10.5.7.4 Added fields for multi currency on expense report and details
|| 06/10/14 WDF 10.5.8.1 (218536) Prevent ExpenseReport being converted to Voucher if on Worksheet that has not been billed
|| 08/18/14 KMC 10.5.8.3 (225566) Removed the call to sptVoucherRecalcAmounts because it was recalculating the tax amount and overwriting 
||                       any manual update to the taxes.  Replaced with sptVoucherRollupAmounts to get the voucher header total to calculate correctly
|| 11/25/14 GHL 10.5.8.6 (237442) Do not create the vendor invoice if the APAccount has the wrong currency
|| 01/20/15 RLB 10.5.8.7 parm was added to voucher update and insert
*/

	DECLARE	@CompanyKey int,
			@VendorKey int,
			@UserKey int,
			@GLCompanyKey int,
			@UserGLCompanyKey int,
			@OfficeKey int,
			@ClassKey int,
			@DepartmentKey int,
			@Today smalldatetime,
			@TermsPercent decimal(9,3),
			@TermsDays int,
			@TermsNet int,
			@DueDate smalldatetime,
			@HeaderSalesTaxKey int,
			@HeaderSalesTax2Key int,
			@APAccountKey int,
			@VendorAPAccountKey int,
			@RequireGLAccounts tinyint,
			@ExpenseAccountKey int,
			@DefaultExpenseAccountKey int,
			@UseExpenseTypeClassOnVoucher tinyint,
			@ExpenseReceiptKey int,
			@InvoiceNumber varchar(50),
			@SetGLCompanyKey int,
			@RetVal int,
			@VoucherKey int,
			@Description varchar(500),
			@ProjectKey int,
			@ClientKey int,
			@TaskKey int,
			@ItemKey int,
			@Quantity decimal(24, 4),
			@UnitCost money,
			@TotalCost money,
			@Markup decimal(24, 4),
			@UnitRate money,
			@BillableCost money,
			@Billable tinyint,
			@InvoiceLineKey int,
			@DateBilled smalldatetime,
			@InvoiceNumberSuffix int,
			@EnvelopeNumber varchar(30),
			@DetailTaxable tinyint,
			@DetailTaxable2 tinyint,
			@DetailSalesTax1Amount money,
			@DetailSalesTax2Amount money,
			@DetailSalesTaxAmount money,
			@UseGLCompany tinyint,
			@RequireGLCompany tinyint,
			@UseOffice tinyint,
			@RequireOffice tinyint,
			@UseDepartment tinyint,
			@RequireDepartment tinyint,
			@UseClass tinyint,
			@RequireClass tinyint,
			@oIdentity int,
			@ExpenseDate smalldatetime,
            @ApproverPref smallint,
			@CurrencyID varchar(10),
			@PCurrencyID varchar(10),
			@ExchangeRate decimal(24,7),
			@PExchangeRate decimal(24,7),
			@PTotalCost money,
			@GrossAmount money,
			@MultiCurrency int

	--Get data from the Expense Envelope
	SELECT	@CompanyKey = CompanyKey,
			@VendorKey = VendorKey,
			@UserKey = UserKey,
			@EnvelopeNumber = EnvelopeNumber,
			@HeaderSalesTaxKey = SalesTaxKey,
			@HeaderSalesTax2Key = SalesTax2Key,
			@CurrencyID = CurrencyID,
			@ExchangeRate = isnull(ExchangeRate, 1)
	FROM	tExpenseEnvelope (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey

	SELECT	@UseGLCompany = UseGLCompany,
			@RequireGLCompany = RequireGLCompany,
			@UseOffice = UseOffice,
			@RequireOffice = RequireOffice,
			@UseDepartment = UseDepartment,
			@RequireDepartment = RequireDepartment,
			@UseClass = UseClass,
			@RequireClass = RequireClasses,
			@UseExpenseTypeClassOnVoucher = UseExpenseTypeClassOnVoucher,
            @ApproverPref = ISNULL(DefaultAPApprover, 0),
			@MultiCurrency = ISNULL(MultiCurrency, 0)
	FROM	tPreference (nolock) 
	WHERE	CompanyKey = @CompanyKey

	IF @VendorKey IS NULL
		RETURN -1 --No Valid Vendor on the Expense Envelope

	IF @UserKey IS NULL
		RETURN -2 --No User on the Expense Envelope

	--Get data from the user
	SELECT	@OfficeKey = OfficeKey,
			@UserGLCompanyKey = GLCompanyKey,
			@ClassKey = ClassKey,
			@DepartmentKey = DepartmentKey
	FROM	tUser (nolock)
	WHERE	UserKey = @UserKey

	IF NOT EXISTS
			(SELECT	NULL
			FROM	tCompany (nolock)
			WHERE	CompanyKey = @VendorKey AND Active = 1 AND VendorID is not null and Vendor = 1)
		RETURN -1 --Invalid Vendor


	SELECT	@TermsPercent = ISNULL(TermsPercent, 0.00),
			@TermsDays = ISNULL(TermsDays, 0),
			@TermsNet = ISNULL(TermsNet, 0),
			@VendorAPAccountKey = DefaultAPAccountKey
	FROM	tCompany (NOLOCK)
	WHERE	CompanyKey = @VendorKey

	SELECT	@TermsNet = ISNULL(@TermsNet,0)
	SELECT	@Today = CAST((CAST(MONTH(GETDATE()) AS varchar) + '/' + CAST(DAY(GETDATE()) AS varchar) + '/' + CAST(YEAR(GETDATE()) AS varchar)) AS smalldatetime)
	SELECT	@DueDate = DATEADD(day,@TermsNet,@Today)

	SELECT	@APAccountKey = DefaultAPAccountKey,
			@DefaultExpenseAccountKey = DefaultExpenseAccountKey,
			@RequireGLAccounts = RequireGLAccounts,
			@UseExpenseTypeClassOnVoucher = ISNULL(UseExpenseTypeClassOnVoucher, 0)
	FROM	tPreference (NOLOCK)
	WHERE	CompanyKey = @CompanyKey

	IF ISNULL(@VendorAPAccountKey, 0) > 0
		SELECT	@APAccountKey = @VendorAPAccountKey	

	IF isnull(@APAccountKey, 0) = 0 AND @RequireGLAccounts = 1
		RETURN -3 --Invalid AP Account

	IF isnull(@APAccountKey, 0) > 0
		IF NOT EXISTS
				(SELECT	NULL
				FROM	tGLAccount (nolock)
				WHERE	GLAccountKey = @APAccountKey AND Active = 1)
			RETURN -10 --Inactive AP Account

	IF @MultiCurrency = 1 And isnull(@APAccountKey, 0) > 0
	begin
		-- Make sure that the AP account has the right currency
		if exists (select 1   
		     from tGLAccount (nolock) 
		     where GLAccountKey = @APAccountKey
			 and   isnull(CurrencyID, '') <> isnull(@CurrencyID, '')
			 )
			 return -13 
	end


	--Create the Temp Table
	IF Object_Id('tempdb..#tExpenseReceipt') IS NOT NULL
		DROP TABLE #tExpenseReceipt

	SELECT	*
			, NULL AS GLCompanyKey
			, NULL AS OfficeKey
			, NULL AS DepartmentKey
			, NULL AS ExpenseAccountKey
			, NULL AS ClientKey
			, NULL AS ClassKey
			, 0 AS GLCompanySource 
	INTO	#tExpenseReceipt
	FROM	tExpenseReceipt (nolock)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey and TransferOutDate is NULL

	--Set the Client from the Project
	UPDATE	#tExpenseReceipt
	SET		GLCompanyKey = p.GLCompanyKey, -- by default will come from the project
			OfficeKey = p.OfficeKey,	   -- by default will come from the project
			ClientKey = p.ClientKey,
			-- set company source = 0 when there is a project (186159)
			GLCompanySource = 0 --isnull(p.GLCompanySource, 0)  -- override source from the project
	FROM	tProject p (nolock)
	WHERE	#tExpenseReceipt.ProjectKey = p.ProjectKey

	-- if no project, get it from the user
	UPDATE	#tExpenseReceipt
	SET		GLCompanySource = 1
	WHERE	isnull(ProjectKey, 0)= 0 

	--Set GLCompanyKey from the user based on GLCompanySource 0 from project, 1 from user
	IF @UseGLCompany = 1
	BEGIN
		UPDATE	#tExpenseReceipt
		SET		GLCompanyKey = @UserGLCompanyKey
		WHERE	isnull(GLCompanySource, 0) = 1
	END

	--Set Office from the user based on GLCompanySource 0 from project, 1 from user
	if @UseOffice = 1
	BEGIN
		UPDATE	#tExpenseReceipt
		SET		OfficeKey = @OfficeKey
		WHERE	isnull(GLCompanySource, 0) = 1
	END
	
	if @UseDepartment = 1
	BEGIN

		if @UseExpenseTypeClassOnVoucher = 1
		BEGIN
			-- get the department from the item
			UPDATE	#tExpenseReceipt
			SET		DepartmentKey = i.DepartmentKey
			FROM	tItem i (nolock)
			WHERE	#tExpenseReceipt.ItemKey = i.ItemKey
		END

		--set it from the user.
		UPDATE	#tExpenseReceipt
		SET		DepartmentKey = @DepartmentKey
		WHERE	DepartmentKey IS NULL

	END

	if @UseClass = 1
	BEGIN

		-- try to get the class from the project first
		UPDATE	#tExpenseReceipt
		SET		#tExpenseReceipt.ClassKey = p.ClassKey
		FROM	tProject p (nolock)
		WHERE	#tExpenseReceipt.ProjectKey = p.ProjectKey
			
		UPDATE	#tExpenseReceipt
		SET		ClassKey = NULL
		WHERE   ClassKey = 0
				
		if @UseExpenseTypeClassOnVoucher = 1
		BEGIN
			-- get the class from the item
			UPDATE	#tExpenseReceipt
			SET		#tExpenseReceipt.ClassKey = i.ClassKey
			FROM	tItem i (nolock)
			WHERE	#tExpenseReceipt.ItemKey = i.ItemKey
		    AND     #tExpenseReceipt.ClassKey IS NULL		
	
			UPDATE	#tExpenseReceipt
			SET		ClassKey = NULL
			WHERE   ClassKey = 0
		END
		
		--set it from the user.
		UPDATE	#tExpenseReceipt
		SET		ClassKey = @ClassKey
		WHERE	ClassKey IS NULL


	END

	--Set the ExpenseAccountKeyfrom the Item
	UPDATE	#tExpenseReceipt
	SET		ExpenseAccountKey = i.ExpenseAccountKey
	FROM	tItem i (nolock)
	WHERE	#tExpenseReceipt.ItemKey = i.ItemKey

	-- if there is no ExpenseAccountKey set yet set it to the default Expense Account (176226)
	IF EXISTS(
				SELECT	NULL
				FROM	#tExpenseReceipt
				WHERE	ExpenseAccountKey IS NULL)
			if ISNULL(@DefaultExpenseAccountKey, 0) > 0
			BEGIN
				UPDATE #tExpenseReceipt
				SET ExpenseAccountKey = @DefaultExpenseAccountKey
				WHERE #tExpenseReceipt.ExpenseAccountKey IS NULL

			END
			
				

	--Validate that the Keys are all Active and check for required
	if @UseGLCompany = 1
	BEGIN
		IF EXISTS(
				SELECT	NULL
				FROM	tGLCompany gl (nolock)
				INNER JOIN #tExpenseReceipt tmp ON gl.GLCompanyKey = tmp.GLCompanyKey
				WHERE	ISNULL(gl.Active, 0) = 0)
			RETURN -7 --Inactive GLCompanyKey
		if @RequireGLCompany = 1
		BEGIN
			if EXISTS (Select 1 from #tExpenseReceipt Where isnull(GLCompanyKey, 0) = 0)
				return -101
		END
	END

	-- GL Companies are set to 0 to allow proper looping in the ledger
	Update #tExpenseReceipt Set GLCompanyKey = 0 Where GLCompanyKey is null

	if @UseOffice = 1
	BEGIN
		IF EXISTS(
			SELECT	NULL
			FROM	tOffice o (nolock)
			INNER JOIN #tExpenseReceipt tmp ON o.OfficeKey = tmp.OfficeKey
			WHERE	ISNULL(o.Active, 0) = 0)
		RETURN -8 --Inactive Office
		if @RequireOffice = 1
		BEGIN
			if EXISTS (Select 1 from #tExpenseReceipt Where OfficeKey is null)
				return -102
		END
	END

	if @UseDepartment = 1
	BEGIN
		IF EXISTS(
			SELECT	NULL
			FROM	tDepartment d (nolock)
			INNER JOIN #tExpenseReceipt tmp ON d.DepartmentKey = tmp.DepartmentKey
			WHERE	ISNULL(d.Active, 0) = 0)
		RETURN -11 --Inactive Department
		if @RequireDepartment = 1
		BEGIN
			if EXISTS (Select 1 from #tExpenseReceipt Where DepartmentKey is null)
				return -103
		END
	END

	if @UseClass = 1
	BEGIN
		IF EXISTS(
			SELECT	NULL
			FROM	tClass d (nolock)
			INNER JOIN #tExpenseReceipt tmp ON d.ClassKey = tmp.ClassKey
			WHERE	ISNULL(d.Active, 0) = 0)
		RETURN -9 --Inactive Department
		
		if @RequireClass = 1
		BEGIN
			-- This class will go on the header, so validate it also
			if isnull(@ClassKey, 0) = 0
				return -104

			if EXISTS (Select 1 from #tExpenseReceipt Where ClassKey is null)
				return -104		
		END
	END

	-- Prevent Expense Report conversion if attached to worksheet that has not been billed
	IF EXISTS (
			SELECT NULL
			  FROM tBilling b (NOLOCK) INNER JOIN tBillingDetail  bd (NOLOCK) ON  bd.BillingKey = b.BillingKey
									   INNER JOIN tExpenseReceipt er (NOLOCK) ON  bd.Entity     = 'tExpenseReceipt' AND
																				  bd.EntityKey  = er.ExpenseReceiptKey
			WHERE b.CompanyKey = @CompanyKey
			  AND b.Status < 5
			  AND er.ExpenseEnvelopeKey = @ExpenseEnvelopeKey)
		RETURN -105

	IF EXISTS(
			SELECT	NULL
			FROM	tGLAccount gl (nolock)
			INNER JOIN #tExpenseReceipt tmp ON gl.GLAccountKey = tmp.ExpenseAccountKey
			WHERE	ISNULL(gl.Active, 0) = 0)
		RETURN -12 --Inactive Expense Account

	IF @RequireGLAccounts = 1
		IF EXISTS(
				SELECT	NULL
				FROM	#tExpenseReceipt
				WHERE	ExpenseAccountKey IS NULL)
			RETURN - 4 --Invalid Expense Account

	--See if there is more than one GLCompany. If so, we need to add a suffix to the Invoice Number when generating
	IF (SELECT COUNT(DISTINCT GLCompanyKey) FROM #tExpenseReceipt) > 1
		SELECT @InvoiceNumberSuffix = 1
	ELSE
		SELECT @InvoiceNumberSuffix = 0

	--Loop through the GLCompanyKeys, creating one invoice per GLCompany
	BEGIN TRAN

	SELECT	@GLCompanyKey = -1

	WHILE (1=1)
	BEGIN
		SELECT	@GLCompanyKey = MIN(GLCompanyKey)
		FROM	#tExpenseReceipt
		WHERE	GLCompanyKey > @GLCompanyKey

		IF @GLCompanyKey IS NULL
			BREAK

		IF @GLCompanyKey = 0
			SELECT	@SetGLCompanyKey = NULL
		ELSE
			SELECT	@SetGLCompanyKey = @GLCompanyKey

		IF @InvoiceNumberSuffix > 0
			SELECT	@InvoiceNumber = @EnvelopeNumber + '-' + CAST(@InvoiceNumberSuffix AS varchar),
					@InvoiceNumberSuffix = @InvoiceNumberSuffix + 1
		ELSE
			SELECT	@InvoiceNumber = @EnvelopeNumber

		--Create the Voucher Header
		EXEC @RetVal = sptVoucherInsert
			@CompanyKey,
			@VendorKey,
			@Today, --@InvoiceDate
			@Today, --@PostingDate
			@InvoiceNumber,
			@Today, --@DateReceived
			@LoggedUserKey, --@CreatedByKey
			@TermsPercent,
			@TermsDays,
			@TermsNet,
			@DueDate,
			NULL, --@Description
			NULL, --ProjectKey
			@LoggedUserKey, --@ApprovedByKey
			@APAccountKey,
			@ClassKey,
			@HeaderSalesTaxKey, -- SalesTaxKey
			@HeaderSalesTax2Key, -- Sales2TaxKey
			@SetGLCompanyKey, --GLCompanyKey
			@OfficeKey, --OfficeKey
			0,    --OpeningTransaction
			0,    --VoucherType		
			@CurrencyID,
			@ExchangeRate,
			NULL, --@PCurrencyID,
			NULL, --@PExchangeRate,	
			null, -- @CompanyMediaKey
			@VoucherKey OUTPUT					

		IF @RetVal = -1
		BEGIN
			ROLLBACK TRAN
			RETURN -5 --Invoice Number already exists
		END

		IF @VoucherKey IS NULL
		BEGIN
			ROLLBACK TRAN
			RETURN -6 --General error when creating voucher	
		END
        
       IF @ApproverPref = 2
		   Update tVoucher Set Status = 4 where VoucherKey = @VoucherKey
		ELSE	
           Update tVoucher Set Status = 2 where VoucherKey = @VoucherKey
        
 		--Now Loop through each receipt line with that GLCompanyKey
		SELECT	@ExpenseReceiptKey = 0

		WHILE (1=1)
		BEGIN
			SELECT	@ExpenseReceiptKey = MIN(ExpenseReceiptKey)
			FROM	#tExpenseReceipt
			WHERE	ExpenseReceiptKey > @ExpenseReceiptKey
			AND		GLCompanyKey = @GLCompanyKey and TransferToKey is NULL

			IF @ExpenseReceiptKey IS NULL
				BREAK

			--Get values from Receipt
			SELECT	@Description = ISNULL(Description, '') + ISNULL(' ' + Comments, ''),
					@ProjectKey = ProjectKey,
					@ClientKey = ClientKey,
					@TaskKey = TaskKey,
					@ItemKey = ItemKey,
					@ClassKey = ClassKey,
					@OfficeKey = OfficeKey,
					@DepartmentKey = DepartmentKey,
					@Quantity = ActualQty,
					@UnitCost = ActualUnitCost,
					@TotalCost = ActualCost,
					@Markup = Markup,
					@UnitRate = UnitRate,
					@BillableCost = BillableCost,
					@Billable = Billable,
					@ExpenseAccountKey = ExpenseAccountKey,
					@DetailTaxable = Taxable,
					@DetailTaxable2 = Taxable2,
					@DetailSalesTax1Amount = SalesTax1Amount,
					@DetailSalesTax2Amount = SalesTax2Amount,
					@DetailSalesTaxAmount = SalesTaxAmount,
					@InvoiceLineKey =
						CASE 
							WHEN DateBilled IS NULL THEN NULL
							ELSE 0
						END,
					@DateBilled =
						CASE 
							WHEN DateBilled IS NULL THEN NULL
							ELSE @Today
						END,
					@ExpenseDate = ExpenseDate,
					@PCurrencyID = PCurrencyID,
					@PExchangeRate = isnull(PExchangeRate, 1),
					@PTotalCost = PTotalCost,
					@GrossAmount = GrossAmount
			FROM	#tExpenseReceipt (nolock)
			WHERE	ExpenseReceiptKey = @ExpenseReceiptKey


			IF @TotalCost <> 0
			BEGIN
				EXEC @RetVal = sptVoucherDetailInsert
					@VoucherKey,
					NULL, --@PurchaseOrderDetailKey
					@ClientKey,
					@ProjectKey,
					@TaskKey,
					@ItemKey,
					@ClassKey,
					@Description,
					@Quantity,
					@UnitCost, --@UnitCost
					NULL, --@UnitDescription
					@TotalCost,
					@UnitRate, -- @UnitRate
					@Billable, --@Billable
					@Markup, --@Markup,
					@BillableCost, --@BillableCost
					@ExpenseAccountKey,
					@DetailTaxable, --@Taxable
					@DetailTaxable2,--@Taxable2
					0, --@LastVoucher
					@OfficeKey,
					@DepartmentKey,
					0, -- @CheckProject, do not check project since this is a just transfer of expenses
					NULL, -- Commission
					@GrossAmount, 
					@PCurrencyID,
					@PExchangeRate,
					@PTotalCost,
					@oIdentity OUTPUT		

				IF @RetVal = -1
				BEGIN
					ROLLBACK TRAN
					RETURN -7 --Error Generating Voucher Detail
				END

				UPDATE	tVoucherDetail
				SET		InvoiceLineKey = @InvoiceLineKey,
						DateBilled = @DateBilled,
						SourceDate = @ExpenseDate
				WHERE	VoucherDetailKey = @oIdentity

				if @DetailTaxable = 1 or @DetailTaxable2 = 1
				BEGIN
					update tVoucherDetail
					set SalesTax1Amount = ISNULL(@DetailSalesTax1Amount, 0),
						Taxable = @DetailTaxable,
						SalesTax2Amount = ISNULL(@DetailSalesTax2Amount, 0),
						Taxable2 = @DetailTaxable2,
						SalesTaxAmount = ISNULl(@DetailSalesTaxAmount, 0)
					Where VoucherDetailKey = @oIdentity
				End

				UPDATE	#tExpenseReceipt
				SET		VoucherDetailKey = @oIdentity
				WHERE	ExpenseReceiptKey = @ExpenseReceiptKey

				--Build a pipe separated string of VoucherKeys to send back
				SELECT @VoucherKeyList = ISNULL(@VoucherKeyList, '') + CAST(@VoucherKey as varchar) + '|'
			END
		END
	END

	UPDATE	tExpenseEnvelope
	SET		Paid = 1,
			VoucherKey = ISNULL(@VoucherKey, 0)
	WHERE	ExpenseEnvelopeKey = @ExpenseEnvelopeKey

	UPDATE	tExpenseReceipt
	SET		VoucherDetailKey = tmp.VoucherDetailKey
	FROM	#tExpenseReceipt tmp
	WHERE	tExpenseReceipt.ExpenseReceiptKey = tmp.ExpenseReceiptKey

	COMMIT TRAN
	
	--EXEC sptVoucherRecalcAmounts @VoucherKey
	EXEC sptVoucherRollupAmounts @VoucherKey
	
	 SELECT @ProjectKey = -1
	 WHILE (1=1)
	 BEGIN
		SELECT @ProjectKey = MIN(ProjectKey)
		FROM   #tExpenseReceipt
		WHERE  ProjectKey > @ProjectKey
		
		IF @ProjectKey IS NULL
			BREAK
			
		-- Rollup project, TranType = All
		EXEC sptProjectRollupUpdate @ProjectKey, -1, 1, 1, 1, 1
	 END
 
 
	RETURN 1
GO
