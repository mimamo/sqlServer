USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBottomLineInvoice]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBottomLineInvoice]

	 @CompanyKey int
	,@UserKey int
	,@IgnoreDates int
	,@LinkID varchar(50)
	,@VendorID varchar(50)
	,@InvoiceNumber varchar(50)
	,@InvoiceDate smalldatetime
	,@MatchedDate smalldatetime  = NULL
	,@DueDate smalldatetime
	,@EstimateID varchar(50)
	,@POLinkID varchar(50)
	,@InvoiceMonth varchar(2)
	,@InvoiceYear varchar(4)
	,@TotalInvoiceGross decimal(24,6)
	,@TotalInvoiceNet decimal(24,6)
	,@CMP tinyint = 0	-- syncing from CMP?  WMJ = 0 / CMP = 1

as --Encrypt

/*
|| When     Who Rel      What
|| 06/10/08 RTC	8.5.1.3  New For Bottom Line Invoicing
|| 06/18/08 GHL 8.513    Added OpeningTransaction
|| 09/16/08 RTC 10.0.0.9 Insure vendor is active.
|| 07/17/09 MAS 10.5.0   (57112) Always checks for @ExpenseAccountKey 
|| 07/20/09 MAS 10.5.5   (58132) Apply the difference in the TotalInvoiceNet vs the TotalOrderAmount, 
						 Removed the insure "the total voucher net is not more than the associated orders net amount" check and error code
|| 11/11/09 MAS 10.5.1.3 (47035)
|| 03/25/10 MAS 10.5.1.3 (76058) Added the option to use the ClearDate from Strata as the PostingDate	
|| 07/26/10 MAS 10.5.3.2 (85965) Account for Broadcast Months (The broadcast calendar is a M-Su weekly calendar, and the month
||                        of the week is determined by the month that the Sunday falls into.  Spot (broadcast) buying is done on
||                        a broadcast month.  Bottom-line invoicing is only available in our spot module so the month will always be broadcast month. )
|| 10/15/10 MAS 10.5.3.6 (92260) Added sptVoucherRecalcAmounts
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert
|| 01/17/12 GHL 10.5.5.2 VoucherType = 0 now since the Voucher UI can handle all po kinds 	
|| 03/28/12 GHL 10.5.5.4 Passing @TargetGLCompanyKey = null to sptVoucherDetailUpdate	
|| 08/13/12 MAS 10.5.5.9 Use the Vendor's DefaultAPAccountKey if it's set.  Otherwise default to the Company DefaultAPAccountKey	
|| 08/23/12 MAS 10.5.5.9 (152132)Changed the percision of all the client costing params 
|| 08/16/12 MAS 10.5.7.0 (187109)Added @ClassKey to sptVoucherInsert, sptVoucherDetailInsert and sptVoucherDetailUpdate 
|| 11/20/13 GHL 10.5.7.3 Added GrossAmount and Commission when calling sptInvoiceDetailInsert/Update
|| 11/22/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptInvoiceDetailInsert
|| 12/06/13 MAS 10.5.7.1 (187514, 189765)Account for orders that are greater than the BLI being applied and create a negative vouche detail line for the difference
|| 03/05/14 PLC 10.5.7.7 Added logic clear month for a bottom line invoice.
|| 06/14/14 PLC 10.5.8.1 Move logic clear month for a bottom line invoice to pref.
|| 06/14/14 PLC 10.5.8.1 Added invoice month to post date logic.
|| 08/01/14 PLC 10.5.8.2 Fixed logic to close bottomline invoice so all purdetails get closed.
|| 08/29/14 PLC 10.5.8.3 Added logic to ignore dates on bottomline invoice so all purdetails get closed.
|| 11/25/14 PLC 10.5.8.6 Fixed logic to import an invoice into a closed month
|| 01/20/15 RLB 10.5.8.7 Adding missing parm
*/

declare @VoucherKey int
declare @PurchaseOrderKey int
declare @VendorKey int
declare @GLCompanyKey int
declare @POStatus smallint
declare @TermsPercent decimal(24,4)
declare @TermsDays int
declare @TermsNet int
declare @RetVal int
declare @APAccountKey int
declare @OfficeKey int
declare @BCClientLink smallint
declare @ProjectKey int
declare	@AutoApproveExternalInvoices tinyint
declare @Status smallint
declare @Error int
declare @PurchaseOrderDetailKey int
declare @LineNumber int
declare @AdjustmentNumber int
declare @DetailOrderDate smalldatetime
declare @AmtApplyGross decimal(24,4)
declare @AmtApplyNet decimal(24,4)
declare @TaskKey int
declare @ItemKey int
declare @DepartmentKey int
declare @BillAt smallint
declare @VoucherDetailKey int
declare @DeleteExistingVoucher tinyint
declare @LineTotalCost decimal(24,4)
declare @LineTotalGross decimal(24,4)
declare @RequireItems tinyint
declare @RequireTasks tinyint
declare @ExpenseAccountKey int
declare @RequireAccounts tinyint
declare @Commission decimal(24,4)
declare @DateRangeBegin smalldatetime
declare @DateRangeEnd smalldatetime
declare @TranStarted tinyint
declare @OrderLineTotalCost decimal(24,4)
declare @ClassKey int
declare @Active tinyint
declare @LastPurchaseOrderDetailKey int
declare @ClientKey int
declare @PostingDate smalldatetime
declare @UseClearedDate int
declare @CloseMonthBLInvoice tinyint

			Declare @PODLinkID varchar(50)
			Declare @SpotLinkID varchar(50)
			Declare @StartDate smalldatetime
			Declare @EndDate smalldatetime
			Declare @UserDate1 smalldatetime
			Declare @UserDate2 smalldatetime
			Declare @UserDate3 smalldatetime
			Declare @UserDate4 smalldatetime
			Declare @UserDate5 smalldatetime
			Declare @UserDate6 smalldatetime
			Declare @Quantity decimal(24,4)
			Declare @Markup decimal(24,4)
			Declare @UnitRate decimal(24,4)
			Declare @PODGross decimal(24,4)
			Declare @PODMarkup decimal(24,4)
			Declare @Program varchar(300)
			Declare @Comments varchar(1000)
			Declare @OrderDays varchar(50)
			Declare @OrderTime varchar(50)
			Declare @OrderLength varchar(50)
			Declare @RevisionPurchaseOrderDetailKey int
			Select @RevisionPurchaseOrderDetailKey = NULL
		


--init transaction flag
select @TranStarted = 0

--set date range
select @DateRangeBegin = cast(@InvoiceYear as varchar(4)) + '-' + @InvoiceMonth + '-01 00:00:00'
if @InvoiceMonth = '12'
	select @DateRangeEnd = cast(cast(cast(@InvoiceYear as int) + 1 as varchar(4)) + '-' + '01-01 00:00:00' as smalldatetime)
else
	select @DateRangeEnd = cast(cast(@InvoiceYear as varchar(4)) + '-' + cast(cast(@InvoiceMonth as int) + 1 as varchar(2)) + '-01 00:00:00' as smalldatetime)

-- Adjust dates for broadcast month
Select @DateRangeBegin = DateAdd(day, -6, DateAdd(day, (8-DatePart(weekday, 
    DateAdd(Month, DateDiff(Month, 0, @DateRangeBegin), 0)))%7, 
    DateAdd(Month, DateDiff(Month, 0, @DateRangeBegin), 0)))

Select @DateRangeEnd = DateAdd(day, -7,	DateAdd(day, (8-DatePart(weekday, 
    DateAdd(Month, DateDiff(Month, 0, @DateRangeEnd), 0)))%7, 
    DateAdd(Month, DateDiff(Month, 0, @DateRangeEnd), 0)))    

--find associated purchase order
select	 @PurchaseOrderKey = PurchaseOrderKey
		,@POStatus = Status
		,@BillAt = BillAt
from tPurchaseOrder (nolock)
where CompanyKey = @CompanyKey
and LinkID = @POLinkID
and POKind = 2

select @VendorKey = CompanyKey 
	  ,@Active = isnull(Active, 0)
	  ,@APAccountKey = DefaultAPAccountKey 	
from tCompany (nolock) 
where OwnerCompanyKey = @CompanyKey 
and Vendor = 1 
and VendorID = @VendorID
	
if @VendorKey is null
	return -3

if @Active <> 1
	return -20
			
select	 @ClassKey = ClassKey
		,@ProjectKey = ProjectKey
		,@GLCompanyKey = GLCompanyKey
		,@OfficeKey = OfficeKey
from	tMediaEstimate (nolock)
where	EstimateID = @EstimateID
and		CompanyKey = @CompanyKey
		
--validate associated purchase order conditions
if @PurchaseOrderKey is null
	return -1
	
if @POStatus < 4 
	return -2
			
if @InvoiceDate is null
	return -7
			
if @InvoiceNumber is null
	return -8

-- Use the company defualt APAccountKey if the vendor didn't have one setup
If 	@APAccountKey IS NULL								
	--get defaults needed
	select   @BCClientLink = isnull(BCClientLink,1)
			,@RequireItems = RequireItems
			,@RequireTasks = RequireTasks
			,@RequireAccounts = RequireGLAccounts      
			,@APAccountKey = DefaultAPAccountKey
			,@AutoApproveExternalInvoices = AutoApproveExternalInvoices	
			,@UseClearedDate = ISNULL(UseClearedDate, 0) 
			,@CloseMonthBLInvoice = ISNULL(CloseMonthBLInvoice, 0) 
	from tPreference (nolock)
	where CompanyKey = @CompanyKey
Else
	--get defaults needed
	select   @BCClientLink = isnull(BCClientLink,1)
			,@RequireItems = RequireItems
			,@RequireTasks = RequireTasks
			,@RequireAccounts = RequireGLAccounts      
			,@AutoApproveExternalInvoices = AutoApproveExternalInvoices	
			,@UseClearedDate = ISNULL(UseClearedDate, 0) 
			,@CloseMonthBLInvoice = ISNULL(CloseMonthBLInvoice, 0)
	from tPreference (nolock)
	where CompanyKey = @CompanyKey

If @UseClearedDate = 1 
	Select @PostingDate = @MatchedDate
else If @UseClearedDate = 0
	Select @PostingDate = @InvoiceDate
else
	begin -- new option number 2 invoice month the below code has been tested above with week begin
		DECLARE @dtDate DATETIME
		SET @dtDate = cast(@InvoiceYear as varchar(4)) + '-' + @InvoiceMonth + '-01 00:00:00'
		SELECT @PostingDate = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@dtDate)+1,0))
	end  
	
if @AutoApproveExternalInvoices = 1
	select @Status = 4
else
	select @Status = 2	
				
select   @TermsPercent = isnull(TermsPercent, 0)
		,@TermsDays = isnull(TermsDays, 0)
		,@TermsNet = isnull(TermsNet, 0) 
from tCompany (nolock)
where CompanyKey = @VendorKey
		
select @DueDate = dateadd(day, @TermsNet, @InvoiceDate)
				 			
--check if voucher exists	
select @VoucherKey = min(VoucherKey) 
from tVoucher (nolock)
where CompanyKey = @CompanyKey 
and LinkID = @LinkID
and InvoiceNumber = @InvoiceNumber

--if bottom line voucher already exists, check both voucher and lines to make sure thay can be updated
if isnull(@VoucherKey, 0) > 0
	begin
		--existing voucher, make sure it's not already been posted
		if (select Posted
			from tVoucher (nolock)
			where VoucherKey = @VoucherKey) = 1
				return -4 
		
		--existing voucher, make sure voucher detail lines have not been invoiced to client or written off
		if exists(select 1 
					from tVoucherDetail vd (nolock)
					where vd.VoucherKey = @VoucherKey
					and (WriteOff = 1 or isnull(InvoiceLineKey,-1) >= 0))
			return -5

		--existing voucher, make sure voucher detail lines are not on billing worksheets
		if exists(select 1 
					from tBillingDetail bd (nolock) inner join tVoucherDetail vd (nolock) on bd.EntityKey = vd.VoucherDetailKey
					where vd.VoucherKey = @VoucherKey
					and bd.Entity = 'tVoucherDetail')
			return -6
		
		--loop through existing voucher lines subtracting total net amount from bottom line invoice total amount
		select @VoucherDetailKey = -1
		while 1=1
			begin
				select @VoucherDetailKey = min(VoucherDetailKey)
				from tVoucherDetail (nolock)
				where VoucherKey = @VoucherKey
				and VoucherDetailKey > @VoucherDetailKey
				
				if @VoucherDetailKey is null
					break
					
				select @LineTotalCost = vd.TotalCost
						,@OrderLineTotalCost = pod.TotalCost
				from tVoucherDetail vd (nolock) inner join tPurchaseOrderDetail pod (nolock) on vd.PurchaseOrderDetailKey = pod.PurchaseOrderDetailKey
				where VoucherDetailKey = @VoucherDetailKey

				--if this is a partial invoice line, delete it, may end up re-adding it later
				if @LineTotalCost < @OrderLineTotalCost
					begin
						if @TranStarted = 0
							begin
								select @TranStarted = 1
								begin tran
							end	
														
						exec @RetVal = sptVoucherDetailDelete @VoucherDetailKey, 0
						if @RetVal <> 1 
							begin
								rollback tran
								return -11
							end				
					end
				else
					if @LineTotalCost < @TotalInvoiceNet
						select @TotalInvoiceNet = @TotalInvoiceNet - @LineTotalCost
					else
						begin
							if @LineTotalCost = @TotalInvoiceNet
								begin
									select @TotalInvoiceNet = 0
									break
								end
							else
								--the invoice line total cost is greater than the invoice total net, need to delete this and all remaining lines
								begin
									select @VoucherDetailKey = @VoucherDetailKey  -1
									break
								end
						end
			end
					
		--delete lines if needed
		if @VoucherDetailKey is not null
			begin
				if @TranStarted = 0
					begin
						select @TranStarted = 1
						begin tran
					end	
					
				while 1=1
					begin
						select @VoucherDetailKey = min(VoucherDetailKey)
						from tVoucherDetail (nolock)
						where VoucherKey = @VoucherKey
						and VoucherDetailKey > @VoucherDetailKey
						
						if @VoucherDetailKey is null
							break	
							
						exec @RetVal = sptVoucherDetailDelete @VoucherDetailKey, 0
						if @RetVal <> 1 
							begin
								rollback tran
								return -11
							end				
					end 
			end
	end --end of existing voucher processing
else
	begin
		if @TranStarted = 0
			begin
				select @TranStarted = 1
				begin tran
			end	
		
		--need to add new voucher header
		exec @RetVal = sptVoucherInsert
			@CompanyKey,
			@VendorKey,
			@InvoiceDate,
			@PostingDate,
			@InvoiceNumber,
			@InvoiceDate,
			@UserKey,
			@TermsPercent,
			@TermsDays,
			@TermsNet,
			@DueDate,
			null,
			null,
			@UserKey,
			@APAccountKey,
			@ClassKey,
			null,
			null,
			@GLCompanyKey,
			@OfficeKey,
			0, --OpeningTransaction
			0,
			null, -- CurrencyID
			1,    -- ExchangeRate
			null, -- PCurrencyID
			1,    -- PExchangeRate
			null, -- CompanyMediaKey		
			@VoucherKey output
			
		if @RetVal = -1
			begin
				rollback tran
				return -9  --Invoice number already exists
			end
			
		if @RetVal = -2
			begin
				rollback tran
				return -10  --Project status is not accepting costs
			end		

		update tVoucher 
		set LinkID = @LinkID
		,Status = @Status 
		,BottomLineInvoice = 1
		,InvoiceMonth = @InvoiceMonth
		,InvoiceYear = @InvoiceYear
		where VoucherKey = @VoucherKey
	end

if @TranStarted = 0
	begin
		select @TranStarted = 1
		begin tran
	end	
	
-- now we have a voucher header, create new voucher details by looping through order details
select @LineNumber = -1
while 1=1
	begin
        if @IgnoreDates = 1
			select @LineNumber = min(LineNumber) 
			from tPurchaseOrderDetail (nolock)
			where PurchaseOrderKey = @PurchaseOrderKey
			and LineNumber > @LineNumber
			and Closed = 0
			and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
		else
			select @LineNumber = min(LineNumber) 
			from tPurchaseOrderDetail (nolock)
			where PurchaseOrderKey = @PurchaseOrderKey
			and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
			and LineNumber > @LineNumber
			and Closed = 0
			and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0			
		
		if @LineNumber is null
			break 

		select @AdjustmentNumber = -1
		while 1=1
			begin
				if @TotalInvoiceNet = 0
				break

				if @IgnoreDates = 1
					select @AdjustmentNumber = min(AdjustmentNumber)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and LineNumber = @LineNumber
					and AdjustmentNumber > @AdjustmentNumber
					and Closed = 0
					and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
				else
					select @AdjustmentNumber = min(AdjustmentNumber)
					from tPurchaseOrderDetail (nolock)
					where PurchaseOrderKey = @PurchaseOrderKey
					and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
					and LineNumber = @LineNumber
					and AdjustmentNumber > @AdjustmentNumber
					and Closed = 0
					and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
				


				if @AdjustmentNumber is null
					break

				select @DetailOrderDate = '1990-01-01'
				while 1=1
					begin 
						if @TotalInvoiceNet = 0
						break

						if @IgnoreDates = 1
							select @DetailOrderDate = min(DetailOrderDate)
							from tPurchaseOrderDetail (nolock)
							where PurchaseOrderKey = @PurchaseOrderKey
							and LineNumber = @LineNumber
							and AdjustmentNumber = @AdjustmentNumber
							and DetailOrderDate > @DetailOrderDate
							and Closed = 0
							and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
						else
							select @DetailOrderDate = min(DetailOrderDate)
							from tPurchaseOrderDetail (nolock)
							where PurchaseOrderKey = @PurchaseOrderKey
							and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
							and LineNumber = @LineNumber
							and AdjustmentNumber = @AdjustmentNumber
							and DetailOrderDate > @DetailOrderDate
							and Closed = 0
							and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
						
						
						if @DetailOrderDate is null
							break
						
						select @PurchaseOrderDetailKey = -1
						while 1=1
							begin 
								if @TotalInvoiceNet = 0
								break

								if @IgnoreDates = 1
									select @PurchaseOrderDetailKey = min(PurchaseOrderDetailKey) 
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and PurchaseOrderDetailKey > @PurchaseOrderDetailKey
									and LineNumber = @LineNumber
									and AdjustmentNumber = @AdjustmentNumber
									and DetailOrderDate = @DetailOrderDate
									and Closed = 0
									and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
								else
									select @PurchaseOrderDetailKey = min(PurchaseOrderDetailKey) 
									from tPurchaseOrderDetail (nolock)
									where PurchaseOrderKey = @PurchaseOrderKey
									and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
									and PurchaseOrderDetailKey > @PurchaseOrderDetailKey
									and LineNumber = @LineNumber
									and AdjustmentNumber = @AdjustmentNumber
									and DetailOrderDate = @DetailOrderDate
									and Closed = 0
									and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0
								

								if @PurchaseOrderDetailKey is null
									break
										
								Select @LastPurchaseOrderDetailKey = @PurchaseOrderDetailKey

								select @AmtApplyNet = isnull(TotalCost, 0) - isnull(AppliedCost, 0)
								,@AmtApplyGross = 
									case @BillAt
										when 0 then isnull(BillableCost, 0) - isnull(AmountBilled, 0)
										when 1 then isnull(TotalCost, 0) - isnull(AmountBilled, 0)
										when 2 then isnull(BillableCost, 0) - isnull(TotalCost, 0) - isnull(AmountBilled, 0)
									end 
								,@LineTotalGross = isnull(BillableCost, 0)
								,@LineTotalCost = isnull(TotalCost, 0)	
								,@ProjectKey = ProjectKey
								,@TaskKey = TaskKey
								,@ItemKey = ItemKey
								,@OfficeKey = OfficeKey
								,@DepartmentKey = DepartmentKey
								from tPurchaseOrderDetail (nolock)
								where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
							
								--what can we apply? if line > than invoice left to allocate, need to adjust
								if @AmtApplyNet > @TotalInvoiceNet
									select @AmtApplyNet = @TotalInvoiceNet  --apply remaining balance of invoice
									
								-- check for zero cost spots
								if @LineTotalCost = 0
									select @Commission = 0
								else
									select @Commission = ((@LineTotalGross/@LineTotalCost) - 1) * 100
								
								if @BCClientLink = 1 --	link to client through project (required)
									begin
										if isnull(@ProjectKey, 0) = 0
											begin
												rollback tran
												return -13
											end
									
										if isnull(@TaskKey, 0) = 0
											if @RequireTasks = 1
												begin
													rollback tran
													return -14
												end
									end			
								   
								if @RequireItems = 1
									if @ItemKey is null
										begin
											rollback tran
											return -15
										end										

								if ISNULL(@ItemKey, 0) > 0
									Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

								if ISNULL(@ExpenseAccountKey, 0) = 0
									Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
									
								if ISNULL(@ExpenseAccountKey, 0) = 0
									Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
											
								if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
										begin
											rollback tran
											return -16
										end
								
								-- If using Projects/Tasks - Check to see if the associated Task is completed
								if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
									BEGIN
										exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',NULL, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
										if @RetVal < -1 
											BEGIN
												rollback tran
												return -21
											END
									END
																		
								exec @RetVal = sptVoucherDetailInsert
									@VoucherKey,
									@PurchaseOrderDetailKey,
									null,
									@ProjectKey,
									@TaskKey,
									@ItemKey,
									@ClassKey,
									'', --Comments
									1,  -- always set quantity to 1 since the line is at spot level or bottom line, either way it s/b 1  
									null,
									null,
									@AmtApplyNet,
									null,
									1,
									null, -- Markup, because null, will be recalculated in sp
									@AmtApplyGross,
									@ExpenseAccountKey,
									0,
									0,
									1, -- LastVoucher
									@OfficeKey,
									@DepartmentKey,
									1, -- @CheckProject
									@Commission,
									null, -- GrossAmount, because null, will be recalculated in sp
									null,        -- PCurrencyID
									1,           -- PExchangeRate
									@AmtApplyNet,  -- PTotalCost
									@VoucherDetailKey output
									
								if @RetVal = -2
									begin
										rollback tran
										return -17 --Project Status does not allow additional costs
									end
									
								if @RetVal = -1
									begin
										rollback tran
										return -18 --Problem inserting line
									end
									
								--now subtract just applied amount from total invoice amount left to apply
								select @TotalInvoiceNet = @TotalInvoiceNet - @AmtApplyNet
								if @TotalInvoiceNet = 0
									break
							end	
					end	
			end
	end
	
-- Apply the remaining amount
if @TotalInvoiceNet > 0 
	begin
		-- Which PurchaseOrderDetailKey should we use
		if @LastPurchaseOrderDetailKey is null
			Begin
				Select @PurchaseOrderDetailKey = max(PurchaseOrderDetailKey)
				From tPurchaseOrderDetail (nolock)
				where PurchaseOrderKey = @PurchaseOrderKey
				
				Select @AmtApplyNet = @TotalInvoiceNet
				,@AmtApplyGross = 0
				,@LineTotalGross = 0
				,@LineTotalCost = @TotalInvoiceNet
				,@LinkID = SUBSTRING(LinkID, 0, CHARINDEX('-', LinkID)) 
				,@SpotLinkID = SUBSTRING(LinkID, CHARINDEX('-', LinkID)+1, LEN(LinkID))
				,@StartDate = DetailOrderDate
				,@EndDate = DetailOrderEndDate
				,@Quantity = 1
				,@UnitRate = UnitRate
				,@PODMarkup =ISNULL(Markup,0)
				,@Program = ShortDescription
				,@Comments = LongDescription
				,@OrderDays = OrderDays
				,@OrderTime = OrderTime
				,@UserDate1 = UserDate1
				,@UserDate2 = UserDate2
				,@UserDate3 = UserDate3
				,@UserDate4 = UserDate4
				,@UserDate5 = UserDate5
				,@UserDate6 = UserDate6
				,@OrderLength = OrderLength
				,@ProjectKey = ProjectKey
				,@TaskKey = TaskKey
				,@ItemKey = ItemKey
				,@OfficeKey = OfficeKey
				,@DepartmentKey = DepartmentKey
			from tPurchaseOrderDetail (nolock)
			where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

			if @RequireItems = 1
				if @ItemKey is null
					begin
						rollback tran
						return -15
					end										

			if ISNULL(@ItemKey, 0) > 0
				Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

			if ISNULL(@ExpenseAccountKey, 0) = 0
				Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
				
			if ISNULL(@ExpenseAccountKey, 0) = 0
				Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
						
			if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
				begin
					rollback tran
					return -16
				end				
			
			-- *** Create the Revision line here ***
			
		exec @RetVal = sptPurchaseOrderDetailInsert
			@PurchaseOrderKey,
			@LineNumber,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@Program,
			1,
			@TotalInvoiceNet,
			NULL,
			@TotalInvoiceNet,
			@TotalInvoiceNet,
			1,
			@PODMarkup,
			@TotalInvoiceGross,
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
			@TotalInvoiceGross,	-- GrossAmount
			null,		-- PCurrencyID
			1,			-- PExchangeRate
			@TotalInvoiceNet,	-- PTotalCost
			@RevisionPurchaseOrderDetailKey output
								
			if ISNULL(@RevisionPurchaseOrderDetailKey, 0) > 0
				Begin
					update tPurchaseOrderDetail
					set AutoAdjustment = 2
					where PurchaseOrderDetailKey = @RevisionPurchaseOrderDetailKey
				End
				
				if @RetVal < 0
				begin
					rollback tran
					return -19 --Problem applying Total Invoice Net difference
				end
			
			   Select @PurchaseOrderDetailKey = @RevisionPurchaseOrderDetailKey
			   select @LastPurchaseOrderDetailKey = @PurchaseOrderDetailKey
			
				Select @LastPurchaseOrderDetailKey = @PurchaseOrderDetailKey

								select @AmtApplyNet = isnull(TotalCost, 0) - isnull(AppliedCost, 0)
								,@AmtApplyGross = 
									case @BillAt
										when 0 then isnull(BillableCost, 0) - isnull(AmountBilled, 0)
										when 1 then isnull(TotalCost, 0) - isnull(AmountBilled, 0)
										when 2 then isnull(BillableCost, 0) - isnull(TotalCost, 0) - isnull(AmountBilled, 0)
									end 
								,@LineTotalGross = isnull(BillableCost, 0)
								,@LineTotalCost = isnull(TotalCost, 0)	
								,@ProjectKey = ProjectKey
								,@TaskKey = TaskKey
								,@ItemKey = ItemKey
								,@OfficeKey = OfficeKey
								,@DepartmentKey = DepartmentKey
								from tPurchaseOrderDetail (nolock)
								where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
							
								--what can we apply? if line > than invoice left to allocate, need to adjust
								if @AmtApplyNet > @TotalInvoiceNet
									select @AmtApplyNet = @TotalInvoiceNet  --apply remaining balance of invoice
									
								-- check for zero cost spots
								if @LineTotalCost = 0
									select @Commission = 0
								else
									select @Commission = ((@LineTotalGross/@LineTotalCost) - 1) * 100
								
								if @BCClientLink = 1 --	link to client through project (required)
									begin
										if isnull(@ProjectKey, 0) = 0
											begin
												rollback tran
												return -13
											end
									
										if isnull(@TaskKey, 0) = 0
											if @RequireTasks = 1
												begin
													rollback tran
													return -14
												end
									end			
								   
								if @RequireItems = 1
									if @ItemKey is null
										begin
											rollback tran
											return -15
										end										

								if ISNULL(@ItemKey, 0) > 0
									Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

								if ISNULL(@ExpenseAccountKey, 0) = 0
									Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
									
								if ISNULL(@ExpenseAccountKey, 0) = 0
									Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
											
								if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
										begin
											rollback tran
											return -16
										end
								
								-- If using Projects/Tasks - Check to see if the associated Task is completed
								if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
									BEGIN
										exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',NULL, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
										if @RetVal < -1 
											BEGIN
												rollback tran
												return -21
											END
									END
																		
								exec @RetVal = sptVoucherDetailInsert
									@VoucherKey,
									@PurchaseOrderDetailKey,
									null,
									@ProjectKey,
									@TaskKey,
									@ItemKey,
									@ClassKey,
									'', --Comments
									1,  -- always set quantity to 1 since the line is at spot level or bottom line, either way it s/b 1  
									null,
									null,
									@AmtApplyNet,
									null,
									1,
									null, -- Markup, because null, will be recalculated in sp
									@AmtApplyGross,
									@ExpenseAccountKey,
									0,
									0,
									1, -- LastVoucher
									@OfficeKey,
									@DepartmentKey,
									1, -- @CheckProject
									@Commission,
									null, -- GrossAmount, because null, will be recalculated in sp
									null,        -- PCurrencyID
									1,           -- PExchangeRate
									@AmtApplyNet,  -- PTotalCost
									@VoucherDetailKey output
									
								if @RetVal = -2
									begin
										rollback tran
										return -17 --Project Status does not allow additional costs
									end
									
								if @RetVal = -1
									begin
										rollback tran
										return -18 --Problem inserting line
									end
								
			
			end
		else
		begin
			Select @PurchaseOrderDetailKey = @LastPurchaseOrderDetailKey
		
		-- Which VoucherDetail record should we update
		Select @VoucherDetailKey = VoucherDetailKey
			 , @ClientKey = ClientKey
			 , @ExpenseAccountKey = ExpenseAccountKey
			 , @AmtApplyGross = BillableCost
		From tVoucherDetail (nolock)
		Where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
		
		select @AmtApplyNet = isnull(AppliedCost, 0) + @TotalInvoiceNet
			,@ProjectKey = ProjectKey
			,@TaskKey = TaskKey
			,@ItemKey = ItemKey
			,@OfficeKey = OfficeKey
			,@DepartmentKey = DepartmentKey
			,@LineTotalGross = isnull(AppliedCost, 0) 
			,@LineTotalCost = isnull(TotalCost, 0)	
			from tPurchaseOrderDetail (nolock)
			where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
			
		if @RequireItems = 1
			if @ItemKey is null
				begin
					rollback tran
					return -15
				end										

		if ISNULL(@ItemKey, 0) > 0
			Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

		if ISNULL(@ExpenseAccountKey, 0) = 0
			Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
			
		if ISNULL(@ExpenseAccountKey, 0) = 0
			Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
					
		if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
			begin
				rollback tran
				return -16
			end	
			
		-- check for zero cost spots
		if @LineTotalCost  = 0
			select @Commission = 0
		else
			select @Commission = ((@LineTotalGross  /@LineTotalCost) - 1) * 100
									
		exec @RetVal = sptVoucherDetailUpdate
			@VoucherDetailKey,
			@VoucherKey,
			@PurchaseOrderDetailKey,
			@ClientKey,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			'', --Comments
			1,  -- always set quantity to 1 since the line is at spot level or bottom line, either way it s/b 1  
			null,
			null,
			@AmtApplyNet,
			null,
			1,
			null, -- Markup, because null, will be recalculated in sp
			@AmtApplyGross,
			@ExpenseAccountKey,
			0,
			0,
			1, -- LastVoucher
			@OfficeKey,
			@DepartmentKey,
			NULL, -- TargetGLCompanyKey
			1, -- Project Rollup
			@Commission,
			null, -- GrossAmount, because null, will be recalculated in sp
			null,        -- PCurrencyID
			1,           -- PExchangeRate
			@AmtApplyNet  -- PTotalCost

		if @RetVal < 0
			begin
				rollback tran
				return -19 --Problem applying Total Invoice Net difference
			end
		end
	end -- end Apply the remaining amount			

	if @CloseMonthBLInvoice = 1
	begin -- begin close month
	 -- If the invoice is for less than the order we'll need to create order revision lines for
	 -- the date range of the Invoice.
		Declare @Remaining_bal decimal(24,4)
		
		if @IgnoreDates = 1
			select @Remaining_bal = sum(isnull(TotalCost,0) - isnull(AppliedCost,0))
			from tPurchaseOrderDetail
			where PurchaseOrderKey = @PurchaseOrderKey
		else
			select @Remaining_bal = sum(isnull(TotalCost,0) - isnull(AppliedCost,0))
			from tPurchaseOrderDetail
			where PurchaseOrderKey = @PurchaseOrderKey
			and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
				
		
		select @Remaining_bal = isnull(@Remaining_bal,0)
		
		if @Remaining_bal <> 0  
			Begin
			-- Which PurchaseOrderDetailKey should we use
			if @LastPurchaseOrderDetailKey is null
				begin
					if @IgnoreDates = 1
						Select @PurchaseOrderDetailKey = max(PurchaseOrderDetailKey)
						From tPurchaseOrderDetail (nolock)
						where PurchaseOrderKey = @PurchaseOrderKey
					else
						Select @PurchaseOrderDetailKey = max(PurchaseOrderDetailKey)
						From tPurchaseOrderDetail (nolock)
						where PurchaseOrderKey = @PurchaseOrderKey
						and DetailOrderDate between @DateRangeBegin and @DateRangeEnd -- Original date range for the invoice (month)
					
				end
			else
				Select @PurchaseOrderDetailKey = @LastPurchaseOrderDetailKey
			end 
				
			Select @AmtApplyNet = ISNULL(TotalCost, 0) - ISNULL(AppliedCost, 0)
				,@AmtApplyGross = 
					case @BillAt
						when 0 then isnull(BillableCost, 0) - isnull(AmountBilled, 0)
						when 1 then isnull(TotalCost, 0) - isnull(AmountBilled, 0)
						when 2 then isnull(BillableCost, 0) - isnull(TotalCost, 0) - isnull(AmountBilled, 0)
					end 
				,@LineTotalGross = isnull(BillableCost, 0)
				,@LineTotalCost = isnull(TotalCost, 0)
				,@LinkID = SUBSTRING(LinkID, 0, CHARINDEX('-', LinkID)) 
				,@SpotLinkID = SUBSTRING(LinkID, CHARINDEX('-', LinkID)+1, LEN(LinkID))
				,@StartDate = DetailOrderDate
				,@EndDate = DetailOrderEndDate
				,@Quantity = 1
				,@UnitRate = UnitRate
				,@PODMarkup =ISNULL(Markup,0)
				,@Program = ShortDescription
				,@Comments = LongDescription
				,@OrderDays = OrderDays
				,@OrderTime = OrderTime
				,@UserDate1 = UserDate1
				,@UserDate2 = UserDate2
				,@UserDate3 = UserDate3
				,@UserDate4 = UserDate4
				,@UserDate5 = UserDate5
				,@UserDate6 = UserDate6
				,@OrderLength = OrderLength
				,@ProjectKey = ProjectKey
				,@TaskKey = TaskKey
				,@ItemKey = ItemKey
				,@OfficeKey = OfficeKey
				,@DepartmentKey = DepartmentKey
			from tPurchaseOrderDetail (nolock)
			where PurchaseOrderDetailKey = @PurchaseOrderDetailKey

			if @RequireItems = 1
				if @ItemKey is null
					begin
						rollback tran
						return -15
					end										

			if ISNULL(@ItemKey, 0) > 0
				Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

			if ISNULL(@ExpenseAccountKey, 0) = 0
				Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
				
			if ISNULL(@ExpenseAccountKey, 0) = 0
				Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
						
			if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
				begin
					rollback tran
					return -16
				end				
			
			-- Check to see how much of the OrderLine needs to be revsersed
			if ISNULL(@PODMarkup,0) = 0 
				select @PODGross = (@Remaining_bal * -1)
			else
				Select @PODGross = (@Remaining_bal /(1 - (ISNULL(@PODMarkup,0) * .010))	* -1)
			
			
			select @Remaining_bal = (@Remaining_bal * -1)
			
			-- *** Create the Revision line here ***
			
		exec @RetVal = sptPurchaseOrderDetailInsert
			@PurchaseOrderKey,
			@LineNumber,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			@ClassKey,
			@Program,
			-1,
			@UnitRate,
			NULL,
			@Remaining_bal,
			@UnitRate,
			1,
			@PODMarkup,
			@PODGross,
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
			@PODGross,	-- GrossAmount
			null,		-- PCurrencyID
			1,			-- PExchangeRate
			@Remaining_bal,	-- PTotalCost
			@RevisionPurchaseOrderDetailKey output
					
			
			if ISNULL(@RevisionPurchaseOrderDetailKey, 0) > 0
				Begin
					update tPurchaseOrderDetail
					set AutoAdjustment = 2
					where PurchaseOrderDetailKey = @RevisionPurchaseOrderDetailKey
				End
				
				if @RetVal < 0
				begin
					rollback tran
					return -19 --Problem applying Total Invoice Net difference
				end
			
			select @PurchaseOrderDetailKey = -1
			while (1=1)
				begin -- close remaining rows
				    if @IgnoreDates = 1
					    select @PurchaseOrderDetailKey = MIN(PurchaseOrderDetailKey)
						from tPurchaseOrderDetail (nolock)
						where PurchaseOrderDetailKey > @PurchaseOrderDetailKey
						and PurchaseOrderKey = @PurchaseOrderKey
						and isnull(AppliedCost,0) <> TotalCost
					else
					    select @PurchaseOrderDetailKey = MIN(PurchaseOrderDetailKey)
						from tPurchaseOrderDetail (nolock)
						where PurchaseOrderDetailKey > @PurchaseOrderDetailKey
						and PurchaseOrderKey = @PurchaseOrderKey
						and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
						and isnull(AppliedCost,0) <> TotalCost
					
					if @PurchaseOrderDetailKey is NULL 
						break
	--				
					-- add VoucherDetail line
					
								select @AmtApplyNet = isnull(TotalCost, 0) - isnull(AppliedCost, 0)
								,@AmtApplyGross = 
									case @BillAt
										when 0 then isnull(BillableCost, 0) - isnull(AmountBilled, 0)
										when 1 then isnull(TotalCost, 0) - isnull(AmountBilled, 0)
										when 2 then isnull(BillableCost, 0) - isnull(TotalCost, 0) - isnull(AmountBilled, 0)
									end 
								,@LineTotalGross = isnull(BillableCost, 0)
								,@LineTotalCost = isnull(TotalCost, 0)	
								,@ProjectKey = ProjectKey
								,@TaskKey = TaskKey
								,@ItemKey = ItemKey
								,@OfficeKey = OfficeKey
								,@DepartmentKey = DepartmentKey
								from tPurchaseOrderDetail (nolock)
								where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
							
								--what can we apply? if line > than invoice left to allocate, need to adjust
							--	if @AmtApplyNet > @TotalInvoiceNet
							--		select @AmtApplyNet = @TotalInvoiceNet  --apply remaining balance of invoice
									
								-- check for zero cost spots
								if @LineTotalCost = 0
									select @Commission = 0
								else
									select @Commission = ((@LineTotalGross/@LineTotalCost) - 1) * 100
								
								if @BCClientLink = 1 --	link to client through project (required)
									begin
										if isnull(@ProjectKey, 0) = 0
											begin
												rollback tran
												return -13
											end
									
										if isnull(@TaskKey, 0) = 0
											if @RequireTasks = 1
												begin
													rollback tran
													return -14
												end
									end			
								   
								if @RequireItems = 1
									if @ItemKey is null
										begin
											rollback tran
											return -15
										end										

								if ISNULL(@ItemKey, 0) > 0
									Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

								if ISNULL(@ExpenseAccountKey, 0) = 0
									Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
									
								if ISNULL(@ExpenseAccountKey, 0) = 0
									Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
											
								if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
										begin
											rollback tran
											return -16
										end
								
								-- If using Projects/Tasks - Check to see if the associated Task is completed
								if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
									BEGIN
										exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',NULL, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
										if @RetVal < -1 
											BEGIN
												rollback tran
												return -21
											END
									END
																		
								exec @RetVal = sptVoucherDetailInsert
									@VoucherKey,
									@PurchaseOrderDetailKey,
									null,
									@ProjectKey,
									@TaskKey,
									@ItemKey,
									@ClassKey,
									'', --Comments
									1,  -- always set quantity to 1 since the line is at spot level or bottom line, either way it s/b 1  
									null,
									null,
									@AmtApplyNet,
									null,
									1,
									null, -- Markup, because null, will be recalculated in sp
									@AmtApplyGross,
									@ExpenseAccountKey,
									0,
									0,
									1, -- LastVoucher
									@OfficeKey,
									@DepartmentKey,
									1, -- @CheckProject
									@Commission,
									null, -- GrossAmount, because null, will be recalculated in sp
									null,        -- PCurrencyID
									1,           -- PExchangeRate
									@AmtApplyNet,  -- PTotalCost
									@VoucherDetailKey output
					
			--		update tPurchaseOrderDetail 
			--		set Closed = 1
			--		where PurchaseOrderDetailKey = @PurchaseOrderDetailKey
				
				end -- close remaining rows
	end  -- end close month
		
		
EXEC sptVoucherRecalcAmounts @VoucherKey

commit tran
GO
