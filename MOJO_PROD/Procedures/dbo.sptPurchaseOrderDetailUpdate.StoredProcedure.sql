USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailUpdate]
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
	@NoFinancialUpdate tinyint = 0, --This is used when called from sptPurchaseOrderDetailUpdateFromWorksheet since the financial fields are updated there
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,
	@DetailVendorKey int = null,
	@Bucket int = NULL,
	@SalesTaxAmount money = 0,
	@SalesTax1Amount money = 0,
	@SalesTax2Amount money = 0

AS --Encrypt

 /*
  || When     Who Rel    What
  || 12/07/06 GHL 8.4    Added restriction on changes of IO 
  || 02/20/07 GHL 8.4    Added project rollup section
  || 04/13/07 BSH 8.4.5  DateUpdated needed to be updated.
  || 07/16/07 BSH 8.5    (9659)Update OfficeKey, DepartmentKey 
  || 1/21/09  GWG 10.018 Added Rounding protection on cost and gross
  || 12/11/09 MFT 10.515 Added insert logic
  || 04/30/10 GHL 10.522 (79762) Do not update spots which have been transferred out
  || 07/20/10 MFT 10.532 Changed insert test to ISNULL(@PurchaseOrderDetailKey, 0) < 1 to support data manager updates
  || 10/14/10 MFT 10.536 Added -5 error return test, modified error test in INSERT section
  || 11/02/10 MFT 10.537 Added @AdjustmentNumber to insert to allow for document level saving
  || 07/01/11 GHL 10.546 (111482) Added call to sptPurchaseOrderRollupAmounts for tax amounts 
  || 08/28/12 RLB 10.559 (94289, 150065) Changes made for enhancment
  || 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @ShortDescription from 200 to 300
  || 08/30/13 CRG 10.5.7.1 Added @LineType, @MediaPremiumKey, @PremiumAmountType, @PremiumPct, @GrossAmount
  || 10/04/13 CRG 10.5.7.3 Added @Commission
  || 12/17/13 GHL 10.5.7.5 Added currency parameters
  || 12/26/13 CRG 10.5.7.4 Modified LineNumber logic for Interactive orders
  || 1/3/13   CRG 10.5.7.6 Added @DetailVendorKey
  || 01/20/14 GHL 10.575 For import compare isnull(PTotalCost, 0) to 0 rather than PTotalCost to NULL
  || 03/14/14 CRG 10.5.7.7 Added @Bucket (When @Bucket is not NULL, it indicates that this is a new Broadcast order and not a Legacy one)
  || 04/28/14 RLB 10.5.7.9 (214240) increasing the description length and allow updated of prebilled or applied line for description and comments other fields should be locked down.
  || 05/08/14 RLB 10.5.7.9 (215598) since fields are locked down in PO allow update to a closed PO
  || 07/17/14 GHL 10.5.8.2 Do not restore MediaPremiumKey because we may go from a manual premium to a stored premium or viceversa
  || 08/13/14 GHL 10.5.8.3 If @NoFinancialUpdate = 1, do not check if it is billed, because we restore the financial data anyway
  || 08/22/14 GHL 10.5.8.3 Added sales tax amounts
  || 01/08/15 GAR 10.5.8.8 Added POKind = 0 to code where we assign next line numbers.
  */
  
declare @POKind smallint
declare @FlightInterval tinyint
declare @FlightStartDate smalldatetime
declare @FlightEndDate smalldatetime
declare @DefaultDate smalldatetime
declare @CompanyKey int
declare @AllowChangesAfterClientInvoice tinyint
declare @InvoiceLineKey int
declare @OldProjectKey int
declare @GLCompanyKey int

SELECT
	@GLCompanyKey = ISNULL(GLCompanyKey, 0),
	@POKind = POKind,
	@FlightInterval = ISNULL(FlightInterval, 3),
	@FlightStartDate = ISNULL(FlightStartDate, @DefaultDate),
	@FlightEndDate = ISNULL(FlightEndDate,ISNULL(FlightStartDate, @DefaultDate))
FROM tPurchaseOrder po (nolock)
WHERE po.PurchaseOrderKey = @PurchaseOrderKey

IF EXISTS(
	SELECT *
	FROM tProject p (nolock)
	WHERE
		p.ProjectKey = @ProjectKey AND
		ISNULL(p.GLCompanyKey, 0) <> @GLCompanyKey
) RETURN -5

if isnull(@PExchangeRate, 0) <= 0
	select @PExchangeRate = 1

if isnull(@PTotalCost, 0) = 0
	select @PTotalCost = @TotalCost

if isnull(@GrossAmount, 0) = 0
	select @GrossAmount = @BillableCost

IF ISNULL(@PurchaseOrderDetailKey, 0) < 1
	BEGIN --INSERT LOGIC
		select @DefaultDate = cast(datepart(yyyy,getdate()) as varchar(4)) + '-' + cast(datepart(mm,getdate()) as varchar(2)) + '-' + cast(datepart(dd,getdate()) as varchar(2)) 
		
		if @POKind IN (1,2)
			begin
				if exists(SELECT 1
								FROM tPurchaseOrder po (NOLOCK)
								 WHERE po.PurchaseOrderKey = @PurchaseOrderKey
								 AND po.Closed = 1)
				update tPurchaseOrder
						 set Closed = 0
					 where PurchaseOrderKey = @PurchaseOrderKey
			end
		else
			begin
				IF EXISTS (SELECT 1
							 FROM tPurchaseOrder po (NOLOCK)
							WHERE po.PurchaseOrderKey = @PurchaseOrderKey
								AND (po.Closed = 1 or po.Downloaded = 1))
					RETURN -2
			end 
	  
		if ISNULL(@ProjectKey, 0) > 0
			IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
				Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
				Return -3 
		
		DECLARE @NextNum as int
		
		-- Default value for NextNum
		SELECT @NextNum = ISNULL(Max(LineNumber),0) + 1 FROM tPurchaseOrderDetail (NOLOCK) WHERE PurchaseOrderKey = @PurchaseOrderKey
		
		if @POKind IN (0, 1, 4)
			begin
				if isnull(@LineNumber,0) > 0
					begin
						select @NextNum = @LineNumber
					end
			end
		
		if @POKind = 2
			begin
				-- associate this line to an existing line if importing from Strata or SmartPlus
				if isnull(@LineNumber,0) > 0
					begin
						select @NextNum = @LineNumber					
					end 
				else
						begin
						-- line number will be zero, use calculated number and calculate dates
						if @FlightInterval = 1 and @DetailOrderDate is null
							select @DetailOrderDate = @FlightStartDate
									,@DetailOrderEndDate = @FlightStartDate
						if @FlightInterval = 2 and @DetailOrderDate is null
							select @DetailOrderDate = @FlightStartDate
									,@DetailOrderEndDate = dateadd(d,6,@FlightStartDate)
						if @FlightInterval = 3 and @DetailOrderDate is null
							begin
								select @DetailOrderDate = isnull(@DetailOrderDate,@FlightStartDate)
											,@DetailOrderEndDate = isnull(@DetailOrderEndDate,@FlightEndDate)
							end	
					end			
			end 

if @GrossAmount is null
	select @GrossAmount = @BillableCost
		
		INSERT tPurchaseOrderDetail
			(
			PurchaseOrderKey,
			LineNumber,
			AdjustmentNumber,
			ProjectKey,
			TaskKey,
			ItemKey,
			ClassKey,
			ShortDescription,
			Quantity,
			UnitCost,
			UnitDescription,
			TotalCost,
			UnitRate,
			Billable,
			Markup,
			BillableCost,
			LongDescription,
			CustomFieldKey,
			DetailOrderDate,
			DetailOrderEndDate,
			UserDate1,
			UserDate2,
			UserDate3,
			UserDate4,
			UserDate5,
			UserDate6,
			OrderDays,
			OrderTime,
			OrderLength,
			Taxable,
			Taxable2,
			OfficeKey,
			DepartmentKey,
			Quantity1,
			Quantity2,
			LineType,
			MediaPremiumKey,
			PremiumAmountType,
			PremiumPct,
			GrossAmount,
			Commission,
			PCurrencyID,
			PExchangeRate,
			PTotalCost,
			DetailVendorKey,
			Bucket,
			SalesTaxAmount,
			SalesTax1Amount,
            SalesTax2Amount
			)

		VALUES
			(
			@PurchaseOrderKey,
			@NextNum,		-- @LineNumber,
			@AdjustmentNumber,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@ShortDescription,
			@Quantity,
			@UnitCost,
			@UnitDescription,
			Round(@TotalCost, 2),
			@UnitRate,
			@Billable,
			@Markup,
			Round(@BillableCost, 2),
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
			@Quantity1,
			@Quantity2,
			@LineType,
			@MediaPremiumKey,
			@PremiumAmountType,
			@PremiumPct,
			@GrossAmount,
			@Commission,
			@PCurrencyID,
			@PExchangeRate,
			@PTotalCost,
			@DetailVendorKey,
			@Bucket,
			@SalesTaxAmount,
			@SalesTax1Amount,
            @SalesTax2Amount
			)
		
		SELECT @PurchaseOrderDetailKey = SCOPE_IDENTITY()
		
		exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey
		
		exec sptPurchaseOrderRollupAmounts @PurchaseOrderKey

		RETURN @PurchaseOrderDetailKey
	END --INSERT LOGIC

	select @LineNumber = LineNumber
	      ,@AdjustmentNumber = AdjustmentNumber
	      ,@InvoiceLineKey = isnull(InvoiceLineKey,0)
		  ,@OldProjectKey = ProjectKey
	  from tPurchaseOrderDetail (nolock)
	 where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

	select @POKind = POKind 
		  ,@FlightInterval = isnull(FlightInterval,3)
		  ,@CompanyKey = CompanyKey
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey

	-- determine if order lines (spots) can be updated after client invocie has been created
	select @AllowChangesAfterClientInvoice = 
	       case when @POKind = 0 then 0
		       when @POKind = 1 then isnull(IOAllowChangesAfterClientInvoice, 0)
		       when @POKind = 2 then isnull(BCAllowChangesAfterClientInvoice, 0)
	        end
      from tPreference (nolock)
     where CompanyKey = @CompanyKey

	if @POKind = 2  -- is this a broadcast (spot level) order?
		begin
			-- changes cannot be made after a vendor invoice has been received, make sure none of the spots get updated since they shared information
			IF EXISTS (SELECT 1 FROM tVoucherDetail (NOLOCK)
						where PurchaseOrderDetailKey in (select PurchaseOrderDetailKey
														   from tPurchaseOrderDetail (nolock)
														  where PurchaseOrderKey = @PurchaseOrderKey
															and LineNumber = @LineNumber
															and AdjustmentNumber = @AdjustmentNumber))
				RETURN -1
		end
/*	
	else
		begin
			IF EXISTS (SELECT 1 FROM   tVoucherDetail vd (NOLOCK)
						inner join tPurchaseOrderDetail pod (NOLOCK) on pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey
						WHERE  pod.PurchaseOrderDetailKey = @PurchaseOrderDetailKey)
				RETURN -1	
		end
*/

	--make sure PO is not closed
/*	IF EXISTS (SELECT 1
	           FROM		tPurchaseOrder po (NOLOCK)
	           WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
	           AND    (po.Closed = 1))
		RETURN -2
		
	-- make sure the project is accepting expenses
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -3 */
			
DECLARE @CurrentStatus int
DECLARE @Revision int

--Get existing values for Optional Parms
DECLARE @OldQuantity1 decimal(24, 4),
		@OldQuantity2 decimal(24, 4),
		@OldLineType varchar(50),
		@OldMediaPremiumKey int,
		@OldPremiumAmountType varchar(50),
		@OldPremiumPct decimal(24, 4),
		@OldGrossAmount money,
		@OldCommission decimal(24, 4),
		@OldDetailVendorKey int,
		@OldBucket int
		
SELECT	@OldQuantity1 = Quantity1,
		@OldQuantity2 = Quantity2,
		@OldLineType = LineType,
		@OldMediaPremiumKey = MediaPremiumKey,
		@OldPremiumAmountType = PremiumAmountType,
		@OldPremiumPct = PremiumPct,
		@OldGrossAmount = GrossAmount,
		@OldCommission = Commission,
		@OldDetailVendorKey = DetailVendorKey,
		@OldBucket = Bucket
FROM	tPurchaseOrderDetail (nolock)
WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey

IF @Quantity1 IS NULL SELECT @Quantity1 = @OldQuantity1
IF @Quantity2 IS NULL SELECT @Quantity2 = @OldQuantity2
IF @LineType IS NULL SELECT @LineType = @OldLineType
--IF @MediaPremiumKey IS NULL SELECT @MediaPremiumKey = @OldMediaPremiumKey -- otherwise we cannot change to/from manual premium
IF @PremiumAmountType IS NULL SELECT @PremiumAmountType = @OldPremiumAmountType
IF @PremiumPct IS NULL SELECT @PremiumPct = @OldPremiumPct
IF @Commission IS NULL SELECT @Commission = @OldCommission
IF @DetailVendorKey IS NULL SELECT @DetailVendorKey = @OldDetailVendorKey
IF @Bucket IS NULL SELECT @Bucket = @OldBucket

IF @NoFinancialUpdate = 1
BEGIN
	--If we're not updating the financial numbers, get their existing values
	SELECT	@Quantity1 = Quantity1,
			@Quantity2 = Quantity2,
			@Quantity = Quantity,
			@UnitCost = UnitCost,
			@Markup = Markup,
			@TotalCost = TotalCost,
			@BillableCost = BillableCost,
			@GrossAmount = GrossAmount,
			@LineType = LineType,
			@SalesTaxAmount = SalesTaxAmount,
			@SalesTax1Amount = SalesTax1Amount,
            @SalesTax2Amount = SalesTax2Amount
	FROM	tPurchaseOrderDetail (nolock)
	WHERE	PurchaseOrderDetailKey = @PurchaseOrderDetailKey
END
	
	if @POKind = 2 AND @Bucket IS NULL  -- is this a LEGACY broadcast (spot level) order?
	    if @FlightInterval = 3  -- is this a summary flight?
			begin
				if @InvoiceLineKey > 0 -- has the line been invoiced?
					begin
						if @SelectUpdate = 0 and @AllowChangesAfterClientInvoice = 0 -- if changes are not allowed after invoice
							return -4
					end
				
				-- update the summary line (spot)
				UPDATE
					tPurchaseOrderDetail
				SET
					PurchaseOrderKey = @PurchaseOrderKey,
					ProjectKey = @ProjectKey,
					TaskKey = @TaskKey,
					ItemKey = @ItemKey,
					ClassKey = @ClassKey,
					ShortDescription = @ShortDescription,
					UnitCost = @UnitCost,
					UnitDescription = @UnitDescription,
					TotalCost = Round(@TotalCost, 2),
					UnitRate = @UnitRate,
					Billable = @Billable,
					Markup = @Markup,
					BillableCost = Round(@BillableCost, 2),
					LongDescription = @LongDescription,
					CustomFieldKey = @CustomFieldKey,
					DetailOrderDate = @DetailOrderDate,
					DetailOrderEndDate = @DetailOrderEndDate,				
					OrderDays = @OrderDays,
					OrderTime = @OrderTime,
					OrderLength = @OrderLength,
					Taxable = @Taxable,
					Taxable2 = @Taxable2,
					OfficeKey = @OfficeKey,
					DepartmentKey = @DepartmentKey,
					Quantity1 = @Quantity1,
					Quantity2 = @Quantity2,
					LineType = @LineType,
					MediaPremiumKey = @MediaPremiumKey,
					PremiumAmountType = @PremiumAmountType,
					PremiumPct = @PremiumPct,
					GrossAmount = @GrossAmount,
					Commission = @Commission,
					PCurrencyID = @PCurrencyID,
					PExchangeRate = @PExchangeRate,
					PTotalCost = ROUND(@PTotalCost,2),
					DetailVendorKey = @DetailVendorKey,
					Bucket = @Bucket,
					SalesTaxAmount = @SalesTaxAmount,
			        SalesTax1Amount = @SalesTax1Amount,
                    SalesTax2Amount = @SalesTax2Amount
				WHERE PurchaseOrderKey = @PurchaseOrderKey 
				  and LineNumber = @LineNumber
				  and AdjustmentNumber = @AdjustmentNumber
				  and TransferToKey is null -- ignore records transferred out
			end 	  
	    else  -- not a summary broadcast order
			begin
				-- have any of the spots on this line been invoiced?
				if exists (select 1 from tPurchaseOrderDetail (nolock)
				            where PurchaseOrderKey = @PurchaseOrderKey
				              and LineNumber = @LineNumber
				              and AdjustmentNumber = @AdjustmentNumber
				              and isnull(InvoiceLineKey,0) > 0)
					begin
						if @SelectUpdate = 1 OR @AllowChangesAfterClientInvoice = 1 -- if changes are allowed after invoice
							update tPurchaseOrderDetail
							   set PurchaseOrderKey = @PurchaseOrderKey,
								   ProjectKey = @ProjectKey,
								   TaskKey = @TaskKey,
								   ItemKey = @ItemKey,
								   ClassKey = @ClassKey,
								   ShortDescription = @ShortDescription,
								   UnitCost = @UnitCost,
								   UnitDescription = @UnitDescription,
								   TotalCost = Round(@TotalCost, 2),
								   UnitRate = @UnitRate,
								   Billable = @Billable,
								   Markup = @Markup,
								   BillableCost = Round(@BillableCost, 2),
								   LongDescription = @LongDescription,
								   CustomFieldKey = @CustomFieldKey,
								   OrderDays = @OrderDays,
								   OrderTime = @OrderTime,
								   OrderLength = @OrderLength,
								   Taxable = @Taxable,
								   Taxable2 = @Taxable2,
								   OfficeKey = @OfficeKey,
								   DepartmentKey = @DepartmentKey,
								   Quantity1 = @Quantity1,
								   Quantity2 = @Quantity2,
								   LineType = @LineType,
								   MediaPremiumKey = @MediaPremiumKey,
								   PremiumAmountType = @PremiumAmountType,
								   PremiumPct = @PremiumPct,
								   GrossAmount = @GrossAmount,
								   Commission = @Commission,
								   PCurrencyID = @PCurrencyID,
								   PExchangeRate = @PExchangeRate,
								   PTotalCost = ROUND(@PTotalCost,2),
								   DetailVendorKey = @DetailVendorKey,
								   Bucket = @Bucket,
								   SalesTaxAmount = @SalesTaxAmount,
								   SalesTax1Amount = @SalesTax1Amount,
								   SalesTax2Amount = @SalesTax2Amount
						 where PurchaseOrderKey = @PurchaseOrderKey 
							   and LineNumber = @LineNumber
							   and AdjustmentNumber = @AdjustmentNumber		
							   and TransferToKey is null -- ignore records transferred out
						-- else, do nothing, only update spot level info
					end
				else  -- no spots have been invoiced, update line level information
					update tPurchaseOrderDetail
					    set PurchaseOrderKey = @PurchaseOrderKey,
						    ProjectKey = @ProjectKey,
							TaskKey = @TaskKey,
							ItemKey = @ItemKey,
							ClassKey = @ClassKey,
							ShortDescription = @ShortDescription,
							UnitCost = @UnitCost,
							UnitDescription = @UnitDescription,
							TotalCost = Round(@TotalCost, 2),
							UnitRate = @UnitRate,
							Billable = @Billable,
							Markup = @Markup,
							BillableCost = Round(@BillableCost, 2),
							LongDescription = @LongDescription,
							CustomFieldKey = @CustomFieldKey,
							OrderDays = @OrderDays,
							OrderTime = @OrderTime,
							OrderLength = @OrderLength,
							Taxable = @Taxable,
							Taxable2 = @Taxable2,
							OfficeKey = @OfficeKey,
							DepartmentKey = @DepartmentKey,
							LineType = @LineType,
							Quantity1 = @Quantity1,
							Quantity2 = @Quantity2,
							MediaPremiumKey = @MediaPremiumKey,
							PremiumAmountType = @PremiumAmountType,
							PremiumPct = @PremiumPct,
							GrossAmount = @GrossAmount,
							Commission = @Commission,
							PCurrencyID = @PCurrencyID,
							PExchangeRate = @PExchangeRate,
							PTotalCost = ROUND(@PTotalCost,2),
							DetailVendorKey = @DetailVendorKey,
							Bucket = @Bucket,
							SalesTaxAmount = @SalesTaxAmount,
			                SalesTax1Amount = @SalesTax1Amount,
                            SalesTax2Amount = @SalesTax2Amount
					  where PurchaseOrderKey = @PurchaseOrderKey 
						and LineNumber = @LineNumber
						and AdjustmentNumber = @AdjustmentNumber				
						and TransferToKey is null -- ignore records transferred out
			end
	else -- not a broadcast order, update POs and IOs
	BEGIN
		-- for IO, check if we can change
		IF @POKind = 1 And @InvoiceLineKey > 0 And @NoFinancialUpdate = 0 And @AllowChangesAfterClientInvoice = 0 AND @SelectUpdate = 0 
			RETURN -4
	
		UPDATE
			tPurchaseOrderDetail
		SET
			PurchaseOrderKey = @PurchaseOrderKey,
			ProjectKey = @ProjectKey,
			TaskKey = @TaskKey,
			ItemKey = @ItemKey,
			ClassKey = @ClassKey,
			ShortDescription = @ShortDescription,
			Quantity = @Quantity,
			UnitCost = @UnitCost,
			UnitDescription = @UnitDescription,
			TotalCost = Round(@TotalCost, 2),
			UnitRate = @UnitRate,
			Billable = @Billable,
			Markup = @Markup,
			BillableCost = Round(@BillableCost, 2),
			LongDescription = @LongDescription,
			CustomFieldKey = @CustomFieldKey,
			DetailOrderDate = @DetailOrderDate,
			DetailOrderEndDate = @DetailOrderEndDate,
			UserDate1 = @UserDate1,
			UserDate2 = @UserDate2,
			UserDate3 = @UserDate3,
			UserDate4 = @UserDate4,
			UserDate5 = @UserDate5,
			UserDate6 = @UserDate6,
			OrderDays = @OrderDays,
			OrderTime = @OrderTime,
			OrderLength = @OrderLength,
			Taxable = @Taxable,
			Taxable2 = @Taxable2,
			OfficeKey = @OfficeKey,
			DepartmentKey = @DepartmentKey,
			Quantity1 = @Quantity1,
			Quantity2 = @Quantity2,
			LineType = @LineType,
			MediaPremiumKey = @MediaPremiumKey,
			PremiumAmountType = @PremiumAmountType,
			PremiumPct = @PremiumPct,
			GrossAmount = @GrossAmount,
			Commission = @Commission,
			PCurrencyID = @PCurrencyID,
			PExchangeRate = @PExchangeRate,
			PTotalCost = ROUND(@PTotalCost,2),
			DetailVendorKey = @DetailVendorKey,
			Bucket = @Bucket,
			SalesTaxAmount = @SalesTaxAmount,
			SalesTax1Amount = @SalesTax1Amount,
            SalesTax2Amount = @SalesTax2Amount
		WHERE
			PurchaseOrderDetailKey = @PurchaseOrderDetailKey 
	END

	exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey
		
	exec sptPurchaseOrderRollupAmounts @PurchaseOrderKey

	EXEC sptProjectRollupUpdate @ProjectKey, 5, 1, 1, 1, 1 
	IF @ProjectKey <> @OldProjectKey
		EXEC sptProjectRollupUpdate @OldProjectKey, 5, 1, 1, 1, 1 
	
RETURN @PurchaseOrderDetailKey
GO
