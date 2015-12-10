USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetForReportLayoutP]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetForReportLayoutP]
	(
	@EstimateKey int
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 8/23/10   GHL 10.5.3.4 Created for estimates with est type = 6 (by project)
|| 09/14/10  MFT 10.5.3.5 Added Description
|| 03/30/11  MFT 10.5.4.2 Changed Taxable to Taxable1, added Taxable2
|| 07/29/14  MFT 10.5.8.2 (223887) Fixed ExpenseGross/TotalGross fields
*/
	SET NOCOUNT ON
	
	/* Assume done in calling stored proc 

    CREATE TABLE #tEstDetail
				(Entity varchar(50) null,
				EntityKey int null,
				Subject text null,
				IndentLevel int null,
				SummaryTaskKey int null,
				CampaignSegmentKey int null,
				WorkTypeKey int null,
				LaborHours decimal(24,4) null,
				LaborGross money null,
				LaborRate money null,
				ItemQty decimal(24,4) null,
				ItemUnitRate money null,
				ExpenseGross money NULL,
				TotalGross money null,
				Taxable1 tinyint null,
				Taxable2 tinyint null,
				SortOrder int null,
				FinalOrder int null,
				KeepRow tinyint null,
				Bold tinyint null,
				DisplayOption smallint null)
		
		*/

		declare @kProjectEntity varchar(50) select @kProjectEntity = 'tEstimate' -- could also be 'tProject' 

		insert #tEstDetail (Entity
		                   ,EntityKey
						   ,Subject
						   ,Description
						   ,IndentLevel
						   ,SummaryTaskKey 
				           ,CampaignSegmentKey 
				           ,WorkTypeKey 
				           ,LaborHours 
				           ,LaborGross
				           ,LaborRate 
				           ,ItemQty 
				           ,ItemUnitRate
				           ,ExpenseGross
				           ,TotalGross
				           ,Taxable1
				           ,Taxable2
				           ,SortOrder 
				           ,FinalOrder 
				           ,KeepRow 
				           ,Bold 
				           ,DisplayOption
						   )
              select      @kProjectEntity -- 'tEstimate' -- or 'tProject'
			              ,ep.ProjectEstimateKey -- or ep.ProjectKey
						  ,rtrim(ltrim(e.EstimateName)) -- should be EstimateName rather than ProjectName
						  ,p.Description
						  ,case when isnull(p.CampaignSegmentKey, 0) = 0 then 0 else 1 end
						  ,0-- SummaryTaskKey 
				          ,isnull(p.CampaignSegmentKey, 0) 
				          ,0 --WorkTypeKey 
				          ,e.Hours
						  ,e.LaborGross
						  ,0 -- LaborRate
						  ,1 -- ItemQty 
				          ,0 -- ItemUnitRate
									,e.ExpenseGross -- ExpenseGross
									,ISNULL(e.LaborGross, 0) + ISNULL(e.ExpenseGross, 0) -- TotalGross
				          ,0 --Taxable1
				          ,0 --Taxable2
				          ,isnull(p.CampaignOrder, 0) --SortOrder 
				          ,0 --FinalOrder 
				          ,1-- KeepRow 
				          ,0 --Bold 
				          ,1 -- DisplayOption

			from        tEstimateProject ep (nolock)
			inner join  tProject p (nolock) on ep.ProjectKey = p.ProjectKey
			inner join  tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey
			where       ep.EstimateKey = @EstimateKey 
			  	
		--Insert segments
		INSERT	#tEstDetail
				(Entity,
				EntityKey,
				IndentLevel,
				KeepRow, Bold, DisplayOption,
				CampaignSegmentKey
				)
		SELECT DISTINCT 'tCampaignSegment',
				CampaignSegmentKey,
				0,
				1, 1, 2,
				CampaignSegmentKey
		FROM	#tEstDetail
		WHERE	CampaignSegmentKey > 0
		
		UPDATE	#tEstDetail
		SET		#tEstDetail.Subject = cs.SegmentName,
				#tEstDetail.SortOrder = isnull(cs.DisplayOrder, 0)
		FROM	#tEstDetail
		INNER JOIN tCampaignSegment cs (nolock) ON #tEstDetail.EntityKey = cs.CampaignSegmentKey AND #tEstDetail.Entity = 'tCampaignSegment'

		update #tEstDetail 
		set    #tEstDetail.LaborRate = case when #tEstDetail.LaborHours = 0 then 0 
			                                    else #tEstDetail.LaborGross / #tEstDetail.LaborHours end
		
		-- make sure that the sort orders are unique
		declare @CountRecs int
		declare @CountOrders int
		declare @CampaignSegmentKey int

		select @CountRecs = count(*) from #tEstDetail where Entity = 'tCampaignSegment'
		select @CountOrders = count(distinct SortOrder) from #tEstDetail where Entity = 'tCampaignSegment'

		-- if different, something is wrong
		if @CountRecs <> @CountOrders
			update #tEstDetail set SortOrder = EntityKey  where Entity = 'tCampaignSegment'

		select @CampaignSegmentKey = -1										 
		while (1=1)
		begin
			select @CampaignSegmentKey = min(EntityKey)
			from  #tEstDetail
			where Entity = 'tCampaignSegment'
			and   EntityKey > @CampaignSegmentKey

			if @CampaignSegmentKey is null
				break

			select @CountRecs = count(*) from #tEstDetail where Entity = @kProjectEntity and CampaignSegmentKey = @CampaignSegmentKey
			select @CountOrders = count(distinct SortOrder) from #tEstDetail where Entity = @kProjectEntity and CampaignSegmentKey = @CampaignSegmentKey
	
			-- if different, something is wrong
			if @CountRecs <> @CountOrders
				update #tEstDetail set SortOrder = EntityKey  where Entity = @kProjectEntity and CampaignSegmentKey = @CampaignSegmentKey

		end


		-- now determine the final order
		declare @SortOrder int --  for segments
		declare @SortOrder2 int -- for projects
		declare @FinalOrder int

		select @SortOrder = -1
				,@FinalOrder = 1

		while (1=1)
		begin
			select @SortOrder = min(SortOrder) 
			from   #tEstDetail
			where  Entity = 'tCampaignSegment'
			and    SortOrder > @SortOrder

			if @SortOrder is null
				break
				
			
			select @CampaignSegmentKey = EntityKey
			from   #tEstDetail
			where  Entity = 'tCampaignSegment'
			and    SortOrder = @SortOrder

			update #tEstDetail
			set    FinalOrder = @FinalOrder 
			where  Entity = 'tCampaignSegment'
			and    SortOrder = @SortOrder

			select @FinalOrder = @FinalOrder + 1

			select @SortOrder2 = -1

			while (1=1)
			begin
				select @SortOrder2 = min(SortOrder) 
				from   #tEstDetail
				where  Entity = @kProjectEntity
				and    SortOrder > @SortOrder2
				and    CampaignSegmentKey = @CampaignSegmentKey

				if @SortOrder2 is null
					break

				update #tEstDetail
				set    FinalOrder = @FinalOrder 
				where  Entity = @kProjectEntity
				and    SortOrder = @SortOrder2
				and    CampaignSegmentKey = @CampaignSegmentKey

				select @FinalOrder = @FinalOrder + 1

			end

		end

		--select * from #tEstDetail order by FinalOrder

	RETURN 1
GO
