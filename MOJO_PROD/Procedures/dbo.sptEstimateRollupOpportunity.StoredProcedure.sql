USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateRollupOpportunity]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateRollupOpportunity]
	@EstimateKey INT
AS --Encrypt

/*
|| When     Who Rel       What
|| 04/20/10 GHL 10.5.2.2  Creation for new functionality between estimates and opps
||
||                        Estimates can be linked to opps in 3 ways:
||                        1) Directly through tEstimate.LeadKey
||                        2) Indirectly through tEstimate.CampaignKey-->tLead.ConvertedEntityKey
||                        3) Indirectly through tEstimate.ProjectKey-->tLead.ConvertedEntityKey
||
||                        Also we can only have situation 1 + 2 or situation 1 + 3
||
||                        If LeadKey > 0, determine ConvertedToProjectKey and ConvertedToCampaignKey
||                        all totals for the 3 entities go against LeadKey (in effect only 2 will be present)
||
||                        If ProjectKey > 0 or CampaignKey > 0, determine ConvertedFromLeadKey
||                        all totals for the 3 entities go against ConvertedFromLeadKey (in effect only 2 will be present)  
|| 12/18/12 GHL 10.5.6.3  (162812) Added update of tLead.Labor (new field)                    
*/
	SET NOCOUNT ON
	
	if isnull(@EstimateKey, 0) = 0
		return 1

	-- this will go to LeadKey			
	declare @SaleAmount money			-- Total budget with tax
	declare @OutsideCostsGross money	-- Total Expenses gross with production item
	declare @MediaGross money			-- Total Expenses gross with media item
	declare @OutsideCostsNet money		-- Total Expenses net with production item
	declare @MediaNet money				-- Total Expenses net with media item
	declare @AGI money
	declare @OutsideCostsPerc decimal(24,4)
	declare @MediaPerc decimal(24,4)
	declare @Labor money

	-- this will go to @ConvertedFromLeadKey			
	declare @SaleAmount2 money			-- Total budget with tax
	declare @OutsideCostsGross2 money	-- Total Expenses gross with production item
	declare @MediaGross2 money			-- Total Expenses gross with media item
	declare @OutsideCostsNet2 money		-- Total Expenses net with production item
	declare @MediaNet2 money				-- Total Expenses net with media item
	declare @AGI2 money
	declare @OutsideCostsPerc2 decimal(24,4)
	declare @MediaPerc2 decimal(24,4)
	declare @Labor2 money

	-- for the main entities on tEstimate and tLead
	declare @ProjectKey int
	declare @CampaignKey int
	declare @LeadKey int
	
	declare @ConvertEntity varchar(50)
	declare @ConvertEntityKey int
	
	declare @ConvertedToProjectKey int
	declare @ConvertedToCampaignKey int
	declare @ConvertedFromLeadKey int
	
	-- for temporary totals
	declare @LeadHasApprovedEstimates int
	declare @EntityHasApprovedEstimates int
	
	declare @EstimateTotal money
	declare @ProdGross money
	declare @ProdNet money
	declare @IOBCGross money -- MediaGross already declared so call it IOBC
	declare @IOBCNet money
	declare @LaborGross money

	select @ProjectKey = ProjectKey
	      ,@CampaignKey = CampaignKey
	      ,@LeadKey = LeadKey
	from   tEstimate  (nolock)
	where  EstimateKey = @EstimateKey
	
	select @ProjectKey = isnull(@ProjectKey, 0)
		, @CampaignKey = isnull(@CampaignKey, 0)
		, @LeadKey = isnull(@LeadKey, 0) 
	
	-- these 2 vars are here to avoid double dipping
	-- if an opp is converted to a campaign and we copy the estimates, now we have estimates in both places
	-- in that case, get the totals from the entity
	select @LeadHasApprovedEstimates = 0, @EntityHasApprovedEstimates = 0
	
	if @LeadKey > 0
	begin
		select @ConvertEntity = ConvertEntity
		      ,@ConvertEntityKey = ConvertEntityKey
		from   tLead (nolock)
		where  LeadKey = @LeadKey 

		select @ConvertEntity = isnull(@ConvertEntity, ''), @ConvertEntityKey = isnull(@ConvertEntityKey, 0)

		select @LeadHasApprovedEstimates = count(EstimateKey)
		from   vEstimateApproved (nolock)
		where  Approved = 1
		and    LeadKey = @LeadKey
				
		if @ConvertEntity = 'tProject'
		begin
			select @ConvertedToProjectKey = @ConvertEntityKey, @ConvertedToCampaignKey = 0
			
			select @EntityHasApprovedEstimates = count(EstimateKey)
			from   vEstimateApproved (nolock)
			where  Approved = 1
			and    ProjectKey = @ConvertedToProjectKey
		end
		else if	@ConvertEntity = 'tCampaign'
		begin
			select @ConvertedToProjectKey = 0, @ConvertedToCampaignKey = @ConvertEntityKey
		
			select @EntityHasApprovedEstimates = count(EstimateKey)
			from   vEstimateApproved (nolock)
			where  Approved = 1
			and    CampaignKey = @ConvertedToCampaignKey
		end
		else
			select @ConvertedToProjectKey = 0, @ConvertedToCampaignKey = 0, @EntityHasApprovedEstimates = 0
			
		if @EntityHasApprovedEstimates > 0
			select @LeadHasApprovedEstimates = 0
								
	end
	
	if @ProjectKey > 0
	begin
		select @ConvertedFromLeadKey = LeadKey
		from   tLead (nolock)
		where  ConvertEntity = 'tProject'
		and    ConvertEntityKey = @ProjectKey

		select @EntityHasApprovedEstimates = count(EstimateKey)
		from   vEstimateApproved (nolock)
		where  Approved = 1
		and    ProjectKey = @ProjectKey

		if @ConvertedFromLeadKey > 0
			select @LeadHasApprovedEstimates = count(EstimateKey)
			from   vEstimateApproved (nolock)
			where  Approved = 1
			and    LeadKey = @ConvertedFromLeadKey

		if @EntityHasApprovedEstimates > 0
			select @LeadHasApprovedEstimates = 0
			
	end
	
	if @CampaignKey > 0
	begin
		select @ConvertedFromLeadKey = LeadKey
		from   tLead (nolock)
		where  ConvertEntity = 'tCampaign'
		and    ConvertEntityKey = @CampaignKey

		select @EntityHasApprovedEstimates = count(EstimateKey)
		from   vEstimateApproved (nolock)
		where  Approved = 1
		and    CampaignKey = @CampaignKey

		if @ConvertedFromLeadKey > 0
			select @LeadHasApprovedEstimates = count(EstimateKey)
			from   vEstimateApproved (nolock)
			where  Approved = 1
			and    LeadKey = @ConvertedFromLeadKey

		if @EntityHasApprovedEstimates > 0
			select @LeadHasApprovedEstimates = 0

	end
	
	select @ConvertedToProjectKey = isnull(@ConvertedToProjectKey, 0)
		  ,@ConvertedToCampaignKey = isnull(@ConvertedToCampaignKey, 0)
		  ,@ConvertedFromLeadKey = isnull(@ConvertedFromLeadKey, 0)

	/* The following totals will go to tLead for LeadKey 
	totals for LeadKey
	totals for ConvertedToProjectKey
	totals for ConvertedToCampaignKey
	*/
	
	select @SaleAmount = 0, @OutsideCostsGross = 0, @MediaGross = 0, @OutsideCostsNet = 0, @MediaNet = 0, @Labor = 0 
		  	
	if @LeadKey > 0
	begin		
		
		if @LeadHasApprovedEstimates > 0 
		begin
			select @EstimateTotal = 0, @ProdGross = 0, @IOBCGross = 0, @ProdNet = 0, @IOBCNet = 0 , @LaborGross = 0
			
			select @EstimateTotal = sum(isnull(EstimateTotal, 0) + isnull(SalesTaxAmount, 0) )
			from   vEstimateApproved (nolock)
			where  LeadKey = @LeadKey
			and    Approved = 1
			
			Select @ProdNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@ProdGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.LeadKey = @LeadKey
			And   i.ItemType = 0 -- prod
			And   e.Approved = 1
			 
			Select @IOBCNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@IOBCGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.LeadKey = @LeadKey
			And   i.ItemType in (1, 2) -- io/bc
			And   e.Approved = 1

			select @LaborGross = Sum(e.LaborGross)
			from   vEstimateApproved e (nolock)
			Where e.LeadKey = @LeadKey
			And   e.Approved = 1

			select @SaleAmount = @SaleAmount + isnull(@EstimateTotal, 0)
				   ,@OutsideCostsNet = @OutsideCostsNet + isnull(@ProdNet, 0)
				   ,@OutsideCostsGross = @OutsideCostsGross + isnull(@ProdGross, 0)
				   ,@MediaNet = @MediaNet + isnull(@IOBCNet, 0)
				   ,@MediaGross = @MediaGross + isnull(@IOBCGross, 0)
                   ,@Labor = @Labor + isnull(@LaborGross, 0)
		end		       		
		       		
		if @ConvertedToProjectKey > 0 and @EntityHasApprovedEstimates > 0
		begin
			select @EstimateTotal = 0, @ProdGross = 0, @IOBCGross = 0, @ProdNet = 0, @IOBCNet = 0, @LaborGross = 0 
			
			select @EstimateTotal = sum(isnull(EstimateTotal, 0) + isnull(SalesTaxAmount, 0) )
			from   vEstimateApproved (nolock)
			where  ProjectKey = @ConvertedToProjectKey
			and    Approved = 1
			
			Select @ProdNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@ProdGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ConvertedToProjectKey
			And   i.ItemType = 0 -- prod
			And   e.Approved = 1
			 
			Select @IOBCNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@IOBCGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ConvertedToProjectKey
			And   i.ItemType in (1, 2) -- io/bc
			And   e.Approved = 1

			select @LaborGross = Sum(e.LaborGross)
			from   vEstimateApproved e (nolock)
			Where e.ProjectKey = @ConvertedToProjectKey
			And   e.Approved = 1

			select @SaleAmount = @SaleAmount + isnull(@EstimateTotal, 0)
				   ,@OutsideCostsNet = @OutsideCostsNet + isnull(@ProdNet, 0)
				   ,@OutsideCostsGross = @OutsideCostsGross + isnull(@ProdGross, 0)
				   ,@MediaNet = @MediaNet + isnull(@IOBCNet, 0)
				   ,@MediaGross = @MediaGross + isnull(@IOBCGross, 0)
				   ,@Labor = @Labor + isnull(@LaborGross, 0)
		
		end


		if @ConvertedToCampaignKey > 0  and @EntityHasApprovedEstimates > 0
		begin
			select @EstimateTotal = 0, @ProdGross = 0, @IOBCGross = 0, @ProdNet = 0, @IOBCNet = 0, @LaborGross = 0 
			
			select @EstimateTotal = sum(isnull(EstimateTotal, 0) + isnull(SalesTaxAmount, 0) )
			from   vEstimateApproved (nolock)
			where  CampaignKey = @ConvertedToCampaignKey
			and    Approved = 1
			
			Select @ProdNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@ProdGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.CampaignKey = @ConvertedToCampaignKey
			And   i.ItemType = 0 -- prod
			And   e.Approved = 1
			 
			Select @IOBCNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@IOBCGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.CampaignKey = @ConvertedToCampaignKey
			And   i.ItemType in (1, 2) -- io/bc
			And   e.Approved = 1

			select @LaborGross = Sum(e.LaborGross)
			from   vEstimateApproved e (nolock)
			Where e.CampaignKey = @ConvertedToCampaignKey
			And   e.Approved = 1

			select @SaleAmount = @SaleAmount + isnull(@EstimateTotal, 0)
				   ,@OutsideCostsNet = @OutsideCostsNet + isnull(@ProdNet, 0)
				   ,@OutsideCostsGross = @OutsideCostsGross + isnull(@ProdGross, 0)
				   ,@MediaNet = @MediaNet + isnull(@IOBCNet, 0)
				   ,@MediaGross = @MediaGross + isnull(@IOBCGross, 0)
				   ,@Labor = @Labor + isnull(@LaborGross, 0)
		
		end
		       		
	end
	
	/* The following totals will go to tLead for ConvertedFromLeadKey 
	totals for ConvertedFromLeadKey
	totals for ProjectKey
	totals for CampaignKey
	*/
	
	select @SaleAmount2 = 0, @OutsideCostsGross2 = 0, @MediaGross2 = 0, @OutsideCostsNet2 = 0, @MediaNet2 = 0, @Labor2 = 0 
		  	
	if @ConvertedFromLeadKey > 0
	begin		
	
		if @LeadHasApprovedEstimates > 0
		begin
		
			select @EstimateTotal = 0, @ProdGross = 0, @IOBCGross = 0, @ProdNet = 0, @IOBCNet = 0, @LaborGross = 0 

			select @EstimateTotal = sum(isnull(EstimateTotal, 0) + isnull(SalesTaxAmount, 0) )
			from   vEstimateApproved (nolock)
			where  LeadKey = @ConvertedFromLeadKey
			and    Approved = 1
			
			Select @ProdNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@ProdGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.LeadKey = @ConvertedFromLeadKey
			And   i.ItemType = 0 -- prod
			And   e.Approved = 1
			 
			Select @IOBCNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@IOBCGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.LeadKey = @ConvertedFromLeadKey
			And   i.ItemType in (1, 2) -- io/bc
			And   e.Approved = 1

			select @LaborGross = Sum(e.LaborGross)
			from   vEstimateApproved e (nolock)
			Where e.LeadKey = @ConvertedFromLeadKey
			And   e.Approved = 1

			select @SaleAmount2 = @SaleAmount2 + isnull(@EstimateTotal, 0)
				   ,@OutsideCostsNet2 = @OutsideCostsNet2 + isnull(@ProdNet, 0)
				   ,@OutsideCostsGross2 = @OutsideCostsGross2 + isnull(@ProdGross, 0)
				   ,@MediaNet2 = @MediaNet2 + isnull(@IOBCNet, 0)
				   ,@MediaGross2 = @MediaGross2 + isnull(@IOBCGross, 0)
				   ,@Labor2 = @Labor2 + isnull(@LaborGross, 0)

		end
				       		
		if @ProjectKey > 0 and @EntityHasApprovedEstimates > 0
		begin
			select @EstimateTotal = 0, @ProdGross = 0, @IOBCGross = 0, @ProdNet = 0, @IOBCNet = 0, @LaborGross = 0 
			
			select @EstimateTotal = sum(isnull(EstimateTotal, 0) + isnull(SalesTaxAmount, 0) )
			from   vEstimateApproved (nolock)
			where  ProjectKey = @ProjectKey
			and    Approved = 1
			
			Select @ProdNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@ProdGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ProjectKey
			And   i.ItemType = 0 -- prod
			And   e.Approved = 1
			 
			Select @IOBCNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@IOBCGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.ProjectKey = @ProjectKey
			And   i.ItemType in (1, 2) -- io/bc
			And   e.Approved = 1

			select @LaborGross = Sum(e.LaborGross)
			from   vEstimateApproved e (nolock)
			Where e.ProjectKey = @ProjectKey
			And   e.Approved = 1

			select @SaleAmount2 = @SaleAmount2 + isnull(@EstimateTotal, 0)
				   ,@OutsideCostsNet2 = @OutsideCostsNet2 + isnull(@ProdNet, 0)
				   ,@OutsideCostsGross2 = @OutsideCostsGross2 + isnull(@ProdGross, 0)
				   ,@MediaNet2 = @MediaNet2 + isnull(@IOBCNet, 0)
				   ,@MediaGross2 = @MediaGross2 + isnull(@IOBCGross, 0)
				    ,@Labor2 = @Labor2 + isnull(@LaborGross, 0)
		
		end


		if @CampaignKey > 0 And @EntityHasApprovedEstimates > 0
		begin
			select @EstimateTotal = 0, @ProdGross = 0, @IOBCGross = 0, @ProdNet = 0, @IOBCNet = 0, @LaborGross = 0 
			
			select @EstimateTotal = sum(isnull(EstimateTotal, 0) + isnull(SalesTaxAmount, 0) )
			from   vEstimateApproved (nolock)
			where  CampaignKey = @CampaignKey
			and    Approved = 1
		
			Select @ProdNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@ProdGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.CampaignKey = @CampaignKey
			And   i.ItemType = 0 -- prod
			And   e.Approved = 1
			 
			Select @IOBCNet	= Sum(case 
				when e.ApprovedQty = 1 Then ete.TotalCost
				when e.ApprovedQty = 2 Then ete.TotalCost2
				when e.ApprovedQty = 3 Then ete.TotalCost3 
				when e.ApprovedQty = 4 Then ete.TotalCost4
				when e.ApprovedQty = 5 Then ete.TotalCost5
				when e.ApprovedQty = 6 Then ete.TotalCost6											 
				end)
				,@IOBCGross = Sum(case 
				when e.ApprovedQty = 1 Then ete.BillableCost
				when e.ApprovedQty = 2 Then ete.BillableCost2
				when e.ApprovedQty = 3 Then ete.BillableCost3 
				when e.ApprovedQty = 4 Then ete.BillableCost4
				when e.ApprovedQty = 5 Then ete.BillableCost5
				when e.ApprovedQty = 6 Then ete.BillableCost6											 
				end)
			From tEstimateTaskExpense ete (nolock)
				inner join vEstimateApproved e (nolock) on ete.EstimateKey = e.EstimateKey
				inner join tItem i (nolock) on ete.ItemKey = i.ItemKey
			Where e.CampaignKey = @CampaignKey
			And   i.ItemType in (1, 2) -- io/bc
			And   e.Approved = 1

			select @LaborGross = Sum(e.LaborGross)
			from   vEstimateApproved e (nolock)
			Where e.CampaignKey = @CampaignKey
			And   e.Approved = 1

			select @SaleAmount2 = @SaleAmount2 + isnull(@EstimateTotal, 0)
				   ,@OutsideCostsNet2 = @OutsideCostsNet2 + isnull(@ProdNet, 0)
				   ,@OutsideCostsGross2 = @OutsideCostsGross2 + isnull(@ProdGross, 0)
				   ,@MediaNet2 = @MediaNet2 + isnull(@IOBCNet, 0)
				   ,@MediaGross2 = @MediaGross2 + isnull(@IOBCGross, 0)
		           ,@Labor2 = @Labor2 + isnull(@LaborGross, 0)

		end
		       		
	end
	
	
	if @LeadKey > 0
	begin
		-- calc the AGI
		select @AGI = isnull(@SaleAmount, 0) - isnull(@OutsideCostsNet,0) - isnull(@MediaNet,0) 
	
		-- calc the markups
		if @OutsideCostsNet = 0
			Select @OutsideCostsPerc = 0
		else
			Select @OutsideCostsPerc = ((@OutsideCostsGross / @OutsideCostsNet) - 1.0) * 100.0

		if @MediaNet = 0
			Select @MediaPerc = 0
		else
			Select @MediaPerc = ((@MediaGross / @MediaNet) - 1.0) * 100.0
		
		update tLead
		set    SaleAmount = isnull(@SaleAmount, 0)
		      ,OutsideCostsGross = isnull(@OutsideCostsGross, 0)
		      ,MediaGross = isnull(@MediaGross, 0)
		      ,OutsideCostsPerc = isnull(@OutsideCostsPerc, 0)
		      ,MediaPerc = isnull(@MediaPerc, 0)
			  ,Labor = isnull(@Labor, 0)
		      ,AGI = isnull(@AGI, 0)
		where  LeadKey = @LeadKey
	end
	
	if @ConvertedFromLeadKey > 0
	begin
		-- calc the AGI
		select @AGI2 = isnull(@SaleAmount2, 0) - isnull(@OutsideCostsNet2,0) - isnull(@MediaNet2,0) 
	
		-- calc the markups
		if @OutsideCostsNet2 = 0
			Select @OutsideCostsPerc2 = 0
		else
			Select @OutsideCostsPerc2 = ((@OutsideCostsGross2 / @OutsideCostsNet2) - 1.0) * 100.0

		if @MediaNet2 = 0
			Select @MediaPerc2 = 0
		else
			Select @MediaPerc2 = ((@MediaGross2 / @MediaNet2) - 1.0) * 100.0
		
		update tLead
		set    SaleAmount = isnull(@SaleAmount2, 0)
		      ,OutsideCostsGross = isnull(@OutsideCostsGross2, 0)
		      ,MediaGross = isnull(@MediaGross2, 0)
		      ,OutsideCostsPerc = isnull(@OutsideCostsPerc2, 0)
		      ,MediaPerc = isnull(@MediaPerc2, 0)
		      ,Labor = isnull(@Labor2, 0)
		      ,AGI = isnull(@AGI2, 0)
		where  LeadKey = @ConvertedFromLeadKey
	end
	
	
	RETURN 1
GO
