USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateRecalcSalesTaxProject]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateRecalcSalesTaxProject]
	(
		@ProjectKey int
	)
AS -- Encrypt

	SET NOCOUNT ON
	
	-- Recalculates the Sales Taxes for all unapproved estimates on a project
	-- Should be done when a task has been deleted on a project
	
	DECLARE @EstimateKey int
	       ,@ApprovedQty int
	       ,@SalesTax1Amount money
	       ,@SalesTax2Amount money
	       
	SELECT @EstimateKey = -1
	WHILE (1=1)
	BEGIN
		SELECT @EstimateKey = MIN(EstimateKey)
		FROM   tEstimate (NOLOCK)
		WHERE  ProjectKey = @ProjectKey
		AND    EstimateKey > @EstimateKey
		AND NOT ((isnull(ExternalApprover, 0) > 0 and  ExternalStatus = 4) 
		     Or (isnull(ExternalApprover, 0) = 0 and  InternalStatus = 4))   	
		
		
		IF @EstimateKey IS NULL
			BREAK
			
		SELECT @ApprovedQty = ApprovedQty
		FROM   tEstimate (NOLOCK)
		WHERE  EstimateKey = @EstimateKey
		
		Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
		Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
		Exec sptEstimateTaskRollupDetail @EstimateKey
	
	END		
	
	RETURN 1
GO
