USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceDelete]
	(
		@EstimateKey int
	)

AS --Encrypt

Delete tEstimateService Where EstimateKey = @EstimateKey
GO
