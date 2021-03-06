USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetHoursDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptEstimateGetHoursDetail]

	(
		@EstimateKey int
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 3/18/08   CRG 8.5.0.6 (23116) Now Grouping the values so that it displays correctly if you switch between Detail and Summary.
*/

Select EstimateKey, TaskKey, ServiceKey, UserKey, sum(Hours) as Hours, min(Rate) as Rate, min(Cost) as Cost
from tEstimateTaskLabor etl (nolock)
Where
	etl.EstimateKey = @EstimateKey
group by EstimateKey, TaskKey, ServiceKey, UserKey
GO
