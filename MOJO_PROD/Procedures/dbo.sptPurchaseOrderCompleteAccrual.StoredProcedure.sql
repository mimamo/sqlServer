USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderCompleteAccrual]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderCompleteAccrual]
	(
	@PurchaseOrderKey int			-- Not required if detail entered
	,@PurchaseOrderDetailKey int	-- If not null process the POD only, If null process the whole PO
	,@UserKey int = NULL			-- If null, created by copied from PO
	,@PostingDate smalldatetime = NULL
	,@VoucherKey int output
	)
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/23/09 GHL 10.024 Creation. This sp creates vouchers to fix orders accrual problems    
||                     Returns are:
||                     -1	-- nothing to unaccrue, no voucher created
||                     -2	-- error creating voucher
||                     1	-- voucher created to unaccrue
|| 10/15/09 GWG 10.5.1.2 Modified the expense account to be the same as the AP account.
|| 01/29/10 GHL 10.5.1.7 Fixed logic for duplicate Invoice Numbers.
|| 01/17/11 GHL 10.5.4.0 (100563) Added support for closing a BO spot (linked by same LineNumber and AdjustmentNumber) 
|| 02/01/12 GHL 10.5.5.2 Only complete accrual on closed po details so that we can use this sp in the accrued order detail
||                       where the user can close lines first and then we call sptPurchaseOrderCompleteAccrual
||                       with POKey = @POKey and PODKey = null
|| 03/07/12 GHL 10.5.5.4 (136574) VoucherDetail rec should be marked as billed and DateBilled = PostingDate on the voucher
|| 02/07/13 GHL 10.565 (167854) Added VoucherID for a customization for Spark44
|| 10/16/13 GHL 10.5.7.3 Added GrossAmount and Commission when calling sptInvoiceDetailInsert
|| 11/06/13 GHL 10.5.7.4 Added multi currency fields
|| 10/22/14 GHL 10.5.8.5 (233823) Use ExpenseAccountKey from tItem
|| 03/26/15 GHL 10.5.9.1 (251194) Use InvoiceDate = PostingDate
*/

	SET NOCOUNT ON
	
	DECLARE @AccruedAmount money
	DECLARE @UnaccruedAmount money
	DECLARE @InvoiceLineKey int
	DECLARE @CreateVoucher int	
	DECLARE @CreateVoucherDetail int	
	DECLARE @PODKey int
	DECLARE @RetVal int
	DECLARE @Closed int
	DECLARE @ClosingMode int
	DECLARE @LineNumber int
	DECLARE @AdjustmentNumber int
	DECLARE @POKind int 

	DECLARE @kPOMode int        select @kPOMode = 1
	DECLARE @kSinglePODMode int select @kSinglePODMode = 2
	DECLARE @kSpotPODMode int   select @kSpotPODMode = 3

	SELECT @CreateVoucher = 0
	SELECT @VoucherKey = NULL
	
	IF ISNULL(@PurchaseOrderKey, 0) = 0 AND ISNULL(@PurchaseOrderDetailKey, 0) = 0
		RETURN -1
	
	IF @PurchaseOrderDetailKey IS NULL
		SELECT @ClosingMode = @kPOMode
	ELSE
	BEGIN
		-- look at the POKind, LineNumber and Adjustement
		select @POKind = po.POKind
	      ,@LineNumber = pod.LineNumber
	      ,@AdjustmentNumber = pod.AdjustmentNumber

		  -- also load the PO number because, this sp was called with PODKey only, we will need it later 
		  ,@PurchaseOrderKey = pod.PurchaseOrderKey    
	  from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	  
	  SELECT @POKind = isnull(@POKind, 0)
	        ,@LineNumber = isnull(@LineNumber, 0)
	        ,@AdjustmentNumber = isnull(@AdjustmentNumber, 0)

	  IF @POKind = 2
		SELECT @ClosingMode = @kSpotPODMode
	  ELSE
		SELECT @ClosingMode = @kSinglePODMode

	END

	IF @ClosingMode = @kSinglePODMode
	BEGIN
		SELECT @PurchaseOrderKey = PurchaseOrderKey 
		      ,@AccruedAmount = AccruedCost
		      ,@InvoiceLineKey = InvoiceLineKey
		FROM   tPurchaseOrderDetail (nolock)
		WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	    
	    -- abort if not prebilled yet
	    IF ISNULL(@InvoiceLineKey, 0) = 0
			RETURN -1 
	    
		SELECT @UnaccruedAmount = SUM(PrebillAmount)
		FROM   tVoucherDetail (nolock)
		WHERE  PurchaseOrderDetailKey = @PurchaseOrderDetailKey

		IF ISNULL(@AccruedAmount, 0) <> ISNULL(@UnaccruedAmount, 0)
			SELECT @CreateVoucher = 1		 		
	END 
	
	IF @ClosingMode = @kPOMode
	BEGIN		
		SELECT @PODKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @PODKey = MIN(PurchaseOrderDetailKey)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @PurchaseOrderKey 
			AND    PurchaseOrderDetailKey > @PODKey
			AND    ISNULL(InvoiceLineKey, 0) > 0
			AND    ISNULL(Closed, 0) = 1-- added 2/1/12
				
			IF @PODKey IS NULL
				BREAK
				
			SELECT @AccruedAmount = AccruedCost
			FROM   tPurchaseOrderDetail (nolock)
			WHERE  PurchaseOrderDetailKey = @PODKey
		
			SELECT @UnaccruedAmount = SUM(PrebillAmount)
			FROM   tVoucherDetail (nolock)
			WHERE  PurchaseOrderDetailKey = @PODKey

			IF ISNULL(@AccruedAmount, 0) <> ISNULL(@UnaccruedAmount, 0)
				SELECT @CreateVoucher = 1		 		

			IF @CreateVoucher = 1
				BREAK									
		END
			
	END

	IF @ClosingMode = @kSpotPODMode
	BEGIN		
		SELECT @PODKey = -1
		WHILE (1=1)
		BEGIN
			SELECT @PODKey = MIN(PurchaseOrderDetailKey)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @PurchaseOrderKey 
			AND    PurchaseOrderDetailKey > @PODKey
			AND    ISNULL(InvoiceLineKey, 0) > 0
			AND    LineNumber = @LineNumber
			AND    AdjustmentNumber = @AdjustmentNumber
			AND    ISNULL(Closed, 0) = 1 -- added 2/1/12

			IF @PODKey IS NULL
				BREAK
				
			SELECT @AccruedAmount = AccruedCost
			FROM   tPurchaseOrderDetail (nolock)
			WHERE  PurchaseOrderDetailKey = @PODKey
		
			SELECT @UnaccruedAmount = SUM(PrebillAmount)
			FROM   tVoucherDetail (nolock)
			WHERE  PurchaseOrderDetailKey = @PODKey

			IF ISNULL(@AccruedAmount, 0) <> ISNULL(@UnaccruedAmount, 0)
				SELECT @CreateVoucher = 1		 		

			IF @CreateVoucher = 1
				BREAK									
		END
			
	END
	
	-- If we do not create a voucher, abort now
	IF @CreateVoucher = 0
		RETURN -1
		
	-- create a voucher, get defaults from PO
	DECLARE @CompanyKey int,
			@VendorKey int,
			@InvoiceDate smalldatetime,
			@PurchaseOrderNumber varchar(50),
			@InvoiceNumber varchar(50),
			@DateReceived smalldatetime,
			@CreatedByKey int,
			@TermsPercent decimal(24,4),
			@TermsDays int,
			@TermsNet int,
			@DueDate smalldatetime,
			@Description varchar(500),
			@ProjectKey int,
			@ApprovedByKey int,
			@APAccountKey int,
			@ExpenseAccountKey int,
			@DefaultExpenseAccountKey int,
			@ClassKey int,
			@SalesTaxKey int,
			@SalesTax2Key int,
			@GLCompanyKey int,
			@OfficeKey int,	
			@OpeningTransaction tinyint,
			@CurrencyID varchar(10),
			@ExchangeRate decimal(24,7),
			@PCurrencyID varchar(10),
			@PExchangeRate decimal(24,7),
			@PTotalCost money	
	
	IF @PostingDate IS NULL
		SELECT @PostingDate = CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101), 101)
		
	select @InvoiceDate = @PostingDate

	SELECT @CompanyKey = CompanyKey
			,@VendorKey = VendorKey 
			,@PurchaseOrderNumber = PurchaseOrderNumber
			,@DateReceived = CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101), 101)
			,@CreatedByKey = ISNULL(@UserKey, CreatedByKey)
			,@Description = 'Created to unaccrue PO accruals'
			,@ProjectKey = ProjectKey
			,@ApprovedByKey = ISNULL(@UserKey, ApprovedByKey)
			,@ClassKey = ClassKey
			,@SalesTaxKey = SalesTaxKey -- does that matter?
			,@SalesTax2Key = SalesTax2Key
			,@GLCompanyKey = GLCompanyKey
			,@OfficeKey = NULL -- could get from project	
			,@OpeningTransaction = 0
			,@CurrencyID = CurrencyID
			,@ExchangeRate = isnull(ExchangeRate, 1)
			,@PCurrencyID = PCurrencyID
			,@PExchangeRate = isnull(PExchangeRate, 1)
	FROM tPurchaseOrder (NOLOCK)
	WHERE PurchaseOrderKey = @PurchaseOrderKey	
		
	declare @DuplicateVendorInvoiceNbr tinyint
	declare @AutoApproveExternalInvoices tinyint
	declare @BCClientLink tinyint
	declare @VICount int
		
	Select	@APAccountKey = DefaultAPAccountKey
	        ,@DefaultExpenseAccountKey = DefaultExpenseAccountKey
			,@DuplicateVendorInvoiceNbr = isnull(DuplicateVendorInvoiceNbr,0)
			,@AutoApproveExternalInvoices = isnull(AutoApproveExternalInvoices, 0)
			,@BCClientLink = isnull(BCClientLink,1)
	from	tPreference (NOLOCK) 
	Where	CompanyKey = @CompanyKey
	
	-- by default, Invoice # = PO #
	select @InvoiceNumber = @PurchaseOrderNumber
	
	if @DuplicateVendorInvoiceNbr = 0
	begin
		select @VICount = 0
		while (1=1)
		begin
			if @VICount > 0
				select @InvoiceNumber = @PurchaseOrderNumber + ' (' + cast( @VICount as VARCHAR(50)) + ')'
			
			if exists (select 1 from tVoucher (nolock) 
				where InvoiceNumber = @InvoiceNumber
				and CompanyKey = @CompanyKey and VendorKey = @VendorKey
				)
				select @VICount = @VICount + 1
			else
				break

			-- no running wild loop
			if @VICount > 1000
				break
		end
	end 	
	
		
	Select @TermsPercent = ISNULL(TermsPercent, 0), @TermsDays = ISNULL(TermsDays, 0), @TermsNet = ISNULL(TermsNet, 0) 
		From tCompany (NOLOCK) Where CompanyKey = @VendorKey
		
	Select @DueDate = ISNULL(@DueDate, DATEADD(day, @TermsNet, @InvoiceDate))
		
	Declare @VoucherID int
	Select @VoucherID = ISNULL(Max(VoucherID), 0) + 1 
	from tVoucher (nolock) Where CompanyKey = @CompanyKey and isnull(CreditCard, 0) = 0

	-- Direct Insert instead of sptVoucherInsert to bypass some checks such as ExpenseActive 		
	INSERT tVoucher
		(
		CompanyKey,
		VendorKey,
		InvoiceDate,
		PostingDate,
		InvoiceNumber,
		DateReceived,
		CreatedByKey,
		TermsPercent,
		TermsDays,
		TermsNet,
		DueDate,
		Description,
		ProjectKey,
		ApprovedByKey,
		APAccountKey,
		ClassKey,
		SalesTaxKey,
		SalesTax2Key,
		Status,
		GLCompanyKey,
		OfficeKey,
		OpeningTransaction,
		VoucherID,
		CurrencyID,
		ExchangeRate,
		PCurrencyID,
		PExchangeRate
		)

	VALUES
		(
		@CompanyKey,
		@VendorKey,
		@InvoiceDate,
		@PostingDate,
		@InvoiceNumber,
		@DateReceived,
		@CreatedByKey,
		@TermsPercent,
		@TermsDays,
		@TermsNet,
		@DueDate,
		@Description,
		@ProjectKey,
		@ApprovedByKey,
		@APAccountKey,
		@ClassKey,
		@SalesTaxKey,
		@SalesTax2Key,
		4,    -- @Status, Approved
		@GLCompanyKey,
		@OfficeKey,
		@OpeningTransaction,
		@VoucherID,
		@CurrencyID,
		@ExchangeRate,
		@PCurrencyID,
		@PExchangeRate
		)
	
	SELECT @VoucherKey = @@IDENTITY, @RetVal = @@ERROR
	
	IF @RetVal <> 0
	BEGIN
		SELECT @VoucherKey = NULL
		RETURN -2
	END
		
	-- create a voucher detail, get defaults from PO detail	
	DECLARE @VoucherDetailKey int
			,@ClientKey int,
			--@ProjectKey int,
			@TaskKey int,
			@ItemKey int,
			--@ClassKey int,
			@ShortDescription varchar(500),
			@Quantity decimal(15, 3),
			@UnitCost money,
			@UnitDescription varchar(30),
			@TotalCost money,
			@UnitRate money,
			@Billable tinyint,
			@Markup decimal(9, 3),
			@BillableCost money,
			@Taxable tinyint,
			@Taxable2 tinyint,
			@LastVoucher tinyint,
			--@OfficeKey int,
			@DepartmentKey int,
			@CheckProject int 

	
	SELECT @PODKey = -1
	
	WHILE (1=1)
	BEGIN
		/*
		IF @PurchaseOrderDetailKey IS NOT NULL
			SELECT @PODKey = @PurchaseOrderDetailKey
		ELSE
			SELECT @PODKey = MIN(PurchaseOrderDetailKey)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @PurchaseOrderKey
			AND    PurchaseOrderDetailKey > @PODKey
			AND    ISNULL(InvoiceLineKey, 0) > 0
		*/
		
		IF @ClosingMode = @kSinglePODMode 
			SELECT @PODKey = @PurchaseOrderDetailKey
		
		IF @ClosingMode = @kPOMode	
			SELECT @PODKey = MIN(PurchaseOrderDetailKey)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @PurchaseOrderKey
			AND    PurchaseOrderDetailKey > @PODKey
			AND    ISNULL(InvoiceLineKey, 0) > 0
			AND    ISNULL(Closed, 0) = 1 -- added 2/1/12

		IF @ClosingMode = @kSpotPODMode	
			SELECT @PODKey = MIN(PurchaseOrderDetailKey)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @PurchaseOrderKey
			AND    PurchaseOrderDetailKey > @PODKey
			AND    ISNULL(InvoiceLineKey, 0) > 0
			AND    LineNumber = @LineNumber
			AND    AdjustmentNumber = @AdjustmentNumber
			AND    ISNULL(Closed, 0) = 1 -- added 2/1/12

		IF @PODKey IS NULL
			BREAK
		
		SELECT 	@ProjectKey = pod.ProjectKey
				,@TaskKey = pod.TaskKey
				,@ItemKey = pod.ItemKey
				,@ClassKey = pod.ClassKey
				,@ShortDescription = pod.ShortDescription
				,@Quantity = 0 -- should not matter
				,@UnitCost = pod.UnitCost
				,@UnitDescription = pod.UnitDescription
				,@TotalCost = 0 -- pod.TotalCost
				,@UnitRate = pod.UnitRate
				,@Billable = 0
				,@Markup =  0
				,@BillableCost = 0
				,@Taxable = pod.Taxable -- or 0
				,@Taxable2 = pod.Taxable2 -- 0
				,@LastVoucher = 1  -- This is the most important to unaccrue
				,@OfficeKey = pod.OfficeKey
				,@DepartmentKey = pod.DepartmentKey
				,@CheckProject = 0
				
				,@AccruedAmount = ISNULL(pod.AccruedCost, 0)

				,@PCurrencyID = PCurrencyID
				,@PExchangeRate = PExchangeRate
				,@PTotalCost = 0
		FROM tPurchaseOrderDetail pod (NOLOCK)
		WHERE pod.PurchaseOrderDetailKey = @PODKey 
	
		SELECT @CreateVoucherDetail = 0
		
		IF @ClosingMode <> @kSinglePODMode
		BEGIN
			SELECT @UnaccruedAmount = SUM(PrebillAmount)
			FROM   tVoucherDetail (nolock)
			WHERE  PurchaseOrderDetailKey = @PODKey

			IF ISNULL(@AccruedAmount, 0) <> ISNULL(@UnaccruedAmount, 0)
				SELECT @CreateVoucherDetail = 1		 		
		END
		ELSE
		BEGIN
			-- Only 1 purchase order detail
			-- if we came that far, we need a voucher detail 
			SELECT @CreateVoucherDetail = 1
		END
		
		IF @CreateVoucherDetail = 1
		BEGIN
			select @ExpenseAccountKey = ExpenseAccountKey from tItem (nolock) where ItemKey = @ItemKey

			select @ExpenseAccountKey = isnull(@ExpenseAccountKey, @DefaultExpenseAccountKey)

			EXEC sptVoucherDetailInsert
					@VoucherKey,
					@PODKey,
					@ClientKey,
					@ProjectKey,
					@TaskKey,
					@ItemKey,
					@ClassKey,
					@ShortDescription,
					@Quantity,
					@UnitCost,
					@UnitDescription,
					@TotalCost,
					@UnitRate,
					@Billable,
					@Markup,
					@BillableCost,
					@ExpenseAccountKey,
					@Taxable,
					@Taxable2,
					@LastVoucher,
					@OfficeKey,
					@DepartmentKey,
					@CheckProject,
					NULL, -- Commission
					@BillableCost, -- Gross Amount
					@PCurrencyID,
					@PExchangeRate,
					@PTotalCost,
					@VoucherDetailKey OUTPUT
		END
		
		-- correct DateBilled on voucher
		if isnull(@VoucherDetailKey, 0) > 0
			update tVoucherDetail
			set    InvoiceLineKey = 0, DateBilled = @PostingDate
			where  VoucherDetailKey = @VoucherDetailKey

		-- if we only process 1 detail, exit loop now
		--IF @PurchaseOrderDetailKey IS NOT NULL
		IF @ClosingMode = @kSinglePODMode
			BREAK
	END
	

	RETURN 1
GO
