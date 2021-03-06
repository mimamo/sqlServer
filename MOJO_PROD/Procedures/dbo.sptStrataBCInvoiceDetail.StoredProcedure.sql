USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataBCInvoiceDetail]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataBCInvoiceDetail]
(
	@VoucherKey int,
	@UserKey int,
	@LinkID varchar(50),
	@PODetailLinkID varchar(50),
	@SpotLinkID varchar(50),
	@Quantity decimal(24,4),
	@Comments varchar(500),
	@MarkInvoiceAsBilled tinyint,
	@SpotRate decimal(24,6),
	@StnCltWeight decimal(24,6),
	@CltWeight decimal(24,6),
	@StnWeight decimal(24,6),
	@CMP tinyint = 0	-- syncing from CMP?  WMJ = 0 / CMP = 1
)

as --Encrypt

/*
|| When     Who Rel      What
|| 11/13/06 RTC 8.3570   Added last voucher flag for sptVoucherDetailInsert.
|| 11/16/06 CRG 8.3571   Modified to get the ClassKey from tPurchaseOrderDetail.
|| 12/05/06 RTC 8.4      Check to make sure the voucher has not already been posted before updating existing voucher detail lines.
|| 02/06/07 RTC 8.4.0.3  Do not post to WIP if project is not specified or project is specified and is non-billable
|| 03/15/07 GWG 8.4.1    Added conditional logic for prerecognizing vendor invoice revenue (medialogic)
|| 05/17/07 RTC 8.4.2.2  (#9239) If client link is through estimate do not check for project and project billable
|| 06/05/07 RTC 8.4.3    (#9428) If order is pre-billed, do not post to WIP
|| 10/11/07 BSH 8.5      Insert GLCompany and Office to the Invoice, Office and Department to InvoiceLine, removed all WIP logic.
|| 01/31/08 GHL 8.503    (20244) Added CheckProject parameter so that the checking of the project 
||                       can be bypassed when creating vouchers from expense receipts  
|| 06/23/08 RTC 10.0.0.3 Only validate tasks if Require Tasks on Expenses is set in system options.
|| 01/14/09 GWG 10.016   (43852) Modified the recalc of sales tax to take into account direct editing of sales tax
|| 07/17/09 MAS 10.016   (57112) Removed unused var @NonBillable and also logic based on @NonBillable
|| 09/21/09 GHL 10.5     Using now sptVoucherRecalcAmounts (taxes editable now on the voucher lines)
|| 10/07/09 MAS 10.5.1.9 () Calculate Client Costing
|| 10/07/09 MAS 10.5.1.9 (67320) Removed rounding when calculating Client Costing UnitRate/UnitCost also set Commision/Markup = 0 when UnitRate = 0
|| 11/11/09 MAS 10.5.1.3 (47035)
|| 11/30/09 MAS 10.5.1.4 (69169) Added @PODQuantity and @BillAt to re-calculate Gross and net if the Quantity in the order is  
||							different then the quantity in the invoice record.	
|| 01/12/09 MAS 10.5.1.6 (71305) Added @PODInvoiceLineKey and @VDTotGross to re-calculate Gross and net if the Quantity in the order is
||							different then the quantity in the invoice record and the POD line was invoiced. 	
|| 10/15/10 MAS 10.5.3.6 (91521) sptVoucherRecalcAmounts and sptPurchaseOrderDetailUpdateAppliedCost were not getting called for new Voucher Detail lines 			  		
|| 11/08/10 MAS 10.5.3.7 (93028) Changed the way we round from round(qty * cost, 2) to qty * round(cost,2) to be consitient with Strata
|| 08/23/12 MAS 10.5.5.9 (152132) Changed the percision of all the client costing params
|| 08/24/12 MAS 10.5.5.9 (152348) Compare the PODUnitCost with the UnitCost to see if we need to make an adjustment 
|| 10/16/12 MAS 10.5.6.1 (156020) Calculate PODUnitCost using the markup also include teh total cost of all the Adjustment Lines(PODAdjTotalCost)
                                  to determine if we should change the BillableCost (over or under billing amount)  
|| 10/16/12 MAS 10.5.6.2 (157840) Check to see if the total amount of a detail line (and revisions) are equal to the Voucher Detail line.  If so Call sptPurchaseOrderDetailChangeClose
|| 12/13/12 MAS 10.5.6.2 (162448) Modified the @ProcessAllSpots option we're sending to sptPurchaseOrderDetailChangeClose from 1 to 0
|| 12/13/12 MAS 10.5.6.3 (162955) Update tVoucherDetail SET BillableCost = @NewGross 
||                                and Modified the @ProcessAllSpots option we're sending to sptPurchaseOrderDetailChangeClose from 0 to 2
|| 02/05/13 MAS 10.5.6.4 (166079) Added a fix to include the original line and all the revisions when calculating the @AmountBilled.
||                                Also, pass in the POKey to sptPurchaseOrderDetailChangeClose 
|| 03/01/13 MAS 10.5.6.5 (170566) Use the POD Quantity when creating the matching voucher detail records
|| 07/11/13 MAS 10.5.7.0 (185524) Set the LastVoucher flag for the original Voucher Detail, not the VoucherDetails we create for adjustment lines
|| 08/15/13 MAS 10.5.8.0 (186667) When calculating the vd.BillableCost, consider all other vd lines associated with the pod
|| 09/26/13 MAS 10.5.8.0 (190593) Wrapped @TotBillableCost in an ISNULL
|| 10/16/13 GHL 10.5.7.3 Added GrossAmount and Commission when calling sptInvoiceDetailInsert
|| 11/22/13 GHL 10.5.7.4 Added PCurrency and PExchangeRate parms when calling sptInvoiceDetailInsert
|| 12/06/13 MAS 10.5.7.4 (198687) Determine if there anything to unaccrue and set the prebill amount, Update the original voucher detail line to the same qty, unit cost and total of the main po line 
|| 01/21/14 MAS 10.5.7.6 (203357) When creating matching VD lines for POD revisions, set the VD.LastVoucher flag and make sure the POD.AppliedCost is updated or each POD revisions
|| 01/22/14 GHL 10.5.7.6 Added update of PTotalCost in direct insert in tVoucherDetail + (2/3/14)
|| 10/13/14 PLC 10.5.8.5 Change logic to get closed flag if detail line already existed.
*/

Declare @PODetailKey int, @POKey int, @VoucherDetailKey int, @CompanyKey int, @VendorKey int, @RetVal int, @RequireItems tinyint, @ClassKey int
Declare @ExpenseAccountKey int, @ProjectKey int, @TaskKey int, @ItemKey int, @TotalCost money, @TotGross money, @TotBillableCost money, @RequireAccounts tinyint
declare @BCClientLink smallint
declare @FullLinkID varchar(50)
declare @FullPOLinkID varchar(50)
declare @OfficeKey int, @DepartmentKey int
declare @AmountBilled  money
declare @PODTotalCost money
declare @RequireTasks tinyint
DECLARE	@SalesTax1Amount money, @SalesTax2Amount money
declare @UseClientCosting tinyint 
declare @POClientCosting tinyint 
declare @UnitCost money
declare	@UnitRate money, @PODUnitCost money
declare	@Commission decimal(24,4)
declare @Markup decimal(24,4)
declare @PODQuantity int, @PODAdjQuantity int, @BillAt int, @PODInvoiceLineKey int
declare @VDTotGross money
declare @LineNumber int, @Closed tinyint
declare @DetailOrderDate smalldatetime, @DetailOrderEndDate smalldatetime
declare @PODTotalGross money, @PODTotalBilled money
declare @PODAdjDetailKey int
declare @VDLineNumber int
select @FullLinkID = @LinkID + '-' + @SpotLinkID
select @FullPOLinkID = @PODetailLinkID + '-' + @SpotLinkID

Select @VendorKey = VendorKey, @CompanyKey = CompanyKey from tVoucher (NOLOCK) Where VoucherKey = @VoucherKey

if @VendorKey is null
	Return -1

-- try with old style LinkID
Select @VoucherDetailKey = MIN(VoucherDetailKey) from tVoucherDetail (NOLOCK) 
Where VoucherKey = @VoucherKey and LinkID = @LinkID
	
if @VoucherDetailKey is null	  -- not found with old style key, try new full key
	Select @VoucherDetailKey = MIN(VoucherDetailKey) from tVoucherDetail (NOLOCK) 
	Where VoucherKey = @VoucherKey and LinkID = @FullLinkID
	
select @BCClientLink = isnull(BCClientLink,1)
      ,@RequireAccounts = RequireGLAccounts 
      ,@RequireTasks = RequireTasks  
      ,@UseClientCosting = BCUseClientCosting
from tPreference (nolock) where CompanyKey = @CompanyKey

if @VoucherDetailKey is null
BEGIN
	Select @PODetailKey = Min(PurchaseOrderDetailKey) 
	from tPurchaseOrderDetail pod (NOLOCK) 
	inner join tPurchaseOrder po on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where po.VendorKey = @VendorKey and pod.LinkID = @FullPOLinkID
	
	if @PODetailKey is null
		Return -2
	
	Select @TotBillableCost = ISNULL(SUM(ISNULL(BillableCost, 0)), 0) 
	From tVoucherDetail (nolock) 
	Where PurchaseOrderDetailKey = @PODetailKey
		
	Select   @POKey = pod.PurchaseOrderKey
			,@PODQuantity = IsNUll(pod.Quantity,0)
			,@BillAt = po.BillAt
			,@PODInvoiceLineKey = IsNUll(pod.InvoiceLineKey,0)
			,@ProjectKey = pod.ProjectKey
			,@TaskKey = pod.TaskKey
			,@ItemKey = pod.ItemKey 
			,@ClassKey = pod.ClassKey
			,@OfficeKey = pod.OfficeKey
			,@DepartmentKey = pod.DepartmentKey
			,@TotGross = 
				case po.BillAt
					when 0 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 1 then ISNULL(pod.TotalCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 2 then (ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0)) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
				end 
			,@PODUnitCost = isnull(pod.UnitCost,0) * (1 - isnull(pod.Markup,0)/100)
			,@AmountBilled  = isnull(pod.AmountBilled,0)
			,@POClientCosting = po.UseClientCosting
			,@LineNumber = LineNumber
			,@DetailOrderDate = DetailOrderDate
			,@DetailOrderEndDate = DetailOrderEndDate
			,@Closed =  ISNULL(pod.Closed, 0)
	From tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where PurchaseOrderDetailKey = @PODetailKey

	-- We should include original POD and all if it's adjustments
	Select @AmountBilled  = SUM(ISNULL(pod.AmountBilled,0))
	From tPurchaseOrderDetail pod (NOLOCK) 
	Where pod.PurchaseOrderKey = @POKey
		And pod.LineNumber = LineNumber
		And pod.DetailOrderDate = DetailOrderDate
		And pod.DetailOrderEndDate = DetailOrderEndDate
		AND ISNULL(pod.InvoiceLineKey, 0) > 0
			
	-- Find the Adjustment line Quantities
	Select @PODAdjQuantity = IsNUll(Sum(pod.Quantity),0)
	From tPurchaseOrderDetail pod (NOLOCK) 
	Where pod.PurchaseOrderKey = @POKey
		And pod.LineNumber = @LineNumber
		And pod.DetailOrderDate = @DetailOrderDate
		And pod.DetailOrderEndDate = @DetailOrderEndDate
		And pod.AutoAdjustment = 1
	
	
	-- If POD ClientCosting is NULL use the system setting
	if @POClientCosting is null
		Begin
			Select @POClientCosting = @UseClientCosting
			
			Update tPurchaseOrder 
			Set UseClientCosting = @POClientCosting
			Where PurchaseOrderKey = @POKey
		End
	
	if @POClientCosting = 1
		begin
			Select @UnitRate = @SpotRate * @StnCltWeight * @CltWeight
			Select @UnitCost = @SpotRate * @StnWeight
			if @UnitRate = 0
				Select @Commission = 0
			else
				Select @Commission = (1 - ROUND(@UnitCost / @UnitRate, 4)) * 100
		end
	else
		begin
			Select @UnitRate = @SpotRate
			Select @UnitCost = @SpotRate * @StnWeight
			Select @Commission = (1 - @StnWeight) * 100
		end  
	select @TotalCost = @Quantity * round(@UnitCost,2)
	
	select @Markup = dbo.fCommissionToMarkup(@Commission)     

	if @Quantity <> (@PODQuantity + @PODAdjQuantity) OR @PODUnitCost <> @UnitCost
		Begin
			 -- Check if this Line has already been invoiced
			If @PODInvoiceLineKey > 0
				Begin
					if @BillAt = 0
						Begin	
							Select @VDTotGross = isNull(SUM(BillableCost) ,0)
							from tVoucherDetail Where PurchaseOrderDetailKey = @PODetailKey					
							if @AmountBilled  <= @VDTotGross + @Quantity * ROUND(@UnitRate,2)
								Select @TotGross = @Quantity * ROUND(@UnitRate,2) - (@AmountBilled  - @VDTotGross)
						End
					if @BillAt = 1
						Begin
							Select @VDTotGross = isNull(SUM(BillableCost) ,0)
							from tVoucherDetail Where PurchaseOrderDetailKey = @PODetailKey	
							if @AmountBilled  <= @VDTotGross + @TotalCost
								Select @TotGross =  @TotalCost  - (@AmountBilled  - @VDTotGross)
						End
				End
			Else
				Begin		
					Select @TotGross = 
						case @BillAt
							when 0 then @Quantity * ROUND(@UnitRate,2)
							when 1 then @TotalCost
						end
				End	
		End

	if exists(Select 1 from tPurchaseOrder (nolock) Where PurchaseOrderKey = @POKey and Status < 4)
		return -3
		
	if @BCClientLink = 1 and ISNULL(@ProjectKey, 0) = 0
		Return -4
	
	IF @BCClientLink = 1 and ISNULL(@TaskKey, 0) = 0 and @RequireTasks = 1
		Return -5
		
	Select @RequireItems = RequireItems from tPreference (NOLOCK) Where CompanyKey = @CompanyKey and RequireItems = 1
	if @RequireItems = 1
		if @ItemKey is null
			return -6
		
	if ISNULL(@ItemKey, 0) > 0
		Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

	if ISNULL(@ExpenseAccountKey, 0) = 0
		Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey
		
	if ISNULL(@ExpenseAccountKey, 0) = 0
		Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
		
	if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
		Return -7
					
	-- If using Projects/Tasks - Check to see if the associated Task is completed
	if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
		BEGIN
			exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',@VoucherDetailKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
			if @RetVal < -1 
				return -23 
		END
				
	Exec @RetVal = sptVoucherDetailInsert
		@VoucherKey,
		@PODetailKey,
		NULL,
		@ProjectKey,
		@TaskKey,
		@ItemKey,
		@ClassKey,
		@Comments,
		@Quantity,
		@UnitCost,
		NULL,
		@TotalCost, 
		NULL,
		1,
		null, --Markup, because it is null, will be recalculated in sp
		@TotGross, 
		@ExpenseAccountKey,
		0,
		0,
		0, -- Last Voucher
		@OfficeKey,
		@DepartmentKey,
		1, -- @CheckProject
		@Commission,
		null, --GrossAmount, because it is null, will be recalculated in sp
		null,        -- PCurrencyID
		1,           -- PExchangeRate
		@TotalCost,  -- PTotalCost
		@VoucherDetailKey output
		
	if @RetVal = -3
		Return -10 --Voucher is already posted
	if @RetVal = -2
		Return -11 --Project Status does not allow additional costs
	if @RetVal = -1
		Return -12 --Problem inserting line
		
	-- sptVoucherDetailInsert may have marked this line as billed, do no change it
	if @MarkInvoiceAsBilled = 1
		update tVoucherDetail 
		set LinkID = @FullLinkID 
		where VoucherDetailKey = @VoucherDetailKey
	else
		-- sptVoucherDetailInsert may have marked this line as billed, change it back 
		update tVoucherDetail 
		set InvoiceLineKey = null
		   ,DateBilled = null
		   ,LinkID = @FullLinkID
		where VoucherDetailKey = @VoucherDetailKey		
	
END
ELSE
BEGIN
	--voucher detail exists
	
	--make sure voucher has not already been posted
	if (select Posted
		from tVoucher (nolock)
		where VoucherKey = @VoucherKey) = 1
			return -22 --voucher has already been posted, do not update
			
	Select @PODetailKey = PurchaseOrderDetailKey from tVoucherDetail (NOLOCK) Where VoucherDetailKey = @VoucherDetailKey
	if ISNULL(@PODetailKey, 0) = 0
		return -20
	
	if exists(Select 1 from tVoucherDetail (NOLOCK) 
	           Where VoucherDetailKey = @VoucherDetailKey and (WriteOff = 1 or InvoiceLineKey >= 0))
		return -21
	
	Select @TotBillableCost = ISNULL(SUM(ISNULL(BillableCost, 0)), 0) 
	From tVoucherDetail (nolock) 
	Where PurchaseOrderDetailKey = @PODetailKey
		
	Select   @POKey = pod.PurchaseOrderKey
			,@PODQuantity = IsNUll(pod.Quantity,0)
			,@BillAt = po.BillAt
			,@PODInvoiceLineKey = IsNUll(pod.InvoiceLineKey,0)
			,@ProjectKey = pod.ProjectKey
			,@TaskKey = pod.TaskKey
			,@TotGross = 
				case po.BillAt
					when 0 then  ISNULL(pod.BillableCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 1 then  ISNULL(pod.TotalCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 2 then (ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0)) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
				end 	
			,@PODUnitCost = (isnull(pod.UnitCost,0) * (isnull(pod.UnitCost,0) * (1 - isnull(pod.Markup,0)/100)))
			,@AmountBilled  = isnull(pod.AmountBilled,0)
			,@POClientCosting = po.UseClientCosting
			,@LineNumber = LineNumber
			,@DetailOrderDate = DetailOrderDate
			,@DetailOrderEndDate = DetailOrderEndDate
			,@Closed =  ISNULL(pod.Closed, 0)
	From tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where PurchaseOrderDetailKey = @PODetailKey

	-- If using Projects/Tasks - Check to see if the associated Task is completed
	if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
		BEGIN
			exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',@VoucherDetailKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
			if @RetVal < -1 
				return -23 
		END

	-- We should include original POD and all if it's adjustments
	Select @AmountBilled  = SUM(ISNULL(pod.AmountBilled,0))
	From tPurchaseOrderDetail pod (NOLOCK) 
	Where pod.PurchaseOrderKey = @POKey
		And pod.LineNumber = LineNumber
		And pod.DetailOrderDate = DetailOrderDate
		And pod.DetailOrderEndDate = DetailOrderEndDate
		AND ISNULL(pod.InvoiceLineKey, 0) > 0
		
	-- Find the Adjustment line Quantities
	Select @PODAdjQuantity = IsNUll(Sum(pod.Quantity),0)
	From tPurchaseOrderDetail pod (NOLOCK) 
	Where pod.PurchaseOrderKey = @POKey
		And pod.LineNumber = @LineNumber
		And pod.DetailOrderDate = @DetailOrderDate
		And pod.DetailOrderEndDate = @DetailOrderEndDate
		And pod.AutoAdjustment = 1
					
	-- If POD ClientCosting is NULL use the system setting
	if @POClientCosting is null
		Begin
			Select @POClientCosting = @UseClientCosting
			
			Update tPurchaseOrder 
			Set UseClientCosting = @POClientCosting
			Where PurchaseOrderKey = @POKey
		End
		
	if @POClientCosting = 1
		begin
			Select @UnitRate = @SpotRate * @StnCltWeight * @CltWeight
			Select @UnitCost = @SpotRate * @StnWeight
			if @UnitRate = 0
				Select @Commission = 0
			else
				Select @Commission = (1 - ROUND(@UnitCost / @UnitRate, 4)) * 100
		end
	else
		begin
			Select @UnitRate = @SpotRate
			Select @UnitCost = @SpotRate * @StnWeight
			Select @Commission = (1 - @StnWeight) * 100
		end  
	select @TotalCost = @Quantity * ROUND(@UnitCost,2)	

	select @Markup = dbo.fCommissionToMarkup(@Commission)     

	-- If the Quantity from the invoice doesn't equal the Quantity from the POD, recalculate the totals
	-- We need to exclude the Existing Voucher record from the Gross total since it's going to be updated
	if @Quantity <> (@PODQuantity + @PODAdjQuantity) OR @PODUnitCost <> @UnitCost
		Begin
			 -- Check if this Line has already been invoiced
			If @PODInvoiceLineKey > 0
				Begin
					if @BillAt = 0
						Begin	
							Select @VDTotGross = isNull(SUM(BillableCost) ,0)
							from tVoucherDetail 
							Where PurchaseOrderDetailKey = @PODetailKey	
							And VoucherDetailKey < @VoucherDetailKey					
							if @AmountBilled  <= @VDTotGross + @Quantity * ROUND(@UnitRate,2)
								Select @TotGross = @Quantity * ROUND(@UnitRate,2) - (@AmountBilled  - @VDTotGross)
						End
					if @BillAt = 1
						Begin
							Select @VDTotGross = isNull(SUM(BillableCost) ,0)
							from tVoucherDetail 
							Where PurchaseOrderDetailKey = @PODetailKey	 
							And VoucherDetailKey < @VoucherDetailKey
							if @AmountBilled  <= @VDTotGross + @TotalCost
								Select @TotGross =  @TotalCost  - (@AmountBilled  - @VDTotGross)
						End
				End
			Else
				Begin		
					Select @TotGross = 
						case @BillAt
							when 0 then @Quantity * ROUND(@UnitRate,2)
							when 1 then @TotalCost
						end
				End	
		End

		
	Update tVoucherDetail
	Set
		Quantity = @Quantity,
		Markup = @Markup,
		Commission = @Commission,
		UnitCost = @UnitCost,
		TotalCost = @TotalCost,
		PTotalCost = @TotalCost,
		BillableCost = @TotGross,
		GrossAmount = ROUND(@TotalCost * (1 + @Markup/100), 2),
		ShortDescription = @Comments,
		LinkID = @FullLinkID
	Where
		VoucherDetailKey = @VoucherDetailKey

END

-- Find the total net cost for POD line and all of it's revisions.
-- BC, Interactive and Print all use this same routine 
if @Closed = 0 
	Begin
		Select @PODTotalCost = isnull(Sum(pod.TotalCost),0), @PODTotalGross = isnull(Sum(pod.BillableCost),0), @PODTotalBilled = isnull(Sum(pod.AmountBilled),0)
		From tPurchaseOrderDetail pod (NOLOCK) 
		Where pod.PurchaseOrderKey = @POKey
			And pod.LineNumber = @LineNumber
			And pod.DetailOrderDate = @DetailOrderDate
			And pod.DetailOrderEndDate = @DetailOrderEndDate
		
		if @PODTotalCost = @TotalCost
			Begin
				Declare @NewGross money, @POUnitCost money 
				Declare @NewPODAdjQuantity int

				-- Loop through all the adjustments lines and create voucher detail lines
				Select @PODAdjDetailKey = -1
				while 1=1
					begin
						Select @PODAdjDetailKey = min(PurchaseOrderDetailKey)
						From tPurchaseOrderDetail pod (NOLOCK) 
						Where pod.PurchaseOrderKey = @POKey
						And pod.LineNumber = @LineNumber
						And pod.DetailOrderDate = @DetailOrderDate
						And pod.DetailOrderEndDate = @DetailOrderEndDate
						And ISNULL(pod.AutoAdjustment, 0) > 0
						And pod.PurchaseOrderDetailKey > @PODAdjDetailKey

						if @PODAdjDetailKey is null
							break

						Select	@PODTotalCost = isnull(pod.TotalCost,0), 
								@PODTotalGross = isnull(pod.BillableCost,0), 
								@PODTotalBilled = isnull(pod.AmountBilled,0),
								@POUnitCost = isnull(pod.UnitCost, 0),
								@NewPODAdjQuantity = ISNULL(pod.Quantity, 0)
						From tPurchaseOrderDetail pod (NOLOCK) 
						Where pod.PurchaseOrderDetailKey = @PODAdjDetailKey				

						Select @NewGross = 
							case @BillAt
								when 0 then @PODTotalGross - @PODTotalBilled 
								when 1 then @PODTotalCost - @PODTotalBilled 
								when 2 then @PODTotalGross - @PODTotalCost - @PODTotalBilled 
							end

						Select @VDLineNumber = MAX(LineNumber) + 1
						From tVoucherDetail vd (NOLOCK)
						Where VoucherKey = @VoucherKey

						Insert Into tVoucherDetail (
							VoucherKey,
							LineNumber,
							PurchaseOrderDetailKey, 
							ProjectKey, 
							TaskKey, 
							ItemKey, 
							ClassKey,
							Quantity,
							UnitCost,
							TotalCost,
							PTotalCost,
							ExpenseAccountKey,
							OfficeKey,
							DepartmentKey,
							LastVoucher, 
							BillableCost,
							GrossAmount
							) 
						values (
							@VoucherKey,
							@VDLineNumber,
							@PODAdjDetailKey, 
							@ProjectKey, 
							@TaskKey, 
							@ItemKey, 
							@ClassKey,
							@NewPODAdjQuantity,
							@POUnitCost, -- UnitCost
							@PODTotalCost, -- TotalCost
							@PODTotalCost, -- PTotalCost
							@ExpenseAccountKey,
							@OfficeKey,
							@DepartmentKey,
							1, -- (203357) set the LastVoucher flag
							ISNULL(@NewGross, 0),
							ISNULL(@NewGross, 0)
							)
							
					-- determine if there anything to unaccrue and set the prebill amount
					declare @OpenAccrual money, @POAccrual money, @Unaccrued money, @OtherQty decimal(24,4), @OtherNet money
					Select @POAccrual = isnull(AccruedCost, 0) from tPurchaseOrderDetail (nolock) 
					Where PurchaseOrderDetailKey = @PODetailKey
					if @POAccrual <> 0
					BEGIN
						Select @Unaccrued = ISNULL(SUM(ISNULL(PrebillAmount, 0)), 0),
								@OtherQty = ISNULL(SUM(ISNULL(Quantity, 0)), 0),
								@OtherNet = ISNULL(SUM(ISNULL(TotalCost, 0)), 0) 
						from tVoucherDetail (nolock) 
						Where PurchaseOrderDetailKey = @PODetailKey and VoucherDetailKey <> @VoucherDetailKey

						Select @OpenAccrual = @POAccrual - @Unaccrued

						Update tVoucherDetail Set PrebillAmount = @OpenAccrual Where VoucherDetailKey = @VoucherDetailKey

					END

					--Update the original voucher detail line to the same qty, unit cost and total of the main po line
					Select	 @PODTotalCost = isnull(pod.TotalCost,0), 
							 @POUnitCost = isnull(pod.UnitCost, 0),
							@NewPODAdjQuantity = ISNULL(pod.Quantity, 0)
					From tPurchaseOrderDetail pod (NOLOCK) 
					Where pod.PurchaseOrderDetailKey = @PODetailKey	


					-- Set the LastVoucher flag for the original Voucher Detail, not the Voucher Detail lines we create for adjustment lines 
					Update tVoucherDetail
					Set LastVoucher = 1,
						TotalCost = @PODTotalCost - @OtherNet,
						PTotalCost = @PODTotalCost - @OtherNet,
						UnitCost = @POUnitCost,
						Quantity = @NewPODAdjQuantity - @OtherQty
					Where VoucherDetailKey = @VoucherDetailKey

					-- (203357) When creating matching VD lines for POD revisions, make sure the POD.AppliedCost is updated for the POD revisions
					EXEC sptPurchaseOrderDetailUpdateAppliedCost @PODAdjDetailKey  -- This will also close the POD adjustment line				
				End
			End
	End	
	
EXEC sptVoucherRecalcAmounts @VoucherKey
EXEC sptPurchaseOrderDetailUpdateAppliedCost @PODetailKey
	
return @VoucherDetailKey
GO
