USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPurchaseOrderDetailQuoteInsert]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPurchaseOrderDetailQuoteInsert]
	@PurchaseOrderKey int,
	@LineNumber int,
	@ProjectKey int,
	@TaskKey int,
	@ItemKey int,
	@ClassKey int,
	@ShortDescription varchar(300),
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
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When     Who Rel   What
|| 03/17/11 RLB 10542 (106252) a Clone of sptPurchaseOrderDetailInsert but with added Get Markup calls i removed the IO an BO called because only a PO will be created from this screen
|| 07/07/11 GHL 10.546 (111482) calling now sptPurchaseOrderRollupAmounts instead of recalculating the taxes
|| 08/10/11 RLB 10.547 (118407) passing back the New POD Key so i can update estimate expenses
|| 12/03/12 MAS 10.5.6.2 (161425)Changed the length of @ShortDescription from 200 to 300
|| 01/10/14 GHL 10.5.7.6 Added setting of CurrencyID
|| 10/21/14 GHL 10.5.8.5 (233422) Getting now Exchange Rate
*/

declare @POKind smallint
declare @FlightInterval tinyint
declare @FlightStartDate smalldatetime
declare @FlightEndDate smalldatetime
declare @DefaultDate smalldatetime
declare @PCurrencyID varchar(10)
declare @PExchangeRate decimal(24,7)
declare @RateHistory decimal(24,7)
declare @CompanyKey int
declare @GLCompanyKey int
declare @PTotalCost money
declare @GrossAmount money

	select @DefaultDate = cast(datepart(yyyy,getdate()) as varchar(4)) + '-' + cast(datepart(mm,getdate()) as varchar(2)) + '-' + cast(datepart(dd,getdate()) as varchar(2)) 

	select @POKind = POKind
	      ,@FlightInterval = isnull(FlightInterval,3)
	      ,@FlightStartDate = isnull(FlightStartDate,@DefaultDate)
	      ,@FlightEndDate = isnull(FlightEndDate,isnull(FlightStartDate,@DefaultDate))
		  ,@PCurrencyID = PCurrencyID
		  ,@CompanyKey = CompanyKey
		  ,@GLCompanyKey = GLCompanyKey
	  from tPurchaseOrder (nolock)
	 where PurchaseOrderKey = @PurchaseOrderKey
	 
	if isnull(@PCurrencyID, '') = ''
		select @PCurrencyID = null

	if @PCurrencyID is not null
		exec sptCurrencyGetRate @CompanyKey, @GLCompanyKey, @PCurrencyID, @DefaultDate, @PExchangeRate output, @RateHistory output
	
	if isnull(@PExchangeRate, 0) <=0
		select @PExchangeRate = 1

	if @POKind = 0
		IF EXISTS (SELECT 1
				FROM   tVoucherDetail vd (NOLOCK)
						,tPurchaseOrderDetail pod (NOLOCK)
						,tPurchaseOrder po (NOLOCK)
				WHERE  po.PurchaseOrderKey = @PurchaseOrderKey
				AND    po.PurchaseOrderKey = pod.PurchaseOrderKey
							AND    pod.PurchaseOrderDetailKey = vd.PurchaseOrderDetailKey)
			RETURN -1
	
	           
		
	if ISNULL(@ProjectKey, 0) > 0
		IF NOT EXISTS(Select 1 from tProject p (nolock) inner join tProjectStatus ps (nolock) on p.ProjectStatusKey = ps.ProjectStatusKey
			Where p.ProjectKey = @ProjectKey and ps.ExpenseActive = 1)
			Return -3
			
	DECLARE @NextNum as int, @GetMarkupFrom int, @ItemMarkUp decimal(24,4), @ClientKey int, @ItemRateSheetKey int, @UseUnitRate tinyint

	-- Default value for NextNum
	SELECT @NextNum = ISNULL(Max(LineNumber),0) + 1 FROM tPurchaseOrderDetail (NOLOCK) WHERE PurchaseOrderKey = @PurchaseOrderKey
	
	--- Find Markup if there is a project or Item 
	
	if ISNULL(@ItemKey, 0) > 0
		SELECT @UseUnitRate = ISNULL(UseUnitRate, 0) from tItem (nolock) where ItemKey = @ItemKey
	
	if ISNULL(@ProjectKey, 0) > 0
		BEGIN
			
			SELECT @GetMarkupFrom = GetMarkupFrom, @ClientKey = ClientKey, @ItemRateSheetKey = ItemRateSheetKey FROM tProject (nolock) where ProjectKey = @ProjectKey
			
			SELECT @ItemMarkUp =
				CASE 
					WHEN @GetMarkupFrom = 1 then (Select ItemMarkup from tCompany (nolock) where CompanyKey = @ClientKey)
					WHEN @GetMarkupFrom = 2 then (Select ItemMarkup from tProject (nolock) where ProjectKey = @ProjectKey)
					WHEN @GetMarkupFrom = 3 then CASE ISNULL(@UseUnitRate, 0)
													when 1 then (Select UnitRate from tItem (nolock) where ItemKey = @ItemKey)
													else (Select Markup from tItem (nolock) where ItemKey = @ItemKey)
												 END
					WHEN @GetMarkupFrom = 4 then CASE ISNULL(@UseUnitRate, 0)
														when 1 then (Select UnitRate from tItemRateSheetDetail (nolock) where ItemRateSheetKey = @ItemRateSheetKey and ItemKey = @ItemKey)
														else (Select Markup from tItemRateSheetDetail (nolock) where ItemRateSheetKey = @ItemRateSheetKey and ItemKey = @ItemKey)
												 END
					WHEN @GetMarkupFrom = 5 then (select Markup from tTask (nolock) where TaskKey = @TaskKey)
				end
				
				if ISNULL(@ItemMarkUp, 0) <> 0
					if ISNULL(@UseUnitRate, 0) = 1
						BEGIN
							SELECT @UnitRate = @ItemMarkUp
							SELECT @Markup = ((@ItemMarkUp - @UnitCost)/ @UnitCost) * 100.0
							SELECT @BillableCost = @TotalCost + (@UnitCost * @Quantity * (@Markup / 100.0))
						END
					ELSE
						BEGIN
						 SELECT @Markup = @ItemMarkUp
						 SELECT @UnitRate = @UnitCost * (1 + (@Markup / 100.0))
						 SELECT @BillableCost = @TotalCost + (@UnitCost * @Quantity * (@Markup / 100.0))
						END
		
		END
	ELSE
		if ISNULL(@ItemKey, 0) > 0
			if ISNULL(@UseUnitRate, 0) = 1
				BEGIN
					SELECT @ItemMarkUp = UnitRate from tItem (nolock) where ItemKey = @ItemKey
					if ISNULL(@ItemMarkUp, 0) > 0
						BEGIN
							SELECT @UnitRate = @ItemMarkUp
							SELECT @Markup = ((@ItemMarkUp - @UnitCost)/ @UnitCost) * 100.0
							SELECT @BillableCost = @TotalCost + (@UnitCost * @Quantity * (@Markup / 100.0))
						END
				END	
			ELSE
				BEGIN
					SELECT @ItemMarkUp = Markup from tItem (nolock) where ItemKey = @ItemKey
					if ISNULL(@ItemMarkUp, 0) > 0
						BEGIN
							SELECT @Markup = @ItemMarkUp
							SELECT @UnitRate = @UnitCost * (1 + (@Markup / 100.0))
							SELECT @BillableCost = @TotalCost + (@UnitCost * @Quantity * (@Markup / 100.0))
						END
				END
	
	-- By default, PTotalCost = TotalCost and GrosAmount = BillableCost
	select @PTotalCost = @TotalCost
			,@GrossAmount = @BillableCost	
		
	-- if there is an exchange rate, convert from Home Currency to PCurrency
	if @PExchangeRate <> 1
		select @PTotalCost = ROUND(@TotalCost / @PExchangeRate, 2)
			,@BillableCost = ROUND(@BillableCost / @PExchangeRate, 2)
			
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
		Round(@GrossAmount, 2),
		@PCurrencyID,
		@PExchangeRate,
		Round(@PTotalCost, 2)
		)
	
	SELECT @oIdentity = @@IDENTITY
	
	exec sptPurchaseOrderDetailUpdateApprover @PurchaseOrderKey

	EXEC sptPurchaseOrderRollupAmounts @PurchaseOrderKey 

	RETURN @oIdentity
GO
