USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusPrintOrderDetail]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusPrintOrderDetail]
	(
		@PurchaseOrderKey int,
		@UserKey int,		
		@LinkID varchar(50),
		@StartDate smalldatetime,
		@UnitCost money,
		@UnitRate money,
		@Commission decimal(24,4),
		@ClientDiscountRate decimal(24,4),
		@Quantity decimal(24,4),
		@Comments varchar(1000),
		@InsertLineStatus varchar(1),
		@Caption varchar(600),
		@CMP tinyint = 0		-- syncing from CMP?  WMJ = 0 / CMP = 1
	)

AS --Encrypt

  /*
  || When     Who Rel      What
  || 10/03/06 RTC 8.3566   Added logic to handle auto-revision lines for print orders.
  || 04/17/07 BSH 8.4.5    DateUpdated needed to be updated.
  || 08/30/07 BSH 8.4.3.5  (9146)AdjTotalNet calculation corrected to not use UnitCost.
  || 10/01/07 GHL 8.5      Added DateClosed logic
  || 10/05/07 BSH 8.5      Insert OfficeKey to PO Detail, get from Estimate or Project based on ClientLink. 
  || 05/16/08 BSH WMJ	   (26498)Added logic for ClientDiscount %. 
  || 07/17/08 RTC 10.0.0.5 Get the GL Class from the media estimate
  || 11/11/09 MAS 10.5.1.3 (47035)
  || 07/07/10 MAS 10.5.1.3 (82215)Added a flag to determine if the commission was reset, Bill at Net if Commision = 0
  || 10/30/12 GHL 10.5.6.1 (158082) Added rounding of net and gross  
  || 12/17/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptPurchaseOrderDetailInsert
  || 02/03/14 GHL 10.5.7.6  Added PTotalCost to direct update/insert into POD
  */
  
  
declare @PODKey int
declare @ProjectKey int
declare @TaskKey int
declare @ItemKey int
declare @NewKey int
declare @TotNet money
declare @TotGross money
declare @RetVal integer
declare @CompanyKey int
declare @AppliedCost money
declare @TotalCost money 
declare @Closed tinyint
declare @AllowChangesAfterClientInvoice tinyint
declare @GeneratePrebilledRevisions tinyint
declare @ShowAdjustmentsAsSingleLine tinyint
declare @Prebilled as tinyint
declare @NetQuantity decimal(24,4)
declare @NetUnitCost money
declare @NetTotalCost money
declare @NetBillableCost money
declare @NetQuantityChange tinyint
declare @NetUnitCostChange tinyint
declare @AdjQuantity decimal(24,4)
declare @AdjUnitCost money
declare @AdjTotalCost money
declare @AdjBillableCost money
declare @ExistingPODAdjKey int
declare @NewAdjustmentNumber int
declare @NewAdjustmentNumber2 int
declare @CustomFieldKey int
declare @ObjectFieldSetKey int
declare @CurrAppliedCost money
declare @CurrTotalCost money
declare @LineNumber int
declare @AdjCommission decimal(24,4) 
declare @OfficeKey int
declare @IOClientLink int
declare @MediaEstimateKey int
declare @DepartmentKey int
declare @ClassKey int
declare @CommissionHasBeenReset int
    
--find existing POD     
select @PODKey = min(PurchaseOrderDetailKey)
  from tPurchaseOrderDetail (nolock)
 where PurchaseOrderKey = @PurchaseOrderKey 
   and LinkID = @LinkID

-- Init the Reset Flag
Select @CommissionHasBeenReset = 0
		      
-- check to see if PO was deleted in SmartPlus and if it can be deleted in CMP
if @InsertLineStatus = 'C'
	if @PODKey is not null
		begin
			-- make sure the line is not on a client invoice
			if exists(select 1 
						from tPurchaseOrderDetail (nolock) 
						where PurchaseOrderDetailKey = @PODKey 
							and InvoiceLineKey is not null)
				return -1
				
			-- make sure the line has no vendor invoices applied
			if exists(select 1 
						from tVoucherDetail vd (nolock) inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
						where pod.PurchaseOrderDetailKey = @PODKey)
				return -2

			-- make sure the line is not on a billing worksheet
			if exists(select 1 
						from tBillingDetail bd (nolock) inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
					where bd.EntityKey = @PODKey 
						and bd.Entity = 'tPurchaseOrderDetail'
						and b.Status < 5)
				return -3 	

			-- make sure the line's PO is not closed 
			if exists (select 1
						from tPurchaseOrder (nolock)
						where PurchaseOrderKey = @PurchaseOrderKey
						and (Closed = 1))
				return -9
															
			-- no vendor or client invoices, or billing worksheets, delete PO
			exec @RetVal = sptSmartPlusOrderDetailDelete @PODKey, @UserKey, @CMP
				if @RetVal = -9 -- Could not delete because the task is complete
					return -10
					
				-- 	other errors 
				if @RetVal < 0 
					return -4
				else
					return 1					
		end
	else
		return 1

select @ProjectKey = ProjectKey,
       @TaskKey = TaskKey,
       @ItemKey = ItemKey,
	   @CompanyKey = CompanyKey,
	   @MediaEstimateKey = MediaEstimateKey,
	   @ClassKey = ClassKey
  from tPurchaseOrder (nolock) 
 where PurchaseOrderKey = @PurchaseOrderKey

-- get line number
select @LineNumber = min(isnull(LineNumber,1))
from tPurchaseOrderDetail (nolock)
where PurchaseOrderKey = @PurchaseOrderKey 
and LinkID = @LinkID
	
-- determine if order lines (spots) can be updated after client invoice has been created
-- determine if revision lines should be auto generated for prebilled lines
-- determine if one or two revision lines should be created
select @AllowChangesAfterClientInvoice = isnull(IOAllowChangesAfterClientInvoice, 0)
	    ,@GeneratePrebilledRevisions = isnull(IOGeneratePrebilledRevisions, 0)
	    ,@ShowAdjustmentsAsSingleLine = isnull(IOShowAdjustmentsAsSingleLine, 1)
	    ,@IOClientLink = isnull(IOClientLink,1)
    from tPreference (nolock)
    where CompanyKey = @CompanyKey
    
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
    
--save original value for adjustment logic
select @AdjCommission = @Commission  
    
select @TotGross = isnull(@UnitRate, 0) * isnull(@Quantity, 0)
if @Commission = 1.0
	Begin
	   -- Commission of 0 means to bill net at gross
       select @TotNet = @TotGross, @Commission = 0
       Select @CommissionHasBeenReset = 1
    End
else
	Begin
	-- For a free spot, the user should set the commisoin = 100%
       select @TotNet = @TotGross - (@TotGross * (@Commission / 100))
    End
    
---This is done for Client Discounts. 
if @Commission <> @ClientDiscountRate AND @CommissionHasBeenReset = 0
	Begin
		select @UnitRate = @UnitRate - @UnitRate * Round((@Commission - @ClientDiscountRate) / 100, 4)
		select @TotGross = isnull(@UnitRate, 0) * isnull(@Quantity, 0)
		select @Commission = @ClientDiscountRate
		select @AdjCommission = @Commission
	End

-- If using Projects/Tasks - Check to see if the associated Task is completed
if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
	BEGIN
		exec @RetVal = spTaskValidatePercComp 'tPurchaseOrderDetail',@PODKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
		if @RetVal < -1 
			return -10 
	END		
	
if @PODKey is null
    begin
	    exec @RetVal = sptPurchaseOrderDetailInsert
			@PurchaseOrderKey,
			0,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@Caption,
			@Quantity,
			@UnitRate,
			null,
			@TotNet,
			null,
			1,
			@Commission,
			@TotGross,
			@Comments,
			0,
			@StartDate,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			null,
			0,
			0,
			@OfficeKey,
			@DepartmentKey,
			@TotGross,	-- GrossAmount
			null,		-- PCurrencyID
			1,			-- PExchangeRate
			@TotNet,	-- PTotalCost
			@NewKey output
		
	    update tPurchaseOrderDetail 
	       set LinkID = @LinkID 
	     where PurchaseOrderDetailKey = @NewKey
	end
else
	begin
		-- handle existing line updates

		-- do not allow updates if vendor invoices have been applied
		if exists(select 1 
			        from tVoucherDetail vd (nolock) inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
			        where pod.PurchaseOrderDetailKey = @PODKey)
			return -7
					
		-- make sure this line is not on a billing worksheet
		if exists(select 1 
		            from tBillingDetail bd (nolock) inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
		           where bd.EntityKey = @PODKey 
		            and bd.Entity = 'tPurchaseOrderDetail'
		             and b.Status < 5)
			return -8

		-- if this is an existing line/spot and it has been invoiced, do not allow changes if the system options do not allow
		select @Prebilled = 0
		if exists(select 1 from tPurchaseOrderDetail (nolock) Where PurchaseOrderDetailKey = @PODKey and InvoiceLineKey is not null)		
			begin
				select @Prebilled = 1
				if @GeneratePrebilledRevisions = 0 and @AllowChangesAfterClientInvoice = 0
						-- the line was prebilled and system options do not allow any kind of updating
						return -6
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
							,@NetUnitCost = avg(UnitCost)
							,@NetTotalCost = sum(TotalCost)
							,@NetBillableCost = sum (BillableCost)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
					and ((isnull(AutoAdjustment,0) = 0)  -- include billed and unbilled manual adjustment lines
						or (isnull(AutoAdjustment,0) = 1 and InvoiceLineKey is not null))  -- only include billed auto-adjustment lines since we will reuse the existing unbilled auto adjustment line for the update below
				else -- two line adjustments
					-- include billed and unbilled manual adjustment lines
					-- include billed and unbilled auto-adjustment lines
					select @NetQuantity = sum(Quantity)
							,@NetUnitCost = avg(UnitCost)
							,@NetTotalCost = sum(TotalCost)
							,@NetBillableCost = sum (BillableCost)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
				
				-- verify something has changed, requiring a revision
				select @NetQuantityChange = 0
				select @NetUnitCostChange = 0
				
				if @NetQuantity <> @Quantity
					select @NetQuantityChange = 1
				if @NetUnitCost <> @UnitRate
					select @NetUnitCostChange = 1

				if @NetQuantityChange = 1
				or @NetUnitCostChange = 1
					begin
						-- determine if we need to create one or two adjustment lines
						if @ShowAdjustmentsAsSingleLine = 1
							begin
								-- calculate values to be inserted
								-- if Unit Cost did change, we need to generate a line with quantity of 1 or -1 for the net difference to avoid rounding issues
								if @NetUnitCostChange = 1
									begin
										-- if billed gross/net > current transaction total, client was overbilled
										begin
											if @NetBillableCost > @TotGross
												select @AdjQuantity = -1
														,@AdjTotalCost = (@NetTotalCost - @TotNet)  * -1
														,@AdjBillableCost = (@NetBillableCost - @TotGross) * -1
														,@AdjUnitCost = @NetBillableCost - @TotGross
											-- net/gross < sum of existing billed transactions, client was underbilled
											else
												select @AdjQuantity = 1
														,@AdjTotalCost = @TotNet - @NetTotalCost
														,@AdjBillableCost = @TotGross - @NetBillableCost 
														,@AdjUnitCost = @TotGross - @NetBillableCost 								
										end
										if @AdjCommission = 1.0 
											select @AdjCommission = 0
									end
								-- only quantity changed, can adjust with new quantity difference
								else
									begin
										select @AdjQuantity = @Quantity - @NetQuantity
										select @AdjBillableCost = round(round(isnull(@UnitRate, 0),2) * isnull(@AdjQuantity, 0),2)
										select @AdjUnitCost = @UnitRate			
										if @AdjCommission = 1.0 
											select @AdjTotalCost = 0, @AdjCommission = 0
										else
											select @AdjTotalCost = @AdjBillableCost - (@AdjBillableCost * (@AdjCommission / 100))															
									end
								
								-- look to see if an existing auto adjustment line exists that has not been billed and adjust it
								-- otherwise create a new adjustment line
								select @ExistingPODAdjKey = min(PurchaseOrderDetailKey)
								from tPurchaseOrderDetail (nolock)
								where PurchaseOrderKey = @PurchaseOrderKey
								and LineNumber = @LineNumber
								and InvoiceLineKey is null  -- only unbilled lines
								and AutoAdjustment = 1  -- it was originally added using this procedure, do not update manual lines
														
								if @ExistingPODAdjKey is not null  -- update the existing auto-adjustment line
									begin
										update tPurchaseOrderDetail
											set
											Quantity = @AdjQuantity,
											Markup = @AdjCommission,
											UnitCost = @AdjUnitCost,
											TotalCost = round(@AdjTotalCost,2),
											PTotalCost = round(@AdjTotalCost,2),
											BillableCost = round(@AdjBillableCost, 2)
										where PurchaseOrderDetailKey = @ExistingPODAdjKey
										
										update tPurchaseOrder
										set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
										where PurchaseOrderKey = @PurchaseOrderKey									
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
											@AdjQuantity,
											@AdjUnitCost,
											UnitDescription,
											round(@AdjTotalCost,2), 
											round(@AdjTotalCost,2), 
											null,  -- @UnitRate,
											Billable,
											@AdjCommission,
											round(@AdjBillableCost,2),
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
										@NetQuantity * -1,
										case @NetQuantity
											when 0 then round((@NetBillableCost),2)
											else round((@NetBillableCost * -1)/(@NetQuantity * -1),2)
										end,
										UnitDescription,
										round(@NetTotalCost,2) * -1,
										round(@NetTotalCost,2) * -1,
										null, --(@NetBillableCost * -1)/(@NetQuantity * -1), -- UnitRate
										Billable,
										case @NetBillableCost
											when 0 then 0
											else 100 - round((@NetTotalCost * -1)/(@NetBillableCost * -1)*100,4)
										end,
										round(@NetBillableCost,2) * -1,
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
									where PurchaseOrderKey = @PurchaseOrderKey 
								end
								
								-- create a new adjustment line
								if @Quantity <> 0
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
										round(@TotNet,2),
										round(@TotNet,2),
										null,  --@UnitRate,
										Billable,
										@Commission,
										round(@TotGross,2),
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
						set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime),
						    Closed = 0
						where PurchaseOrderKey = @PurchaseOrderKey
					end
													
				update tPurchaseOrderDetail
				set ProjectKey = @ProjectKey,
					TaskKey = @TaskKey,
					ItemKey = @ItemKey,
					ClassKey = @ClassKey,
					ShortDescription = @Caption,
					LongDescription = @Comments,
					Quantity = @Quantity,
					Markup = @Commission,
					UnitCost = @UnitRate,
					TotalCost = round(@TotNet,2),
					PTotalCost = round(@TotNet,2),
					BillableCost = round(@TotGross,2),
					DetailOrderDate = @StartDate,
					OfficeKey  = @OfficeKey,
					DepartmentKey = @DepartmentKey
				where PurchaseOrderDetailKey = @PODKey
				
                update tPurchaseOrder
				set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
				where PurchaseOrderKey = @PurchaseOrderKey 
				
			end
    end

exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey

return 1
GO
