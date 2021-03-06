USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceRollupDetail]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceRollupDetail]
	@EstimateKey int
	
AS --Encrypt
	
-- This stored proc should be used after the last insert into tEstimateService to update estimate Gross Amounts.
-- This is required since tEstimateService contains now a rate 
	
Declare @EstType smallint 

Select	@EstType = e.EstType
from tEstimate e (nolock)
	inner join tProject p (nolock) on e.ProjectKey = p.ProjectKey 
Where e.EstimateKey = @EstimateKey

if @EstType = 2 Or @EstType = 4
begin
	Delete tEstimateTaskLabor
	Where
		EstimateKey = @EstimateKey and
		ServiceKey not in (Select ServiceKey from tEstimateService (nolock) Where EstimateKey = @EstimateKey)

	Update tEstimateTaskLabor
	Set    tEstimateTaskLabor.Rate = es.Rate
	From   tEstimateService es (NOLOCK)
	Where  tEstimateTaskLabor.EstimateKey = @EstimateKey 
	And    tEstimateTaskLabor.EstimateKey = es.EstimateKey 
	And    tEstimateTaskLabor.ServiceKey = es.ServiceKey

	Delete tEstimateTaskAssignmentLabor
	Where
		EstimateKey = @EstimateKey and
		ServiceKey not in (Select ServiceKey from tEstimateService (nolock) Where EstimateKey = @EstimateKey)

	Update tEstimateTaskAssignmentLabor
	Set    tEstimateTaskAssignmentLabor.Rate = es.Rate
	From   tEstimateService es (NOLOCK)
	Where  tEstimateTaskAssignmentLabor.EstimateKey = @EstimateKey 
	And    tEstimateTaskAssignmentLabor.EstimateKey = es.EstimateKey 
	And    tEstimateTaskAssignmentLabor.ServiceKey = es.ServiceKey
	
	-- This will update the Labor Gross and Contingency on the estimate
	EXEC sptEstimateTaskRollupDetail @EstimateKey
	
end

	RETURN 1
GO
