USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSmartPlusBCInvoiceDetail]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSmartPlusBCInvoiceDetail]
(
	@VoucherKey int,
	@UserKey int,
	@LinkID varchar(50),
	@PODetailLinkID varchar(50),
	@DollarsApprovedGross decimal(24,4),
	@DollarsApprovedNet decimal(24,4),
	@Comments varchar(500),
	@TotalInvoiceLines int,
	@PODetailLineDate smalldatetime,
	@CMP tinyint = 0		-- syncing from CMP?  WMJ = 0 / CMP = 1
	
)

as --Encrypt

/*
|| When     Who Rel      What
|| 09/28/06 CRG 8.35     Added parameter for sptVoucherDetailInsert
|| 12/05/06 RTC 8.4      Check to make sure an existing vendor invoice has not already been posted
|| 02/06/07 RTC 8.4.0.3  Do not post to WIP if project is not specified or project is specified and is non-billable
|| 03/15/07 GWG 8.4.1    Added conditional logic for prerecognizing vendor invoice revenue (medialogic)
|| 04/02/07 RTC 8.4.1.1  Always set quantity to one since vendor invoice is at spot level or bottom line.
||                       Calculate Open Gross properly considering number of lines and any prebill amounts.
|| 05/17/07 RTC 8.4.2.2  (#9239) If client link is through estimate do not check for project and project billable
|| 06/05/07 RTC 8.4.3    (#9428) If order is pre-billed, do not post to WIP
|| 10/11/07 BSH 8.5      Insert Office and Department to InvoiceLine, removed all WIP logic.
|| 01/31/08 GHL 8.503    (20244) Added sptVoucherDetailInsert.CheckProject parameter so that the checking of the project 
||                       can be bypassed when creating vouchers from expense receipts
|| 08/06/08 GHL 10.0.0.6 (30771) Added pod.Closed = 0 to where clause when hunting for order details
||                       The problem was when several PODs have same linkID, all VDs point to the same POD
||                       and only one POD was closed   
|| 08/20/08 RTC 10.0.0.7 (#32068, 32757) Changed the way open gross is calculated for broadcast invoices when they span more than one broadcast week. 
|| 01/14/09 GWG 10.016   (43852) Modified the recalc of sales tax to take into account direct editing of sales tax
|| 06/01/09 RTC 10.0.2.6 (52114,51394) Auto-generate order lines if invoice lines cannot find any open order lines to apply to
|| 09/21/09 GHL 10.5      Using now sptVoucherRecalcAmounts (taxes editable now on the voucher lines)
|| 11/11/09 MAS 10.5.1.3 (47035)
|| 04/12/10 MAS 10.5.2.1 (78683) Added an ISNULL to @DollarsApprovedNet
|| 05/11/10 MAS 10.5.4.4 (111164) For some reason the pod.Quantity records were zero - Added isnull(nullif(pod.Quantity,0), 1))
|| 10/31/12 GHL 10.5.6.2 Added rounding of net and gross before updating recs
|| 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @Program(ShortDescription) from 200 to 300
|| 03/25/13 MAS 10.5.6.6 (170140)Added @PODetailLineDate so that we can include the PO Detail Line date from the .dat file when trying to match
||                        invoices line to the order line.  
|| 05/01/13 MAS 10.5.6.7 (172249)Removed the @PODetailLineDate filter when trying to Auto GenerateInvoice Order Lines
|| 10/16/13 GHL 10.5.7.3  Added GrossAmount and Commission when calling sptVoucherDetailInsert
|| 11/22/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptVoucherDetailInsert
|| 12/17/13 GHL 10.5.7.4  Added PCurrency and PExchangeRate parms when calling sptPurchaseOrderDetailInsert
|| 04/29/14 RLB 10.5.7.9 (214240) increasing short description
|| 07/01/14 PLC 10.5.8.1 (220195) allow all bonus to attach to a closed week with zero unit cost
|| 11/24/14 PLC 10.5.8.1 (236060) fixed the commision calc
*/

declare @VoucherDetailKey int
declare @CompanyKey int
declare @VendorKey int
declare @TotalCost decimal(24,4)
declare @TotalGross decimal(24,4)
declare @Commission decimal(24,4)
declare @Markup decimal(24,4)
declare @POLinkID varchar(50)
declare @PODetailKey int
declare @POKey int
declare @RetVal int
declare @RequireItems tinyint
declare @RequireTasks tinyint
declare @ExpenseAccountKey int
declare @ProjectKey int
declare @TaskKey int
declare @ItemKey int, @OfficeKey int, @DepartmentKey int
declare @RequireAccounts tinyint
declare @BCClientLink smallint
declare @NonBillable tinyint
declare @AmountBilled money
DECLARE	@SalesTax1Amount money, @SalesTax2Amount money

declare @AutoGenerateInvoiceOrderLines tinyint
declare @PODCopyLineKey int
declare @NewKey int
declare @LineNumber int
declare @ClassKey int
declare @Program varchar(max)
declare @PODComments varchar(1000)
declare @StartDate smalldatetime
declare @EndDate smalldatetime
declare @UserDate1 smalldatetime
declare @UserDate2 smalldatetime
declare @UserDate3 smalldatetime
declare @UserDate4 smalldatetime
declare @UserDate5 smalldatetime
declare @UserDate6 smalldatetime
declare @OrderDays varchar(50)
declare @OrderTime varchar(50)
declare @OrderLength varchar(50)
	

select @VendorKey = VendorKey,
       @CompanyKey = CompanyKey,
       @POLinkID = LinkID
  from tVoucher (nolock) 
 where VoucherKey = @VoucherKey

if @VendorKey is null
	return -1
	
select @BCClientLink = isnull(BCClientLink,1)
      ,@RequireItems = RequireItems
      ,@RequireTasks = RequireTasks
      ,@RequireAccounts = RequireGLAccounts    
      ,@AutoGenerateInvoiceOrderLines = isnull(AutoGenerateInvoiceOrderLines, 0)    
  from tPreference (nolock)
 where CompanyKey = @CompanyKey
 	
select @VoucherDetailKey = min(VoucherDetailKey) 
  from tVoucherDetail (nolock)
 where VoucherKey = @VoucherKey 
   and LinkID = @LinkID

select @TotalCost = ISNULL(@DollarsApprovedNet, 0)
	   
-- check for zero cost spots
if @TotalCost = 0
	select @Commission = 0
else
	select @Commission = (1 - (@TotalCost/@DollarsApprovedGross)) * 100
select @Markup = dbo.fCommissionToMarkup(@Commission)     
               	
if @VoucherDetailKey is null
	begin
		select @PODetailKey = min(PurchaseOrderDetailKey) 
		  from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		 where po.VendorKey = @VendorKey
		   and po.LinkID  = @POLinkID 
		   and pod.LinkID = @PODetailLinkID
		   and po.CompanyKey = @CompanyKey
		   and (pod.DetailOrderDate <= @PODetailLineDate and pod.DetailOrderEndDate >= @PODetailLineDate)
		   -- Added so that we cover all PODs, one after the other, after closing each one of them
		   -- The problem is when we have several PODs with the same LinkID and LineNumber
		   -- All voucher lines point to the first POD 
		   and (pod.Closed = 0 or pod.UnitCost=0)
							 
		 
		-- handle when no order detail found to apply invoice to
		if @PODetailKey is null
			begin
				-- does company preference indicate to generate order lines? 
				if @AutoGenerateInvoiceOrderLines = 1
					begin
						select @PODCopyLineKey = max(PurchaseOrderDetailKey) 
						from tPurchaseOrderDetail pod (nolock) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
						where po.VendorKey = @VendorKey
						and po.LinkID  = @POLinkID 
						and pod.LinkID = @PODetailLinkID
						and po.CompanyKey = @CompanyKey
						
						if @PODCopyLineKey is null
							return -2
												
						select @POKey = PurchaseOrderKey 
								,@ProjectKey = ProjectKey
								,@TaskKey = TaskKey
								,@ItemKey = ItemKey
								,@ClassKey = ClassKey
								,@Program = ShortDescription
								,@Commission = Markup
								,@PODComments = LongDescription
								,@StartDate = DetailOrderDate
								,@EndDate = DetailOrderEndDate
								,@UserDate1 = UserDate1
								,@UserDate2 = UserDate2
								,@UserDate3 = UserDate3
								,@UserDate4 = UserDate4
								,@UserDate5 = UserDate5
								,@UserDate6 = UserDate6
								,@OrderDays = OrderDays
								,@OrderTime = OrderTime
								,@OrderLength = OrderLength
								,@OfficeKey = OfficeKey
								,@DepartmentKey = DepartmentKey
							from tPurchaseOrderDetail (nolock)
							where PurchaseOrderDetailKey = @PODCopyLineKey
							
						select @LineNumber = max(LineNumber) + 1
						from tPurchaseOrderDetail (nolock)
						where PurchaseOrderKey = @POKey
													
						exec @RetVal = sptPurchaseOrderDetailInsert
							@POKey,
							@LineNumber,
							@ProjectKey,
							@TaskKey,
							@ItemKey,
							@ClassKey,
							@Program,
							1, --Quantity
							0, --UnitRate
							null,
							0,  --TotalCost
							null,
							1,
							@Commission,
							0, --BillableCost
							@PODComments,
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
							0, -- GrossAmount
							null, -- PCurrencyID
							1, --PExchangeRate
							0, --PTotalCost
							@NewKey output
								
						if @RetVal < 0
							return -2
							
						update tPurchaseOrderDetail 
						set LinkID = null 
						where PurchaseOrderDetailKey = @NewKey	
						
						select @PODetailKey = @NewKey
					end
				else
					return -2
			end
			
			
		Select	 @POKey = pod.PurchaseOrderKey
				,@ProjectKey = pod.ProjectKey
				,@TaskKey = pod.TaskKey
				,@ItemKey = pod.ItemKey
				,@OfficeKey = pod.OfficeKey
				,@DepartmentKey = pod.DepartmentKey
				,@TotalGross = 
					case po.BillAt
						when 0 then @DollarsApprovedGross - (ISNULL(pod.AmountBilled, 0) / isnull(nullif(pod.Quantity,0), 1))
						when 1 then @DollarsApprovedNet - (ISNULL(pod.AmountBilled, 0) / isnull(nullif(pod.Quantity,0), 1))
						when 2 then (@DollarsApprovedGross - @DollarsApprovedNet) - (ISNULL(pod.AmountBilled, 0) / isnull(nullif(pod.Quantity,0), 1))
					end 	
				,@AmountBilled = isnull(pod.AmountBilled,0)					
		From tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		Where PurchaseOrderDetailKey = @PODetailKey
       		
		if exists(select 1 from tPurchaseOrder (nolock) where PurchaseOrderKey = @POKey and Status < 4)
			return -3
			
        if @BCClientLink = 1 --	link to client through project (required)
	        begin
		  if isnull(@ProjectKey, 0) = 0
			       return -4
			
		        if isnull(@TaskKey, 0) = 0
			        if @RequireTasks = 1
				        return -5
	        end			
		   
		if @RequireItems = 1
			if @ItemKey is null
				return -6
				
		--if project was specified, validate that it is active and is a billable project
		if @BCClientLink = 1
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
			
		-- If using Projects/Tasks - Check to see if the associated Task is completed
		if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
			BEGIN
				exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',@VoucherDetailKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
				if @RetVal < -1 
					return -22 
			END
					
		exec @RetVal = sptVoucherDetailInsert
			@VoucherKey,
			@PODetailKey,
			null,
			@ProjectKey,
			@TaskKey,
			@ItemKey,
			null,
			@Comments,
			1,  -- always set quantity to 1 since the line is at spot level or bottom line, either way it s/b 1  
			null,
			null,
			@TotalCost,
			null,
			1,
			null, --Markup, because it is null, will be recalculated in sp
			@TotalGross,
			@ExpenseAccountKey,
			0,
			0,
			0,
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
			return -10 --Voucher is already posted
		if @RetVal = -2
			return -11 --Project Status does not allow additional costs
		if @RetVal = -1
			return -12 --Problem inserting line
			
		update tVoucherDetail 
		   set LinkID = @LinkID 
		 where VoucherDetailKey = @VoucherDetailKey
	end
else
	begin
	--voucher detail exists

	--make sure voucher has not already been posted
	if (select Posted
		from tVoucher (nolock)
		where VoucherKey = @VoucherKey) = 1
			return -10 --voucher has already been posted, do not update

		select @PODetailKey = PurchaseOrderDetailKey
		  from tVoucherDetail (nolock)
		 where VoucherDetailKey = @VoucherDetailKey
		 
		if isnull(@PODetailKey, 0) = 0
			return -20
			
		if exists(select 1 from tVoucherDetail (nolock) 
		           where VoucherDetailKey = @VoucherDetailKey
		             and (WriteOff = 1 or InvoiceLineKey >= 0))
			return -21

		Select   @ProjectKey = pod.ProjectKey
				,@TaskKey = pod.TaskKey
				,@TotalGross = 
				case po.BillAt
					when 0 then @DollarsApprovedGross - (ISNULL(pod.AmountBilled, 0) / isnull(pod.Quantity, 1))
					when 1 then @DollarsApprovedNet - (ISNULL(pod.AmountBilled, 0) / isnull(pod.Quantity, 1))
					when 2 then (@DollarsApprovedGross - @DollarsApprovedNet) - (ISNULL(pod.AmountBilled, 0) / isnull(pod.Quantity, 1))
				end 								
		From tPurchaseOrderDetail pod (NOLOCK) inner join tPurchaseOrder po (nolock) on pod.PurchaseOrderKey = po.PurchaseOrderKey
		Where PurchaseOrderDetailKey = @PODetailKey

		-- If using Projects/Tasks - Check to see if the associated Task is completed
		if ISNULL(@CMP,0) = 0 and ISNULL(@TaskKey,0) > 0
			BEGIN
				exec @RetVal = spTaskValidatePercComp 'tVoucherDetail',@VoucherDetailKey, NULL, @ProjectKey, NULL, @TaskKey, @UserKey
				if @RetVal < -1 
					return -22 
			END
						
		update tVoucherDetail
		   set Markup = @Markup,
		       Commission = @Commission,
			   TotalCost = round(@TotalCost,2),
			   PTotalCost = round(@TotalCost,2),
			   BillableCost = round(@TotalGross,2),
			   GrossAmount = ROUND(@TotalCost * (1 + @Markup/100), 2),
			   ShortDescription = @Comments
			   
		 where VoucherDetailKey = @VoucherDetailKey

		EXEC sptVoucherRecalcAmounts @VoucherKey


		exec sptPurchaseOrderDetailUpdateAppliedCost @PODetailKey

	end

return @VoucherDetailKey
GO
