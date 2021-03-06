USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborInsertMultiple]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborInsertMultiple]
	(
		@EstimateKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel	  What
  || 04/02/09 GHL 10.022  (50356) Added DISTINCT to eliminate duplicate tEstimateTaskLabor recs
  */
  
	SET NOCOUNT ON

	DECLARE @EstType SMALLINT
	SELECT @EstType = EstType
	FROM   tEstimate (NOLOCK)
	WHERE  EstimateKey = @EstimateKey
	
	DELETE tEstimateTaskLabor
	WHERE  EstimateKey = @EstimateKey

	IF @EstType = 2 Or @EstType = 4
	BEGIN
		-- 2: By Task And Service
		-- 4: By Service Only 
		INSERT tEstimateTaskLabor
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			UserKey,
			Hours,
			Rate,
			Cost
			)

		SELECT DISTINCT
			@EstimateKey,
			b.TaskKey,
			b.ServiceKey,
			b.UserKey,
			b.Hours,
			b.Rate,
			isnull(s.HourlyCost, 0)
		FROM #tTaskLabor b
		INNER JOIN tService s (NOLOCK) ON s.ServiceKey = b.ServiceKey
		
		IF @EstType = 4
		BEGIN
			-- If By Service Only, update the rate in tEstimateService 
			UPDATE tEstimateService
			SET    tEstimateService.Rate = b.Rate
			FROM #tTaskLabor b
			WHERE  tEstimateService.EstimateKey = @EstimateKey
			AND    tEstimateService.ServiceKey = b.ServiceKey
		END
		
	END
	
	IF @EstType = 3 
	BEGIN
		-- By Task And User
		INSERT tEstimateTaskLabor
			(
			EstimateKey,
			TaskKey,
			ServiceKey,
			UserKey,
			Hours,
			Rate,
			Cost
			)

		SELECT DISTINCT
			@EstimateKey,
			b.TaskKey,
			b.ServiceKey,
			b.UserKey,
			b.Hours,
			b.Rate,
			isnull(u.HourlyCost, 0)
		FROM #tTaskLabor b
		INNER JOIN tUser u (NOLOCK) ON u.UserKey = b.ServiceKey
	END
	
	
	
Declare @ApprovedQty smallint,@SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey
	 
	RETURN 1
GO
