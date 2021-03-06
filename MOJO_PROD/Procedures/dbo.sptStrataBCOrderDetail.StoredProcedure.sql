USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBCOrderDetail]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBCOrderDetail]
	(
		@PurchaseOrderKey int,
		@UserKey int,
		@LinkID varchar(50),
		@SpotLinkID varchar(50),
		@StartDate smalldatetime,
		@EndDate smalldatetime,
		@Quantity decimal(24,4),
		@Program varchar(max),
		@Comments varchar(1000),
		@OrderDays varchar(50),
		@OrderTime varchar(50),
		@OrderLength varchar(50),
		@Cost decimal(24,6),
		@StnCltWeight decimal(24,6),
		@CltWeight decimal(24,6),
		@StnWeight decimal(24,6),
		@CMP tinyint = 0	-- syncing from CMP?  WMJ = 0 / CMP = 1
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 11/16/06 CRG 8.3571  Modified to get the ClassKey from tPurchaseOrder.
|| 11/30/06 CRG 8.3571  Modified to update the ClassKey on an existing detail line.
|| 02/05/07 RTC 8.4.0.2 When creating two line adjustments, insure the second ine's total cost <> 0
|| 04/17/07 BSH 8.4.5   DateUpdated needed to be updated.
|| 10/01/07 GHL 8.5     Added update of DateClosed
|| 10/01/07 BSH 8.5     Insert OfficeKey to PO Detail, get from Estimate or Project based on ClientLink. 
|| 05/27/09 RTC 8.5.3.7 (53517) Corrected single adjustment line calculations
|| 10/07/09 MAS 10.5.1.9() Calculate Client Costing
|| 10/07/09 MAS 10.5.1.9 (67320) Removed rounding when calculating Client Costing UnitRate/UnitCost also set Commision/Markup = 0 when UnitRate = 0
|| 11/11/09 MAS 10.5.1.3 (47035)
|| 11/11/10 MAS 10.5.3.8 Reset the PO Header closed flag to 0 when a new line is added.
||                       Changed the way we determine if a revision line should be created.  We were using an AVG(UnitCost), we now use TotalCost
|| 01/20/11 MAS 10.5.4   (100689, 100759) Changed the way were are calculating revision lines.  We Look at quantity, TotalCost and BillableCost
||						 if any of them change, we generate a revision line.  The revision lines can have any combination of Qty, TotalCost and 
||                       Billiable cost, so long as the total match that of Strata.  We do not try and keep UnitCost insync with Strata!	
|| 08/16/11 MAS 10.5.4.7 (118934) Was using the @TotGross by error when calculating revision Net amounts.  Should have been using @TotNet
|| 08/23/12 MAS 10.5.5.9 (152132)Changed the precision of all the client costing params
|| 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @Program(ShortDescription) from 200 to 300
|| 05/07/13 WDF 10.5.6.8 ( 175953) For existing line updates, deleted revision(s) if no changes detected.
|| 12/17/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptPurchaseOrderDetailInsert
|| 01/27/14 GHL 10.5.7.6 Added update of PTotalCost in inserts/updates of tPurchaseOrderDetail
|| 04/29/14 RLB 10.5.7.9 (214240)Changed the length of @Program(ShortDescription) from 300 to max
|| 08/14/14 PLC 10.5.8.3 (226102)Changed the logic to not delete details on vouchers and include those dollars as well.
*/

Declare @PODKey int
Declare @ProjectKey int, @TaskKey int, @ItemKey int, @RetVal int, @NewKey int, @TotNet money, @TotGross money, @Markup decimal(24,4)
declare @LineNumber int 
declare @UserDate1 smalldatetime
declare @UserDate2 smalldatetime
declare @UserDate3 smalldatetime
declare @UserDate4 smalldatetime
declare @UserDate5 smalldatetime
declare @UserDate6 smalldatetime
declare @Date1Days int
declare @Date2Days int
declare @Date3Days int
declare @Date4Days int
declare @Date5Days int
declare @Date6Days int
declare @CompanyKey int
declare @CompanyMediaKey int 
declare @CurrAppliedCost money
declare @CurrTotalCost money 
declare @Closed tinyint
declare @FullLinkID varchar(50)
declare @LinkIDVersion tinyint
declare @LinkIDLen int
declare @AllowChangesAfterClientInvoice tinyint
declare @GeneratePrebilledRevisions tinyint
declare @ShowAdjustmentsAsSingleLine tinyint
declare @Prebilled as tinyint
declare @NetQuantity decimal(24,4)
declare @NetUnitCost money
declare @NetTotalCost money
declare @NetBillableCost money
declare @SomethingChanged tinyint
declare @AdjQuantity decimal(24,4)
declare @AdjUnitCost money, @AdjTotalCost money, @AdjBillableCost money
declare @ExistingPODAdjKey int
declare @NewAdjustmentNumber int
declare @NewAdjustmentNumber2 int
declare @CustomFieldKey int
declare @ObjectFieldSetKey int
declare	@ClassKey int, @OfficeKey int
declare @BCClientLink int
declare @MediaEstimateKey int
declare @DepartmentKey int
declare @RequireDepartment tinyint, @UseClientCosting tinyint, @POClientCosting tinyint 
declare @UnitCost money, @UnitRate money
declare	@Commission decimal(24,4)

	select @ProjectKey = ProjectKey
		  ,@TaskKey = TaskKey
		  ,@ItemKey = ItemKey
		  ,@CompanyMediaKey = CompanyMediaKey
		  ,@CompanyKey = CompanyKey
		  ,@ClassKey = ClassKey
		  ,@MediaEstimateKey = MediaEstimateKey
		  ,@POClientCosting = UseClientCosting -- do not allow the users to switch between using and not using client costings
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
	 
	-- determine if order lines (spots) can be updated after client invoice has been created
	-- determine if revision lines should be auto generated for prebilled lines
	-- determine if one or two revision lines should be created
	select @AllowChangesAfterClientInvoice = isnull(BCAllowChangesAfterClientInvoice, 0)
	      ,@GeneratePrebilledRevisions = isnull(BCGeneratePrebilledRevisions, 0)
	      ,@ShowAdjustmentsAsSingleLine = isnull(BCShowAdjustmentsAsSingleLine, 1)
	      ,@BCClientLink = isnull(BCClientLink,1)
          ,@RequireDepartment = RequireDepartment
          ,@UseClientCosting = BCUseClientCosting
      from tPreference (nolock)
     where CompanyKey = @CompanyKey
	
	-- If PO ClientCosting is NULL use the system setting
	if @POClientCosting is null
		Begin
			Select @POClientCosting = @UseClientCosting
			
			Update tPurchaseOrder 
			Set UseClientCosting = @POClientCosting
			Where PurchaseOrderKey = @PurchaseOrderKey
		End
		
	if @POClientCosting = 1
		begin
			Select @UnitRate = @Cost * @StnCltWeight * @CltWeight
			Select @UnitCost = @Cost * @StnWeight
			if @UnitRate = 0
				Select @Commission = 0
			else
				Select @Commission = (1 - ROUND(@UnitCost / @UnitRate, 4)) * 100
		end
	else
		begin
			Select @UnitRate = @Cost
			Select @UnitCost = @Cost * @StnWeight
			Select @Commission = (1 - @StnWeight) * 100
		end
	    
     if @BCClientLink = 1
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
          	 
	-- handle old and new variations of the link id, always convert old version to new version
	select @FullLinkID = LinkID
	  from tPurchaseOrderDetail (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
	   and LinkID = @LinkID
	 and DetailOrderDate = @StartDate 
	   and DetailOrderEndDate = @EndDate
	   
	-- did we find the line without the spot id as part of the link id (old version)?
	if @FullLinkID is not null
		begin
			-- found it with simple version, update with detailed link id version
			select @FullLinkID = @LinkID + '-' + @SpotLinkID	
			select @LinkIDVersion = 1
		end
	else
		begin
			-- could not find it with simple link id, try with detailed version
			select @FullLinkID = LinkID
			  from tPurchaseOrderDetail (nolock)
			 where PurchaseOrderKey = @PurchaseOrderKey 
			   and LinkID = @LinkID + '-' + @SpotLinkID
			   and DetailOrderDate = @StartDate 
			   and DetailOrderEndDate = @EndDate
				 	
			if @FullLinkID is not null
				-- found it with detailed version
				select @LinkIDVersion = 2
			else
				-- it must be a new line
				select @FullLinkID = @LinkID + '-' + @SpotLinkID
		end		
			
	if @LinkIDVersion is not null  -- not a new line
		begin
			if @LinkIDVersion = 1
				begin
					select @LineNumber = min(isnull(LineNumber,1))
					  from tPurchaseOrderDetail (nolock)
					 where PurchaseOrderKey = @PurchaseOrderKey
					   and LinkID = @LinkID
					  
					select @PODKey = min(PurchaseOrderDetailKey)
					  from tPurchaseOrderDetail (nolock) 
					 where PurchaseOrderKey = @PurchaseOrderKey 
					   and LinkID = @LinkID
					   and DetailOrderDate = @StartDate 
					   and DetailOrderEndDate = @EndDate	
				end			   
			else
				begin
					select @LineNumber = min(isnull(LineNumber,1))
					  from tPurchaseOrderDetail (nolock)
					 where PurchaseOrderKey = @PurchaseOrderKey
					   and LinkID = @LinkID + '-' + @SpotLinkID
				   	
					select @PODKey = min(PurchaseOrderDetailKey)
					  from tPurchaseOrderDetail (nolock) 
					 where PurchaseOrderKey = @PurchaseOrderKey 
					   and LinkID = @LinkID + '-' + @SpotLinkID
					   and DetailOrderDate = @StartDate 
					   and DetailOrderEndDate = @EndDate	
				end			   	

		end
	else
		begin
			-- if this spot is new and has a zero quantity, no need to add it and burn keys
			if ISNULL(@Quantity, 0) = 0
				return 1
			else
				-- must be a new spot, check if it is the first spot on the line or a new line
				select @LineNumber = isnull((select min(LineNumber)
											    from tPurchaseOrderDetail (nolock)
											   where PurchaseOrderKey = @PurchaseOrderKey 
												 and left(LinkID,len(@LinkID)) = @LinkID)
											,(select isnull(max(LineNumber),0)
												from tPurchaseOrderDetail (nolock)
											   where PurchaseOrderKey = @PurchaseOrderKey)+1) 
		end
	select @TotNet = round(round(isnull(@UnitCost, 0),2) * isnull(@Quantity, 0),2)
	      ,@TotGross = round(round(isnull(@UnitRate, 0),2) * isnull(@Quantity, 0),2)
	
	
	-- calc media dates if used
	select @Date1Days = isnull(Date1Days,0)
	  from tStringCompany sc (nolock) inner join tCompanyMedia cm (nolock) on sc.CompanyKey = cm.CompanyKey
	 where sc.CompanyKey = @CompanyKey
	   and sc.StringID = 'MediaBroadcast1'
	   and sc.StringSingular is not null
	   and cm.CompanyMediaKey = @CompanyMediaKey
	   
	select @Date2Days = isnull(Date2Days,0)
	  from tStringCompany sc (nolock) inner join tCompanyMedia cm (nolock) on sc.CompanyKey = cm.CompanyKey
	 where sc.CompanyKey = @CompanyKey
	   and sc.StringID = 'MediaBroadcast2'
	   and sc.StringSingular is not null
	   and cm.CompanyMediaKey = @CompanyMediaKey
	   
	select @Date3Days = isnull(Date3Days,0)
	  from tStringCompany sc (nolock) inner join tCompanyMedia cm (nolock) on sc.CompanyKey = cm.CompanyKey
	 where sc.CompanyKey = @CompanyKey
	   and sc.StringID = 'MediaBroadcast3'
	   and sc.StringSingular is not null
	   and cm.CompanyMediaKey = @CompanyMediaKey
	   
	select @Date4Days = isnull(Date4Days,0)
	  from tStringCompany sc (nolock) inner join tCompanyMedia cm (nolock) on sc.CompanyKey = cm.CompanyKey
	 where sc.CompanyKey = @CompanyKey
	   and sc.StringID = 'MediaBroadcast4'
	   and sc.StringSingular is not null
	   and cm.CompanyMediaKey = @CompanyMediaKey
	   
	select @Date5Days = isnull(Date5Days,0)
	  from tStringCompany sc (nolock) inner join tCompanyMedia cm (nolock) on sc.CompanyKey = cm.CompanyKey
	 where sc.CompanyKey = @CompanyKey
	   and sc.StringID = 'MediaBroadcast5'
	   and sc.StringSingular is not null
	   and cm.CompanyMediaKey = @CompanyMediaKey
	   
	select @Date6Days = isnull(Date6Days,0)
	  from tStringCompany sc (nolock) inner join tCompanyMedia cm (nolock) on sc.CompanyKey = cm.CompanyKey
	 where sc.CompanyKey = @CompanyKey
	   and sc.StringID = 'MediaBroadcast6'
	   and sc.StringSingular is not null
	   and cm.CompanyMediaKey = @CompanyMediaKey
	 
	if @Date1Days > 0
		select @UserDate1 = dateadd(d,@Date1Days*-1,@StartDate)
	   
	if @Date2Days > 0
		select @UserDate2 = dateadd(d,@Date2Days*-1,@StartDate)
	   
	if @Date3Days > 0
		select @UserDate3 = dateadd(d,@Date3Days*-1,@StartDate)
	   
	if @Date4Days > 0
		select @UserDate4 = dateadd(d,@Date4Days*-1,@StartDate)
	   
	if @Date5Days > 0
		select @UserDate5 = dateadd(d,@Date5Days*-1,@StartDate)
	   
	if @Date6Days > 0
		select @UserDate6 = dateadd(d,@Date6Days*-1,@StartDate)
	   
	if @PODKey is null
	BEGIN		
		-- If using Projects/Tasks - Check to see if the associated Task is completed
		if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
			BEGIN
				exec @RetVal = spTaskValidatePercComp 'tPurchaseOrderDetail',@PODKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
				if @RetVal < -1 
					return -4 
			END
		
		exec @RetVal = sptPurchaseOrderDetailInsert
			@PurchaseOrderKey,
			@LineNumber,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@Program,
			@Quantity,
			@UnitRate,
			NULL,
			@TotNet,
			null,
			1,
			@Commission,
			@TotGross,
			@Comments,
			0,
			@StartDate,
			@EndDate,
			@UserDate1,
			@UserDate2,
			@UserDate3,
			@UserDate4,
			@UserDate5,
			@UserDate6,
			@OrderDays,
			@OrderTime,
			@OrderLength,
			0,
			0,
			@OfficeKey,
			@DepartmentKey,
			@TotGross,	-- GrossAmount
			null,		-- PCurrencyID
			1,			-- PExchangeRate
			@TotNet,	-- PTotalCost
			@NewKey output
			
		Update tPurchaseOrderDetail Set LinkID = @FullLinkID Where PurchaseOrderDetailKey = @NewKey

	END
	ELSE
	BEGIN
		-- handle existing line updates

		-- If using Projects/Tasks - Check to see if the associated Task is completed
		if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
			BEGIN
				exec @RetVal = spTaskValidatePercComp 'tPurchaseOrderDetail',@PODKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
				if @RetVal < -1 
					return -4 
			END
					
		-- make sure this line is not on a billing worksheet
		if exists(select 1 
		            from tBillingDetail bd (nolock) inner join tBilling b (nolock) on bd.BillingKey = b.BillingKey
		           where bd.EntityKey = @PODKey 
		            and bd.Entity = 'tPurchaseOrderDetail'
		             and b.Status < 5)
			return -2 
			
		-- if this is an existing line/spot and it has been invoiced, do not allow changes if the system options do not allow
		select @Prebilled = 0
		if exists(select 1 from tPurchaseOrderDetail (nolock) Where PurchaseOrderDetailKey = @PODKey and InvoiceLineKey is not null)		
			begin
				select @Prebilled = 1
				if @GeneratePrebilledRevisions = 0 and @AllowChangesAfterClientInvoice = 0
						-- the line was prebilled and system options do not allow any kind of updating
						return -1
			end
	
		-- is this a prebilled line that may require auto-revision line(s) to be created
		if @Prebilled = 1 and @GeneratePrebilledRevisions = 1
			begin
				-- get current values from original line and any automatic or manual revision lines associated to it for a period within the flight
				if @ShowAdjustmentsAsSingleLine = 1
					select @NetQuantity = sum(Quantity)
							,@NetTotalCost = sum(TotalCost)
							,@NetBillableCost = sum (BillableCost)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
					and DetailOrderDate = @StartDate 
					and DetailOrderEndDate = @EndDate	
					and ((isnull(AutoAdjustment,0) = 0)  -- include billed and unbilled manual adjustment lines
						or (isnull(AutoAdjustment,0) = 1 and InvoiceLineKey is not null)
						or exists (select 1 from tVoucherDetail vd (nolock) -- include records on vendor invoices
						where vd.PurchaseOrderDetailKey = tPurchaseOrderDetail.PurchaseOrderDetailKey) )  -- only include billed auto-adjustment lines since we will reuse the existing unbilled auto adjustment line for the update below
				else -- two line adjustments
					-- include billed and unbilled manual adjustment lines
					-- include billed and unbilled auto-adjustment lines
					select @NetQuantity = sum(Quantity)
							,@NetTotalCost = sum(TotalCost)
							,@NetBillableCost = sum (BillableCost)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
					and DetailOrderDate = @StartDate 
					and DetailOrderEndDate = @EndDate	
				
				-- verify something has changed, requiring a revision
				select @SomethingChanged = 0
				
				if @NetQuantity <> @Quantity or @NetTotalCost <> @TotNet or @NetBillableCost <>  @TotGross
					select @SomethingChanged = 1

				if @SomethingChanged = 1
					begin
						-- determine if we need to create one or two adjustment lines
						if @ShowAdjustmentsAsSingleLine = 1
							begin
								-- calculate values to be inserted
								-- Reconcile Quantity, TotalCoast and BillableCost.  DO NOT worry about the UnitCost
								-- this could result in POD records with just quanitity changes, just TotalCost and TotalBillable changes or both
								-- if billed gross/net > current transaction total, client was overbilled
								if @NetBillableCost > @TotGross
									select @AdjQuantity = @Quantity - @NetQuantity
									       -- ,@AdjTotalCost = ((@NetTotalCost - @TotNet) * (1 - (@Commission/100)))  * -1
									        ,@AdjTotalCost = (@NetTotalCost - @TotNet) * -1
											,@AdjBillableCost = (@NetBillableCost - @TotGross) * -1
											,@AdjUnitCost = ABS((@NetBillableCost - @TotGross) / IsNull(Nullif(@AdjQuantity, 0), 1)) --this is really the unit rate used in the UI
								-- net/gross < sum of existing billed transactions, client was underbilled
								else
									select @AdjQuantity = @Quantity - @NetQuantity
										    -- ,@AdjTotalCost = (@TotNet - @NetTotalCost) * (1 - (@Commission/100))
										    ,@AdjTotalCost = (@TotNet - @NetTotalCost)
											,@AdjBillableCost = @TotGross - @NetBillableCost 
											,@AdjUnitCost = ABS((@TotGross - @NetBillableCost) / IsNull(Nullif(@AdjQuantity, 0), 1)) --this is really the unit rate used in the UI									
								-- look to see if an existing auto adjustment line exists that has not been billed and adjust it
								-- otherwise create a new adjustment line
								select @ExistingPODAdjKey = min(PurchaseOrderDetailKey)
								from tPurchaseOrderDetail (nolock)
								where PurchaseOrderKey = @PurchaseOrderKey
								and LineNumber = @LineNumber
								and DetailOrderDate = @StartDate 
								and DetailOrderEndDate = @EndDate	
								and InvoiceLineKey is null  -- only unbilled lines
								and AutoAdjustment = 1  -- it was originally added using this procedure, do not update manual lines
														
								if @ExistingPODAdjKey is not null  -- update the existing auto-adjustment line
									begin
										update tPurchaseOrderDetail
											set
											Quantity = @AdjQuantity,
											Markup = @Commission,
											UnitCost = @AdjUnitCost,
											TotalCost = @AdjTotalCost,
											PTotalCost = @AdjTotalCost,
											BillableCost = @AdjBillableCost
										where PurchaseOrderDetailKey = @ExistingPODAdjKey									
						
						                update tPurchaseOrder
										set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
										where PurchaseOrderKey = @PurchaseOrderKey
									end
								else -- create a new single adjustment line
									begin
									-- first check to see if an existing Adjustment Number can be used
									select @NewAdjustmentNumber  = min(isnull(AdjustmentNumber,0))
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and LineNumber = @LineNumber
									and AutoAdjustment = 1  -- it was originally added using this procedure, do not update manual lines
									and UnitCost = @AdjUnitCost  --cannot be mixed since UI treats multiple lines as group for this field
									and AdjustmentNumber not in (select AdjustmentNumber
																		from tPurchaseOrderDetail (nolock)
																		where PurchaseOrderKey = @PurchaseOrderKey
																		and LineNumber = @LineNumber
																		and AutoAdjustment = 1							
																		and DetailOrderDate = @StartDate 
																		and DetailOrderEndDate = @EndDate	
																		)
									if isnull(@NewAdjustmentNumber,0) = 0
										begin
											select @NewAdjustmentNumber = isnull(max(AdjustmentNumber),0)
											from tPurchaseOrderDetail (nolock)
											where PurchaseOrderKey = @PurchaseOrderKey
											and LineNumber = @LineNumber	

											select @NewAdjustmentNumber = @NewAdjustmentNumber + 1
										end									
										
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
									-- first check to see if an existing Adjustment Number can be used
									select @NewAdjustmentNumber  = min(isnull(AdjustmentNumber,0))
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and LineNumber = @LineNumber
									and AutoAdjustment = 1  -- it was originally added using this procedure, do not update manual lines
									and AdjustmentNumber not in (select AdjustmentNumber
																						from tPurchaseOrderDetail (nolock)
																						where PurchaseOrderKey = @PurchaseOrderKey
																						and LineNumber = @LineNumber
																						and AutoAdjustment = 1							
																						and DetailOrderDate = @StartDate 
																						and DetailOrderEndDate = @EndDate	
																						)
									if isnull(@NewAdjustmentNumber,0) = 0
										begin
											select @NewAdjustmentNumber = isnull(max(AdjustmentNumber),0)
											from tPurchaseOrderDetail (nolock)
											where PurchaseOrderKey = @PurchaseOrderKey
											and LineNumber = @LineNumber	

											select @NewAdjustmentNumber = @NewAdjustmentNumber + 1
										end
										
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
								if @Quantity <> 0  and @TotNet <> 0
								begin																
									-- first check to see if an existing Adjustment Number can be used
									select @NewAdjustmentNumber2 = min(isnull(AdjustmentNumber,0))
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and LineNumber = @LineNumber
									and AutoAdjustment = 1  -- it was originally added using this procedure, do not update manual lines
									and AdjustmentNumber <> @NewAdjustmentNumber  -- first adjustment line - full backout
									--and UnitCost = @AdjUnitCost  --cannot be mixed since UI treats multiple lines as group for this field
									and AdjustmentNumber not in (select AdjustmentNumber
																		from tPurchaseOrderDetail (nolock)
																		where PurchaseOrderKey = @PurchaseOrderKey
																		and LineNumber = @LineNumber
																		and AutoAdjustment = 1							
																		and DetailOrderDate = @StartDate 
																		and DetailOrderEndDate = @EndDate
																		and AdjustmentNumber <> @NewAdjustmentNumber  -- first adjustment line - full backout
																		)
									if isnull(@NewAdjustmentNumber2,0) = 0
										begin
											select @NewAdjustmentNumber2 = isnull(max(AdjustmentNumber),0)
											from tPurchaseOrderDetail (nolock)
											where PurchaseOrderKey = @PurchaseOrderKey
											and LineNumber = @LineNumber	

											select @NewAdjustmentNumber2 = @NewAdjustmentNumber2 + 1
										end

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
										@NewAdjustmentNumber											
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
				   begin
						-- nothing has changed since prebilling...remove any revision and return
						delete from tPurchaseOrderDetail
						 where PurchaseOrderKey = @PurchaseOrderKey
						   and LineNumber = @LineNumber
						   and DetailOrderDate = @StartDate 
						   and DetailOrderEndDate = @EndDate	
						   and isnull(AutoAdjustment,0) = 1 
						   and InvoiceLineKey is null
						   and not exists (select 1 from tVoucherDetail vd (nolock) -- include records on vendor invoices
						where vd.PurchaseOrderDetailKey = tPurchaseOrderDetail.PurchaseOrderDetailKey)  


						return 1
					end
			end
			
		-- this is an existing unbilled line or an existing prebilled line and system options allow updates to it
		else	
			begin			
				-- get current values
				select @CurrAppliedCost = AppliedCost
					  ,@CurrTotalCost = TotalCost
					  ,@Closed = Closed
				from tPurchaseOrderDetail (nolock)
				where PurchaseOrderDetailKey = @PODKey
		 			
				if @Closed = 1 
				and @TotNet <> @CurrTotalCost 
				and @TotNet <> @CurrAppliedCost
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
					ShortDescription = @Program,
					LongDescription = @Comments,
					Quantity = @Quantity,
					Markup = @Commission,
					UnitCost = @UnitRate,
					TotalCost = @TotNet,
					PTotalCost = @TotNet,
					BillableCost = @TotGross,
					OrderDays = @OrderDays,
					OrderTime = @OrderTime,
					OrderLength = @OrderLength,
					DetailOrderDate = @StartDate,
					DetailOrderEndDate = @EndDate,
					UserDate1 = @UserDate1,
					UserDate2 = @UserDate2,
					UserDate3 = @UserDate3,
					UserDate4 = @UserDate4,
					UserDate5 = @UserDate5,
					UserDate6 = @UserDate6,
					LinkID = @FullLinkID,
					ClassKey = @ClassKey,
					OfficeKey = @OfficeKey,
					DepartmentKey = @DepartmentKey
				Where
					PurchaseOrderDetailKey = @PODKey
					
                update tPurchaseOrder
				set DateUpdated = CAST( CAST(MONTH(GETDATE()) as varchar) + '/' + CAST(DAY(GETDATE()) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as smalldatetime) 
				where PurchaseOrderKey = @PurchaseOrderKey 
			end
	END
GO
