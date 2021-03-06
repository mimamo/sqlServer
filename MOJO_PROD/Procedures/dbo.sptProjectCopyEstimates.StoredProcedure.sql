USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCopyEstimates]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectCopyEstimates]
	(
	@Entity varchar(50)
	,@EntityKey int
	,@ToProjectKey int
	,@CopyApproval int
	,@UserKey int = null
	)
AS --Encrypt

 /*
  || When     Who Rel      What
  || 04/23/10 GHL 10.522   Copy estimates of type service only (type 4) or segment/service (type 5) to a project
  ||                       Assume rollup to project will be done in calling sp
  || 11/11/10 GHL 10.5.3.8 (94144) Modified call to sptEstimateCopy (new param UserKey)
  */
  
	SET NOCOUNT ON
	 
	declare @EstimateKey int
	declare @NewEstimateKey int
	declare @RetVal int
	declare @CampaignKey int
	declare @SalesTax1Amount MONEY
	declare @SalesTax2Amount MONEY
	declare @ApprovedQty int
	
	if @Entity = 'tLead'
	begin
		select @EstimateKey = -1
		
		while (1=1)
		begin
			-- here we should only have type 4...because opps are not associated to segments 
			select @EstimateKey = min(EstimateKey)
			from   tEstimate (nolock)
			where  EstimateKey > @EstimateKey
			and    LeadKey = @EntityKey
			and    EstType = 4
			
			if @EstimateKey is null 
				break

			exec @RetVal = sptEstimateCopy @EstimateKey, @ToProjectKey, null, null, @CopyApproval, @UserKey, @NewEstimateKey output

		end
		
	end
	
	
	if @Entity = 'tCampaignSegment'
	begin
		select @EstimateKey = -1
		
		select @CampaignKey = CampaignKey
		from   tCampaignSegment (nolock)
		where  CampaignSegmentKey = @EntityKey
		
		while (1=1)
		begin
			-- here we should only have type 5...because the entity is a segment
			select @EstimateKey = min(EstimateKey)
			from   tEstimate (nolock)
			where  EstimateKey > @EstimateKey
			and    CampaignKey = @CampaignKey
			and    EstType = 5
			
			if @EstimateKey is null 
				break

			Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey

			exec @RetVal = sptEstimateCopy @EstimateKey, @ToProjectKey, null, null, @CopyApproval, @UserKey, @NewEstimateKey output

			-- now delete the segments different from our segment passed as EntityKey
			delete tEstimateTaskLabor where EstimateKey = @NewEstimateKey and CampaignSegmentKey <> @EntityKey
			delete tEstimateTaskExpense where EstimateKey = @NewEstimateKey and CampaignSegmentKey <> @EntityKey
			
			-- problem is that segment/service do not have tEstimateService records
			if (select count(*) from tEstimateService (nolock) where EstimateKey = @NewEstimateKey) = 0
			insert tEstimateService (EstimateKey, ServiceKey, Rate)
			select @NewEstimateKey, ServiceKey, MAX(Rate)
			from   tEstimateTaskLabor (nolock)
			where  EstimateKey = @NewEstimateKey
			group by ServiceKey
			
			--problem here is that since we removed  expenses or labor, we have to recalc everything
			Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
			
			Update tEstimate 
			set SalesTaxAmount = @SalesTax1Amount
				, SalesTax2Amount = @SalesTax2Amount 
			    , EstType = 4  --- is now service only
			where EstimateKey = @NewEstimateKey
			
			Exec sptEstimateTaskRollupDetail @NewEstimateKey

		end

	end
	 
	RETURN 1
GO
