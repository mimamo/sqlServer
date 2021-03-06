USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskExpenseDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskExpenseDelete]
	@EstimateTaskExpenseKey int

AS --Encrypt

Declare @EstimateKey int, @TaskKey int
Select @EstimateKey = EstimateKey, @TaskKey = TaskKey from tEstimateTaskExpense (nolock) WHERE EstimateTaskExpenseKey = @EstimateTaskExpenseKey

	DELETE
	FROM tEstimateTaskExpense
	WHERE
		EstimateTaskExpenseKey = @EstimateTaskExpenseKey 

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
