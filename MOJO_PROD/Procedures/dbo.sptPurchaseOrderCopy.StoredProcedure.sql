USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderCopy]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderCopy]
	@PurchaseOrderKey int,
	@CreatedByKey int = null,
	@OrderedBy varchar(200) = null,
	@CopyProjectKey int = null,
	@CopyTaskKey int = null,
	@CopyClassKey int = null,
	@CopyMediaEstimateKey int = null,
	@oIdentity INT OUTPUT

AS --ENCRYPT

  /*
  || When     Who Rel   What
  || 02/26/07 GHL 8.4   Added project rollup section 
  || 07/18/07 BSH 8.5   (9659)Insert GLCompanyKey, OfficeKey, DepartmentKey         
  || 10/22/08 GHL 10.5  (37963) Added CompanyAddressKey param
  || 09/14/09 GHL 10.5  Added logic for Transfers
  || 10/08/09 GHL 10.512 (65124) Bubbling up the errors from PO insert to show on the UI
  || 11/11/11 MAS 10.5.5.0 (121862) Added Print options, 1 to print all lines, 2 print just open lines
  || 12/19/11 RLB 10.5.5.1 (121862) Fixed SP for new Print option
  || 10/19/12 RLB 10.5.6.1 (157356) When coping setting the createdby and orderbyname to the session user
  || 12/03/12 MAS 10.5.6.2 (161425) Changed the length of @ShortDescription from 200 to 300
  || 12/12/12 WDF 10.5.6.3 (145601) Over-ride Fields for PO Copy
  || 12/06/13 GHL 10.5.7.5 If ordered by is null, get user name from CreatedByKey 
  || 12/16/13 GHL 10.5.7.5 Added currency info to PO header and lines
  || 12/26/13 GHL 10.5.7.5 Added saving of line taxes + other taxes
  || 04/29/14 RLB 10.5.7.9 (214240) increasing short description
  || 06/26/14 WDF 10.5.8.1 (220913) Set PODate to current date rather than date of copied PO
  || 08/28/14 RLB 10.5.8.3 (217703) Fixed PODate pulling in time part
  || 10/02/14 WDF 10.5.8.4 (231800) Set DueDate to current date rather than date of copied PO unless it is Null
  */

	if isnull(@CreatedByKey, 0) > 0 and isnull(@OrderedBy, '') = '' 
		select  @OrderedBy = UserName from vUserName where UserKey = @CreatedByKey

	Declare
	@CompanyKey int,
	@POKind smallint,
	@PurchaseOrderTypeKey int,
	@VendorKey int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@Contact varchar(200),
	@PODate smalldatetime,
	@DueDate smalldatetime,
	@CustomFieldKey int,
	@HeaderTextKey int,
	@FooterTextKey int,
	@ApprovedByKey int,
	@CompanyMediaKey int,
	@MediaEstimateKey int,
	@OrderDisplayMode smallint,
	@BillAt smallint,
	@SalesTaxKey int,
	@SalesTax2Key int,	
	@FlightStartDate smalldatetime,
	@FlightEndDate smalldatetime,
	@FlightInterval tinyint,
	@PrintClientOnOrder tinyint,
	@NewPurchaseOrderKey int,
	@TranType varchar(2),
	@OldPurchaseOrderDetailKey int,
	@RETVAL int,
	@LineNumber int,
	@ShortDescription varchar(max),
	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@Billable tinyint,
	@Markup decimal(24,4),
	@BillableCost money,
	@LongDescription varchar(6000),
	@DetailOrderDate smalldatetime,
	@DetailOrderEndDate smalldatetime,
	@UserDate1 smalldatetime,
	@UserDate2 smalldatetime,
	@UserDate3 smalldatetime,
	@UserDate4 smalldatetime,
	@UserDate5 smalldatetime,
	@UserDate6 smalldatetime,
	@OrderDays varchar(50),
	@OrderTime varchar(50),
	@OrderLength varchar(50),
	@Taxable tinyint,
	@PurchaseOrderNumber varchar(30),
	@Taxable2 tinyint,
	@NewPurchaseOrderDetailKey int,
	@OldPurchaseOrderTrafficKey int,
	@ISCICode varchar(100),
	@ShowPercent decimal(24,4),
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@Comments varchar(2000),
	@NewTrafficKey INT,
	@AdjustmentNumber INT,
	@MediaRevisionReasonKey INT,
	@ObjectFieldSetKey int,
	@FieldSetKey int,
	@UnitRate money,
	@PrintTraffic tinyint,
	@PrintOption tinyint,
	@Address1 varchar(100),
	@Address2 varchar(100),
	@Address3 varchar(100),
	@City varchar(100),
	@State varchar(50),
	@PostalCode varchar(20),
	@Country varchar(50),
	@DeliveryInstructions varchar(1000),
	@SpecialInstructions varchar(1000),
	@DeliverTo1 varchar(100),
	@DeliverTo2 varchar(100),
	@DeliverTo3 varchar(100),
	@DeliverTo4 varchar(100),
	@GLCompanyKey int,
	@OfficeKey int,
	@DepartmentKey int,
	@CompanyAddressKey int,
	@CurrencyID varchar(10),
	@ExchangeRate decimal(24,7),
	@PCurrencyID varchar(10),
	@PExchangeRate decimal(24,7),
	@GrossAmount money,
	@PTotalCost money,
	@Commission decimal(24,4),
	@SalesTaxAmount money,
	@SalesTax1Amount money,
	@SalesTax2Amount money


	if @CopyProjectKey = -1
		Select @CopyProjectKey = NULL

	if @CopyTaskKey = -1
		Select @CopyTaskKey = NULL

	-- set the project now because we use it later to get the GL company
	IF isnull(@CopyProjectKey, 0) > 0
		SELECT @ProjectKey = @CopyProjectKey
	else
		SELECT @ProjectKey = ProjectKey
		FROM tPurchaseOrder (nolock)
		WHERE PurchaseOrderKey = @PurchaseOrderKey   

	if isnull(@ProjectKey, 0) > 0
		select @GLCompanyKey = GLCompanyKey 
		from   tProject (nolock)
		where  ProjectKey = @ProjectKey
	else
		select @GLCompanyKey = GLCompanyKey 
		FROM tPurchaseOrder (nolock)
		WHERE PurchaseOrderKey = @PurchaseOrderKey   
	

	SELECT @CompanyKey = CompanyKey,
	@POKind = POKind,
	@PurchaseOrderTypeKey = PurchaseOrderTypeKey,
	@VendorKey = VendorKey,
	@TaskKey = ISNULL(@CopyTaskKey, TaskKey) ,
	@ItemKey = ItemKey,
	@ClassKey = ISNULL(@CopyClassKey, ClassKey),
	@Contact = Contact,
	@PODate = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
	@DueDate = CASE 
                  WHEN DueDate IS NULL THEN NULL
                  ELSE CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime)
               END,
	@CustomFieldKey = CustomFieldKey,
	@HeaderTextKey = HeaderTextKey,
	@FooterTextKey = FooterTextKey,
	@ApprovedByKey = ApprovedByKey,
	@CompanyMediaKey = CompanyMediaKey,
	@MediaEstimateKey = ISNULL(@CopyMediaEstimateKey, MediaEstimateKey),
	@OrderDisplayMode = OrderDisplayMode,
	@BillAt = BillAt,
	@SalesTaxKey = SalesTaxKey,
	@SalesTax2Key = SalesTax2Key,	
	@FlightStartDate = FlightStartDate,
	@FlightEndDate = FlightEndDate,
	@FlightInterval = FlightInterval,
	@PrintClientOnOrder = PrintClientOnOrder,
	@PurchaseOrderNumber = NULL,
	@PrintTraffic = PrintTraffic,
	@PrintOption = PrintOption,
	@Address1 = Address1,
	@Address2 = Address2,
	@Address3 = Address3,
	@City = City,
	@State = State,
	@PostalCode = PostalCode,
	@Country = Country,
	@DeliveryInstructions = DeliveryInstructions,
	@SpecialInstructions = SpecialInstructions,
	@DeliverTo1 = DeliverTo1,
	@DeliverTo2 = DeliverTo2,
	@DeliverTo3 = DeliverTo3,
	@DeliverTo4 = DeliverTo4,
	@CompanyAddressKey = CompanyAddressKey,
	@CurrencyID = CurrencyID,
	@ExchangeRate = ExchangeRate,
	@PCurrencyID = PCurrencyID,
	@PExchangeRate = PExchangeRate
	FROM tPurchaseOrder (nolock)
	WHERE PurchaseOrderKey = @PurchaseOrderKey
	
	-- make sure that the task belong to the project, if not null, it
	if isnull(@TaskKey, 0) > 0
	begin
		if (select ProjectKey from tTask (nolock) where TaskKey = @TaskKey)
			<> @ProjectKey
			select @TaskKey = null
	end

	-- Make a copy of the custom field
	IF ISNULL(@CustomFieldKey,0) > 0
    BEGIN
		SELECT	@FieldSetKey = FieldSetKey
		FROM	tObjectFieldSet (NOLOCK)
		WHERE	ObjectFieldSetKey = @CustomFieldKey
		
		EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
		
		IF ISNULL(@ObjectFieldSetKey,0) > 0
			INSERT	tFieldValue
					(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
			SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
			FROM	tFieldValue (NOLOCK)
			WHERE	ObjectFieldSetKey = @CustomFieldKey
    END
            
	exec @RETVAL = sptPurchaseOrderInsert @CompanyKey,@POKind ,@PurchaseOrderTypeKey,
		@PurchaseOrderNumber ,
		@VendorKey ,@ProjectKey ,@TaskKey ,@ItemKey ,@ClassKey ,@Contact ,@PODate ,@DueDate ,
		@OrderedBy ,@ObjectFieldSetKey ,@HeaderTextKey ,@FooterTextKey ,@ApprovedByKey ,@CreatedByKey ,
		@CompanyMediaKey ,@MediaEstimateKey ,@OrderDisplayMode ,@BillAt ,@SalesTaxKey ,@SalesTax2Key ,	
		@FlightStartDate ,@FlightEndDate ,@FlightInterval,@PrintClientOnOrder, @PrintTraffic, @PrintOption, @GLCompanyKey,
		@CompanyAddressKey, @CurrencyID, @ExchangeRate, @PCurrencyID, @PExchangeRate, @NewPurchaseOrderKey OUTPUT
	
	SELECT @oIdentity = @NewPurchaseOrderKey
	IF @RETVAL <> 1
		RETURN @RETVAL
	
	--Update PurchaseOrder Address information
	exec sptPurchaseOrderAddressUpdate
		@NewPurchaseOrderKey,
		@Address1,
		@Address2,
		@Address3,
		@City,
		@State,
		@PostalCode,
		@Country,
		@DeliveryInstructions,
		@SpecialInstructions,
		@DeliverTo1,
		@DeliverTo2,
		@DeliverTo3,
		@DeliverTo4
			
	SELECT @OldPurchaseOrderTrafficKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @OldPurchaseOrderTrafficKey = MIN(PurchaseOrderTrafficKey)
		FROM tPurchaseOrderTraffic (NOLOCK) 
		WHERE PurchaseOrderKey = @PurchaseOrderKey
		AND PurchaseOrderTrafficKey > @OldPurchaseOrderTrafficKey

		IF @OldPurchaseOrderTrafficKey IS NULL
                  BREAK
		
		SELECT @PurchaseOrderKey = PurchaseOrderKey,
			@ISCICode = ISCICode, 
			@ShowPercent = ShowPercent,
			@StartDate = StartDate,
			@EndDate = EndDate,
			@Comments = Comments
		FROM tPurchaseOrderTraffic (NOLOCK)
		WHERE PurchaseOrderTrafficKey = @OldPurchaseOrderTrafficKey

		exec sptPurchaseOrderTrafficInsert
			@NewPurchaseOrderKey,
			@ISCICode, 
			@ShowPercent,
			@StartDate,
			@EndDate,
			@Comments,
			@NewTrafficKey OUTPUT
	END
	
	
	
	SELECT @OldPurchaseOrderDetailKey = -1
      WHILE (1=1)
      BEGIN
            SELECT @OldPurchaseOrderDetailKey = MIN(PurchaseOrderDetailKey)
            FROM   tPurchaseOrderDetail (NOLOCK)
            Where  PurchaseOrderKey = @PurchaseOrderKey 
            AND PurchaseOrderDetailKey > @OldPurchaseOrderDetailKey
            AND TransferToKey is null

			IF @OldPurchaseOrderDetailKey IS NULL
                  BREAK
            
			SELECT @PurchaseOrderKey = PurchaseOrderKey,
			@LineNumber = LineNumber,
			@ProjectKey = ISNULL(@CopyProjectKey, ProjectKey),
			@TaskKey = ISNULL(@CopyTaskKey, TaskKey) ,
			@ItemKey = ItemKey,
			@ClassKey = ISNULL(@CopyClassKey, ClassKey),
			@ShortDescription = ShortDescription,
			@Quantity = Quantity,
			@UnitCost = UnitCost,
			@UnitDescription = UnitDescription ,
			@TotalCost = TotalCost,
			@Billable = Billable ,
			@Markup = Markup,
			@BillableCost = BillableCost ,
			@LongDescription = LongDescription ,
			@CustomFieldKey = CustomFieldKey,
			@DetailOrderDate = DetailOrderDate ,
			@DetailOrderEndDate = DetailOrderEndDate,
			@UserDate1 = UserDate1,
			@UserDate2 = UserDate2,
			@UserDate3 = UserDate3,
			@UserDate4 = UserDate4,
			@UserDate5 = UserDate5,
			@UserDate6 = UserDate6,
			@OrderDays = OrderDays,
			@OrderTime = OrderTime,
			@OrderLength = OrderLength,
			@Taxable = Taxable,
			@Taxable2 = Taxable2,
			@AdjustmentNumber = AdjustmentNumber,
			@MediaRevisionReasonKey = MediaRevisionReasonKey,
			@UnitRate = UnitRate,
			@OfficeKey = ISNULL((SELECT OfficeKey FROM tProject (NOLOCK) WHERE ProjectKey = @ProjectKey), OfficeKey),
			@DepartmentKey = DepartmentKey,
			@GrossAmount = GrossAmount,
			@PTotalCost = PTotalCost,
			@PCurrencyID = PCurrencyID,
			@PExchangeRate = PExchangeRate,
			@Commission = Commission,
			@SalesTaxAmount = SalesTaxAmount,
			@SalesTax1Amount = SalesTax1Amount,
			@SalesTax2Amount = SalesTax2Amount

			FROM   tPurchaseOrderDetail (NOLOCK)
            WHERE PurchaseOrderDetailKey = @OldPurchaseOrderDetailKey
 
            IF ISNULL(@CustomFieldKey,0) > 0
            BEGIN
				SELECT	@FieldSetKey = FieldSetKey
				FROM	tObjectFieldSet (NOLOCK)
				WHERE	ObjectFieldSetKey = @CustomFieldKey
				
				EXEC spCF_tObjectFieldSetInsert @FieldSetKey, @ObjectFieldSetKey OUTPUT
				
				IF ISNULL(@ObjectFieldSetKey,0) > 0
					INSERT	tFieldValue
							(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
					SELECT	newid(), FieldDefKey, @ObjectFieldSetKey, FieldValue
					FROM	tFieldValue (NOLOCK)
					WHERE	ObjectFieldSetKey = @CustomFieldKey
            END
			ELSE
				SELECT @ObjectFieldSetKey = NULL	


			-- make sure that the task belong to the project, if not null, it
			if isnull(@TaskKey, 0) > 0
			begin
				if (select ProjectKey from tTask (nolock) where TaskKey = @TaskKey)
					<> @ProjectKey
					select @TaskKey = null
			end

			EXEC sptPurchaseOrderDetailInsert
			@NewPurchaseOrderKey,
			@LineNumber,
			@ProjectKey,
			@TaskKey ,
			@ItemKey ,
			@ClassKey ,
			@ShortDescription ,
			@Quantity ,
			@UnitCost ,
			@UnitDescription ,
			@TotalCost ,
			@UnitRate,
			@Billable ,
			@Markup ,
			@BillableCost ,
			@LongDescription ,
			@ObjectFieldSetKey ,
			@DetailOrderDate ,
			@DetailOrderEndDate ,
			@UserDate1 ,
			@UserDate2 ,
			@UserDate3 ,
			@UserDate4 ,
			@UserDate5 ,
			@UserDate6 ,
			@OrderDays ,
			@OrderTime ,
			@OrderLength ,
			@Taxable ,
			@Taxable2 ,
			@OfficeKey,
			@DepartmentKey,
			@GrossAmount,	
			@PCurrencyID,		
			@PExchangeRate,
			@PTotalCost,
			@NewPurchaseOrderDetailKey OUTPUT

		-- Now update the revision history + missing fields in sp insert
		UPDATE tPurchaseOrderDetail
		SET	   AdjustmentNumber = @AdjustmentNumber
			  ,MediaRevisionReasonKey = @MediaRevisionReasonKey
			  ,Commission = @Commission
			  ,SalesTaxAmount = @SalesTaxAmount
			  ,SalesTax1Amount = @SalesTax1Amount
			  ,SalesTax2Amount = @SalesTax2Amount
		WHERE PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey
		
		-- Now copy the taxes
		insert tPurchaseOrderDetailTax (PurchaseOrderDetailKey, SalesTaxKey, SalesTaxAmount)
		select @NewPurchaseOrderDetailKey, SalesTaxKey, SalesTaxAmount
		from   tPurchaseOrderDetailTax (nolock)
		where  PurchaseOrderDetailKey = @OldPurchaseOrderDetailKey

      END

-- rollup the taxes and totals from the lines to the header on the new PO
EXEC sptPurchaseOrderRollupAmounts @NewPurchaseOrderKey 

-- Run project rollup on original po since project keys were obtained from it
EXEC sptProjectRollupUpdateEntity 'tPurchaseOrder', @PurchaseOrderKey, 0


RETURN 1
GO
