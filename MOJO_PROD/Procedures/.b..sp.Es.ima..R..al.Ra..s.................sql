USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateRecalcRates]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateRecalcRates]
	(
		@EstimateKey Int
	)
AS -- Encrypt

	SET NOCOUNT ON

	DECLARE @EstType INT
			,@ProjectKey INT
			,@ApprovedQty INT
			,@GetRateFrom INT
			,@TimeRateSheetKey INT
			
	SELECT @ProjectKey = e.ProjectKey
		   ,@EstType = e.EstType
		   ,@GetRateFrom = ISNULL(p.GetRateFrom, 1)
		   ,@TimeRateSheetKey = ISNULL(p.TimeRateSheetKey, 0)		   
	FROM   tEstimate e (NOLOCK)
		INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey 
	WHERE  e.EstimateKey = @EstimateKey
	
	-- 1 By Task, 2 By Task & Service, 3 By Task & Person, 4 By Service 
	IF @EstType IN (1, 3)
		RETURN 1
		
	IF @GetRateFrom = 5 -- From Service Rate Sheet	
	BEGIN
		UPDATE tEstimateTaskLabor
		SET    tEstimateTaskLabor.Rate = ISNULL(trsd.HourlyRate1, s.HourlyRate1) 	
		FROM   tTimeRateSheetDetail trsd (NOLOCK)
			  ,tService s (NOLOCK)		
		WHERE  trsd.TimeRateSheetKey = @TimeRateSheetKey
		AND    tEstimateTaskLabor.ServiceKey = trsd.ServiceKey
		AND    tEstimateTaskLabor.ServiceKey = s.ServiceKey
		AND    tEstimateTaskLabor.EstimateKey = @EstimateKey
		
		UPDATE tEstimateTaskAssignmentLabor
		SET    tEstimateTaskAssignmentLabor.Rate = ISNULL(trsd.HourlyRate1, s.HourlyRate1) 	
		FROM   tTimeRateSheetDetail trsd (NOLOCK)
			  ,tService s (NOLOCK)		
		WHERE  trsd.TimeRateSheetKey = @TimeRateSheetKey
		AND    tEstimateTaskAssignmentLabor.ServiceKey = trsd.ServiceKey
		AND    tEstimateTaskAssignmentLabor.ServiceKey = s.ServiceKey
		AND    tEstimateTaskAssignmentLabor.EstimateKey = @EstimateKey

		UPDATE tEstimateService
		SET    tEstimateService.Rate = ISNULL(trsd.HourlyRate1, s.HourlyRate1) 	
		FROM   tTimeRateSheetDetail trsd (NOLOCK)
			  ,tService s (NOLOCK)		
		WHERE  trsd.TimeRateSheetKey = @TimeRateSheetKey
		AND    tEstimateService.ServiceKey = trsd.ServiceKey
		AND    tEstimateService.ServiceKey = s.ServiceKey
		AND    tEstimateService.EstimateKey = @EstimateKey
		
	END
	ELSE
	BEGIN
		UPDATE tEstimateTaskLabor
		SET    tEstimateTaskLabor.Rate = s.HourlyRate1 	
		FROM   tService s (NOLOCK)		
		WHERE  tEstimateTaskLabor.ServiceKey = s.ServiceKey
		AND    tEstimateTaskLabor.EstimateKey = @EstimateKey
		
		UPDATE tEstimateTaskAssignmentLabor
		SET    tEstimateTaskAssignmentLabor.Rate = s.HourlyRate1 	
		FROM   tService s (NOLOCK)		
		WHERE  tEstimateTaskAssignmentLabor.ServiceKey = s.ServiceKey
		AND    tEstimateTaskAssignmentLabor.EstimateKey = @EstimateKey

		UPDATE tEstimateService
		SET    tEstimateService.Rate = s.HourlyRate1 	
		FROM   tService s (NOLOCK)		
		WHERE  tEstimateService.ServiceKey = s.ServiceKey
		AND    tEstimateService.EstimateKey = @EstimateKey

	END

	-- Recalc sales taxes since rates have changed
	DECLARE @SalesTax1Amount MONEY 
			,@SalesTax2Amount MONEY 

	Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
	Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
	
	-- Rollup to estimate totals
	Exec sptEstimateTaskRollupDetail @EstimateKey
		
	-- Rollup to Project and task totals
	Exec sptEstimateRollupDetail @ProjectKey
		
	RETURN 1
GO
