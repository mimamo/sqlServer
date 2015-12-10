USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateDelete]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateDelete]
	@EstimateKey int

AS --Encrypt

  /*
  || When     Who Rel    What
  || 02/08/10 GHL 10.518 Simplified internal status logic to make it similar to VB code
  || 03/08/10 GHL 10.520 Added deletion of tEstimateTaskTemp tables 
  || 03/23/10 GHL 10.522 Removed deletion of tEstimateTaskTemp tables
  || 08/13/10 GHL 10.533 Added deletion of tEstimateProject
  || 11/16/12 GHL 10.562 Added logic for tForecast.RegenerateNeeded
  || 01/22/13 MAS 10.564 Removed deleting tActionLog entries for this estimate
  || 03/06/15 GHL 10.590 Added deletion of tables linked to titles for Abelson Taylor
  */

	if isnull(@EstimateKey, 0) = 0
		return 1
		
	-- Do not delete if the estimate is approved
	Declare @InternalApprover int
	       ,@InternalStatus int
		   ,@ExternalApprover int
	       ,@ExternalStatus int
	       ,@ProjectKey int
		   ,@LeadKey int
		   ,@IncludeInForecast int
		      	
	Select @InternalApprover	= isnull(InternalApprover, 0)
 	       ,@InternalStatus		= isnull(InternalStatus, 1)
		   ,@ExternalApprover	= isnull(ExternalApprover, 0)
	       ,@ExternalStatus		= isnull(ExternalStatus, 1)
		   ,@ProjectKey         = isnull(ProjectKey, 0)
		   ,@LeadKey            = isnull(LeadKey, 0)
		   ,@IncludeInForecast  = isnull(IncludeInForecast, 0)
	From   tEstimate (nolock)
	Where  EstimateKey = @EstimateKey
	
	If @InternalStatus = 4
		Return -1
	
	delete tEstimateService	
	 where EstimateKey = @EstimateKey
	 
	delete tEstimateUser	
	 where EstimateKey = @EstimateKey

	delete tEstimateTaskAssignmentLabor	
	 where EstimateKey = @EstimateKey

	delete tEstimateTaskLabor	
	 where EstimateKey = @EstimateKey

	delete tEstimateTaskExpense	
	 where EstimateKey = @EstimateKey		

	delete tEstimateTask		
	 where EstimateKey = @EstimateKey
	 
	delete tEstimateNotify		
	 where EstimateKey = @EstimateKey
	
	delete tEstimateProject		
	 where EstimateKey = @EstimateKey

	delete tEstimateTaskLaborLevel	
	 where EstimateKey = @EstimateKey

	 delete tEstimateTitle	
	 where EstimateKey = @EstimateKey

	 delete tEstimateTaskLaborTitle	
	 where EstimateKey = @EstimateKey

	if @IncludeInForecast = 1
	begin
		if isnull(@LeadKey, 0) > 0
		begin
			update tForecastDetail
			set    tForecastDetail.RegenerateNeeded = 1
			where  Entity = 'tLead'
			and    EntityKey = @LeadKey
		end

		if isnull(@ProjectKey, 0) > 0
		begin
			update tForecastDetail
			set    tForecastDetail.RegenerateNeeded = 1
			where  Entity in ('tProject-Approved', 'tProject-Potential')
			and    EntityKey = @ProjectKey
		end
	end
			  
	DELETE
	FROM tEstimate
	WHERE
		EstimateKey = @EstimateKey 

	RETURN 1
GO
