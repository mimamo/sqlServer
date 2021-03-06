USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceInsert]
	(
		@EstimateKey int,
		@ServiceKey int,
		@Rate Money
	)
AS --Encrypt


Insert tEstimateService
	(
	EstimateKey,
	ServiceKey,
	Rate
	)
Values
	(
	@EstimateKey,
	@ServiceKey,
	ISNULL(@Rate, 0)
	)

return 1
GO
