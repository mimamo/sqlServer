USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStrataInteractiveInvoice]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStrataInteractiveInvoice]
(
	@CompanyKey int,
	@UserKey int,
	@LinkID varchar(50),
	@DetailLinkID varchar(50),
	@VendorID varchar(50),
	@InvoiceNumber varchar(50),
	@InvoiceDate smalldatetime,
	@ClearedDate smalldatetime = NULL,
	@DueDate smalldatetime,
	@PODetailLinkID varchar(50),
	@Quantity decimal(24,4),
	@Comments varchar(500),
	@MarkInvoiceAsBilled tinyint,
	@EstimateID varchar(50),
	@IlCost decimal(24,6),
	@IlCltNetPercent decimal(24,6),
	@IlNetPercent decimal(24,6),
	@TotalGross decimal(24,6),
	@TotalNet decimal(24,6),
	@TotalClientGross decimal(24,6),
	@TotalClientNet decimal(24,6),
	@CalCltNetType decimal(24,6),
	@CMP tinyint = 0	-- syncing from CMP?  WMJ = 0 / CMP = 1
)

as --Encrypt

/*
|| When     Who Rel      What
|| 09/28/06 CRG 8.35     Added parameter for sptVoucherDetailInsert
|| 11/16/06 CRG 8.3571   Modified to get the ClassKey from the MediaEstimate.
|| 12/05/06 RTC 8.4      Check to make sure the voucher has not already been posted before updating existing voucher detail lines.
|| 02/06/07 RTC 8.4.0.3  Do not post to WIP if project is not specified or project is specified and is non-billable
|| 03/15/07 GWG 8.4.1    Added conditional logic for prerecognizing vendor invoice revenue (medialogic)
|| 05/17/07 RTC 8.4.2.2  (#9239) If client link is through estimate do not check for project and project billable
|| 06/05/07 RTC 8.4.3    (#9428) If order is pre-billed, do not post to WIP
|| 10/10/07 BSH 8.5      Insert GLCompany and Office to the Invoice, Office and Department to InvoiceLine, removed all WIP logic.
|| 01/31/08 GHL 8.503    (20244) Added sptVoucherDetailInsert.CheckProject parameter so that the checking of the project 
||                       can be bypassed when creating vouchers from expense receipts  
|| 06/18/08 GHL 8.513    Added OpeningTransaction to invoice insert
|| 06/23/08 RTC 10.0.0.3 Only validate tasks if Require Tasks on Expenses is set in system options.
|| 09/16/08 RTC 10.0.0.9 Insure vendor is active.
|| 01/14/09 GWG 10.016   (43852) Modified the recalc of sales tax to take into account direct editing of sales tax
|| 09/21/09 GHL 10.5     Using now sptVoucherRecalcAmounts (taxes editable now on the voucher lines)
|| 10/07/09 MAS 10.5.1.9 (67320) Removed rounding when calculating Client Costing UnitRate/UnitCost also set Commision/Markup = 0 when UnitRate = 0
|| 11/11/09 MAS 10.5.1.3 (47035)
|| 11/11/09 MAS 10.5.1.3 (68994) Added * 100 @Markup = @IlNetPercent * 100 
|| 03/25/10 MAS 10.5.1.3 (76058) Added the option to use the ClearDate from Strata as the PostingDate	
|| 11/08/10 MAS 10.5.3.7 (93028) Changed the way we round from round(qty * cost, 2) to qty * round(cost,2) to be consitient with Strata
|| 11/08/11 MAS 10.5.4.9 Added VoucherType to sptVoucherInsert
|| 01/17/12 GHL 10.5.5.2 VoucherType = 0 now since the Voucher UI can handle all po kinds 	
|| 08/13/12 MAS 10.5.5.9 Use the Vendor's DefaultAPAccountKey if it's set.  Otherwise default to the Company DefaultAPAccountKey
|| 08/23/12 MAS 10.5.5.9 (152132)Changed the percision of all the client costing params
|| 04/16/13 MAS 10.5.6.7 (174039)Create VoucherDetail lines for the POD line and all it's revisions if the POD line has been closed.
|| 05/08/13 MAS 10.5.6.7 Added @TotalGross, @TotalNet, @TotalClientGross & @TotalClientNet to support Interactive changes.
|| 07/11/13 MAS 10.5.7.0 (185524) Set the LastVoucher flag for the original Voucher Detail, not the VoucherDetails we create for adjustment lines
|| 08/15/13 MAS 10.5.8.0 (186667) When calculating the vd.BillableCost, consider all other vd lines associated with the pod
|| 10/16/13 GHL 10.5.7.3  Added GrossAmount and Commission when calling sptInvoiceDetailInsert
|| 11/22/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptInvoiceDetailInsert
|| 12/06/13 MAS 10.5.7.4 (198687) Determine if there anything to unaccrue and set the prebill amount, Update the original voucher detail line to the same qty, unit cost and total of the main po line 
|| 01/09/14 PLC 10.5.7.5 (201939) Remove DetailOrderEndDate from purchase order key lookup line because print orders do not have end dates.
|| 01/21/14 MAS 10.5.7.6 (203357) When creating matching VD lines for POD revisions, set the VD.LastVoucher flag and make sure the POD.AppliedCost is updated or each POD revisions
|| 01/22/14 GHL 10.5.7.6 Added update of PTotalCost in direct insert in tVoucherDetail
|| 03/04/15 PLC 10.5.9.0 Updated Department Key in seral places to make sure we are getting the data when needed.
*/

Declare @VoucherKey int, @VendorKey int, @TermsPercent decimal(24,4), @TermsDays int, @TermsNet int, @APAccountKey int, @ClassKey int
Declare @PODetailKey int, @POKey int, @VoucherDetailKey int, @RetVal int, @RequireItems tinyint, @InvoiceLineKey int
Declare @ExpenseAccountKey int, @ProjectKey int, @TaskKey int, @ItemKey int, @TotalCost money, @TotGross money, @TotBillableCost money, @RequireAccounts tinyint
declare @IOClientLink smallint
DECLARE	@AutoApproveExternalInvoices tinyint, @Status smallint
declare @NonBillable tinyint
declare @AmountBilled money
declare @GLCompanyKey int, @OfficeKey int, @DepartmentKey int
declare @RequireTasks tinyint
declare @Active tinyint
declare @UseClientCosting tinyint 
declare @POClientCosting tinyint 
declare	@Markup decimal(24,4)
declare	@VDMarkup decimal(24,4)
declare	@UnitCost money
declare @UnitRate money
declare @PostingDate smalldatetime
declare @UseClearedDate int
declare @PODTotalCost money
declare @LineNumber int, @BillAt int, @Closed tinyint
declare @DetailOrderDate smalldatetime, @DetailOrderEndDate smalldatetime
declare @PODTotalGross money, @PODTotalBilled money
declare @VDLineNumber int
declare @PODAdjDetailKey int

select @VendorKey = CompanyKey
	  ,@Active = isnull(Active, 0) 
	  ,@APAccountKey = DefaultAPAccountKey 	
from tCompany (nolock) 
where OwnerCompanyKey = @CompanyKey 
and Vendor = 1 
and VendorID = @VendorID

if @VendorKey is null
	Return -1

if @Active <> 1
	return -4

if exists(select 1 from tVoucher (nolock)
           where CompanyKey = @CompanyKey 
             and InvoiceNumber = @InvoiceNumber
             and VendorKey = @VendorKey
             and Posted = 1)
	return -12

select @VoucherKey = min(VoucherKey) 
  from tVoucher (nolock) 
 where CompanyKey = @CompanyKey
   and VendorKey = @VendorKey
   and InvoiceNumber = @InvoiceNumber

select @IOClientLink = isnull(IOClientLink,1)
      ,@RequireAccounts = RequireGLAccounts
      ,@RequireTasks = RequireTasks 
      ,@UseClientCosting = IOUseClientCosting  
      ,@UseClearedDate = ISNULL(UseClearedDate, 0) 
  from tPreference (nolock) where CompanyKey = @CompanyKey

If @UseClearedDate > 0 
	Select @PostingDate = @ClearedDate
else
	Select @PostingDate = @InvoiceDate
	
	
if @VoucherKey is null
BEGIN

	if @InvoiceDate is null
		return -2
	if @InvoiceNumber is null
		return -3

 -- Use the company defualt APAccountKey if the vendor didn't have one setup
	If 	@APAccountKey IS NULL	
		Select	@APAccountKey = DefaultAPAccountKey,
				@AutoApproveExternalInvoices = AutoApproveExternalInvoices 
		from	tPreference (NOLOCK) 
		Where	CompanyKey = @CompanyKey
	else
		Select @AutoApproveExternalInvoices = AutoApproveExternalInvoices 
		from	tPreference (NOLOCK) 
		Where	CompanyKey = @CompanyKey
	

	SELECT	@ClassKey = ClassKey,
			@ProjectKey = ProjectKey,
			@GLCompanyKey = GLCompanyKey,
			@OfficeKey = OfficeKey
	FROM	tMediaEstimate (nolock)
	WHERE	EstimateID = @EstimateID
	AND		CompanyKey = @CompanyKey

	Select @TermsPercent = ISNULL(TermsPercent, 0), @TermsDays = ISNULL(TermsDays, 0), @TermsNet = ISNULL(TermsNet, 0) 
		From tCompany (NOLOCK)  Where CompanyKey = @VendorKey

	-- temporary fix until 8.4 is released
	select @DueDate = null

	-- currently SBMS does not allow the due date to be entered, will always be null
	Select @DueDate = ISNULL(@DueDate, DATEADD(day, @TermsNet, @InvoiceDate))

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
		NULL,
		@ProjectKey,
		@UserKey,
		@APAccountKey,
		@ClassKey,
		NULL,
		NULL,
		@GLCompanyKey,
		@OfficeKey,
		0, -- OpeningTransaction
		0,
		null, -- CurrencyID
		1,    -- ExchangeRate
		null, -- PCurrencyID
		1,    -- PExchangeRate
		null, -- CompanyMediaKey		
		@VoucherKey output

	if @RetVal = -1
		Return -10  --Invoice number already exists

	if @RetVal = -2
		Return -11  --Project status is not accepting costs

	IF @AutoApproveExternalInvoices = 1
		SELECT @Status = 4
	ELSE
		SELECT @Status = 2	

	Update tVoucher Set LinkID = @LinkID, Status = @Status Where VoucherKey = @VoucherKey


END

-- Begin Insertion of Line ***************************************************************************

select @VoucherDetailKey = min(VoucherDetailKey) 
  from tVoucherDetail (nolock) 
 where VoucherKey = @VoucherKey 
   and LinkID = @DetailLinkID

if @VoucherDetailKey is null
BEGIN
	Select	@PODetailKey = Min(PurchaseOrderDetailKey)
	from	tPurchaseOrderDetail pod (NOLOCK) 
	inner join tPurchaseOrder po on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where	po.VendorKey = @VendorKey and pod.LinkID = @PODetailLinkID

	if @PODetailKey is null
		Return -1002
	
	Select @TotBillableCost = ISNULL(SUM(ISNULL(BillableCost, 0)), 0) 
	From tVoucherDetail (nolock) 
	Where PurchaseOrderDetailKey = @PODetailKey

	Select	 @POKey = pod.PurchaseOrderKey
			,@ProjectKey = pod.ProjectKey
			,@TaskKey = pod.TaskKey
			,@ItemKey = pod.ItemKey
			,@DepartmentKey = pod.DepartmentKey
			,@ClassKey = pod.ClassKey
			,@TotGross = 
				case po.BillAt
					when 0 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 1 then ISNULL(pod.TotalCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 2 then (ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0)) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0)
				end 
			,@AmountBilled = isnull(pod.AmountBilled,0)
			,@Closed = ISNULL(pod.Closed, 0)
			,@LineNumber = pod.LineNumber
			,@POClientCosting = po.UseClientCosting
			,@DepartmentKey = pod.DepartmentKey
	From tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where PurchaseOrderDetailKey = @PODetailKey

	if exists(Select 1 from tPurchaseOrder (nolock) Where PurchaseOrderKey = @POKey and Status < 4)
		return -1003

	if @IOClientLink = 1 and ISNULL(@ProjectKey, 0) = 0
		Return -1004

	IF @IOClientLink = 1 and ISNULL(@TaskKey, 0) = 0 and @RequireTasks = 1
		Return -1005

	Select @RequireItems = RequireItems from tPreference (NOLOCK) Where CompanyKey = @CompanyKey and RequireItems = 1
	if @RequireItems = 1
		if @ItemKey is null
			return -1006

	--if project was specified, validate that it is active and is a billable project
	if @IOClientLink = 1
		if isnull(@ProjectKey, 0) > 0
			select @NonBillable = isnull(NonBillable, 0) 
			from tProject (nolock)
			where ProjectKey = @ProjectKey

		begin
			if ISNULL(@ItemKey, 0) > 0
				Select @ExpenseAccountKey = ExpenseAccountKey from tItem (NOLOCK) Where ItemKey = @ItemKey

			if ISNULL(@ExpenseAccountKey, 0) = 0
				Select @ExpenseAccountKey = DefaultExpenseAccountKey from tCompany (NOLOCK) Where CompanyKey = @VendorKey

			if ISNULL(@ExpenseAccountKey, 0) = 0
				Select @ExpenseAccountKey = DefaultExpenseAccountKey from tPreference (NOLOCK) Where CompanyKey = @CompanyKey
		end

	if @RequireAccounts = 1 and ISNULL(@ExpenseAccountKey, 0) = 0
		Return -7
		
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
			Select @UnitCost = 
				case @CalCltNetType
					when 100 then @TotalNet	-- New Interactive Order. The Net that goes into WMJ is always the SBMS Vendor Net
					else @IlCost * (1 - @IlNetPercent)
				end
			
			Select @UnitRate =
				case @CalCltNetType
					when 100 then @TotalClientGross	-- New Interactive Order. The WMJ Gross is Vendor Gross from SBMS if using Client Costing.
					else @IlCost * @IlCltNetPercent
				end
			
			if @UnitRate = 0
				Select @Markup = 0
			else		
				Select @Markup = (1 - ROUND(@UnitCost / @UnitRate, 4)) * 100
		end
	else
		begin
			Select @UnitCost = 
				case @CalCltNetType
					when 100 then @TotalNet	-- New Interactive Order. The Net that goes into WMJ is the SBMS Vendor Net.
					else @IlCost * (1 - @IlNetPercent)			
				end
				
			Select @UnitRate = 
				case @CalCltNetType
					when 100 then @TotalClientNet	-- New Interactive Order. if NOT using Client Costing, the SBMS Client Net Cost will go in as the WMJ Gross
					else @IlCost
				end						

			Select @Markup = @IlNetPercent * 100
		end  
	select @TotalCost = @Quantity * ROUND(@UnitCost,2)
	
	select @VDMarkup = dbo.fCommissionToMarkup(@Markup)     

	-- If using Projects/Tasks - Check to see if the associated Task is completed
	if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
		BEGIN
			exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',@VoucherDetailKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
			if @RetVal < -1 
				return -10031 
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
		@TotalCost, --Verify Calculation
		NULL,
		1,
		null, -- Markup, because it is null, it will be recalculated
		@TotGross, --Verify Calculation
		@ExpenseAccountKey,
		0,
		0,
		0,
		@OfficeKey,
		@DepartmentKey,
		1, -- @CheckProject
		@Markup, -- Commission
		null, -- GrossAmount, because it is null, it will be recalculated
		null,        -- PCurrencyID
		1,           -- PExchangeRate
		@TotalCost,  -- PTotalCost
		@VoucherDetailKey output

	if @RetVal = -3
		Return -10010 --Voucher is already posted
	if @RetVal = -2
		Return -10011 --Project Status does not allow additional costs
	if @RetVal = -1
		Return -10012 --Problem inserting line

	-- sptVoucherDetailInsert may have marked this line as billed, do no change it
	if @MarkInvoiceAsBilled = 1
		update tVoucherDetail 
		set LinkID = @DetailLinkID 
		where VoucherDetailKey = @VoucherDetailKey
	else
		-- sptVoucherDetailInsert may have marked this line as billed, change it back 
		update tVoucherDetail 
		set InvoiceLineKey = null
		   ,DateBilled = null
		   ,LinkID = @DetailLinkID
		where VoucherDetailKey = @VoucherDetailKey	

END
ELSE
BEGIN
	--voucher detail exists

	--make sure voucher has not already been posted
	if (select Posted
		from tVoucher (nolock)
		where VoucherKey = @VoucherKey) = 1
			return -10010 --voucher has already been posted, do not update

	Select @PODetailKey = PurchaseOrderDetailKey, @InvoiceLineKey = InvoiceLineKey from tVoucherDetail (NOLOCK) Where VoucherDetailKey = @VoucherDetailKey
	if ISNULL(@PODetailKey, 0) = 0
		return -10020

	if @InvoiceLineKey is not null
		return -10030

	Select @TotBillableCost = ISNULL(SUM(ISNULL(BillableCost, 0)), 0) 
	From tVoucherDetail (nolock) 
	Where PurchaseOrderDetailKey = @PODetailKey and VoucherDetailKey <> @VoucherDetailKey
	
	
	Select	 @POKey = pod.PurchaseOrderKey
			,@ProjectKey = pod.ProjectKey
			,@TaskKey = pod.TaskKey
			,@TotGross = 
				case po.BillAt
					when 0 then ISNULL(pod.BillableCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0) 
					when 1 then ISNULL(pod.TotalCost, 0) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0)
					when 2 then (ISNULL(pod.BillableCost, 0) - ISNULL(pod.TotalCost, 0)) - ISNULL(pod.AmountBilled, 0) - ISNULL(@TotBillableCost, 0)
				end 	
			,@POClientCosting = po.UseClientCosting
			,@DepartmentKey = pod.DepartmentKey
	From tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
	Where PurchaseOrderDetailKey = @PODetailKey

	-- If using Projects/Tasks - Check to see if the associated Task is completed
	if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
		BEGIN
			exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',@VoucherDetailKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
			if @RetVal < -1 
				return -10031 
		END
		
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
			Select @UnitCost = 
				case @CalCltNetType
					when 100 then @TotalNet	-- New Interactive Order. The Net that goes into WMJ is always the SBMS Vendor Net
					else @IlCost * (1 - @IlNetPercent)
				end
				
			Select @UnitRate =
				case @CalCltNetType
					when 100 then @TotalClientGross	-- New Interactive Order. The WMJ Gross is Vendor Gross from SBMS if using Client Costing.
					else @IlCost * @IlCltNetPercent
				end	

			if @UnitRate = 0
				Select @Markup = 0
			else			
			Select @Markup = (1 - ROUND(@UnitCost / @UnitRate, 4)) * 100
		end
	else
		begin
			Select @UnitCost = 
				case @CalCltNetType
					when 100 then @TotalNet	-- New Interactive Order. The Net that goes into WMJ is the SBMS Vendor Net.
					else @IlCost * (1 - @IlNetPercent)			
				end
			
			Select @UnitRate = 
				case @CalCltNetType
					when 100 then @TotalClientNet	-- New Interactive Order. if NOT using Client Costing, the SBMS Client Net Cost will go in as the WMJ Gross
					else @IlCost
				end	

			Select @Markup = @IlNetPercent
		end  
	select @TotalCost = @Quantity * ROUND(@UnitCost,2)
	
	select @VDMarkup = dbo.fCommissionToMarkup(@Markup)     

	Update tVoucherDetail
	Set
		Quantity = @Quantity,
		Markup = @VDMarkup,
		Commission = @Markup,
		UnitCost = @UnitCost,
		TotalCost = @TotalCost,
		PTotalCost = @TotalCost,
		BillableCost = @TotGross,
		GrossAmount = ROUND(@TotalCost * (1 + @VDMarkup/100), 2),
		ShortDescription = @Comments
	Where
		VoucherDetailKey = @VoucherDetailKey
END

-- (174039)Find the total net cost for POD line and all of it's revisions.
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
--						And pod.DetailOrderEndDate = @DetailOrderEndDate
						And ISNULL(pod.AutoAdjustment, 0) > 0
						And pod.PurchaseOrderDetailKey > @PODAdjDetailKey

						if @PODAdjDetailKey is null
							break

						Select	@PODTotalCost = isnull(pod.TotalCost,0), 
								@PODTotalGross = isnull(pod.BillableCost,0), 
								@PODTotalBilled = isnull(pod.AmountBilled,0),
								@POUnitCost = isnull(pod.UnitCost, 0),
								@NewPODAdjQuantity = ISNULL(pod.Quantity, 0),
								@DepartmentKey = pod.DepartmentKey
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
	
return 1
GO
