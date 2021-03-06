USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUpdateApprovedQty]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUpdateApprovedQty]
	@EstimateKey int,
	@ApprovedQty smallint	

AS --Encrypt

If ISNULL(@ApprovedQty, 0) = 0 
	RETURN 1
	
Declare @OldApprovedQty smallint, @EstType int

Select @OldApprovedQty = ApprovedQty, @EstType = EstType from tEstimate (nolock) where EstimateKey = @EstimateKey

If @ApprovedQty = @OldApprovedQty 
	RETURN 1
	
Update tEstimate set ApprovedQty = @ApprovedQty where EstimateKey = @EstimateKey
  
  
-- Rollup the expenses to tEstimateTask if EstType = 1 (by task) if the ApprovedQty has changed
if @EstType = 1 
	exec sptEstimateTaskExpenseRollupDetail @EstimateKey
   
Declare @SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey

	RETURN 1
GO
