USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailUpdateFromWorksheet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptPurchaseOrderDetailUpdateFromWorksheet]
	@PurchaseOrderDetailKey int,
	@PurchaseOrderKey int,
	@LineNumber int = NULL,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@ShortDescription varchar(max),
	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Billable tinyint,
	@Markup decimal(24,4),
	@BillableCost money,
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
	@Taxable tinyint,
	@Taxable2 tinyint,
	@OfficeKey int,
	@DepartmentKey int,
	@AdjustmentNumber int = 0,
	@SelectUpdate tinyint = 0,
	@Quantity1 decimal(24, 4) = null,
	@Quantity2 decimal(24, 4) = null,
	@LineType varchar(50) = null,
	@MediaPremiumKey int = null,
	@PremiumAmountType varchar(50) = null,
	@PremiumPct decimal(24, 4) = null,
	@GrossAmount money = null,
	@Commission decimal(24, 4) = null,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,
	@DetailVendorKey int = null,
	@Bucket int = null,
	@CurrentMediaPrintSpaceKey int,
	@CurrentMediaPrintSpaceID varchar(500),
	@CurrentMediaPrintPositionKey int,
	@CurrentMediaPrintPositionID varchar(500),
	@CurrentCompanyMediaPrintContractKey int,
	@CommissionablePremium tinyint,
	@BucketStartDate smalldatetime = null, -- If not NULL, then we only calc the adjustment for that one bucket
	@OrigPrinted int = 0,
	@OrigEmailed int = 0,
	@OrigRevision int = 0,
	@UserKey int = null,
	@CurrentMediaUnitTypeKey int = null,
	@CancelBuy int = 0,
	@SalesTaxAmount money = 0,
	@SalesTax1Amount money = 0,
	@SalesTax2Amount money = 0
	
AS

/*
|| When      Who Rel      What
|| 10/8/13   CRG 10.5.7.3 Created to check if a line update requires a revision
|| 12/17/13  CRG 10.5.7.5 Added currency parameters to keep it in line with sptPurchaseOrderDetailUpdate.
||                        We will hook in the currency values at a later time once we get the media screens done.
|| 01/17/14  CRG 10.5.7.6 Added @BucketStartDate
|| 1/3/13    CRG 10.5.7.6 Added @DetailVendorKey
|| 03/14/14  CRG 10.5.7.7 Added @Bucket
|| 04/28/14  RLB 10.5.7.9 (214240) increasing the description length.
|| 04/29/14  GHL 10.5.7.9 Added a patch to set the media premium on adjustments if missing
|| 04/30/14  CRG 10.5.7.9 Now checking for changes to Qty1 and Qty2 when determining whether to do a revision
|| 05/01/14  GHL 10.5.7.9 Added update of reversal when @ShowAdjustmentsAsSingleLine = 0
||                        + @CurrentShortDescription is varchar(max)
|| 05/02/14  GHL 10.5.7.9 Corrected the calcs of initial current values (they were incorrect when  @ShowAdjustmentsAsSingleLine = 0)
|| 05/06/14  GHL 10.5.7.9 Modified update of old values
|| 05/07/14  GHL 10.5.7.9 Added checking of LineNumber=1/LineType=order unicity after seeing duplicates 
|| 05/12/14  GHL 10.5.8.0 Added update of old values in the section processing financial values
|| 05/13/14  GHL 10.5.8.0 Added logging of revision history for PO
|| 05/27/14 GHL 10.5.8.0 Added logging for media order
|| 06/03/14 GHL 10.5.8.0 if @ShowAdjustmentsAsSingleLine = 1, need to add current values before logging
|| 06/04/14 GHL 10.5.8.1 Added logic for CurrentMediaPrintPositionID (same as CurrentMediaPrintSpaceID)
|| 06/05/14 GHL 10.5.8.1 Added logic manual premiums (new field tMediaBuyRevisionHistory.PremiumID) 
||                       + fixed logic for premium inserts
|| 06/06/14 GHL 10.5.8.1 Request by Susan to log field changes after Approval (instead of after a rev increase)
|| 06/18/14 GHL 10.5.8.1 Added logging of change of MediaUnitTypeKey
|| 06/23/14 GHL 10.5.8.1 Recalculating now CurrentUnitCost and CurrentUnitRate before logging these values
||                       Do not update if the PO or POD are cancelled
|| 07/17/14 GHL 10.5.8.2 Added logging of changes of premiumID
|| 07/23/14 GHL 10.5.8.2 patch so that all PODs assigned to a premium have the same medium if they change the MediaPremiumKey/PremiumID
||	                     because this creates too many problems with the reports
|| 07/25/14 GHL 10.5.8.2 after recalculating net cost, gross cost and quantity, do not forget unit cost and unit rate 
|| 8/7/14   GHL 10.5.8.3 if we have revisions, we cannot update the financials, otherwise we would update one of the PODs
||                       with what is on the screen and then the new sum for the line number would be different from what is on the screen
|| 8/11/14  GHL 10.5.8.3 After discussion with Susan about the possibility to create adjustements as soon as approved
||                       versus after printing only
||                       - Creating now Adjustments if Approved and Billed
||                       - Setting now Printed = 0, Emailed = 0, DateSent = null, this needs to be tested because I do not know
||                       if the saving is used with a data manager
||                       - Setting the revision = revision + 1 is there is a adjustment created
||                       Added @CancelBuy for the case when we cancel the buy, we must display on the report 
||                       Net 2000 and -2000 (for example) for a total of 0      
|| 8/19/14  GHL 10.5.8.3 Copy DetailOrderDate from the Buyline for premiums and adjustments        
|| 8/20/14  GHL 10.5.8.3 Tweeked revisions and the setting of Printed flag     
|| 08/22/14 GHL 10.5.8.3 Added sales tax amounts       
|| 09/12/14 GHL 10.5.8.4 Updating now last/bottom POD instead of first/top POD
|| 09/16/14 GHL 10.5.8.4 Propagate description from buyline to premium (request by Susan)
|| 11/07/14 GHL 10.5.8.6 Added calculation of SalesTaxAmount = SalesTax1Amount + SalesTax2Amount because of
||                       some potential existing problems with the UI
|| 11/14/14 GHL 10.5.8.6 If the buy line is applied, it cannot be cancelled (last request from SM)
*/
	DECLARE @kErrOrderNum int		select @kErrOrderNum = -10	-- start at -10, because sptPurchaseOrderDetailUpdate uses <-10 
	DECLARE @kErrCancel int			select @kErrCancel = -11

	DECLARE @kPrintKind int			select @kPrintKind = 1
	DECLARE @kTVKind int			select @kTVKind = 2
	DECLARE @kERKind int			select @kERKind = 3
	DECLARE @kInterKind int			select @kInterKind = 4
	DECLARE @kOutdoorKind int		select @kOutdoorKind = 5
	DECLARE @kRadioKind int			select @kRadioKind = 6

	-- If the user  wants to cancel, we cannot do it if the buy line is applied
	if @CancelBuy = 1 and exists 
		(select 1 from tVoucherDetail vd (nolock)
		inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
		where pod.PurchaseOrderKey = @PurchaseOrderKey
		) return @kErrCancel
	 			
	-- Cleanup of taxes because the UI is still too brittle
	-- Because the new media screens only use Tax1 and Tax2 (i.e. no other taxes), recalc Tax = Tax1 + Tax2
	select @SalesTaxAmount = isnull(@SalesTax1Amount, 0) + isnull(@SalesTax2Amount, 0) 

	DECLARE	@ShowAdjustmentsAsSingleLine tinyint,
			@NoFinancialUpdate tinyint,
			@NewPurchaseOrderDetailKey int,
			@ReversalPurchaseOrderDetailKey int,
			@CompanyKey int,
			@POKind int,
			@Status int,
			--@Printed tinyint,
			--@Emailed tinyint,
			@Revision int,
			@CurrentDetailOrderDate smalldatetime,
			@CurrentShortDescription varchar(max),
			@CurrentQuantity decimal(24, 4),
			@CurrentQuantity1 decimal(24, 4),
			@CurrentQuantity2 decimal(24, 4),
			@CurrentUnitCost money,
			@CurrentUnitRate money,
			@CurrentTotalCost money,
			@CurrentGrossAmount money,
			@CurrentBillableCost money,
			@CurrentSalesTaxAmount money,
			@CurrentSalesTax1Amount money,
			@CurrentSalesTax2Amount money,
			-- These are "NEW" because the header has already been saved so "CURRENT" is passed in
			@MediaPrintSpaceKey int,
			@MediaPrintSpaceID varchar(500),
			@MediaPrintPositionKey int,
			@MediaPrintPositionID varchar(500),
			@CompanyMediaPrintContractKey int,
			@CurrentInvoiceLineKey int,
			@CurrentLineType varchar(50),
			@LogChanges int, -- to indicate to log changes
			@NetGrossChanges int, -- to indicate changes of Net/Gross/Quantity
			@MediaUnitTypeKey int,
			@POCancelled int,
			@Cancelled int,
			@CurrentMediaPremiumKey int

	SELECT	@NoFinancialUpdate = 0
	       ,@LogChanges = 0

	SELECT	@ShowAdjustmentsAsSingleLine = ISNULL(po.ShowAdjustmentsAsSingleLine, 1)
	FROM	tPurchaseOrder po (nolock)
	WHERE	po.PurchaseOrderKey = @PurchaseOrderKey
	
	SELECT	@CompanyKey = CompanyKey,
			@POKind = POKind,
			@Status = Status,
			--@Printed = Printed,  -- because of the loop in VB rely on OrigPrinted
			--@Emailed = Emailed,
			@Revision = Revision,
			@MediaPrintSpaceKey = MediaPrintSpaceKey,
			@MediaPrintSpaceID = MediaPrintSpaceID,
			@MediaPrintPositionKey = MediaPrintPositionKey,
			@MediaPrintPositionID = MediaPrintPositionID,
			@CompanyMediaPrintContractKey = CompanyMediaPrintContractKey,
			@MediaUnitTypeKey = MediaUnitTypeKey,
			@POCancelled = Cancelled
 	FROM	tPurchaseOrder (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey

	-- If this is cancelled, abort 
	IF isnull(@POCancelled, 0) = 1
		RETURN @PurchaseOrderDetailKey

	SELECT	@CurrentDetailOrderDate = DetailOrderDate,
			@CurrentShortDescription = ShortDescription,
			@LineNumber = LineNumber,
			@CurrentInvoiceLineKey = InvoiceLineKey,
			@CurrentLineType = LineType,
			@Cancelled = Cancelled,
			@CurrentMediaPremiumKey = MediaPremiumKey
	FROM	tPurchaseOrderDetail (nolock)
	WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	
	-- If this is cancelled, abort
	IF isnull(@Cancelled, 0) = 1
		RETURN @PurchaseOrderDetailKey

	-- Always try to update the most current POD (i.e. max PurchaseOrderDetailKey for the line number)
	-- this situation could happen when we update a prebilled POD, creating a reversal/Adjustment  
	-- and the UI would still point to the old POD
	declare @MaxPurchaseOrderDetailKey int
	select @MaxPurchaseOrderDetailKey = Max(PurchaseOrderDetailKey) 
	from tPurchaseOrderDetail (nolock)
	where PurchaseOrderKey = @PurchaseOrderKey
	and   LineNumber = @LineNumber

	if isnull(@MaxPurchaseOrderDetailKey, 0) > 0 and isnull(@MaxPurchaseOrderDetailKey, 0) <> isnull(@PurchaseOrderDetailKey, 0)
	begin
		select @PurchaseOrderDetailKey = @MaxPurchaseOrderDetailKey
	
		-- and reload the current info
		SELECT	@CurrentDetailOrderDate = DetailOrderDate,
				@CurrentShortDescription = ShortDescription,
				@LineNumber = LineNumber,
				@CurrentInvoiceLineKey = InvoiceLineKey,
				@CurrentLineType = LineType,
				@Cancelled = Cancelled,
				@CurrentMediaPremiumKey = MediaPremiumKey
		FROM	tPurchaseOrderDetail (nolock)
		WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	end  


	IF @CurrentLineType IS NOT NULL
		SELECT @LineType = @CurrentLineType
	
	-- double check that the initial buyline is unique, no duplicate
	if @POKind = 1
	begin
		if @LineNumber = 1 and @LineType = 'order' 
		begin
			if isnull(@PurchaseOrderDetailKey, 0) <= 0
				if exists (select 1 from tPurchaseOrderDetail (nolock)
							where PurchaseOrderKey = @PurchaseOrderKey
							and   LineNumber = 1 and LineType = 'order')
							return  @kErrOrderNum
			else -- else POD exists, check others
				if exists (select 1 from tPurchaseOrderDetail (nolock)
							where PurchaseOrderKey = @PurchaseOrderKey
							and   PurchaseOrderDetailKey <> @PurchaseOrderDetailKey
							and   LineNumber = 1 and LineType = 'order')
							return  @kErrOrderNum
		end 
	end

	if @POKind in ( 2, 6) -- TV/Radio
	begin
		-- The bucket is used for broadcast (2 tv, 6 radio)
		SELECT	@CurrentQuantity = SUM(ISNULL(Quantity, 0)),
				@CurrentQuantity1 = SUM(ISNULL(Quantity1, 0)),
				@CurrentQuantity2 = SUM(ISNULL(Quantity2, 0)),
				@CurrentUnitCost = SUM(ISNULL(UnitCost, 0)),
				@CurrentUnitRate = SUM(ISNULL(UnitRate, 0)),
				@CurrentTotalCost = SUM(ISNULL(TotalCost, 0)),
				@CurrentGrossAmount = SUM(ISNULL(GrossAmount, 0)),
				@CurrentBillableCost = SUM(ISNULL(BillableCost, 0)),
				@CurrentSalesTaxAmount = SUM(ISNULL(SalesTaxAmount, 0)),
				@CurrentSalesTax1Amount = SUM(ISNULL(SalesTax1Amount, 0)),
				@CurrentSalesTax2Amount = SUM(ISNULL(SalesTax2Amount, 0))
		FROM	tPurchaseOrderDetail (nolock)
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
		AND		LineNumber = @LineNumber
		AND		(@BucketStartDate IS NULL
				OR
				UserDate1 = @BucketStartDate)
		AND		(@Bucket IS NULL OR
				Bucket = @Bucket)
	end
	else
	begin
		if @ShowAdjustmentsAsSingleLine = 1
			-- rollup values for that line 
			SELECT	@CurrentQuantity = SUM(ISNULL(Quantity, 0)),
				@CurrentQuantity1 = SUM(ISNULL(Quantity1, 0)),
				@CurrentQuantity2 = SUM(ISNULL(Quantity2, 0)),
				@CurrentUnitCost = SUM(ISNULL(UnitCost, 0)),
				@CurrentUnitRate = SUM(ISNULL(UnitRate, 0)),
				@CurrentTotalCost = SUM(ISNULL(TotalCost, 0)),
				@CurrentGrossAmount = SUM(ISNULL(GrossAmount, 0)),
				@CurrentBillableCost = SUM(ISNULL(BillableCost, 0)),
				@CurrentSalesTaxAmount = SUM(ISNULL(SalesTaxAmount, 0)),
				@CurrentSalesTax1Amount = SUM(ISNULL(SalesTax1Amount, 0)),
				@CurrentSalesTax2Amount = SUM(ISNULL(SalesTax2Amount, 0))
			FROM	tPurchaseOrderDetail (nolock)
			WHERE	PurchaseOrderKey = @PurchaseOrderKey
			AND		LineNumber = @LineNumber
		else
		begin
			-- the rollup is on the last line, look for last PO detail
			declare @MaxPODKey int
			select  @MaxPODKey = Max(PurchaseOrderDetailKey)
			from    tPurchaseOrderDetail (nolock)
			where   PurchaseOrderKey = @PurchaseOrderKey 
			and     LineNumber = @LineNumber

			SELECT	@CurrentQuantity = ISNULL(Quantity, 0),
				@CurrentQuantity1 = ISNULL(Quantity1, 0),
				@CurrentQuantity2 = ISNULL(Quantity2, 0),
				@CurrentUnitCost = ISNULL(UnitCost, 0),
				@CurrentUnitRate = ISNULL(UnitRate, 0),
				@CurrentTotalCost = ISNULL(TotalCost, 0),
				@CurrentGrossAmount = ISNULL(GrossAmount, 0),
				@CurrentBillableCost = ISNULL(BillableCost, 0),
				@CurrentSalesTaxAmount = ISNULL(SalesTaxAmount, 0),
				@CurrentSalesTax1Amount = ISNULL(SalesTax1Amount, 0),
				@CurrentSalesTax2Amount = ISNULL(SalesTax2Amount, 0)
			FROM	tPurchaseOrderDetail (nolock)
			WHERE	PurchaseOrderDetailKey = @MaxPODKey
		end
	end

	-- Recalculate UnitCost and UnitRate
	if isnull(@CurrentQuantity, 0) = 0
		select @CurrentUnitCost = @CurrentTotalCost
	else
		select @CurrentUnitCost = @CurrentTotalCost / @CurrentQuantity

	if isnull(@CurrentQuantity, 0) = 0
		select @CurrentUnitRate = @CurrentGrossAmount
	else
		select @CurrentUnitRate = @CurrentGrossAmount / @CurrentQuantity


declare @CreateAdjustments int	select @CreateAdjustments = 0

if @Status = 4
begin
	if @CancelBuy = 1 -- that would be the cancel Buy Line or cancel Premium cases
		select @CreateAdjustments = 1
	else
	begin
		if @ShowAdjustmentsAsSingleLine = 1
		begin
			-- at this time when the adjustment is a single line, keep on adjusting
			-- we could change later, this would require to recalc TotalCost = NewTotalCost - sum(TotalCost)
			-- in the main loop	

			-- Anything billed?
			if exists (select 1 from tPurchaseOrderDetail (nolock)
						where PurchaseOrderKey = @PurchaseOrderKey
						and   LineNumber = @LineNumber
						and   InvoiceLineKey > 0
						)
				select @CreateAdjustments = 1

			-- Anything on billing WS
			if @CreateAdjustments = 0 and exists (select 1 from tPurchaseOrderDetail pod (nolock)
						inner join tBillingDetail bd (nolock) on pod.PurchaseOrderDetailKey = bd.EntityKey and bd.Entity = 'tPurchaseOrderDetail'
						inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
						where pod.PurchaseOrderKey = @PurchaseOrderKey
						and   pod.LineNumber = @LineNumber
						and   b.Status < 5
						)
				select @CreateAdjustments = 1
		end
		else
		begin
			-- When the adjustment is on 2 lines, a reversal and a new line
			-- we can safely change the SINGLE last POD if it is not prebilled yet   

			-- Anything billed?
			if exists (select 1 from tPurchaseOrderDetail (nolock)
						where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
						and   InvoiceLineKey > 0
						)
				select @CreateAdjustments = 1

			-- Anything on billing WS
			if @CreateAdjustments = 0 and exists (select 1 from tPurchaseOrderDetail pod (nolock)
						inner join tBillingDetail bd (nolock) on pod.PurchaseOrderDetailKey = bd.EntityKey and bd.Entity = 'tPurchaseOrderDetail'
						inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
						where pod.PurchaseOrderDetailKey = PurchaseOrderDetailKey
						and   b.Status < 5
						)
				select @CreateAdjustments = 1

		end
	
	end 
end


/*
Increment the Buyline revision after saving

if the current status is Approved
AND if the buyline is currently printed (or emailed)
AND (
	if there was a change of quantity, Gross, Net, taxes, Issue Date, Space, Position, Contract on buyline or premium
		OR
	if a premium is added
		OR
	if a premium is cancelled
       )
 
*/
declare @FinancialChanges int
declare @NonFinancialChanges int
select @FinancialChanges = 0
select @NonFinancialChanges = 0

IF ISNULL(@CurrentQuantity, 0) <> ISNULL(@Quantity, 0) OR
   ISNULL(@CurrentQuantity1, 0) <> ISNULL(@Quantity1, 0) OR
   ISNULL(@CurrentQuantity2, 0) <> ISNULL(@Quantity2, 0) OR
   ISNULL(@CurrentTotalCost, 0) <> ISNULL(@TotalCost, 0) OR
   ISNULL(@CurrentGrossAmount, 0) <> ISNULL(@GrossAmount, 0) OR
   ISNULL(@CurrentBillableCost, 0) <> ISNULL(@BillableCost, 0) OR
   ISNULL(@CurrentSalesTaxAmount, 0) <> ISNULL(@SalesTaxAmount, 0) OR
   ISNULL(@CurrentSalesTax1Amount, 0) <> ISNULL(@SalesTax1Amount, 0) OR
   ISNULL(@CurrentSalesTax2Amount, 0) <> ISNULL(@SalesTax2Amount, 0) 
select @FinancialChanges = 1

 IF @CurrentDetailOrderDate <> @DetailOrderDate OR
					ISNULL(@CurrentShortDescription, '') <> ISNULL(@ShortDescription, '') OR
					ISNULL(@CurrentMediaPrintSpaceKey, 0) <> ISNULL(@MediaPrintSpaceKey, 0) OR
					ISNULL(@CurrentMediaPrintSpaceID, '') <> ISNULL(@MediaPrintSpaceID, '') OR
					ISNULL(@CurrentMediaPrintPositionKey, 0) <> ISNULL(@MediaPrintPositionKey, 0) OR
					ISNULL(@CurrentMediaPrintPositionID, '') <> ISNULL(@MediaPrintPositionID, '') OR
					ISNULL(@CurrentCompanyMediaPrintContractKey, 0) <> ISNULL(@CompanyMediaPrintContractKey, 0)
select @NonFinancialChanges = 1

declare @IncrementRevision int
select @IncrementRevision = 0
if @Status = 4 
	IF @OrigPrinted = 1 OR @OrigEmailed = 1
		If @Revision = @OrigRevision -- this is because this SP is called from a loop
			IF @FinancialChanges = 1 OR @NonFinancialChanges = 1 OR @CancelBuy = 1
				select @IncrementRevision = 1


/* test only
insert tGil(CurrentQuantity, Quantity,CurrentQuantity1, Quantity1,CurrentQuantity2, Quantity2
           ,CurrentTotalCost,TotalCost,CurrentGrossAmount,GrossAmount,CurrentBillableCost,BillableCost
		   ,CurrentSalesTaxAmount, SalesTaxAmount 
		   ,FinancialChanges, CreateAdjustments, PurchaseOrderDetailKey,PurchaseOrderKey,Printed,Emailed,Revision)
select @CurrentQuantity, @Quantity,@CurrentQuantity1, @Quantity1,@CurrentQuantity2, @Quantity2
           ,@CurrentTotalCost,@TotalCost,@CurrentGrossAmount,@GrossAmount,@CurrentBillableCost,@BillableCost
		   ,@CurrentSalesTaxAmount, @SalesTaxAmount 
		   ,@FinancialChanges, @CreateAdjustments, @PurchaseOrderDetailKey,@PurchaseOrderKey,@OrigPrinted,@OrigEmailed,@OrigRevision		    
*/


	--If it's the main "buy" line (LineNumber = 1) or it's an existing Premium line (LineNumber <> 1 and PurchaseOrderDetailKey > 0)
	IF @LineNumber = 1 OR @PurchaseOrderDetailKey > 0
	BEGIN
		--IF @Status = 4 AND ((ISNULL(@OrigPrinted, 0) + ISNULL(@OrigEmailed, 0) > 0) OR (@OrigRevision > 0) OR (@POKind = 4 AND ISNULL(@CurrentInvoiceLineKey, 0) > 0))
		if @CreateAdjustments = 1
		BEGIN
			--Now check to see if any financial fields changed requiring a new revision line
			IF @FinancialChanges = 1
			BEGIN
				SELECT @NoFinancialUpdate = 1 -- we do not need update the Financials in sptPODUpdate because we create adj here
				--SELECT @LogChanges = 1

				IF @ShowAdjustmentsAsSingleLine = 1
				BEGIN
					--Calculate the Net difference if ShowAsSingleLine is true. Otherwise, pass in the actual numbers
					SELECT	@Quantity = ISNULL(@Quantity, 0) - ISNULL(@CurrentQuantity, 0),
							@Quantity1 = ISNULL(@Quantity1, 0) - ISNULL(@CurrentQuantity1, 0),
							@Quantity2 = ISNULL(@Quantity2, 0) - ISNULL(@CurrentQuantity2, 0),
							@TotalCost = ISNULL(@TotalCost, 0) - ISNULL(@CurrentTotalCost, 0),
							@GrossAmount = ISNULL(@GrossAmount, 0) - ISNULL(@CurrentGrossAmount, 0),
							@BillableCost = ISNULL(@BillableCost, 0) - ISNULL(@CurrentBillableCost, 0),
							@SalesTaxAmount = ISNULL(@SalesTaxAmount, 0) - ISNULL(@CurrentSalesTaxAmount, 0),
							@SalesTax1Amount = ISNULL(@SalesTax1Amount, 0) - ISNULL(@CurrentSalesTax1Amount, 0),
							@SalesTax2Amount = ISNULL(@SalesTax2Amount, 0) - ISNULL(@CurrentSalesTax2Amount, 0)
							
					select @NetGrossChanges = 1

					IF @Quantity <> 0		
						SELECT	@UnitCost = @TotalCost / @Quantity
					ELSE
						SELECT	@UnitCost = @TotalCost
					
					IF @Commission <> 100
						SELECT	@UnitRate = @UnitCost / (1 - (@Commission / 100))
					ELSE
						SELECT @UnitRate = @UnitCost
				END
				ELSE
				BEGIN
					SELECT	@PurchaseOrderDetailKey = MAX(PurchaseOrderDetailKey)
					FROM	tPurchaseOrderDetail (nolock)
					WHERE	PurchaseOrderKey = @PurchaseOrderKey
					AND		LineNumber = @LineNumber
					--AND		AdjustmentNumber = @OrigRevision
				END
				
				EXEC sptPurchaseOrderDetailAdjust 
						@PurchaseOrderDetailKey, 
						null, --@MediaRevisionReasonKey
						@Quantity, 
						@UnitCost, 
						@Markup, 
						@TotalCost, 
						@BillableCost, 
						null, --@SpotDate
						@GrossAmount,
						@Quantity1,
						@Quantity2,
						@UnitRate,
						@Commission,
						1, --@AdjustmentsOptionFromPO
						@Taxable,
						@Taxable2,
						@SalesTaxAmount,
						@SalesTax1Amount,
						@SalesTax2Amount,
						@NewPurchaseOrderDetailKey output,
						@ReversalPurchaseOrderDetailKey output

						
				SELECT	@PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey
				
				-- we need to identify the final reversal due to the cancelling (shown on printout) 
				if @CancelBuy = 1
					update tPurchaseOrderDetail
					set    Cancelled = 1
					where  PurchaseOrderDetailKey in (@NewPurchaseOrderDetailKey,@ReversalPurchaseOrderDetailKey)

				--Even though sptPurchaseOrderDetailAdjust does something with the AdjustmentNumber on the lines, 
				--we're going to increment the revision number on the header and set the AdjustmentNumber on the detail line just to be safe
				
				--IF @OrigPrinted = 1 OR @OrigEmailed = 1
					--If @Revision = @OrigRevision -- inc Revision only if this is the original
						--SELECT	@Revision = ISNULL(@Revision, 0) + 1
					
				if @IncrementRevision = 1
					SELECT	@Revision = ISNULL(@Revision, 0) + 1
							,@IncrementRevision = 0

				UPDATE	tPurchaseOrder
				SET		--Printed = 0,
						--Emailed = 0,
						--DateSent = NULL,
						Revision = @Revision
				WHERE	PurchaseOrderKey = @PurchaseOrderKey
				
				UPDATE	tPurchaseOrderDetail
				SET		AdjustmentNumber = @Revision
				WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				

				-- in case they change a description and a quantity
				IF @NonFinancialChanges = 1
					UPDATE	tPurchaseOrderDetail
						SET		OldDetailOrderDate = @CurrentDetailOrderDate,
								OldShortDescription = @CurrentShortDescription,
								OldMediaPrintSpaceKey = @CurrentMediaPrintSpaceKey,
								OldMediaPrintSpaceID = @CurrentMediaPrintSpaceID,
								OldMediaPrintPositionKey = @CurrentMediaPrintPositionKey,
								OldMediaPrintPositionID = @CurrentMediaPrintPositionID,
								OldCompanyMediaPrintContractKey = @CurrentCompanyMediaPrintContractKey
						WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey

				if @ReversalPurchaseOrderDetailKey is not null
					UPDATE	tPurchaseOrderDetail
					SET		AdjustmentNumber = @Revision
					WHERE	PurchaseOrderDetailKey = @ReversalPurchaseOrderDetailKey

				if @MediaPremiumKey > 0
				begin
					-- patch for missing premiums on updates
					update tPurchaseOrderDetail
					set    MediaPremiumKey = @MediaPremiumKey
					where  PurchaseOrderKey = @PurchaseOrderKey
					and    LineNumber = @LineNumber -- same premium
					and    LineNumber <> 1 -- not a buy
					and    MediaPremiumKey is null
				end

			END
			ELSE
			BEGIN
				-- there was no Financial Changes

				-- Are there any NON Financial changes
				IF @NonFinancialChanges = 1
				BEGIN
					SELECT @NoFinancialUpdate = 1 -- because we just proved that the financials did not change
					      --,@LogChanges = 1

					SELECT	@NewPurchaseOrderDetailKey = MAX(PurchaseOrderDetailKey)
					FROM	tPurchaseOrderDetail (nolock)
					WHERE	PurchaseOrderKey = @PurchaseOrderKey
					AND		LineNumber = @LineNumber
					--AND		AdjustmentNumber = @OrigRevision
					
					if @NewPurchaseOrderDetailKey is not null
					SELECT	@ReversalPurchaseOrderDetailKey = MAX(PurchaseOrderDetailKey)
					FROM	tPurchaseOrderDetail (nolock)
					WHERE	PurchaseOrderKey = @PurchaseOrderKey
					AND		LineNumber = @LineNumber
					--AND		AdjustmentNumber = @OrigRevision
					AND     PurchaseOrderDetailKey <> @NewPurchaseOrderDetailKey

					--IF @OrigPrinted = 1 OR @OrigEmailed = 1
					--BEGIN
						---If @Revision = @OrigRevision -- inc Revision only if this is the original
							--SELECT	@Revision = ISNULL(@Revision, 0) + 1
					
						if @IncrementRevision = 1
						SELECT	@Revision = ISNULL(@Revision, 0) + 1
							,@IncrementRevision = 0

						UPDATE	tPurchaseOrder
						SET		--Printed = 0,
								--Emailed = 0,
								--DateSent = NULL,
								Revision = @Revision
						WHERE	PurchaseOrderKey = @PurchaseOrderKey
						
						UPDATE	tPurchaseOrderDetail
						SET		AdjustmentNumber = @Revision,
								OldDetailOrderDate = @CurrentDetailOrderDate,
								OldShortDescription = @CurrentShortDescription,
								OldMediaPrintSpaceKey = @CurrentMediaPrintSpaceKey,
								OldMediaPrintSpaceID = @CurrentMediaPrintSpaceID,
								OldMediaPrintPositionKey = @CurrentMediaPrintPositionKey,
								OldMediaPrintPositionID = @CurrentMediaPrintPositionID,
								OldCompanyMediaPrintContractKey = @CurrentCompanyMediaPrintContractKey
						WHERE	PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey

						IF @ShowAdjustmentsAsSingleLine = 0 AND @ReversalPurchaseOrderDetailKey is not null
						UPDATE	tPurchaseOrderDetail
						SET		AdjustmentNumber = @Revision
						WHERE	PurchaseOrderDetailKey = @ReversalPurchaseOrderDetailKey
					
					/*	
					END
					ELSE
					BEGIN
						UPDATE	tPurchaseOrderDetail
						SET		OldDetailOrderDate = ISNULL(OldDetailOrderDate, @CurrentDetailOrderDate),
								OldShortDescription = ISNULL(OldShortDescription, @CurrentShortDescription),
								OldMediaPrintSpaceKey = ISNULL(OldMediaPrintSpaceKey, @CurrentMediaPrintSpaceKey),
								OldMediaPrintSpaceID = ISNULL(OldMediaPrintSpaceID, @CurrentMediaPrintSpaceID),
								OldMediaPrintPositionKey = ISNULL(OldMediaPrintPositionKey, @CurrentMediaPrintPositionKey),
								OldMediaPrintPositionID = ISNULL(OldMediaPrintPositionID, @CurrentMediaPrintPositionID),
								OldCompanyMediaPrintContractKey = ISNULL(OldCompanyMediaPrintContractKey, @CurrentCompanyMediaPrintContractKey)
						WHERE	PurchaseOrderDetailKey = @NewPurchaseOrderDetailKey

					END
					*/
				END -- Changes in Media stuff occured?
			END -- Changes in Amounts occured?	
		END -- CreateAdjustments = 1
	END -- Line = 1 or POD key >0
	
	DECLARE	@PremInsert tinyint, @BuylineInsert tinyint
	IF @LineNumber > 1 AND ISNULL(@PurchaseOrderDetailKey, 0) <= 0
		SELECT	@PremInsert = 1
	ELSE
		SELECT	@PremInsert = 0
	
	IF @LineNumber = 1 AND ISNULL(@PurchaseOrderDetailKey, 0) <= 0
		SELECT	@BuylineInsert = 1
	ELSE
		SELECT	@BuylineInsert = 0

-- this is when we would update the top POD (least current POD) 
-- patch by Gil 8/7/14, if we have revisions, we cannot update the financials, otherwise we would update one of the PODs
-- with what is on the screen and then the new sum for the line number would be different from what is on the screen
/*
Example: ShowAdjustmentsAsSingleLine =1, change Gross from 2000 to 1500
Rev 0    Gross = 2000 now if we update with what is on screen ===> Gross = 1500
Rev 1    Gross = -500                                              Gross = -500
        ------------                                               ------------
		   Sum = 1500                                              Sum = 1000 (<> 1500)
*/


-- Also, if the POD key (careful, not the line number) is billed, do not update the financials
if exists (select 1 from tPurchaseOrderDetail (nolock)
			where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			and   InvoiceLineKey > 0
			)
	select @NoFinancialUpdate = 1

-- Anything on billing WS
if @NoFinancialUpdate = 0 and exists (select 1 from tPurchaseOrderDetail pod (nolock)
			inner join tBillingDetail bd (nolock) on pod.PurchaseOrderDetailKey = bd.EntityKey and bd.Entity = 'tPurchaseOrderDetail'
			inner join tBilling b (nolock) on b.BillingKey = bd.BillingKey
			where pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			and   b.Status < 5
			)
	select @NoFinancialUpdate = 1

	EXEC @PurchaseOrderDetailKey = sptPurchaseOrderDetailUpdate 
			@PurchaseOrderDetailKey, 
			@PurchaseOrderKey, 
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
			@UnitRate,
			@Billable,
			@Markup,
			@BillableCost,
			@LongDescription,
			@CustomFieldKey,
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
			@Revision,
			@SelectUpdate,
			@Quantity1,
			@Quantity2,
			@LineType,
			@MediaPremiumKey,
			@PremiumAmountType,
			@PremiumPct,
			@GrossAmount,
			@Commission,
			@NoFinancialUpdate,
			NULL, --@PCurrencyID
			NULL, --@PExchangeRate
			NULL, --@PTotalCost
			@DetailVendorKey,
			@Bucket,
			@SalesTaxAmount,
			@SalesTax1Amount,
			@SalesTax2Amount
				
	
	DECLARE	@OrderPODetailKey int,
			@OrderDetailOrderDate smalldatetime,
			@OrderItemKey int
	
	SELECT	@OrderPODetailKey = MIN(PurchaseOrderDetailKey)
	FROM	tPurchaseOrderDetail (nolock)
	WHERE	PurchaseOrderKey = @PurchaseOrderKey
	AND		LineType = 'order'
	
	SELECT	@OrderDetailOrderDate = DetailOrderDate,
			@OrderItemKey = ItemKey
	FROM	tPurchaseOrderDetail (nolock)
	WHERE	PurchaseOrderDetailKey = @OrderPODetailKey

	-- patch so that all PODs assigned to a premium have the same medium if they change the MediaPremiumKey/PremiumID
	-- this creates too many problems with the reports
	if @LineNumber > 1
	begin
		-- premiums
		update tPurchaseOrderDetail
		set    MediaPremiumKey = @MediaPremiumKey
		      ,ShortDescription = @ShortDescription
		where  PurchaseOrderKey = @PurchaseOrderKey
		and    LineNumber = @LineNumber 
		
		-- 9/16/14 from Susan, propagate description from the buy line to the premium
		declare @BuyLineKey int, @BuyLineDesc varchar(1000)
		select @BuyLineKey = max(PurchaseOrderDetailKey) from tPurchaseOrderDetail (nolock)
		where PurchaseOrderKey = @PurchaseOrderKey
		and LineNumber = 1
		
		if @BuyLineKey > 0
		begin
			select @BuyLineDesc = substring(ShortDescription, 1, 1000) from tPurchaseOrderDetail (nolock)
			where PurchaseOrderDetailKey = @BuyLineKey

			update tPurchaseOrderDetail
			set    ShortDescription = @BuyLineDesc
			where  PurchaseOrderKey = @PurchaseOrderKey
			and    LineNumber = @LineNumber 
			and    isnull(MediaPremiumKey, 0) > 0 -- only if we do not have a manual premium
		end


		-- also the problem with premiums is that they have no DetailOrderDate
		if @POKind not in (@kTVKind, @kRadioKind) 
		begin
			update tPurchaseOrderDetail
			set    DetailOrderDate = @OrderDetailOrderDate
			where  PurchaseOrderKey = @PurchaseOrderKey
			and    LineNumber = @LineNumber
		end

	end
	else 
	begin
		-- buy line
		-- Also a change of date on the buy line is not propagated to the adjustments, so do it now
		if @POKind not in (@kTVKind, @kRadioKind) 
		begin
			update tPurchaseOrderDetail
			set    DetailOrderDate = @OrderDetailOrderDate
			where  PurchaseOrderKey = @PurchaseOrderKey
			and    LineNumber = @LineNumber
		end


	end


	IF @PremInsert = 1
	BEGIN
		--If we just inserted a new premium, then check to see if we need to increment the revision
		IF @Status = 4 AND ((ISNULL(@OrigPrinted, 0) + ISNULL(@OrigEmailed, 0) > 0) OR (@OrigRevision > 0) )
		--IF @Status = 4
		BEGIN
			IF @OrigPrinted = 1 OR @OrigEmailed = 1
			BEGIN
				SELECT  @Revision = Revision
				FROM	tPurchaseOrder (nolock)
				WHERE	PurchaseOrderKey = @PurchaseOrderKey
				
				If @Revision = @OrigRevision -- inc Revision only if this is the original
					SELECT	@Revision = ISNULL(@Revision, 0) + 1
					
				UPDATE	tPurchaseOrder
				SET		Printed = 0,
						Emailed = 0,
						DateSent = NULL,
						Revision = @Revision
				WHERE	PurchaseOrderKey = @PurchaseOrderKey
			END
		END
		
		UPDATE	tPurchaseOrderDetail
		SET		AdjustmentNumber = @Revision
		WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey				
	END
	
	-- is it safe to do this?
	-- I added some checks of field changes because the grid seems to send some intempestive Save commands
	-- even if not dirty
	IF @PremInsert = 0 And @PurchaseOrderDetailKey > 0 And (@OrigPrinted = 1 OR @OrigEmailed = 1) And (@FinancialChanges = 1 OR @NonFinancialChanges = 1 OR @CancelBuy = 1) 
	BEGIN				
		UPDATE	tPurchaseOrder
		SET		Printed = 0,
				Emailed = 0,
				DateSent = NULL
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
	END

	
	-- We need to increment the Revision/Adjustment # if we did not create adjustments
	if @PremInsert = 0  And @IncrementRevision = 1 and @CreateAdjustments = 0
	begin
		select @Revision = isnull(@Revision, 0) + 1

		UPDATE	tPurchaseOrder
		SET		Revision = @Revision
		WHERE	PurchaseOrderKey = @PurchaseOrderKey

		UPDATE	tPurchaseOrderDetail
		SET		AdjustmentNumber = @Revision
		WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	end
	
	IF @LineType = 'prem'
		UPDATE	tPurchaseOrderDetail
		SET		CommissionablePremium = @CommissionablePremium,
				ItemKey = @OrderItemKey
		WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
	ELSE
		UPDATE	tPurchaseOrder
		SET		PODate = @OrderDetailOrderDate
		WHERE	PurchaseOrderKey = @PurchaseOrderKey
		
	
/*
Section for the Logs
*/

declare @Action varchar(200) -- could be 'Field Change'
		,@Comments varchar(200)
		,@FieldName varchar(200)
		,@FieldType smallint -- 1 string, 2 decimal, 3 int, 4 money, 5 date
	
		,@OldString varchar(500)
		,@OldDecimal decimal(24,4)
		,@OldInt int
		,@OldMoney money
		,@OldDate smalldatetime

		,@NewString varchar(500)
		,@NewDecimal decimal(24,4)
		,@NewInt int
		,@NewMoney money
		,@NewDate smalldatetime

declare @MediaOrderKey int
declare @InternalID int
declare @MediaOrderRevision int

declare @PremiumID varchar(50)
declare @CurrentPremiumID varchar(50)

		If @LineNumber > 1
		begin
			if @MediaPremiumKey > 0
				select @PremiumID = isnull(PremiumID, 'Premium') from tMediaPremium (nolock) where MediaPremiumKey = @MediaPremiumKey  
			else
				select @PremiumID = substring(@ShortDescription, 1, 50)
				
			if @CurrentMediaPremiumKey > 0
				select @CurrentPremiumID = isnull(PremiumID, 'Premium') from tMediaPremium (nolock) where MediaPremiumKey = @CurrentMediaPremiumKey  
			else
				select @CurrentPremiumID = substring(@CurrentShortDescription, 1, 50)
					 
		end

		declare @LogPrem int 
		select @LogPrem = 0 

		if @PremInsert = 1 and @Status = 4 
		begin
			select @LogPrem = 1

			select @Action = 'Premium'
			select @Comments = 'Added ' + @PremiumID  
			select @FieldName = null
			select @FieldType = 1
			select @OldString =	null, @OldDecimal = null, @OldInt = null, @OldMoney = null, @OldDate = null
			select @NewString =	null, @NewDecimal = null, @NewInt = null, @NewMoney = null, @NewDate = null

			INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
			   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
			   ,LineNumber, PremiumID)
			VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
			   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
			   ,@LineNumber, @PremiumID)

		end

	select @LogChanges = 0
	
	if @PremInsert = 0 and @Status = 4
	begin

		-- Buy Line LineNumber = 1
		-- LineNumber > 1 means Premium
		select @LineNumber = isnull(@LineNumber, 0)

		-- to log the real values, we 
		IF @ShowAdjustmentsAsSingleLine = 1 and @NetGrossChanges = 1
		begin
			--Restore the proper values
			SELECT	@Quantity = ISNULL(@Quantity, 0) + ISNULL(@CurrentQuantity, 0),
					@Quantity1 = ISNULL(@Quantity1, 0) + ISNULL(@CurrentQuantity1, 0),
					@Quantity2 = ISNULL(@Quantity2, 0) + ISNULL(@CurrentQuantity2, 0),
					@TotalCost = ISNULL(@TotalCost, 0) + ISNULL(@CurrentTotalCost, 0),
					@GrossAmount = ISNULL(@GrossAmount, 0) + ISNULL(@CurrentGrossAmount, 0),
					@BillableCost = ISNULL(@BillableCost, 0) + ISNULL(@CurrentBillableCost, 0),
					@SalesTaxAmount = ISNULL(@SalesTaxAmount, 0) + ISNULL(@CurrentSalesTaxAmount, 0),
					@SalesTax1Amount = ISNULL(@SalesTax1Amount, 0) + ISNULL(@CurrentSalesTax1Amount, 0),
					@SalesTax2Amount = ISNULL(@SalesTax2Amount, 0) + ISNULL(@CurrentSalesTax2Amount, 0)
		
		
			if isnull(@Quantity, 0) = 0
				select @UnitCost = @TotalCost
				      ,@UnitRate = @GrossAmount
			else
				select @UnitCost = @TotalCost / @Quantity
				      ,@UnitRate = @GrossAmount / @Quantity

		end
							
		-- only if this is not insert of a Buy Line, because we would have too many fields 
		if @BuylineInsert = 0
		begin
			if @LineNumber = 1 and ISNULL(@CurrentQuantity, 0) <> ISNULL(@Quantity, 0) 
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'Quantity'
				select @FieldType = 2
				select @OldString =	null, @OldDecimal = ISNULL(@CurrentQuantity, 0), @OldInt = null, @OldMoney = null, @OldDate = null
				select @NewString =	null, @NewDecimal = ISNULL(@Quantity, 0) , @NewInt = null, @NewMoney = null, @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1 and ISNULL(@CurrentQuantity1, 0) <> ISNULL(@Quantity1, 0) 
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'Quantity1'
				select @FieldType = 2
				select @OldString =	null, @OldDecimal = ISNULL(@CurrentQuantity1, 0), @OldInt = null, @OldMoney = null, @OldDate = null
				select @NewString =	null, @NewDecimal = ISNULL(@Quantity1, 0) , @NewInt = null, @NewMoney = null, @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1 and ISNULL(@CurrentQuantity2, 0) <> ISNULL(@Quantity2, 0) 
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'Quantity2'
				select @FieldType = 2
				select @OldString =	null, @OldDecimal = ISNULL(@CurrentQuantity2, 0), @OldInt = null, @OldMoney = null, @OldDate = null
				select @NewString =	null, @NewDecimal = ISNULL(@Quantity2, 0) , @NewInt = null, @NewMoney = null, @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1 and ISNULL(@CurrentMediaUnitTypeKey, 0) <> ISNULL(@MediaUnitTypeKey, 0) 
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'MediaUnitTypeID'
				select @FieldType = 1 -- string, we will pull the ID
				select @OldString =	null, @OldDecimal = null, @OldInt = ISNULL(@CurrentMediaUnitTypeKey, 0), @OldMoney = null, @OldDate = null
				select @NewString =	null, @NewDecimal = null , @NewInt = ISNULL(@MediaUnitTypeKey, 0) , @NewMoney = null, @NewDate = null

				select @OldString = UnitTypeID from tMediaUnitType (nolock) where MediaUnitTypeKey = @CurrentMediaUnitTypeKey
				select @NewString = UnitTypeID from tMediaUnitType (nolock) where MediaUnitTypeKey = @MediaUnitTypeKey

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if ISNULL(@CurrentTotalCost, 0) <> ISNULL(@TotalCost, 0)
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'TotalCost'
				select @FieldType = 4
				select @OldString =	null, @OldDecimal = null, @OldInt = null, @OldMoney = ISNULL(@CurrentTotalCost, 0), @OldDate = null
				select @NewString =	null, @NewDecimal = null , @NewInt = null, @NewMoney = ISNULL(@TotalCost, 0), @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if ISNULL(@CurrentGrossAmount, 0) <> ISNULL(@GrossAmount, 0)
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'GrossAmount'
				select @FieldType = 4
				select @OldString =	null, @OldDecimal = null, @OldInt = null, @OldMoney = ISNULL(@CurrentGrossAmount, 0), @OldDate = null
				select @NewString =	null, @NewDecimal = null , @NewInt = null, @NewMoney = ISNULL(@GrossAmount, 0), @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1 and ISNULL(@CurrentUnitCost, 0) <> ISNULL(@UnitCost, 0)
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'UnitCost'
				select @FieldType = 2
				select @OldString =	null, @OldDecimal = ISNULL(@CurrentUnitCost, 0), @OldInt = null, @OldMoney = null, @OldDate = null
				select @NewString =	null, @NewDecimal = ISNULL(@UnitCost, 0) , @NewInt = null, @NewMoney = null, @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1 and ISNULL(@CurrentUnitRate, 0) <> ISNULL(@UnitRate, 0)
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'UnitRate'
				select @FieldType = 2
				select @OldString =	null, @OldDecimal = ISNULL(@CurrentUnitRate, 0), @OldInt = null, @OldMoney = null, @OldDate = null
				select @NewString =	null, @NewDecimal = ISNULL(@UnitRate, 0) , @NewInt = null, @NewMoney = null, @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if ISNULL(@CurrentBillableCost, 0) <> ISNULL(@BillableCost, 0)
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'BillableCost'
				select @FieldType = 4
				select @OldString =	null, @OldDecimal = null, @OldInt = null, @OldMoney = ISNULL(@CurrentBillableCost, 0), @OldDate = null
				select @NewString =	null, @NewDecimal = null , @NewInt = null, @NewMoney = ISNULL(@BillableCost, 0), @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if ISNULL(@CurrentSalesTaxAmount, 0) <> ISNULL(@SalesTaxAmount, 0)
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'SalesTaxAmount'
				select @FieldType = 4
				select @OldString =	null, @OldDecimal = null, @OldInt = null, @OldMoney = ISNULL(@CurrentSalesTaxAmount, 0), @OldDate = null
				select @NewString =	null, @NewDecimal = null , @NewInt = null, @NewMoney = ISNULL(@SalesTaxAmount, 0), @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1  and @CurrentDetailOrderDate <> @DetailOrderDate
			begin
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'DetailOrderDate'
				select @FieldType = 5
				select @OldString =	null, @OldDecimal = null, @OldInt = null, @OldMoney = null, @OldDate = @CurrentDetailOrderDate
				select @NewString =	null, @NewDecimal = null , @NewInt = null, @NewMoney = null, @NewDate = @DetailOrderDate

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1  and ISNULL(@CurrentShortDescription, '') <> ISNULL(@ShortDescription, '')
			begin
				-- for premiums, we need a way to detect a change of premiums, this is incorrect to log this as a Description change
				select @LogChanges = 1

				select @Action = 'Field Change'
				select @Comments = null  
				select @FieldName = 'ShortDescription'
				select @FieldType = 1
				select @OldString =	substring(@CurrentShortDescription, 1, 500), @OldDecimal = null, @OldInt = null, @OldMoney = null, @OldDate = null
				select @NewString =	substring(@ShortDescription,1,500), @NewDecimal = null , @NewInt = null, @NewMoney = null, @NewDate = null

				INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
				   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
				   ,LineNumber, PremiumID)
				VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
				   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
				   ,@LineNumber, @PremiumID)
			end

			if @LineNumber = 1  
			begin
				if ISNULL(@CurrentMediaPrintSpaceKey, 0) <> ISNULL(@MediaPrintSpaceKey, 0) Or ISNULL(@CurrentMediaPrintSpaceID, '') <> ISNULL(@MediaPrintSpaceID, '')
				begin
					select @LogChanges = 1

					select @Action = 'Field Change'
					select @Comments = null  
					select @FieldName = 'MediaPrintSpaceID'
					select @FieldType = 1

					select @OldString =	null, @OldDecimal = null, @OldInt = ISNULL(@CurrentMediaPrintSpaceKey, 0), @OldMoney = null, @OldDate = null
					select @NewString =	null, @NewDecimal = null , @NewInt =  ISNULL(@MediaPrintSpaceKey, 0), @NewMoney = null, @NewDate = null

					if ISNULL(@CurrentMediaPrintSpaceKey, 0) > 0
						select @OldString = SpaceID from tMediaSpace (nolock) where MediaSpaceKey = @CurrentMediaPrintSpaceKey  
					else
						select @OldString = @CurrentMediaPrintSpaceID
					
					if ISNULL(@MediaPrintSpaceKey, 0) > 0
						select @NewString = SpaceID from tMediaSpace (nolock) where MediaSpaceKey = @MediaPrintSpaceKey  
					else
						select @NewString = @MediaPrintSpaceID

					INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
						,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
						,LineNumber, PremiumID)
					VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
						,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
						,@LineNumber, @PremiumID)
				end
			end -- not a media premium

			if @LineNumber = 1  
			begin
				if ISNULL(@CurrentMediaPrintPositionKey, 0) <> ISNULL(@MediaPrintPositionKey, 0) Or ISNULL(@CurrentMediaPrintPositionID, '') <> ISNULL(@MediaPrintPositionID, '')
				begin
					select @LogChanges = 1

					select @Action = 'Field Change'
					select @Comments = null  
					select @FieldName = 'MediaPrintPositionID'
					select @FieldType = 1

					select @OldString =	null, @OldDecimal = null, @OldInt = ISNULL(@CurrentMediaPrintPositionKey, 0), @OldMoney = null, @OldDate = null
					select @NewString =	null, @NewDecimal = null , @NewInt =  ISNULL(@MediaPrintPositionKey, 0), @NewMoney = null, @NewDate = null

					if ISNULL(@CurrentMediaPrintPositionKey, 0) > 0
						-- for the positions, Susan wants the PositionName vs PositionID
						--select @OldString = PositionID from tMediaPosition (nolock) where MediaPositionKey = @CurrentMediaPrintPositionKey  
						select @OldString = PositionName from tMediaPosition (nolock) where MediaPositionKey = @CurrentMediaPrintPositionKey  
					else
						select @OldString = @CurrentMediaPrintPositionID
					
					if ISNULL(@MediaPrintPositionKey, 0) > 0
						-- for the positions, Susan wants the PositionName vs PositionID
						--select @NewString = PositionID from tMediaPosition (nolock) where MediaPositionKey = @MediaPrintPositionKey  
						select @NewString = PositionName from tMediaPosition (nolock) where MediaPositionKey = @MediaPrintPositionKey  
					else
						select @NewString = @MediaPrintPositionID

					INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
						,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
						,LineNumber, PremiumID)
					VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
						,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
						,@LineNumber, @PremiumID)
				end
			end -- not a media premium
			
			if @LineNumber = 1  and ISNULL(@CurrentCompanyMediaPrintContractKey, 0) <> ISNULL(@CompanyMediaPrintContractKey, 0)
				begin
					select @LogChanges = 1

					select @Action = 'Field Change'
					select @Comments = null  
					select @FieldName = 'CompanyMediaPrintContractID'
					select @FieldType = 1
					select @OldString =	null, @OldDecimal = null, @OldInt = ISNULL(@CurrentCompanyMediaPrintContractKey, 0), @OldMoney = null, @OldDate = null
					select @NewString =	null, @NewDecimal = null , @NewInt =  ISNULL(@CompanyMediaPrintContractKey, 0), @NewMoney = null, @NewDate = null

					select @OldString = ContractID from tCompanyMediaContract (nolock) where CompanyMediaContractKey = @CurrentCompanyMediaPrintContractKey  
					select @NewString = ContractID from tCompanyMediaContract (nolock) where CompanyMediaContractKey = @CompanyMediaPrintContractKey  

					INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
					   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
					   ,LineNumber, PremiumID)
					VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
					   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
					   ,@LineNumber, @PremiumID)
				end

				-- now capture a change of premium ID
				if @LineNumber > 1 and isnull(@CurrentPremiumID, '') <> isnull(@PremiumID, '')
				begin
					select @LogChanges = 1

					select @Action = 'Field Change'
					select @Comments = null  
					select @FieldName = 'PremiumID'
					select @FieldType = 1
					select @OldString =	@CurrentPremiumID, @OldDecimal = null, @OldInt = null, @OldMoney = null, @OldDate = null
					select @NewString =	@PremiumID, @NewDecimal = null , @NewInt =  null, @NewMoney = null, @NewDate = null

					INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action,UserKey,FieldName,FieldType,Comments,Revision,MediaPremiumKey,POKind
					   ,OldString,OldDecimal,OldInt,OldMoney,OldDate,NewString,NewDecimal,NewInt,NewMoney,NewDate
					   ,LineNumber, PremiumID)
					VALUES (@CompanyKey,'tPurchaseOrder',@PurchaseOrderKey,@Action,@UserKey,@FieldName,@FieldType ,@Comments,@Revision,@MediaPremiumKey,@POKind
					   ,@OldString,@OldDecimal,@OldInt,@OldMoney,@OldDate,@NewString,@NewDecimal,@NewInt,@NewMoney,@NewDate
					   ,@LineNumber, @PremiumID)
				end  

		end -- not a Buy Line insert


	end -- new revision


	if @LogChanges = 1 or @LogPrem = 1
	begin
		select @MediaOrderKey = MediaOrderKey
		      ,@InternalID = InternalID
		from   tPurchaseOrder (nolock)
		where  PurchaseOrderKey = @PurchaseOrderKey
		
		select @InternalID = isnull(@InternalID, 0)
		      ,@OrigRevision = isnull(@OrigRevision, 0)

		if isnull(@MediaOrderKey, 0) > 0
		begin
			select @MediaOrderRevision	= Revision from tMediaOrder (nolock) where MediaOrderKey = @MediaOrderKey
			select @Action = 'Buy Line Change'

			--select @Comments = 'Buy Line ID ' + cast(@InternalID as varchar(200)) + ' and revision ' + cast(@OrigRevision as varchar(200)) + ' was changed'
 			select @Comments = 'Buy Line ID ' + cast(@InternalID as varchar(200)) + ' was changed'
 			

			INSERT tMediaBuyRevisionHistory(CompanyKey,Entity,EntityKey,Action, Revision, UserKey, NewInt, Comments)
			values (@CompanyKey, 'tMediaOrder', @MediaOrderKey, @Action, @MediaOrderRevision, @UserKey, @PurchaseOrderKey, @Comments)

		end  
	end

	RETURN @PurchaseOrderDetailKey
GO
