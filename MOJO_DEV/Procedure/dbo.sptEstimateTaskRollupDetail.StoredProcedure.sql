USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptEstimateTaskRollupDetail]    Script Date: 04/29/2016 16:40:03 ******/
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
  || 07/31/15 GHL 10.594 Added ContingencyAmount for WJAPP where the user can enter on the UI an amount
  ||                     versus a Contingency Percent in FLEX
  ||                     Calculating now ContigencyTotal as the sum of the 2 
  || 08/17/15 GHL 10.595 Rolledback calculation using ContingencyAmount 
  || 10/16/15 GHL 10.597 Taking in account now rollups when est type = by project only
  */

declare @kByTaskOnly int            select @kByTaskOnly = 1
declare @kByTaskService int         select @kByTaskService = 2
declare @kByTaskPerson int          select @kByTaskPerson = 3
declare @kByServiceOnly int         select @kByServiceOnly = 4
declare @kBySegmentService int      select @kBySegmentService = 5
declare @kByProject int			    select @kByProject = 6
declare @kByTitleOnly int	        select @kByTitleOnly = 7
declare @kBySegmentTitle int	    select @kBySegmentTitle = 8
  	
Declare @EstType smallint, @ApprovedQty smallint, @Contingency money

Select @EstType = EstType
      , @ApprovedQty = isnull(ApprovedQty, 1)
	  , @Contingency = isnull(Contingency, 0) 
from tEstimate (nolock) 
Where EstimateKey = @EstimateKey
	 
Declare @BudgetExpenses money	-- Net
		,@EstExpenses money		-- Gross
		,@BudgetLabor money		-- Net
		,@EstLabor money		-- Gross
		,@Hours decimal(24, 4)

if @EstType = @kByTaskOnly
BEGIN
	-- By Task Only
	Select  @Hours				= Sum(Hours) 
			,@BudgetExpenses	= sum(BudgetExpenses) 
			,@EstExpenses		= sum(EstExpenses) 
			,@BudgetLabor		= Sum(round(Hours * isnull(Cost, 0),2) ) 
			,@EstLabor			= Sum(EstLabor)
	From tEstimateTask (nolock) 
	Where EstimateKey = @EstimateKey

	UPDATE tEstimate
	SET    EstimateTotal	= ISNULL(@EstLabor, 0) + ISNULL(@EstExpenses, 0)
		  ,LaborGross		= ISNULL(@EstLabor, 0)
		  ,ExpenseGross		= ISNULL(@EstExpenses, 0)
		  ,TaxableTotal		= ISNULL(SalesTaxAmount, 0) + ISNULL(SalesTax2Amount, 0)
		  ,ContingencyTotal	= ROUND((ISNULL(@EstLabor, 0) * ISNULL(Contingency, 0)) / 100.00, 2)
		  ,LaborNet			= ISNULL(@BudgetLabor, 0)
		  ,ExpenseNet		= ISNULL(@BudgetExpenses, 0)	
		  ,Hours			= ISNULL(@Hours, 0)	
	WHERE EstimateKey		= @EstimateKey

END
ELSE IF @EstType > @kByTaskOnly and @EstType <> @kByProject
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

	UPDATE tEstimate
	SET    EstimateTotal	= ISNULL(@EstLabor, 0) + ISNULL(@EstExpenses, 0)
		  ,LaborGross		= ISNULL(@EstLabor, 0)
		  ,ExpenseGross		= ISNULL(@EstExpenses, 0)
		  ,TaxableTotal		= ISNULL(SalesTaxAmount, 0) + ISNULL(SalesTax2Amount, 0)
		  ,ContingencyTotal	= ROUND((ISNULL(@EstLabor, 0) * ISNULL(Contingency, 0)) / 100.00, 2)
		  ,LaborNet			= ISNULL(@BudgetLabor, 0)
		  ,ExpenseNet		= ISNULL(@BudgetExpenses, 0)	
		  ,Hours			= ISNULL(@Hours, 0)	
	WHERE EstimateKey		= @EstimateKey
		  
END
ELSE IF @EstType = @kByProject
BEGIN

	-- when it is by project only, just summarize info on child estimates

	declare @EstimateTotal money
	declare @LaborGross money
	declare @ExpenseGross money
	declare @SalesTax1Amount money
	declare @SalesTax2Amount money
	declare @TaxableTotal money
	declare @ContingencyTotal money
	declare @LaborNet money
	declare @ExpenseNet money
	

	select @EstimateTotal = sum(e.EstimateTotal)
	      ,@LaborGross = sum(e.LaborGross)
	      ,@ExpenseGross = sum(e.ExpenseGross)
	      ,@SalesTax1Amount = sum(e.SalesTaxAmount)
	      ,@SalesTax2Amount = sum(e.SalesTax2Amount)
	      ,@TaxableTotal = sum(e.TaxableTotal)
	      --,@ContingencyTotal = sum(e.ContingencyTotal)
	      ,@ContingencyTotal = (sum(e.LaborGross) * ISNULL(@Contingency, 0)) / 100.00
	      ,@LaborNet = sum(e.LaborNet)
	      ,@ExpenseNet = sum(e.ExpenseNet)
	      ,@Hours = sum(e.Hours)

	from  tEstimateProject ep (nolock)
	    inner join tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey 
	where ep.EstimateKey = @EstimateKey
	
	UPDATE tEstimate
		SET    EstimateTotal	= ISNULL(@EstimateTotal, 0) 
			  ,LaborGross		= ISNULL(@LaborGross, 0)
			  ,ExpenseGross		= ISNULL(@ExpenseGross, 0)
			  ,SalesTaxAmount   = ISNULL(@SalesTax1Amount, 0)
	          ,SalesTax2Amount  = ISNULL(@SalesTax2Amount, 0)
	          ,TaxableTotal		= ISNULL(@TaxableTotal, 0)
			  ,ContingencyTotal	= ISNULL(@ContingencyTotal, 0)
			  ,LaborNet			= ISNULL(@LaborNet, 0)
			  ,ExpenseNet		= ISNULL(@ExpenseNet, 0)	
			  ,Hours			= ISNULL(@Hours, 0)	
		WHERE EstimateKey		= @EstimateKey

END
	
		  
		  		  				
	RETURN 1 


GO

