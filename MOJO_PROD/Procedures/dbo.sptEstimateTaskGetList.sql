USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskGetList]
	@EstimateKey int

AS --Encrypt

Declare @ProjectKey int

		Select @ProjectKey = ProjectKey from tEstimate (nolock) Where EstimateKey = @EstimateKey
		
		
		SELECT *
		FROM tTask (nolock)
		WHERE
			ProjectKey = @ProjectKey
		Order By 
			tTask.ProjectOrder

	RETURN 1
GO
