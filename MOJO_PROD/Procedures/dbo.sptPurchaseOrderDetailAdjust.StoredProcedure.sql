USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailAdjust]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailAdjust]
	(
		@PurchaseOrderDetailKey int	-- Minimum of PurchaseOrderDetailKey for a line # and PO
		,@MediaRevisionReasonKey int
		,@Quantity decimal(24, 4)
		,@UnitCost money
		,@Markup decimal(24,4)
		,@TotalCost money
		,@BillableCost money
		,@SpotDate datetime		-- only used by BC daily and weekly, will help locate spot for a line # 
		,@GrossAmount money = null
		,@Quantity1 decimal(24, 4) = null
		,@Quantity2 decimal(24, 4) = null
		,@UnitRate money = null
		,@Commission decimal(24, 4) = null
		,@AdjustmentsOptionFromPO int = 0
		,@Taxable tinyint = 0
		,@Taxable2 tinyint = 0
		,@SalesTaxAmount money = 0
		,@SalesTax1Amount money = 0
		,@SalesTax2Amount money = 0
		,@oIdentity int Output
		,@oIdentityReversal int Output
	)

AS -- Encrypt

/*
|| When     Who Rel    What
|| 03/01/07 GHL 8.4    Added Project Rollup
|| 09/18/07 BSH 8.5    Added Office and Department Keys.
|| 06/23/11 RLB 10.545 (114864) get new custom fields keys for the revision lines
|| 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @ShortDescription from 200 to 300
|| 03/21/13 WDF 10.5.6.6 (172223) Adjust negative amounts when doing revisions with reversals
|| 10/09/13 CRG 10.5.7.3 Added @GrossAmount, @Quantity1, @Quantity2, @UnitRate, @Commission
|| 12/17/13 GHL 10.5.7.5 Changes for multi currency
|| 04/29/14 RLB 10.5.7.9 (214240) increasing short description
|| 05/01/14 GHL 10.5.7.9 Added @oIdentityReversal the reversal PO detail created if ShowAdjustmentsAsSingleLine = 0
||                       i.e. 1 reversal and a new value 
|| 05/02/14 GHL 10.5.7.9 Added option to read adjustment method from PO
|| 08/26/14 GHL 10.5.8.3 Added taxes for new media screens
*/
	SET NOCOUNT ON
		
	select @oIdentityReversal = null

	-- General purpose vars	
	declare @NewPurchaseOrderDetailKey int
			,@SpotPurchaseOrderDetailKey int
			,@ShowAdjustmentsAsSingleLine int
			,@CompanyKey int
			,@POKind Int			-- 0:PO ,1:IO, 2:BC
			,@FlightInterval Int	-- 1: Daily, 2: Weekly, 3: Summary
			,@RetVal Int
			,@AdjustmentNumber Int
			,@PTotalCost money -- we need to recalc this

	-- Vars for reversal
	declare	@InsertReversal int
			,@RevQuantity decimal(24, 4)
			,@RevUnitCost money
			,@RevMarkup decimal(24,4)
			,@RevTotalCost money
			,@RevBillableCost money
			,@RevGrossAmount money
			,@RevQuantity1 decimal(24, 4)
			,@RevQuantity2 decimal(24, 4)
			,@RevUnitRate money
			,@RevCommission decimal(24, 4)
		    ,@RevSalesTaxAmount money
			,@RevSalesTax1Amount money
			,@RevSalesTax2Amount money
			,@RevTaxable tinyint
			,@RevTaxable2 tinyint

	-- Vars for POD capture							
	declare @PurchaseOrderKey int,
			@LineNumber int,
			@ProjectKey int,
			@TaskKey int,
			@ItemKey int,
			@ClassKey int,
			@ShortDescription varchar(max),
			@UnitDescription varchar(30),
			@Billable tinyint,
			@LongDescription varchar(6000),
			@CustomFieldKey int,
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
			@OfficeKey int,
			@DepartmentKey int,
			@FieldSetKey int,
			@ObjectFieldSetKey int,
			@FieldSet2Key int,
			@ObjectFieldSet2Key int,
			@PCurrencyID varchar(3),
			@PExchangeRate decimal(24,7),
			@ExchangeRate decimal(24,7)
				
		Select  
			@PurchaseOrderKey = pod.PurchaseOrderKey,
			@LineNumber = pod.LineNumber,
			@POKind = po.POKind,
			@FlightInterval = po.FlightInterval,
			@ShowAdjustmentsAsSingleLine = 
			case when @AdjustmentsOptionFromPO = 0 then	
				CASE 
					WHEN po.POKind = 1 THEN ISNULL(pref.IOShowAdjustmentsAsSingleLine, 1)
					WHEN po.POKind = 2 THEN ISNULL(pref.BCShowAdjustmentsAsSingleLine, 1)
					ELSE 1
				END
			else ISNULL(po.ShowAdjustmentsAsSingleLine, 1)
			end
				,
			@ExchangeRate = po.ExchangeRate	 
		From tPurchaseOrderDetail pod (NOLOCK)
			inner join tPurchaseOrder po (NOLOCK) ON pod.PurchaseOrderKey = po.PurchaseOrderKey
			inner join tPreference pref (NOLOCK) ON po.CompanyKey = pref.CompanyKey
		Where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

		IF @POKind = 2 AND @FlightInterval IN (1, 2)  
		BEGIN
			-- Broadcast orders And Daily/Weekly case
			-- We may not have the right spot, check for date to get exact POD
			SELECT @SpotPurchaseOrderDetailKey = PurchaseOrderDetailKey
			From   tPurchaseOrderDetail pod (NOLOCK)
			Where  pod.PurchaseOrderKey = @PurchaseOrderKey
			And    pod.LineNumber = @LineNumber 
			AND    pod.DetailOrderDate = @SpotDate		
			
			IF @SpotPurchaseOrderDetailKey IS NOT NULL
				-- We had the wrong one, correct it
				SELECT @PurchaseOrderDetailKey = @SpotPurchaseOrderDetailKey
		END
			
	-- Get a copy of the detail record 	
	Select  @PurchaseOrderKey = pod.PurchaseOrderKey,
			@LineNumber = pod.LineNumber,
			@ProjectKey = pod.ProjectKey,
			@TaskKey = pod.TaskKey,
			@ItemKey = pod.ItemKey,
			@ClassKey = pod.ClassKey,
			@ShortDescription = pod.ShortDescription,
			--@Quantity decimal(24,4),
			--@UnitCost money,
			@UnitDescription = pod.UnitDescription,
			--@TotalCost = TotalCost,
			@Billable = 1, -- pod.Billable,  -- Or 1?
			--@Markup = Markup,
			--@BillableCost = BillableCost,
			@LongDescription = pod.LongDescription,
			@CustomFieldKey = pod.CustomFieldKey,
			@DetailOrderDate = pod.DetailOrderDate,
			@DetailOrderEndDate = pod.DetailOrderEndDate,
			@UserDate1 = pod.UserDate1,
			@UserDate2 = pod.UserDate2,
			@UserDate3 = pod.UserDate3,
			@UserDate4 = pod.UserDate4,
			@UserDate5 = pod.UserDate5,
			@UserDate6 = pod.UserDate6,
			@OrderDays = pod.OrderDays,
			@OrderTime = pod.OrderTime,
			@OrderLength = pod.OrderLength,
			--@Taxable = pod.Taxable,
			--@Taxable2 = pod.Taxable2,
			@OfficeKey = pod.OfficeKey,
			@DepartmentKey = pod.DepartmentKey,
			@PCurrencyID = pod.PCurrencyID,
			@PExchangeRate = pod.PExchangeRate
		From tPurchaseOrderDetail pod (NOLOCK)
		Where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	if @PExchangeRate = 0
		select @PExchangeRate = 1 -- Cannot divide by 0

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


	Select @InsertReversal = 1

	IF @POKind = 2 AND @SpotPurchaseOrderDetailKey IS NULL AND @FlightInterval IN (1, 2)
	BEGIN
		-- We could not find the spot
		-- The user picked a date that was not used so far for that line
		-- We cannot do the reversal
		Select @InsertReversal = 0
		
		-- Now get the dates from the spot date entered by user
		SELECT @DetailOrderDate = @SpotDate
		IF @FlightInterval = 2 -- Weekly
			SELECT @DetailOrderEndDate = DATEADD(Day, 6, @DetailOrderDate)
		ELSE
			SELECT @DetailOrderEndDate = @DetailOrderDate
		
	END 

	IF @ShowAdjustmentsAsSingleLine = 1
	BEGIN
		-- Just copy what we have
		-- The quantity is the Net Difference
			
		-- need to recalc PTotalCost
		select @PTotalCost =  round( 
				(isnull(@ExchangeRate, 1) * @TotalCost) / isnull(@PExchangeRate, 1) 
					,2)

		EXEC @RetVal = sptPurchaseOrderDetailInsert @PurchaseOrderKey,
			@LineNumber,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@ShortDescription,
			@Quantity,
			@UnitCost,
			@UnitDescription,
			@TotalCost,
			NULL,
			@Billable,
			@Markup,
			@BillableCost,
			@LongDescription,
			@ObjectFieldSetKey,
			@DetailOrderDate,
			@DetailOrderEndDate,
			@UserDate1,
			@UserDate2,
			@UserDate3,
			@UserDate4,
			@UserDate5,
			@UserDate6,
			@OrderDays,
			@OrderTime,
			@OrderLength,
			@Taxable,
			@Taxable2,
			@OfficeKey,
			@DepartmentKey,		
			@GrossAmount,
			@PCurrencyID,
			@PExchangeRate,	
			@PTotalCost,
			@NewPurchaseOrderDetailKey OUTPUT

		-- Check returns later !!!!!!!!
		IF @NewPurchaseOrderDetailKey IS NULL
			RETURN -1
			
		SELECT @AdjustmentNumber = MAX(AdjustmentNumber)
		FROM   tPurchaseOrderDetail (NOLOCK)
		WHERE  PurchaseOrderKey = @PurchaseOrderKey
		AND    LineNumber = @LineNumber
		
		SELECT @AdjustmentNumber = ISNULL(@AdjustmentNumber, 0) + 1 
		
		UPDATE tPurchaseOrderDetail
		SET    MediaRevisionReasonKey = @MediaRevisionReasonKey
			  ,AdjustmentNumber = @AdjustmentNumber
			  ,GrossAmount = @GrossAmount
			  ,Quantity1 = @Quantity1
			  ,Quantity2 = @Quantity2
			  ,UnitRate = @UnitRate
			  ,Commission = @Commission
			  ,LineType = 'rev' --only used by the new media screens, so it doesn't hurt to always set it here

			  ,SalesTaxAmount = @SalesTaxAmount
			  ,SalesTax1Amount = @SalesTax1Amount
			  ,SalesTax2Amount = @SalesTax2Amount
			   
		WHERE  PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey
	END

	IF @ShowAdjustmentsAsSingleLine = 0
	BEGIN
		-- We need to insert 2 rows, first is a reversal of the old one
		-- The second is a new amount
		
		If @InsertReversal = 1
		BEGIN
			SELECT 	@RevQuantity = Quantity * -1
					,@RevUnitCost = UnitCost
					,@RevMarkup = Markup
					,@RevTotalCost = TotalCost * -1
					,@RevBillableCost = BillableCost * -1
					,@RevGrossAmount = GrossAmount * -1
					,@RevQuantity1 = Quantity1 * - 1
					,@RevQuantity2 = Quantity2 * - 1
					,@RevUnitRate = UnitRate * - 1
					,@RevCommission = Commission
					,@RevSalesTaxAmount = SalesTaxAmount * -1
					,@RevSalesTax1Amount = SalesTax1Amount * -1
					,@RevSalesTax2Amount = SalesTax2Amount * -1

			FROM    tPurchaseOrderDetail (NOLOCK)
			WHERE   PurchaseOrderDetailKey = @PurchaseOrderDetailKey		

			if isnull(@RevSalesTax1Amount, 0) = 0
				select @RevTaxable = 0
			else
				select @RevTaxable = 1
			
			if isnull(@RevSalesTax2Amount, 0) = 0
				select @RevTaxable2 = 0
			else
				select @RevTaxable2 = 1

			/* This does not seem to work well with the UI and the new media screens
			-- Adjust IO Revisions with a Negative BillableCost
			IF @POKind = 1
			  IF @BillableCost < 0		        
					Select @BillableCost = (@RevBillableCost * -1) + @BillableCost
					      ,@TotalCost = @BillableCost  - (@BillableCost * (@Markup / 100))
						  
			-- Adjust BC Revisions with a Negative Quantity
			IF @POKind = 2
			  IF @Quantity < 0		        
					Select @Quantity = (@RevQuantity * -1) + @Quantity
					      ,@TotalCost = (@Quantity * @UnitCost) - ((@Quantity * @UnitCost) * (@Markup / 100))
						  ,@BillableCost = (@Quantity * @UnitCost)

			*/

		-- need to recalc PTotalCost
		select @PTotalCost =  round( 
				(isnull(@ExchangeRate, 1) * @RevTotalCost) / isnull(@PExchangeRate, 1) 
					,2)

			EXEC @RetVal = sptPurchaseOrderDetailInsert @PurchaseOrderKey,
				@LineNumber,
				@ProjectKey,
				@TaskKey,
				@ItemKey,
				@ClassKey,
				@ShortDescription,
				@RevQuantity,
				@RevUnitCost,
				@UnitDescription,
				@RevTotalCost,
				NULL,
				@Billable,
				@RevMarkup,
				@RevBillableCost,
				@LongDescription,
				@ObjectFieldSetKey,
				@DetailOrderDate,
				@DetailOrderEndDate,
				@UserDate1,
				@UserDate2,
				@UserDate3,
				@UserDate4,
				@UserDate5,
				@UserDate6,
				@OrderDays,
				@OrderTime,
				@OrderLength,
				@RevTaxable,
				@RevTaxable2,
				@OfficeKey,
			    @DepartmentKey,	
				@RevGrossAmount,
				@PCurrencyID,
				@PExchangeRate,	
				@PTotalCost,
				@NewPurchaseOrderDetailKey OUTPUT

			-- Check returns later !!!!!!!!
			IF @NewPurchaseOrderDetailKey IS NULL
				RETURN -1
				
			SELECT @oIdentityReversal = @NewPurchaseOrderDetailKey

			SELECT @AdjustmentNumber = MAX(AdjustmentNumber)
			FROM   tPurchaseOrderDetail (NOLOCK)
			WHERE  PurchaseOrderKey = @PurchaseOrderKey
			AND    LineNumber = @LineNumber
			
			SELECT @AdjustmentNumber = ISNULL(@AdjustmentNumber, 0) + 1 
			
			UPDATE tPurchaseOrderDetail
			SET    MediaRevisionReasonKey = @MediaRevisionReasonKey
				  ,AdjustmentNumber = @AdjustmentNumber
				  ,GrossAmount = @RevGrossAmount
				  ,Quantity1 = @RevQuantity1
				  ,Quantity2 = @RevQuantity2
				  ,UnitRate = @RevUnitRate
				  ,Commission = @RevCommission
				  ,LineType = 'rev' --only used by the new media screens, so it doesn't hurt to always set it here
			
				  ,SalesTaxAmount = @RevSalesTaxAmount
				  ,SalesTax1Amount = @RevSalesTax1Amount
			      ,SalesTax2Amount = @RevSalesTax2Amount

			WHERE  PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey
		
		END

		IF ISNULL(@CustomFieldKey,0) > 0
		BEGIN
			SELECT	@FieldSet2Key = FieldSetKey
			FROM	tObjectFieldSet (NOLOCK)
			WHERE	ObjectFieldSetKey = @CustomFieldKey
			
			EXEC spCF_tObjectFieldSetInsert @FieldSet2Key, @ObjectFieldSet2Key OUTPUT
			
			IF ISNULL(@ObjectFieldSet2Key,0) > 0
				INSERT	tFieldValue
						(FieldValueKey, FieldDefKey, ObjectFieldSetKey, FieldValue)
				SELECT	newid(), FieldDefKey, @ObjectFieldSet2Key, FieldValue
				FROM	tFieldValue (NOLOCK)
				WHERE	ObjectFieldSetKey = @CustomFieldKey
		END
		ELSE
			SELECT @ObjectFieldSet2Key = NULL
		
		SELECT @NewPurchaseOrderDetailKey = NULL
		

		-- need to recalc PTotalCost
		select @PTotalCost =  round( 
				(isnull(@ExchangeRate, 1) * @TotalCost) / isnull(@PExchangeRate, 1) 
					,2)

		-- Now insert the new amount 
		EXEC @RetVal = sptPurchaseOrderDetailInsert @PurchaseOrderKey,
			@LineNumber,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@ShortDescription,
			@Quantity,
			@UnitCost,
			@UnitDescription,
			@TotalCost,
			NULL,
			@Billable,
			@Markup,
			@BillableCost,
			@LongDescription,
			@ObjectFieldSet2Key,
			@DetailOrderDate,
			@DetailOrderEndDate,
			@UserDate1,
			@UserDate2,
			@UserDate3,
			@UserDate4,
			@UserDate5,
			@UserDate6,
			@OrderDays,
			@OrderTime,
			@OrderLength,
			@Taxable,
			@Taxable2,
			@OfficeKey,
			@DepartmentKey,	
			@GrossAmount,
			@PCurrencyID,
			@PExchangeRate,	
			@PTotalCost,			
			@NewPurchaseOrderDetailKey OUTPUT

		-- Check returns later !!!!!!!!
		IF @NewPurchaseOrderDetailKey IS NULL
			RETURN -1
			
		SELECT @AdjustmentNumber = MAX(AdjustmentNumber)
		FROM   tPurchaseOrderDetail (NOLOCK)
		WHERE  PurchaseOrderKey = @PurchaseOrderKey
		AND    LineNumber = @LineNumber
		
		SELECT @AdjustmentNumber = ISNULL(@AdjustmentNumber, 0) + 1 
		
		UPDATE tPurchaseOrderDetail
		SET    MediaRevisionReasonKey = @MediaRevisionReasonKey
			  ,AdjustmentNumber = @AdjustmentNumber
			  ,GrossAmount = @GrossAmount
			  ,Quantity1 = @Quantity1
			  ,Quantity2 = @Quantity2
			  ,UnitRate = @UnitRate
			  ,Commission = @Commission
			  ,LineType = 'rev' --only used by the new media screens, so it doesn't hurt to always set it here
		
		      ,SalesTaxAmount = @SalesTaxAmount
			  ,SalesTax1Amount = @SalesTax1Amount
			  ,SalesTax2Amount = @SalesTax2Amount
		WHERE  PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey
				 						
	END

	SELECT @oIdentity = @NewPurchaseOrderDetailKey

	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1
														
	RETURN 1
GO
