USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataPrintOrderDetail]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataPrintOrderDetail]
	(
		@PurchaseOrderKey int,
		@UserKey int,
		@LinkID varchar(50),
		@StartDate smalldatetime,
		@Quantity decimal(24,4),
		@Program varchar(max),
		@Comments varchar(1000),
		@Date1 smalldatetime,
		@Date2 smalldatetime,
		@TotalGross decimal(24,6),
		@TotalNet decimal(24,6),
		@TotalClientGross decimal(24,6),
		@TotalClientNet decimal(24,6),
		@IlStatus varchar(5),
		@IlCost decimal(24,6),  -- Use this to pass in the DFA Unit Rate
		@IlNetPercent decimal(24,6),
		@CalCltNetType decimal(24,6),
		@IlCltNetPercent decimal(24,6),
		@IlCltGrossPercent decimal(24,6) = 0,
		@CMP tinyint = 0	-- syncing from CMP?  WMJ = 0 / CMP = 1
	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 10/03/06 RTC 8.3566   Added logic to handle auto-revision lines for print orders.
  || 11/16/06 CRG 8.3571   Modified to get ClassKey from tPurchaseOrder.
  || 02/05/07 RTC 8.4.0.2  When creating two line adjustments, insure the second ine's total cost <> 0
  || 04/17/07 BSH 8.4.5    DateUpdated needed to be updated.
  || 10/01/07 GHL 8.5      Added DateClosed logic
  || 10/05/07 BSH 8.5      Insert OfficeKey to PO Detail, get from Estimate or Project based on ClientLink. 
  || 04/28/09 RTC 10.0.2.4 (50959) Corrected issues with zero quantity revision line generation.
  || 10/07/09 MAS 10.5.1.9 () Calculate Client Costing
  || 10/07/09 MAS 10.5.1.9 (67320) Removed rounding when calculating Client Costing UnitRate/UnitCost also set Commision/Markup = 0 when UnitRate = 0
  || 11/11/09 MAS 10.5.1.3 (47035)
  || 11/17/09 MAS 10.5.1.9 (68648) Removed ISNULL(UseClientCosting,0) when getting UseClientCosting from tPurchaseOrder as it was forcing 
  ||					    No Client Costing, when it should have pulled it out of the Pref table					 
  || 01/14/09 MAS 10.5.1.6 (71874) Changed the Client Costing calculation for Interactive Orders
  || 10/19/10 MAS 10.5.3.7 (92477) Added support for a new Strata Print Client Costing option "Client Gross % statistic"
  || 11/11/10 MAS 10.5.3.8 Reset the PO Header closed flag to 0 when a new line is added.
  ||                       Changed the way we determine if a revision line should be created.  We were using an AVG(UnitCost), we now use TotalCost
  || 12/09/10 MAS 10.5.3.9 (96319)Both print and interactive are always a quantity of 1.  Only create an adjustment line if the @NetTotalCost has changed
  ||                       Always use quantity 0 for adjustment lines.  
  ||                       Delete the auto revision line if the adjustment would result in a $0 line	
  || 03/15/11 MAS 10.5.3.9 (105980)Account for a DetailOrderDate change
  || 05/24/11 MAS 10.5.4.4 (109450)Verify the Task and Project are accepting changes before performing an update/insertion.  Previsouly we were
  ||                       checking the project's status only in sptStrataMediaEstimateUpdate.  So, if during a sync an order that 
  ||                       was not accepting changes was included (and no changes were actually made) they would get an error.
  || 06/15/11 MAS 10.5.4.5 (114001)If not using tasks (TaskKey is 0 or NULL), always defualt @TaskAcceptingUpdates = 1 
  || 08/30/11 MAS 10.5.4.7 (119003)Compare the SUM of TotalCost and BillableCost against the @TotGross and @TotNet to see if something changed
  || 07/11/12 MAS 10.5.5.7 (148195)Changed the precision of the client costing params
  || 08/23/12 MAS 10.5.5.9 (152132)Changed the precision of all the rest of the client costing params
  || 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @Program(ShortDescription) from 200 to 300
  || 03/14/13 MAS 10.5.6.6 Added @CalCltNetType 100 to support Interactive changes.  The new interactive changes use a query that already calculates the
  ||					   Order net and gross.
  || 05/08/13 MAS 10.5.6.7 Added @TotalClientGross & @TotalClientNet to support Interactive changes
  || 11/15/13 MAS 10.5.7.5 (196866) Use @TotalGross for the Interactive Gross.  ORDERED_GROSS_COST (from the Strata query)
  || 12/17/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptPurchaseOrderDetailInsert
  || 02/03/14 GHL 10.5.7.6  Added update of PTotalCost when updating directly tPurchaseOrderDetail
  || 02/05/14 PLC 10.5.7.6  Fixed client net for interactive. 
  || 04/29/14 RLB 10.5.7.9 (214240)Changed the length of @Program(ShortDescription) from 300 to max
  || 06/11/14 GHL 10.5.8.1  Added UserKey = null when calling sptPurchaseOrderDetailDelete, UserKey is used to log print orders with media WS  
  */
    
Declare @PODKey int
Declare @ProjectKey int, @TaskKey int, @ItemKey int, @RetVal int, @NewKey int, @TotNet money, @TotGross money, @Markup decimal(24,4)
declare @AppliedCost money
declare @TotalCost money 
declare @Closed tinyint
declare @AllowChangesAfterClientInvoice tinyint
declare @GeneratePrebilledRevisions tinyint
declare @ShowAdjustmentsAsSingleLine tinyint
declare @Prebilled as tinyint
declare @NetQuantity decimal(24,4)
declare @NetTotalCost money
declare @NetBillableCost money
declare @AdjUnitCost money
declare @AdjTotalCost money
declare @AdjBillableCost money
declare @ExistingPODAdjKey int
declare @ExistingPODAdjTotalCost money
declare @ExistingPODAdjBillableCost money
declare @NewAdjustmentNumber int
declare @NewAdjustmentNumber2 int
declare @CustomFieldKey int
declare @ObjectFieldSetKey int
declare @CompanyKey int
declare @LineNumber int 
declare @ClassKey int
declare @OfficeKey int
declare @IOClientLink int
declare @MediaEstimateKey int
declare @DepartmentKey int
declare @RequireDepartment tinyint 
declare @DFA tinyint
declare @UnitDescription varchar(30)
declare @UseClientCosting tinyint 
declare @POClientCosting tinyint 
declare @UnitCost money
declare	@UnitRate money
declare	@Commission decimal(24,4)
declare @ProjectAcceptingUpdates int
declare @TaskAcceptingUpdates int
declare @CurrTotalCost money
declare @CurrBillableCost money

Select 
	 @ProjectKey = ProjectKey, @TaskKey = TaskKey, @ItemKey = ItemKey
	,@CompanyKey = CompanyKey
	,@ClassKey = ClassKey
	,@MediaEstimateKey = MediaEstimateKey
	,@POClientCosting = UseClientCosting
From tPurchaseOrder (nolock) Where PurchaseOrderKey = @PurchaseOrderKey

-- determine if order lines (spots) can be updated after client invoice has been created
-- determine if revision lines should be auto generated for prebilled lines
-- determine if one or two revision lines should be created
select @AllowChangesAfterClientInvoice = isnull(IOAllowChangesAfterClientInvoice, 0)
      ,@GeneratePrebilledRevisions = isnull(IOGeneratePrebilledRevisions, 0)
      ,@ShowAdjustmentsAsSingleLine = isnull(IOShowAdjustmentsAsSingleLine, 1)
      ,@IOClientLink = isnull(IOClientLink,1)
      ,@RequireDepartment = RequireDepartment
      ,@UseClientCosting = IOUseClientCosting
      ,@DFA = CASE ISNULL(CHARINDEX('dfa',Customizations), 0) When 0 then 0 Else 1 End
  from tPreference (nolock)
 where CompanyKey = @CompanyKey

-- If POD ClientCosting is NULL use the system setting
if @POClientCosting is null
	Begin
		Select @POClientCosting = @UseClientCosting
		
		Update tPurchaseOrder 
		Set UseClientCosting = @POClientCosting
		Where PurchaseOrderKey = @PurchaseOrderKey
	End

-- print lines can have a line that has been cancelled but still marked as billed
-- transfer these lines but at zero cost, if the generate automatic revision lines 
-- option is set a full reversal adjustemnt line wil be generated
if Upper(@IlStatus) = 'Z'
	Begin
		Select @UnitCost = 0
		Select @UnitRate = 0
		Select @Commission = 0
	End
else
	Begin
		-- Interactive and Print order are handled the same except for the calculations, 
		-- @CalCltNetType = 0 for interactive orders, @CalCltNetType = 100 for NEW interactive orders
		-- @CalCltNetType = 99 DFA orders (does not use client costing)
		if @POClientCosting = 1
			begin
				Select @UnitCost = -- Net
					case @CalCltNetType
						when 0 then @TotalNet * (1 - @IlNetPercent)   -- Interactive Order
						when 100 then @TotalNet						  -- New Interactive Order. The Net that goes into WMJ is always the SBMS Vendor Net.
						else @IlCost * (1 - @IlNetPercent)			  -- Print/DFA Order
					end
				Select @UnitRate = -- Gross
					case @CalCltNetType
						when 0 then @TotalGross * (1 - @IlCltNetPercent)			-- Interactive Order
						-- Fix to use Client Net
						when 100 then @TotalClientNet								-- New Interactive Order. The WMJ Gross is Vendor Gross from SBMS if using Client Costing. Fix to use Client Net
						when 1 then @UnitCost + (@IlCost * @IlCltNetPercent)		-- Print Order
						when 2 then @UnitCost + (@UnitCost * @IlCltNetPercent)	
						when 3 then @UnitCost / (1 - @IlCltNetPercent)	
						when 4 then @IlCost * @IlCltGrossPercent * (1 - @IlCltNetPercent)	
					end
				if @UnitRate = 0
					Select @Commission = 0
				else	
					Select @Commission = (1 - ROUND(@UnitCost / @UnitRate, 4)) * 100
			end
		else
			begin
				Select @UnitCost = -- Net
					case @CalCltNetType
						when 0 then @TotalNet * (1 - @IlNetPercent)	-- Interactive Order
						when 100 then @TotalNet						-- New Interactive Order. The Net that goes into WMJ is always the SBMS Vendor Net.
						else @IlCost * (1 - @IlNetPercent)			-- Print/DFA Order
					end
				Select @UnitRate = -- Gross
					case @CalCltNetType
						when 0 then @TotalNet			-- Interactive Order
						when 100 then @TotalGross		-- New Interactive Order. ORDERED_GROSS_COST (from the Strata query)
						else @IlCost -- Print/DFA Order
					end	
				Select @Commission = @IlNetPercent * 100
			end
	End
		
if @IOClientLink = 1
	select @OfficeKey = OfficeKey
	from tProject (nolock)
	where ProjectKey = @ProjectKey
else
	select @OfficeKey = OfficeKey
	from tMediaEstimate (nolock)
	where MediaEstimateKey = @MediaEstimateKey

select @DepartmentKey = DepartmentKey
from tItem (nolock)
where ItemKey = @ItemKey

if @RequireDepartment = 1 -- department is required
	if @DepartmentKey is null
		return -3	
     
Select @PODKey = MIN(PurchaseOrderDetailKey)
From tPurchaseOrderDetail (NOLOCK) Where PurchaseOrderKey = @PurchaseOrderKey and LinkID = @LinkID

if ISNULL(@DFA, 0) = 1
	Begin
		select @TotNet = @TotalNet
		select @TotGross = @TotalGross
		select @UnitDescription = @IlStatus		
	end
Else
	Begin
		select @TotNet = round(round(ISNULL(@UnitCost, 0),2) * ISNULL(@Quantity, 0),2) 
		select @TotGross = round(round(ISNULL(@UnitRate, 0),2) * ISNULL(@Quantity, 0),2)
		Select @UnitDescription = null
	End
	
-- If using Projects/Tasks - Check to see if the associated Task is completed
if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
	BEGIN
		exec @RetVal = spTaskValidatePercComp 'tPurchaseOrderDetail',@PODKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
		if @RetVal < 0 
			select @TaskAcceptingUpdates = 0 -- return -4 
		else
			select @TaskAcceptingUpdates = 1
	END	
else
	BEGIN
	-- Default to allow tasks to accept updates
		select @TaskAcceptingUpdates = 1
	END
	
-- determine if the project is accepting updates
if exists(Select 1 from tProject p (NOLOCK) 
		  inner join tProjectStatus ps (NOLOCK) on p.ProjectStatusKey = ps.ProjectStatusKey
		  Where p.ProjectKey = @ProjectKey and  ps.ExpenseActive = 1 )	
	Begin
		Select @ProjectAcceptingUpdates = 1
	End
Else
	Begin
		-- if there isn't a project set for this order, then accept changes
		if ISNULL(@ProjectKey,0) = 0
			Select @ProjectAcceptingUpdates = 1
		else
			Select @ProjectAcceptingUpdates = 0
	End			  
			
if @PODKey is null
BEGIN
	if ISNULL(@TaskAcceptingUpdates,0) = 0 
		return -4
	if ISNULL(@ProjectAcceptingUpdates,0) = 0 
		return -6
	
	exec @RetVal = sptPurchaseOrderDetailInsert
		@PurchaseOrderKey,
		0,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@Program,
		@Quantity,
		@UnitRate,
		@UnitDescription,
		@TotNet,
		NULL,
		1,
		@Commission,
		@TotGross,
		@Comments,
		0,
		@StartDate,
		NULL,
		@Date1,
		@Date2,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL,
		0,
		0,
		@OfficeKey,
		@DepartmentKey,
		@TotGross,	-- GrossAmount
		null,		-- PCurrencyID
		1,			-- PExchangeRate
		@TotNet,	-- PTotalCost
		@NewKey output
		
	Update tPurchaseOrderDetail Set LinkID = @LinkID Where PurchaseOrderDetailKey = @NewKey

--Cast(Cast(DatePart(mm,@StartDate) as varchar) + '/' + Cast(DatePart(dd,@StartDate) as varchar) + '/' + Cast(DatePart(yyyy,@StartDate) as varchar) as datetime),

END
ELSE
BEGIN

		-- make sure this line is not on a billing worksheet
		if exists(select 1 
		            from tBillingDetail bd (nolock) inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
		           where bd.EntityKey = @PODKey 
		            and bd.Entity = 'tPurchaseOrderDetail'
		             and b.Status < 5)
			return -2 
			
		-- if this is an existing line and it has been invoiced, do not allow changes if the system options do not allow
		select @Prebilled = 0
		if exists(select 1 from tPurchaseOrderDetail (nolock) Where PurchaseOrderDetailKey = @PODKey and InvoiceLineKey is not null)		
			begin
				select @Prebilled = 1
				if @GeneratePrebilledRevisions = 0 and @AllowChangesAfterClientInvoice = 0
						-- the line was prebilled and system options do not allow any kind of updating
						return -1
			end	
				
		-- check to see if something changed between strata and WMJ and if the project/task allows changes
		select @LineNumber = LineNumber
				from tPurchaseOrderDetail (nolock)
				where PurchaseOrderDetailKey = @PODKey
				
		Select 	@CurrTotalCost = SUM(ISNULL(TotalCost,0)),
				@CurrBillableCost = SUM(ISNULL(BillableCost,0))
				from tPurchaseOrderDetail (nolock) 
				Where PurchaseOrderKey = @PurchaseOrderKey
				and LineNumber = @LineNumber			
					
		if 	@CurrTotalCost <> @TotNet or
			@CurrBillableCost <> @TotGross 
			begin
				if ISNULL(@TaskAcceptingUpdates,0) = 0 
					return -4
				if ISNULL(@ProjectAcceptingUpdates,0) = 0 
					return -6
			end

		-- check to see if the Strata order date has changed since the original sync, if so, update the line and all revisions. (105980)
		if @StartDate <> (Select DetailOrderDate from tPurchaseOrderDetail (nolock) Where PurchaseOrderDetailKey = @PODKey)
			begin
				-- get current values from original line and any automatic or manual revision lines associated to it for a period within the flight
				select @LineNumber = LineNumber
				from tPurchaseOrderDetail (nolock)
				where PurchaseOrderDetailKey = @PODKey
				
				update tPurchaseOrderDetail 
				set DetailOrderDate = @StartDate
				where PurchaseOrderKey = @PurchaseOrderKey
				and LineNumber = @LineNumber
			end
		
		-- is this a prebilled line that may require auto-revision line(s) to be created
		if @Prebilled = 1 and @GeneratePrebilledRevisions = 1
			begin
				-- get current values from original line and any automatic or manual revision lines associated to it for a period within the flight
				select @LineNumber = LineNumber
				from tPurchaseOrderDetail (nolock)
				where PurchaseOrderDetailKey = @PODKey
				
				if @ShowAdjustmentsAsSingleLine = 1
					select @NetQuantity = sum(Quantity)
							,@NetTotalCost = sum(TotalCost)
							,@NetBillableCost = sum (BillableCost)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
					---and ((isnull(AutoAdjustment,0) = 0)  -- include billed and unbilled manual adjustment lines
					---	or (isnull(AutoAdjustment,0) = 1 and InvoiceLineKey is not null))  -- only include billed auto-adjustment lines since we will reuse the existing unbilled auto adjustment line for the update below
				else -- two line adjustments
					-- include billed and unbilled manual adjustment lines
					-- include billed and unbilled auto-adjustment lines
					select @NetQuantity = sum(Quantity)
							,@NetTotalCost = sum(TotalCost)
						   ,@NetBillableCost = sum (BillableCost)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
				
				-- verify something has changed, requiring a revision				
				if @NetTotalCost <> @TotNet
					begin
						-- determine if we need to create one or two adjustment lines
						if @ShowAdjustmentsAsSingleLine = 1
							begin

								-- If we have an existing @ExistingPODAdj line, we'll need to exclude it from the adjustment amount
								-- since it was included in @NetTotalCost and @NetBillableCost
								Select @ExistingPODAdjTotalCost = 0
								Select @ExistingPODAdjBillableCost = 0
								
								-- look to see if an existing auto adjustment line exists that has not been billed and adjust it
								-- otherwise create a new adjustment line
								select @ExistingPODAdjKey = min(PurchaseOrderDetailKey), 
									   @ExistingPODAdjTotalCost = ISNULL(SUM(TotalCost), 0),
								       @ExistingPODAdjBillableCost = ISNULL(SUM(BillableCost), 0)
								from tPurchaseOrderDetail (nolock)
								where PurchaseOrderKey = @PurchaseOrderKey
								and LineNumber = @LineNumber
								and InvoiceLineKey is null  -- only unbilled lines
								and AutoAdjustment = 1  -- it was originally added using this procedure, do not update manual lines
							
								-- calculate values to be inserted
								-- if Unit Cost did change, we need to generate a line with quantity of 1 or -1 for the net difference to avoid rounding issues
								begin
									-- if billed gross/net > current transaction total, client was overbilled
									if @NetBillableCost > @TotGross
										select @AdjTotalCost = ((@NetTotalCost - @ExistingPODAdjTotalCost) - @TotNet)  * -1
												,@AdjBillableCost = ((@NetBillableCost - @ExistingPODAdjBillableCost) - @TotGross) * -1
												,@AdjUnitCost = (@NetBillableCost - @ExistingPODAdjBillableCost) - @TotGross
									-- net/gross < sum of existing billed transactions, client was underbilled
									else
										select @AdjTotalCost = @TotNet - (@NetTotalCost - @ExistingPODAdjTotalCost)
												,@AdjBillableCost = @TotGross - (@NetBillableCost - @ExistingPODAdjBillableCost)
												,@AdjUnitCost = @TotGross - (@NetBillableCost - @ExistingPODAdjBillableCost) 								
								end
								
								if @ExistingPODAdjKey is not null  -- update the existing auto-adjustment line
									begin
										-- Delete this line if it adjusted to zero
										if (@ExistingPODAdjTotalCost - @AdjTotalCost) = 0 and (@ExistingPODAdjBillableCost - @AdjBillableCost ) = 0 
											or ( @AdjTotalCost = 0 and @AdjBillableCost = 0 )
											begin
												exec sptPurchaseOrderDetailDelete @ExistingPODAdjKey, null
											end
										else
											begin
												update tPurchaseOrderDetail
													set
													Quantity = 0,
													Markup = @Commission,
													UnitCost = @AdjUnitCost,
													TotalCost = @AdjTotalCost,
													PTotalCost = @AdjTotalCost,
													BillableCost = @AdjBillableCost
												where PurchaseOrderDetailKey = @ExistingPODAdjKey
												
												update tPurchaseOrder
												set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
													,Closed = 0
												where PurchaseOrderKey = @PurchaseOrderKey 
											end
									end									
								else -- create a new single adjustment line
									begin

										select @NewAdjustmentNumber = isnull(max(AdjustmentNumber),0)
										from tPurchaseOrderDetail (nolock)
										where PurchaseOrderKey = @PurchaseOrderKey
										and LineNumber = @LineNumber	

										select @NewAdjustmentNumber = @NewAdjustmentNumber + 1					
										
										-- get new ObjectFieldSetKey
										select @CustomFieldKey = CustomFieldKey
										from tPurchaseOrderDetail (nolock)
										where PurchaseOrderDetailKey = @PODKey 
										
										IF ISNULL(@CustomFieldKey,0) > 0
											exec spCF_CopyFieldSet @CustomFieldKey, 1, @ObjectFieldSetKey output
											
										insert tPurchaseOrderDetail
											(
											PurchaseOrderKey,
											LineNumber,
											ProjectKey,
											TaskKey,
											ItemKey,
											ClassKey,
											ShortDescription,
											Quantity,
											UnitCost,
											UnitDescription,
											TotalCost,
											PTotalCost,
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
											AutoAdjustment,
											AdjustmentNumber
											)
										select
											PurchaseOrderKey,
											LineNumber,
											ProjectKey,
											TaskKey,
											ItemKey,
											ClassKey,
											ShortDescription,
											0, -- @AdjQuantity,
											@AdjUnitCost,
											UnitDescription,
											@AdjTotalCost,
											@AdjTotalCost,
											null,  -- @UnitRate,
											Billable,
											@Commission,
											@AdjBillableCost,
											LongDescription,
											@ObjectFieldSetKey,
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
											1, -- AutoAdjustment			
											@NewAdjustmentNumber								
										from tPurchaseOrderDetail (nolock)
										where PurchaseOrderDetailKey =  @PODKey
										
										update tPurchaseOrder
										set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
											,Closed = 0
										where PurchaseOrderKey = @PurchaseOrderKey  
									end									
							end
							
						-- show adjustments as two lines
						else  
							begin
								-- calculate values to be inserted
								-- regardless of what changed, always reverse the original line and any adjustment line(s) and insert a new line for the new amounts

								-- create a reversal for the net of all existing lines
								if @NetQuantity <> 0
								begin									

									select @NewAdjustmentNumber = isnull(max(AdjustmentNumber),0)
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and LineNumber = @LineNumber	

									select @NewAdjustmentNumber = @NewAdjustmentNumber + 1
										
									--Get new ObjectFieldSetKey
									select @CustomFieldKey = CustomFieldKey
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderDetailKey = @PODKey 
									
									IF ISNULL(@CustomFieldKey,0) > 0
										exec spCF_CopyFieldSet @CustomFieldKey, 1, @ObjectFieldSetKey output
										
									insert tPurchaseOrderDetail
										(
										PurchaseOrderKey,
										LineNumber,
										ProjectKey,
										TaskKey,
										ItemKey,
										ClassKey,
										ShortDescription,
										Quantity,
										UnitCost,
										UnitDescription,
										TotalCost,
										PTotalCost,
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
										AutoAdjustment,
										AdjustmentNumber
										)
									select
										PurchaseOrderKey,
										LineNumber,
										ProjectKey,
										TaskKey,
										ItemKey,
										ClassKey,
										ShortDescription,
										0, -- @NetQuantity * -1,
										case @NetQuantity
											when 0 then round((@NetBillableCost),2)
											else round((@NetBillableCost * -1)/(@NetQuantity * -1),2)
										end,
										UnitDescription,
										@NetTotalCost * -1,
										@NetTotalCost * -1,
										null, --(@NetBillableCost * -1)/(@NetQuantity * -1), -- UnitRate
										Billable,
										case @NetBillableCost
											when 0 then 0
											else 100 - round((@NetTotalCost * -1)/(@NetBillableCost * -1)*100,4)
										end,
										@NetBillableCost * -1,
										LongDescription,
										@ObjectFieldSetKey,
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
										1,  -- AutoAdjustment
										@NewAdjustmentNumber								
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderDetailKey =  @PODKey
									
									update tPurchaseOrder
									set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
										,Closed = 0
									where PurchaseOrderKey = @PurchaseOrderKey  
								end
								
								-- create a new adjustment line
								if @Quantity <> 0 and @TotNet <> 0
								begin		
																						
									select @NewAdjustmentNumber2 = isnull(max(AdjustmentNumber),0)
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and LineNumber = @LineNumber	

									select @NewAdjustmentNumber2 = @NewAdjustmentNumber2 + 1

									--Get new ObjectFieldSetKey
									select @CustomFieldKey = CustomFieldKey
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderDetailKey = @PODKey 
									
									IF ISNULL(@CustomFieldKey,0) > 0
										exec spCF_CopyFieldSet @CustomFieldKey, 1, @ObjectFieldSetKey output
										
									insert tPurchaseOrderDetail
										(
										PurchaseOrderKey,
										LineNumber,
										ProjectKey,
										TaskKey,
										ItemKey,
										ClassKey,
										ShortDescription,
										Quantity,
										UnitCost,
										UnitDescription,
										TotalCost,
										PTotalCost,
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
										AutoAdjustment,
										AdjustmentNumber
										)
									select
										PurchaseOrderKey,
										LineNumber,
										ProjectKey,
										TaskKey,
										ItemKey,
										ClassKey,
										ShortDescription,
										@Quantity,
										case @Quantity
											when 0 then @TotGross
											else round(@TotGross/@Quantity,4)
										end,
										UnitDescription,
										@TotNet,
										@TotNet,
										null,  --@UnitRate,
										Billable,
										@Commission,
										@TotGross,
										LongDescription,
										@ObjectFieldSetKey,
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
										1, -- AutoAdjustment
										@NewAdjustmentNumber2											
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderDetailKey =  @PODKey
									
									update tPurchaseOrder
									set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
										,Closed = 0
									where PurchaseOrderKey = @PurchaseOrderKey  
								end -- Quantity > 0								
							end
					end
				else
					-- nothing has changed since prebilling, simply return
					return 1
			end
			
		-- this is an existing unbilled line or an existing prebilled line and system options allow updates to it
		else	
			begin	
				-- check if line & PO need to be reopened
				select @AppliedCost = AppliedCost
					,@TotalCost = TotalCost
					,@Closed = Closed
				from tPurchaseOrderDetail (nolock)
				where PurchaseOrderDetailKey = @PODKey
				     
				if @Closed = 1 and @TotNet <> @TotalCost and @TotNet <> @AppliedCost
					begin
						update tPurchaseOrderDetail 
						set Closed = 0, DateClosed = NULL 
						where PurchaseOrderDetailKey = @PODKey
						update tPurchaseOrder
						set Closed = 0,
						    DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
						where PurchaseOrderKey = @PurchaseOrderKey
					end
							
				Update tPurchaseOrderDetail
					Set
					ProjectKey = @ProjectKey,
					TaskKey = @TaskKey,
					ItemKey = @ItemKey,
					ClassKey = @ClassKey,
					ShortDescription = @Program,
					LongDescription = @Comments,
					Quantity = @Quantity,
					Markup = @Commission,
					UnitCost = @UnitRate,
					TotalCost = @TotNet,
					PTotalCost = @TotNet,
					BillableCost = @TotGross,
					DetailOrderDate = @StartDate,
					UserDate1 = @Date1,
					UserDate2 = @Date2,
					OfficeKey = @OfficeKey,
					DepartmentKey = @DepartmentKey
				Where
					PurchaseOrderDetailKey = @PODKey
					
				update tPurchaseOrder
				set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
				where PurchaseOrderKey = @PurchaseOrderKey 

			end
END

exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey
GO
