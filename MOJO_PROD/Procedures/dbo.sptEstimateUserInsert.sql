USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateUserInsert]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateUserInsert]
	@EstimateKey int,
	@UserKey int,
	@BillingRate money,
	@oIdentity INT OUTPUT
AS --Encrypt

If exists(select 1 from tEstimateUser (nolock) where EstimateKey = @EstimateKey and UserKey = @UserKey)
	return -1

	INSERT tEstimateUser
		(
		EstimateKey,
		UserKey,
		BillingRate
		)

	VALUES
		(
		@EstimateKey,
		@UserKey,
		@BillingRate
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
