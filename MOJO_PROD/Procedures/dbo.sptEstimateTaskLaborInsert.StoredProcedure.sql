USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborInsert]
	@EstimateKey int,
	@TaskKey int,
	@ServiceKey int,
	@UserKey int,
	@Hours decimal(24,4),
	@Rate money
AS --Encrypt

DECLARE @Cost money

if @ServiceKey is null
BEGIN

SELECT @Cost = ISNULL(HourlyCost, 0)
FROM   tUser (NOLOCK)
WHERE  UserKey = @UserKey
 
If exists(Select 1 from tEstimateTaskLabor (nolock) where EstimateKey = @EstimateKey and TaskKey = @TaskKey and UserKey = @UserKey)
	Update tEstimateTaskLabor
		Set
			Hours = @Hours,
			Rate = @Rate,
			Cost = @Cost
		where EstimateKey = @EstimateKey and TaskKey = @TaskKey and UserKey = @UserKey
else
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
	VALUES
		(
		@EstimateKey,
		@TaskKey,
		NULL,
		@UserKey,
		@Hours,
		@Rate,
		@Cost
		)
	 	
END
ELSE
BEGIN

SELECT @Cost = ISNULL(HourlyCost, 0)
FROM   tService (NOLOCK)
WHERE  ServiceKey = @ServiceKey

If exists(Select 1 from tEstimateTaskLabor (nolock) where EstimateKey = @EstimateKey and TaskKey = @TaskKey and ServiceKey = @ServiceKey)
	Update tEstimateTaskLabor
		Set
			Hours = @Hours,
			Rate = @Rate,
			Cost = @Cost
		where EstimateKey = @EstimateKey and TaskKey = @TaskKey and ServiceKey = @ServiceKey
else
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

	VALUES
		(
		@EstimateKey,
		@TaskKey,
		@ServiceKey,
		NULL,
		@Hours,
		@Rate,
		@Cost
		)

END


Declare @ApprovedQty smallint,@SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey
GO
