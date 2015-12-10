USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskGetTreeEstimate]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptTaskGetTreeEstimate]
	 @ProjectKey int
    ,@EstimateKey int	
AS --Encrypt

	select ta1.*,
			isnull((Select sum(Hours) from tEstimateTaskLabor etl (nolock) Where etl.EstimateKey = @EstimateKey and etl.TaskKey = ta1.TaskKey), 0) as TotalHours,
			isnull((Select sum(Round(Hours * Rate,2)) from tEstimateTaskLabor etl (nolock) Where etl.EstimateKey = @EstimateKey and etl.TaskKey = ta1.TaskKey), 0) as TotalAmt
	  from tTask ta1 (nolock)
	 where ta1.ProjectKey = @ProjectKey
  order by ta1.SummaryTaskKey
          ,ta1.DisplayOrder
	 
	return 1
GO
