USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskRollupDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskRollupDetail]
	(
		@EstimateKey INT
	)
AS -- Encrypt

	SET NOCOUNT ON
	
  /*
  || When     Who Rel    What
  || 04/20/07 GHL 8.42   Labor Net is Sum(Hours * isnull(Cost, 0)) not Sum(Hours * isnull(Cost, Rate))
  ||                     Bug 8894
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  */
  	
Declare @EstType smallint, @ApprovedQty smallint 

Select @EstType = EstType, @ApprovedQty = isnull(ApprovedQty, 1) 
from tEstimate (nolock) 
Where EstimateKey = @EstimateKey
	 
Declare @BudgetExpenses money	-- Net
		,@EstExpenses money		-- Gross
		,@BudgetLabor money		-- Net
		,@EstLabor money		-- Gross
		,@Hours decimal(24, 4)

if @EstType = 1	
	-- By Task Only
	Select  @Hours				= Sum(Hours) 
			,@BudgetExpenses	= sum(BudgetExpenses) 
			,@EstExpenses		= sum(EstExpenses) 
			,@BudgetLabor		= Sum(round(Hours * isnull(Cost, 0),2) ) 
			,@EstLabor			= Sum(EstLabor)
	From tEstimateTask (nolock) 
	Where EstimateKey = @EstimateKey
ELSE
BEGIN	
	-- Service or Person
	Select  @Hours			= Sum(Hours)
			,@EstLabor		= Sum(round(Hours * Rate, 2))
			,@BudgetLabor	= Sum(round(Hours * isnull(Cost, 0), 2)) 
	From tEstimateTaskLabor (nolock)
	Where EstimateKey = @EstimateKey

	Select @BudgetExpenses	= Sum(case 
				when @ApprovedQty = 1 Then ete.TotalCost
				when @ApprovedQty = 2 Then ete.TotalCost2
				when @ApprovedQty = 3 Then ete.TotalCost3 
				when @ApprovedQty = 4 Then ete.TotalCost4
				when @ApprovedQty = 5 Then ete.TotalCost5
				when @ApprovedQty = 6 Then ete.TotalCost6											 
				end)
			,@EstExpenses = Sum(case 
				when @ApprovedQty = 1 Then ete.BillableCost
				when @ApprovedQty = 2 Then ete.BillableCost2
				when @ApprovedQty = 3 Then ete.BillableCost3 
				when @ApprovedQty = 4 Then ete.BillableCost4
				when @ApprovedQty = 5 Then ete.BillableCost5
				when @ApprovedQty = 6 Then ete.BillableCost6											 
				end)
	From tEstimateTaskExpense ete (nolock)
	Where ete.EstimateKey = @EstimateKey
END

	UPDATE tEstimate
	SET    EstimateTotal	= ISNULL(@EstLabor, 0) + ISNULL(@EstExpenses, 0)
		  ,LaborGross		= ISNULL(@EstLabor, 0)
		  ,ExpenseGross		= ISNULL(@EstExpenses, 0)
		  ,TaxableTotal		= ISNULL(SalesTaxAmount, 0) + ISNULL(SalesTax2Amount, 0)
		  ,ContingencyTotal	= (ISNULL(@EstLabor, 0) * ISNULL(Contingency, 0)) / 100.00
		  ,LaborNet			= ISNULL(@BudgetLabor, 0)
		  ,ExpenseNet		= ISNULL(@BudgetExpenses, 0)	
		  ,Hours			= ISNULL(@Hours, 0)	
	WHERE EstimateKey		= @EstimateKey
		  
		  		  				
	RETURN 1
GO
