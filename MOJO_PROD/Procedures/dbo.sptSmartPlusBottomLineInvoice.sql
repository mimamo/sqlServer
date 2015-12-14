USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusBottomLineInvoice]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusBottomLineInvoice]

	 @CompanyKey int
	,@UserKey int
	,@LinkID varchar(50)
	,@InvoiceNumber varchar(50)
	,@InvoiceDate smalldatetime
	,@PostingDate smalldatetime
	,@InvoiceMonth varchar(2)
	,@InvoiceYear varchar(4)
	,@TotalInvoiceGross decimal(24,4)
	,@TotalInvoiceNet decimal(24,4)
	,@CMP tinyint = 0		-- syncing from CMP?  WMJ = 0 / CMP = 1

as --Encrypt

/*
|| When     Who Rel     What
|| 06/10/08 RTC	8.5.1.3 New For Bottom Line Invoicing
|| 06/18/08 GHL 8.513   Added OpeningTransaction
|| 09/16/08 RTC 10.0.0.9 Insure vendor is active.
|| 11/11/09 MAS 10.5.1.3 (47035)
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert
|| 01/17/12 GHL 10.5.5.2 VoucherType = 0 now since the Voucher UI can handle all po kinds 
|| 04/29/13 MAS 10.5.6.7 (176403)Updated the sync to be consistent with Strata's BLI when applying invoice amounts that
||                       exceed the PurchaseOrder amount total.
|| 10/16/13 GHL 10.5.7.3 Added GrossAmount and Commission when calling sptInvoiceDetailInsert
|| 11/22/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptInvoiceDetailInsert
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
declare @DueDate smalldatetime
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
declare @OrderTotalCost decimal(24,4)
declare @Active tinyint
declare @LastPurchaseOrderDetailKey int
declare @ClientKey int

--init transaction flag
select @TranStarted = 0

--set date range
select @DateRangeBegin = cast(@InvoiceYear as varchar(4)) + '-' + @InvoiceMonth + '-01 00:00:00'
if @InvoiceMonth = '12'
	select @DateRangeEnd = cast(cast(cast(@InvoiceYear as int) + 1 as varchar(4)) + '-' + '01-01 00:00:00' as smalldatetime)
else
	select @DateRangeEnd = cast(cast(@InvoiceYear as varchar(4)) + '-' + cast(cast(@InvoiceMonth as int) + 1 as varchar(2)) + '-01 00:00:00' as smalldatetime)

--find associated purchase order
select   @PurchaseOrderKey = PurchaseOrderKey
		,@VendorKey = VendorKey
		,@GLCompanyKey = GLCompanyKey
		,@POStatus = Status
		,@BillAt = BillAt
from tPurchaseOrder (nolock)
where CompanyKey = @CompanyKey
and LinkID = @LinkID
and POKind = 2

--validate associated purchase order conditions
if @PurchaseOrderKey is null
	return -1
	
if @POStatus < 4 
	return -2
	
if @VendorKey is null
	return -3
		
if @InvoiceDate is null
	return -7
			
if @InvoiceNumber is null
	return -8
						
--get defaults needed
select   @BCClientLink = isnull(BCClientLink,1)
		,@RequireItems = RequireItems
		,@RequireTasks = RequireTasks
		,@RequireAccounts = RequireGLAccounts      
		,@APAccountKey = DefaultAPAccountKey
		,@AutoApproveExternalInvoices = AutoApproveExternalInvoices	 
from tPreference (nolock)
where CompanyKey = @CompanyKey
	
if @AutoApproveExternalInvoices = 1
	select @Status = 4
else
	select @Status = 2	
				
select   @TermsPercent = isnull(TermsPercent, 0)
		,@TermsDays = isnull(TermsDays, 0)
		,@TermsNet = isnull(TermsNet, 0) 
		,@Active = isnull(Active, 0)
from tCompany (nolock)
where CompanyKey = @VendorKey
		
if @Active <> 1
	return -20
			
select @DueDate = dateadd(day, @TermsNet, @InvoiceDate)
				 			
--check if voucher exists	
select @VoucherKey = min(VoucherKey) 
from tVoucher (nolock)
where CompanyKey = @CompanyKey 
and LinkID = @LinkID
and InvoiceNumber = @InvoiceNumber

----insure the total voucher net is not more than the associated orders net amount, cannot handle any additional amount
--select @OrderTotalCost = sum(isnull(TotalCost, 0) - isnull(AppliedCost, 0))		
--from tPurchaseOrderDetail (nolock)
--where PurchaseOrderKey = @PurchaseOrderKey
--and DetailOrderDate between @DateRangeBegin and @DateRangeEnd
--and Closed = 0
--and isnull(TotalCost, 0) - isnull(AppliedCost, 0) > 0	
--if @TotalInvoiceNet > @OrderTotalCost
--	return -19

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
			null,
			null,
			null,
			@GLCompanyKey,
			@OfficeKey,
			0,	--OpeningTransaction
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
	
--now we have a voucher header, create new voucher details by looping through order details
select @LineNumber = -1
while 1=1
	begin
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
										
								--if project was specified, validate that it is active and is a billable project
								if @BCClientLink = 1
									if isnull(@ProjectKey, 0) > 0
										begin
											if ISNULL(@ItemKey, 0) > 0
												Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

											if ISNULL(@ExpenseAccountKey, 0) = 0
												Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
												
											if ISNULL(@ExpenseAccountKey, 0) = 0
												Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
										end
											
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
									null,
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
									0,
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
	
-- Apply the remaining amount (from StrataBottomLineInvoice)
if @TotalInvoiceNet > 0
begin
	-- Which PurchaseOrderDetailKey should we use
	if @LastPurchaseOrderDetailKey is null
		Select @PurchaseOrderDetailKey = max(PurchaseOrderDetailKey)
		From tPurchaseOrderDetail (nolock)
		where PurchaseOrderKey = @PurchaseOrderKey
	else
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
		
		-- check for zero cost spots
		if @LineTotalCost = 0
			select @Commission = 0
		else
			select @Commission = ((@LineTotalGross/@LineTotalCost) - 1) * 100
									
		exec @RetVal = sptVoucherDetailUpdate
			@VoucherDetailKey,
			@VoucherKey,
			@PurchaseOrderDetailKey,
			@ClientKey,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			null,
			'', --Comments
			1,  -- always set quantity to 1 since the line is at spot level or bottom line, either way it s/b 1  
			null,
			null,
			@AmtApplyNet,
			null,
			1,
			null, -- Markup because null, will be recalculated in sp
			@AmtApplyGross,
			@ExpenseAccountKey,
			0,
			0,
			0,
			@OfficeKey,
			@DepartmentKey,
			NULL, -- TargetGLCompanyKey
			1, --project rollup
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
	
end	-- end Apply the remaining amount

EXEC sptVoucherRecalcAmounts @VoucherKey

commit tran
GO
