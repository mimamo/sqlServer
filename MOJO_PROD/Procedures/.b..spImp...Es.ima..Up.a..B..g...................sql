USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spImportEstimateUpdateBudget]    Script Date: 12/10/2015 10:54:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spImportEstimateUpdateBudget]

	(
		@EstimateKey int
	)

AS --Encrypt


Declare @ProjectKey int

Select @ProjectKey = ProjectKey from tEstimate (nolock) Where EstimateKey = @EstimateKey

exec sptEstimateRollupDetail @ProjectKey
GO
