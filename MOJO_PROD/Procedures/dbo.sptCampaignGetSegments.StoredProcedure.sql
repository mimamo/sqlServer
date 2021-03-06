USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignGetSegments]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignGetSegments]
	(
	@CampaignKey int
	)
AS
	SET NOCOUNT ON

	create table #segments(
		Entity varchar(20)
		,CampaignSegmentKey int null
		,ProjectKey int null
		,SegmentName varchar(500) null
		,DisplayOrder int null
		,LineLevel int null
		,LineType int null
		,CampaignOrder int null
		,ParentLineKey int null
		)

    insert #segments(
		Entity 
		,CampaignSegmentKey
		,ProjectKey 
		,SegmentName 
		,DisplayOrder
		,LineLevel
		,LineType 
		,CampaignOrder
		,ParentLineKey
		)
	select 'tCampaignSegment'
	     ,CampaignSegmentKey
		 ,0
		 ,SegmentName
		 ,DisplayOrder
		 ,0 -- LineLevel
		 ,1 -- LineType
		 ,0 -- CampaignOrder
		 ,0 -- ParentLineKey
    from tCampaignSegment (nolock)
	where CampaignKey = @CampaignKey

	insert #segments(
		Entity 
		,CampaignSegmentKey
		,ProjectKey 
		,SegmentName 
		,DisplayOrder
		,LineLevel
		,LineType 
		,CampaignOrder
		,ParentLineKey
		)
	select 'tProject'
	     ,CampaignSegmentKey + ProjectKey -- Manufactured
		 ,ProjectKey
		 ,ProjectNumber + ' - ' + ProjectName 
		 ,isnull(CampaignOrder, 0)
		 ,1 -- LineLevel
		 ,2 -- LineType
		 ,0 -- CampaignOrder
		 ,CampaignSegmentKey -- ParentLineKey
    from tProject (nolock)
	where CampaignKey = @CampaignKey

--select * from #segments

	-- need to set the displayOrder order on projects if missing
	declare @DisplayOrder int
	declare @CampaignDisplayOrder int
	declare @CampaignOrder int
	declare @CampaignSegmentKey int
	declare @ProjectKey int

	select @CampaignSegmentKey = -1
	while (1=1)
	begin
		select @CampaignSegmentKey = min(CampaignSegmentKey)
		from   #segments
		where  Entity = 'tCampaignSegment'
		and    CampaignSegmentKey > @CampaignSegmentKey

		if @CampaignSegmentKey is null
			break

        if exists (select 1 from #segments where Entity = 'tProject' and ParentLineKey = @CampaignSegmentKey and DisplayOrder = 0) 
		begin
			select @DisplayOrder = 1
			select @ProjectKey = -1
			while (1=1)
			begin
				select @ProjectKey = min (ProjectKey)
				from   #segments where Entity = 'tProject' and ParentLineKey = @CampaignSegmentKey
				and    ProjectKey > @ProjectKey
				
				if @ProjectKey is null
					break
					
				update #segments set DisplayOrder =	@DisplayOrder where ProjectKey = @ProjectKey  
			
				select @DisplayOrder = @DisplayOrder + 1 
			end -- Project loop
          
		  end -- if nod display order

		end -- campaign loop

--select * from #segments
--return
		-- no set the CampaignOrder
		select @CampaignOrder = 1
		select @CampaignDisplayOrder = -1
		while (1=1)
		begin
			select @CampaignDisplayOrder = min(DisplayOrder)
			from   #segments
			where  Entity = 'tCampaignSegment'
			and    DisplayOrder > @CampaignDisplayOrder

			if @CampaignDisplayOrder is null
				break

            select @CampaignSegmentKey = CampaignSegmentKey
			from   #segments
			where  Entity = 'tCampaignSegment'
			and    DisplayOrder = @CampaignDisplayOrder

            update #segments set CampaignOrder = @CampaignOrder where Entity = 'tCampaignSegment' and CampaignSegmentKey = @CampaignSegmentKey  
			
			select @CampaignOrder = @CampaignOrder + 1 

			select @DisplayOrder = -1
			while (1=1)
			begin
				select @DisplayOrder = min (DisplayOrder)
				from   #segments where Entity = 'tProject' and ParentLineKey = @CampaignSegmentKey
				and    DisplayOrder > @DisplayOrder
				
				if @DisplayOrder is null
					break
					
				update #segments set CampaignOrder = @CampaignOrder where Entity = 'tProject' and ParentLineKey = @CampaignSegmentKey
				and    DisplayOrder = @DisplayOrder

				select @CampaignOrder = @CampaignOrder + 1 
			end 

		end

--select * from #segments
--return

		select s.*
		      , @CampaignKey as CampaignKey
		      , isnull(cs.ProjectTypeKey, 0) as ProjectTypeKey 
			  ,cs.PlanStart
			  ,cs.PlanComplete
			  ,cs.SegmentDescription
			  ,cs.LeadKey
		from #segments s
		left outer join tCampaignSegment cs (nolock) on s.CampaignSegmentKey = cs.CampaignSegmentKey and s.Entity = 'tCampaignSegment' 
		order by s.CampaignOrder 

	RETURN 1
GO
