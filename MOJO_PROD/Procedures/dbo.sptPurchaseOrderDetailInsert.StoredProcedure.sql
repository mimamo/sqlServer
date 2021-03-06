USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailInsert]
	@PurchaseOrderKey int,
	@LineNumber int,
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
	@GrossAmount money = null,
	@PCurrencyID varchar(10) = null,
	@PExchangeRate decimal(24,7) = 1,
	@PTotalCost money = null,  
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel    What
|| 04/13/07 BSH 8.4.5  DateUpdated needed to be updated. 
|| 07/16/07 BSH 8.5    (9659)Insert OfficeKey, DepartmentKey
|| 1/21/09  GWG 10.018 Added Rounding protection on cost and gross
|| 07/01/11 GHL 10.546 (111482) Added call to sptPurchaseOrderRollupAmounts for tax amounts 
|| 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @ShortDescription from 200 to 300
|| 12/17/13 GHL 10.5.7.5 Added currency parameters
|| 12/30/13 CRG 10.5.7.5 Fixed Line Number logic for Interactive orders
|| 04/23/14 RLB 10.5.7.9 (209351) will now allow adding lines to a PO if a line on it is on a voucher also making description field larger for (214240)
|| 09/03/14 GHL 10.5.8.4 (228377) If PTotalCost is null, set PTotalCost = Round(TotalCost, 2)
||                       i.e. not PTotalCost = TotalCost
*/

declare @POKind smallint
declare @FlightInterval tinyint
declare @FlightStartDate smalldatetime
declare @FlightEndDate smalldatetime
declare @DefaultDate smalldatetime

	select @DefaultDate = cast(datepart(yyyy,getdate()) as varchar(4)) + '-' + cast(datepart(mm,getdate()) as varchar(2)) + '-' + cast(datepart(dd,getdate()) as varchar(2)) 

	select @POKind = POKind
	      ,@FlightInterval = isnull(FlightInterval,3)
	      ,@FlightStartDate = isnull(FlightStartDate,@DefaultDate)
	      ,@FlightEndDate = isnull(FlightEndDate,isnull(FlightStartDate,@DefaultDate))
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
/*	 
	if @POKind = 0
		IF EXISTS (SELECT 1
				FROM   tVoucherDetail vd (NOLOCK)
						,tPurchaseOrderDetail pod (NOLOCK)
						,tPurchaseOrder po (NOLOCK)
				WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
				AND    po.PurchaseOrderKey = pod.PurchaseOrderKey
							AND    pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey)
			RETURN -1
*/
	
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
	
	if @POKind in (1, 4)
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
		select @GrossAmount = ROUND(@BillableCost, 2)

	if @PTotalCost is null
		select @PTotalCost = ROUND(@TotalCost, 2)

	if isnull(@PExchangeRate, 0) <= 0
		select @PExchangeRate = 1

	INSERT tPurchaseOrderDetail
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
		GrossAmount,
		PCurrencyID,
		PExchangeRate,
		PTotalCost
		)

	VALUES
		(
		@PurchaseOrderKey,
		@NextNum,		-- @LineNumber,
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
		@GrossAmount,
		@PCurrencyID,
		@PExchangeRate,
		@PTotalCost
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey

	EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey 
		
	RETURN 1
GO
