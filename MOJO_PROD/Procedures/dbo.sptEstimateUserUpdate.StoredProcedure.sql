USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUserUpdate]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUserUpdate]
	@EstimateUserKey int,
	@EstimateKey int,
	@UserKey int,
	@BillingRate money

AS --Encrypt

If exists(select 1 from tEstimateUser (nolock) where EstimateKey = @EstimateKey and UserKey = @UserKey and EstimateUserKey <> @EstimateUserKey)
	return -1
	
	UPDATE
		tEstimateUser
	SET
		EstimateKey = @EstimateKey,
		UserKey = @UserKey,
		BillingRate = @BillingRate
	WHERE
		EstimateUserKey = @EstimateUserKey 



Update tEstimateTaskLabor
	Set Rate = @BillingRate
	Where 
		EstimateKey = @EstimateKey and
		UserKey = @UserKey
		
Exec sptEstimateTaskRollupDetail @EstimateKey

	RETURN 1
GO
