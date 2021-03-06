USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseInsert]
	@EstimateKey int,
	@TaskKey int,
	@ItemKey int,
	@VendorKey int,
	@ClassKey int,
	@ShortDescription varchar(200),
	@LongDescription varchar(1000),
	@Taxable tinyint,
	@Taxable2 tinyint,

	@Quantity decimal(24,4),
	@UnitCost money,
	@UnitDescription varchar(30),
	@TotalCost money,
	@UnitRate money,
	@Billable tinyint,
	@Markup decimal(24,4),
	@BillableCost money,
	@Height decimal(24,4),
	@Width decimal(24,4),
	@ConversionMultiplier decimal(24,4),
	
	@Quantity2 decimal(24,4),
	@UnitCost2 money,
	@UnitDescription2 varchar(30),
	@TotalCost2 money,
	@UnitRate2 money,
	@Markup2 decimal(24,4),
	@BillableCost2 money,
	@Height2 decimal(24,4),
	@Width2 decimal(24,4),
	@ConversionMultiplier2 decimal(24,4),

	@Quantity3 decimal(24,4),
	@UnitCost3 money,
	@UnitDescription3 varchar(30),
	@TotalCost3 money,
	@UnitRate3 money,
	@Markup3 decimal(24,4),
	@BillableCost3 money,
	@Height3 decimal(24,4),
	@Width3 decimal(24,4),
	@ConversionMultiplier3 decimal(24,4),

	@Quantity4 decimal(24,4),
	@UnitCost4 money,
	@UnitDescription4 varchar(30),
	@TotalCost4 money,
	@UnitRate4 money,
	@Markup4 decimal(24,4),
	@BillableCost4 money,
	@Height4 decimal(24,4),
	@Width4 decimal(24,4),
	@ConversionMultiplier4 decimal(24,4),

	@Quantity5 decimal(24,4),
	@UnitCost5 money,
	@UnitDescription5 varchar(30),
	@TotalCost5 money,
	@UnitRate5 money,
	@Markup5 decimal(24,4),
	@BillableCost5 money,
	@Height5 decimal(24,4),
	@Width5 decimal(24,4),
	@ConversionMultiplier5 decimal(24,4),

	@Quantity6 decimal(24,4),
	@UnitCost6 money,
	@UnitDescription6 varchar(30),
	@TotalCost6 money,
	@UnitRate6 money,
	@Markup6 decimal(24,4),
	@BillableCost6 money,
	@Height6 decimal(24,4),
	@Width6 decimal(24,4),
	@ConversionMultiplier6 decimal(24,4),

	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/22/07  CRG 8.5     (11376) Added Height, Width, ConversionMultiplier parameters for Paid Enhancement.
*/

	INSERT tEstimateTaskExpense
		(
		EstimateKey,
		TaskKey,
		ItemKey,
		VendorKey,
		ClassKey,
		ShortDescription,
		LongDescription,
		Taxable,
		Taxable2,

		Quantity,
		UnitCost,
		UnitDescription,
		TotalCost,
		UnitRate,
		Billable,
		Markup,
		BillableCost,
		Height,
		Width,
		ConversionMultiplier,
		
		Quantity2,
		UnitCost2,
		UnitDescription2,
		TotalCost2,
		UnitRate2,
		Markup2,
		BillableCost2,
		Height2,
		Width2,
		ConversionMultiplier2,
		
		Quantity3,
		UnitCost3,
		UnitDescription3,
		TotalCost3,
		UnitRate3,
		Markup3,
		BillableCost3,
		Height3,
		Width3,
		ConversionMultiplier3,

		Quantity4,
		UnitCost4,
		UnitDescription4,
		TotalCost4,
		UnitRate4,
		Markup4,
		BillableCost4,
		Height4,
		Width4,
		ConversionMultiplier4,

		Quantity5,
		UnitCost5,
		UnitDescription5,
		TotalCost5,
		UnitRate5,
		Markup5,
		BillableCost5,
		Height5,
		Width5,
		ConversionMultiplier5,

		Quantity6,
		UnitCost6,
		UnitDescription6,
		TotalCost6,
		UnitRate6,
		Markup6,
		BillableCost6,
		Height6,
		Width6,
		ConversionMultiplier6

		)

	VALUES
		(
		@EstimateKey,
		@TaskKey,
		@ItemKey,
		@VendorKey,
		@ClassKey,
		@ShortDescription,
		@LongDescription,
		@Taxable,
		@Taxable2,

		@Quantity,
		@UnitCost,
		@UnitDescription,
		@TotalCost,
		@UnitRate,
		@Billable,
		@Markup,
		@BillableCost,
		@Height,
		@Width,
		@ConversionMultiplier,

		@Quantity2,
		@UnitCost2,
		@UnitDescription2,
		@TotalCost2,
		@UnitRate2,
		@Markup2,
		@BillableCost2,
		@Height2,
		@Width2,
		@ConversionMultiplier2,
		
		@Quantity3,
		@UnitCost3,
		@UnitDescription3,
		@TotalCost3,
		@UnitRate3,
		@Markup3,
		@BillableCost3,
		@Height3,
		@Width3,
		@ConversionMultiplier3,

		@Quantity4,
		@UnitCost4,
		@UnitDescription4,
		@TotalCost4,
		@UnitRate4,
		@Markup4,
		@BillableCost4,
		@Height4,
		@Width4,
		@ConversionMultiplier4,

		@Quantity5,
		@UnitCost5,
		@UnitDescription5,
		@TotalCost5,
		@UnitRate5,
		@Markup5,
		@BillableCost5,
		@Height5,
		@Width5,
		@ConversionMultiplier5,

		@Quantity6,
		@UnitCost6,
		@UnitDescription6,
		@TotalCost6,
		@UnitRate6,
		@Markup6,
		@BillableCost6,
		@Height6,
		@Width6,
		@ConversionMultiplier6

		)
	
	SELECT @oIdentity = @@IDENTITY

Declare @ApprovedQty smallint, @EstType int, @Gross money, @Net Money, @MU decimal(24,4)

Select @ApprovedQty = ApprovedQty, @EstType = EstType from tEstimate (nolock) Where EstimateKey = @EstimateKey
if @EstType = 1
BEGIN
	-- Calculate based on the Approved Qty
	Select @Net = Sum(case 
					  when @ApprovedQty = 1 then TotalCost
					  when @ApprovedQty = 2 then TotalCost2
					  when @ApprovedQty = 3 then TotalCost3
					  when @ApprovedQty = 4 then TotalCost4
					  when @ApprovedQty = 5 then TotalCost5
					  when @ApprovedQty = 6 then TotalCost6
					  end)
	      ,@Gross = Sum(case 
					  when @ApprovedQty = 1 then BillableCost
					  when @ApprovedQty = 2 then BillableCost2
					  when @ApprovedQty = 3 then BillableCost3
					  when @ApprovedQty = 4 then BillableCost4
					  when @ApprovedQty = 5 then BillableCost5
					  when @ApprovedQty = 6 then BillableCost6
					  end) 
	from tEstimateTaskExpense (nolock) 
	Where TaskKey = @TaskKey and EstimateKey = @EstimateKey
	
	if @Net = 0
		Select @MU = 0
	else
		Select @MU = ((@Gross / @Net) - 1.0) * 100.0
		
	if exists(select 1 from tEstimateTask (nolock) Where TaskKey = @TaskKey and EstimateKey = @EstimateKey)
		Update tEstimateTask Set 
			BudgetExpenses = @Net, Markup = @MU, EstExpenses = @Gross
		Where TaskKey = @TaskKey and EstimateKey = @EstimateKey
	else
		Insert tEstimateTask (EstimateKey, TaskKey, Hours, Rate, EstLabor, BudgetExpenses, Markup, EstExpenses)
		Values (@EstimateKey, @TaskKey, 0, 0, 0, @Net, @MU, @Gross)
		
END

Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey


	RETURN 1
GO
