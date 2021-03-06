USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetEstimateDataForFF]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectGetEstimateDataForFF]
	(
		@ProjectKey INT
		,@EstimateKey INT
	)
AS	-- Encrypt

	SET NOCOUNT ON 
	
  /*
  || When     Who Rel   What
  || 08/31/07 GHL 8.5   (10633) Corrected Billed Amount to be the same as in spRptExpenseSummary
  ||                    i.e. Fixed Fee + Detail Transactions billed, no Advance Billings    
  || 01/31/08 GHL 8.5   (20123) Using now invoice summary rather project cost view  
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))               
  */
  
-- Cloned from sptInvoiceInsertProjectOneLine
-- Used in regular FF
	
declare @BudgetAmount money
declare @RemainingAmount money
declare @FixedFeeBilled money
declare @TransactionsBilled money
declare @Billed money

	-- For Estimates
	Declare @EstType smallint
			,@ApprovedQty smallint
		    ,@EstExpenses money		-- Gross
			,@EstLabor money		-- Gross
					
	If ISNULL(@EstimateKey, 0) = 0
	BEGIN
		Select @BudgetAmount = 
			ISNULL(Sum(EstLabor), 0.0) + ISNULL(Sum(EstExpenses), 0.0) + ISNULL(Sum(ApprovedCOLabor), 0.0) + ISNULL(Sum(ApprovedCOExpense), 0.0)
		From tProject (nolock) Where ProjectKey = @ProjectKey
		
		Select @FixedFeeBilled = ISNULL((Select Sum(il.TotalAmount) 
		 from tInvoiceLine il (nolock) 
			inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
	     Where il.ProjectKey = @ProjectKey 
	     And   invc.AdvanceBill = 0
	     And   il.BillFrom = 1), 0)		-- Fixed Fee
	     
	    Select @TransactionsBilled = ISNULL((SELECT Sum(isum.Amount) 
			from tInvoiceSummary isum (NOLOCK)
				inner join tInvoice invc (nolock) on isum.InvoiceKey = invc.InvoiceKey
				inner join tInvoiceLine il (nolock) on isum.InvoiceLineKey = il.InvoiceLineKey
			 WHERE isum.ProjectKey = @ProjectKey
			 AND   invc.AdvanceBill = 0
			 AND   il.BillFrom = 2
			 ), 0) -- Detail 
			  
	    /* 
		Select @TransactionsBilled = ISNULL((SELECT Sum(AmountBilled) 
			from ProjectCosts (NOLOCK)
			 WHERE ProjectCosts.ProjectKey = @ProjectKey
			 AND   ProjectCosts.InvoiceLineKey >0), 0) -- Detail 
		*/
		
		Select @Billed = @FixedFeeBilled + @TransactionsBilled	
	
	END
	ELSE
	BEGIN
		
		Select @EstType = EstType, @ApprovedQty = isnull(ApprovedQty, 1) 
		from tEstimate (nolock) 
		Where EstimateKey = @EstimateKey

		-- By Task Only
		if @EstType = 1	
			Select  @EstExpenses	= sum(EstExpenses) 
				,@EstLabor			= Sum(EstLabor)
				From tEstimateTask (nolock) 
				Where EstimateKey = @EstimateKey

		-- Service or Person
		if @EstType > 1
			Select  @EstLabor		= Sum(Round(Hours * Rate,2))
					From tEstimateTaskLabor (nolock)
					Where EstimateKey = @EstimateKey

		-- Service or Person
		if @EstType > 1
			Select @EstExpenses = Sum(case 
						when @ApprovedQty = 1 Then ete.BillableCost
						when @ApprovedQty = 2 Then ete.BillableCost2
						when @ApprovedQty = 3 Then ete.BillableCost3 
						when @ApprovedQty = 4 Then ete.BillableCost4
						when @ApprovedQty = 5 Then ete.BillableCost5
						when @ApprovedQty = 6 Then ete.BillableCost6											 
						end)
			From tEstimateTaskExpense ete (nolock)
			Where ete.EstimateKey = @EstimateKey
		
			Select @BudgetAmount = ISNULL(Sum(@EstLabor), 0.0) + ISNULL(Sum(@EstExpenses), 0.0)
			
			Select @FixedFeeBilled = ISNULL((Select Sum(il.TotalAmount) 
				from tInvoiceLine il (nolock) 
				inner join tInvoice invc (nolock) on il.InvoiceKey = invc.InvoiceKey
				Where il.ProjectKey = @ProjectKey 
				And   il.EstimateKey = @EstimateKey
				And invc.AdvanceBill = 0), 0) 

			-- Technically there are no detail transactions created for an estimate
			Select @TransactionsBilled = 0
			
			Select @Billed = @FixedFeeBilled + @TransactionsBilled		
					
	END
		
	Select @RemainingAmount = @BudgetAmount - ISNULL(@Billed, 0)

	Select @RemainingAmount AS RemainingAmount
		   ,@BudgetAmount AS BudgetAmount
		   ,@Billed AS BilledAmount
		   			
	RETURN 1
GO
