USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUserDelete]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUserDelete]
	@EstimateUserKey int

AS --Encrypt

Declare @UserKey int
Declare @EstimateKey int

Select @UserKey = UserKey, @EstimateKey = EstimateKey from tEstimateUser (nolock) Where EstimateUserKey = @EstimateUserKey 

	DELETE
	FROM tEstimateTaskLabor
	WHERE
		UserKey = @UserKey and
		EstimateKey = @EstimateKey

	DELETE
	FROM tEstimateUser
	WHERE
		EstimateUserKey = @EstimateUserKey 
		
	Exec sptEstimateTaskRollupDetail @EstimateKey

	RETURN 1
GO
