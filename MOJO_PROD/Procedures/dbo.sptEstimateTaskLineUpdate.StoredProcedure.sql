USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLineUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLineUpdate]
	 @EstimateKey int
	,@TaskKey int
	,@Hours decimal(9,3)
	,@Cost money
	,@Rate money
	,@EstLabor money
	,@BudgetExpenses money
	,@Markup decimal(9,3)
	,@EstExpenses money
AS --Encrypt
		
	if exists (select EstimateTaskKey	
	             from tEstimateTask (nolock)
	            where EstimateKey = @EstimateKey 
	              and TaskKey = @TaskKey)
	          
		update tEstimateTask
		   set Hours = @Hours
			  ,Cost = @Cost
			  ,Rate = @Rate
			  ,EstLabor = @EstLabor
			  ,BudgetExpenses = @BudgetExpenses
			  ,Markup = @Markup
			  ,EstExpenses = @EstExpenses
		 where EstimateKey = @EstimateKey
           and TaskKey = @TaskKey

	else
		              
		insert tEstimateTask
			  (
			   EstimateKey
			  ,TaskKey
			  ,Hours
			  ,Cost
			  ,Rate
			  ,EstLabor
			  ,BudgetExpenses
			  ,Markup
			  ,EstExpenses
              )

		values
			  ( 
			   @EstimateKey
			  ,@TaskKey
			  ,@Hours
			  ,@Cost
			  ,@Rate
			  ,@EstLabor
			  ,@BudgetExpenses
			  ,@Markup
			  ,@EstExpenses
			)
			
Declare @ApprovedQty smallint,@SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey

 
	RETURN 1
GO
