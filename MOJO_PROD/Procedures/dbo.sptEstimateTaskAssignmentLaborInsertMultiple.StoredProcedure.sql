USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskAssignmentLaborInsertMultiple]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskAssignmentLaborInsertMultiple]
	(
		@EstimateKey INT
	)
AS -- Encrypt

/*
|| When     Who Rel  What
|| 12/14/06 GHL 8.4 Modified to use tasks instead of task assignments. 
|| 04/02/08 GHL 8.5 Corrected group by in tEstimateTaskLabor
*/	
	SET NOCOUNT ON
	 
	DECLARE @EstType SMALLINT
	SELECT @EstType = EstType
	FROM   tEstimate (NOLOCK)
	WHERE  EstimateKey = @EstimateKey

	DELETE tEstimateTaskAssignmentLabor
	WHERE  EstimateKey = @EstimateKey

	DELETE tEstimateTaskLabor
	WHERE  EstimateKey = @EstimateKey

	INSERT tEstimateTaskAssignmentLabor
		(
		EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate
		)
	SELECT
		@EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate
		FROM #tTALabor 
			
	INSERT tEstimateTaskLabor
		(
		EstimateKey,
		TaskKey,
		ServiceKey,
		UserKey,
		Hours,
		Rate
		)
	SELECT
		@EstimateKey,
		BudgetTaskKey,
		ServiceKey,
		UserKey,
		SUM(Hours),
		Rate
		FROM #tTALabor 
	GROUP BY BudgetTaskKey, ServiceKey, UserKey, Rate

IF @EstType = 2
	-- By Service				
	UPDATE tEstimateTaskLabor
	SET	   tEstimateTaskLabor.Cost = ISNULL(s.HourlyCost, 0)
	FROM   tService s (NOLOCK)
	WHERE  tEstimateTaskLabor.EstimateKey = @EstimateKey
	AND	   tEstimateTaskLabor.ServiceKey = s.ServiceKey	
ELSE
	-- By User				
	UPDATE tEstimateTaskLabor
	SET	   tEstimateTaskLabor.Cost = ISNULL(u.HourlyCost, 0)
	FROM   tUser u (NOLOCK)
	WHERE  tEstimateTaskLabor.EstimateKey = @EstimateKey
	AND	   tEstimateTaskLabor.UserKey = u.UserKey	
	
	
Declare @ApprovedQty smallint,@SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey
	 
	RETURN 1
GO
