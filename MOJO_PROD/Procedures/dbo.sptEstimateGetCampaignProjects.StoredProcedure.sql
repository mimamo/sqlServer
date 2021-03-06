USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetCampaignProjects]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetCampaignProjects]
	(
	@EstimateKey int
	,@CampaignKey int
	,@RemoveUnusedSegments int = 1
	,@RemoveUnusedProjects int = 0
	)

AS --Encrypt

/*
|| When      Who Rel      What
|| 08/16/10  GHL 10.5.3.3 Creation to handle estimate by projects
|| 08/17/10  GHL 10.5.3.4 Projects without campaign segments are inserted at the same time as segments
||                        so that users can place them at the top if they choose to
|| 08/17/10  GHL 10.5.3.4 Added @RemoveUnusedProjects so that we can use this sp in the report  
||                        Added fields for report such as description, LaborGross, ExpenseGross
|| 01/04/11  GHL 10.5.4.0 (98496) Do not include ContingencyTotal from the projects, it will be recalculated at the campaign level 
*/
	SET NOCOUNT ON

	if isnull(@CampaignKey, 0) = 0
	begin
		-- just to get a table in Estimate.vb
		select ProjectKey from tProject (nolock) where 1=2
		return 1 
	end

	declare @MultipleSegments int

	select @MultipleSegments = isnull(c.MultipleSegments, 0)
    from   tCampaign c (nolock) 
	where  c.CampaignKey = @CampaignKey

	create table #project (
		Entity varchar(50) null -- 'tProject' or 'tCampaignSegment'

		-- This is the big trick here
		-- I use an identity because we have ProjectKey or CampaignSegmentKey in the same table
		-- and also this way, the records will be automatically ordered by DisplayOrder or CampaignOrder
		,LineKey int identity(1,1)  

		,ProjectNumber varchar(50) null
		,ProjectName varchar(100) null
		,ProjectFullName varchar(500) null
		,ProjectDescription text null

		,EstimateNumber varchar(50) null
		,EstimateName varchar(100) null
		,EstimateFullName varchar(500) null
		,EstimateDescription text null

		,EstimateTotal money null -- total for the estimate grid (includes tax) 
		,LaborGross money null
		,ExpenseGross money null
		,TotalGross money null

		,ParentLineKey int null
		,LineType int null
		,LineLevel int null
		,DisplayOrder int null
		,CampaignOrder int null

		,ProjectKey int null
		,CampaignSegmentKey int null
		,ProjectEstimateKey int null
		)


	-- if no segments, just query tProject/tEstimateProject
	if @MultipleSegments = 0
	begin
		insert #project (
			Entity 

			,ProjectNumber 
			,ProjectName
			,ProjectFullName 
		    ,ProjectDescription

			,EstimateNumber 
			,EstimateName 
			,EstimateFullName 
			,EstimateDescription

			,EstimateTotal 
			,LaborGross
			,ExpenseGross
			,TotalGross

			,ParentLineKey 
			,LineType 
			,LineLevel 
			,DisplayOrder 
			,CampaignOrder 

			,ProjectKey 
			,CampaignSegmentKey 
			,ProjectEstimateKey 
			)

		select 'tProject'
		      
			  ,ltrim(rtrim(p.ProjectNumber))
			  ,p.ProjectName
			  ,ltrim(rtrim(p.ProjectNumber)) + ' - ' + p.ProjectName 
			  ,p.Description

			  ,rtrim(ltrim(e.EstimateNumber))
			  ,rtrim(ltrim(e.EstimateName))
			  ,isnull(rtrim(ltrim(e.EstimateNumber)) + ' - ', '') + isnull(e.EstimateName, '') 
			  ,e.EstDescription

			  ,isnull(e.EstimateTotal, 0) + isnull(e.TaxableTotal, 0)
			  ,isnull(e.LaborGross,0)
			  ,isnull(e.ExpenseGross,0)
			  ,isnull(e.EstimateTotal,0)


			  ,0  As ParentLineKey --int null
			  ,1  As LineType --int null
			  ,0  As LineLevel --int null
			  ,CampaignOrder As DisplayOrder --int null
			  ,CampaignOrder --int null

			  ,p.ProjectKey 
			  , 0 As CampaignSegmentKey 
			  ,ep.ProjectEstimateKey 

		from   tProject p (nolock)
		    left outer join tEstimateProject ep (nolock) on ep.EstimateKey = @EstimateKey and ep.ProjectKey = p.ProjectKey
		    left outer join tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey
		where  p.CampaignKey = @CampaignKey
		order by isnull(p.CampaignOrder, 0), p.ProjectNumber 

		If @RemoveUnusedProjects = 1
			 delete #project 
			 where  #project.Entity = 'tProject'
			 and    isnull(#project.EstimateTotal, 0) = 0

		select * from #project order by CampaignOrder

		return 1
	end

	-- if by segment, we need more info

    -- capture segments (ordered by DisplayOrder)
	insert #project(
		Entity 

		,ProjectNumber 
		,ProjectName
		,ProjectFullName 
		,ProjectDescription

		,EstimateNumber 
		,EstimateName 
		,EstimateFullName 

		,EstimateTotal 

		,ParentLineKey 
		,LineType 
		,LineLevel 
		,DisplayOrder 
		,CampaignOrder 

		,ProjectKey 
		,CampaignSegmentKey 
		,ProjectEstimateKey 
		)

	select 'tCampaignSegment'

		,'' As ProjectNumber -- ProjectNumber 
		,'' --ProjectName
		,SegmentName --ProjectFullName 
		,'' -- ProjectDescription

		,'' -- EstimateNumber 
		,'' -- EstimateName 
		,'' -- EstimateFullName 

		,0 --EstimateTotal 

		,0 --ParentLineKey 
		,1 -- LineType 
		,0 -- LineLevel 
		,DisplayOrder 
		,0 --CampaignOrder 

		,0 --ProjectKey 
		,CampaignSegmentKey
		,0 --ProjectEstimateKey 
		 
    from tCampaignSegment (nolock)
	where CampaignKey = @CampaignKey
	
	UNION ALL

	select 'tProject'

		,ltrim(rtrim(ProjectNumber)) As ProjectNumber 
		,ProjectName
		,ltrim(rtrim(ProjectNumber)) + ' - ' + ProjectName as ProjectFullName 
		,Description

		,'' -- EstimateNumber 
		,'' -- EstimateName 
		,'' -- EstimateFullName 

		,0 --EstimateTotal 

		,0 --ParentLineKey 
		,2 -- LineType 
		,0 -- LineLevel 
		,CampaignOrder as DisplayOrder
		,0 --CampaignOrder 

		,ProjectKey 
		,isnull(CampaignSegmentKey, 0)
		,0 --ProjectEstimateKey 
		 
    from tProject (nolock)
	where CampaignKey = @CampaignKey
	and   isnull(CampaignSegmentKey, 0) = 0

	order by DisplayOrder, ProjectNumber

	-- capture projects (ordered by CampaignOrder, ProjectOrder)
	insert #project(
		Entity 

		,ProjectNumber 
		,ProjectName
		,ProjectFullName 
		,ProjectDescription

		,EstimateNumber 
		,EstimateName 
		,EstimateFullName 

		,EstimateTotal 

		,ParentLineKey 
		,LineType 
		,LineLevel 
		,DisplayOrder 
		,CampaignOrder 

		,ProjectKey 
		,CampaignSegmentKey 
		,ProjectEstimateKey 
		)
	select 'tProject'

		,ltrim(rtrim(ProjectNumber)) 
		,ProjectName
		,ltrim(rtrim(ProjectNumber)) + ' - ' + ProjectName as ProjectFullName 
		,Description

		,'' -- EstimateNumber 
		,'' -- EstimateName 
		,'' -- EstimateFullName 

		,0 --EstimateTotal 

		,0 --ParentLineKey 
		,2 -- LineType 
		,1 -- LineLevel 
		,CampaignOrder 
		,0 --CampaignOrder 

		,ProjectKey 
		,isnull(CampaignSegmentKey, 0)
		,0 --ProjectEstimateKey 
		 
    from tProject (nolock)
	where CampaignKey = @CampaignKey
	and isnull(CampaignSegmentKey, 0) > 0
	order by CampaignOrder, ProjectNumber

	-- capture estimate info
	update #project
	set       #project.ProjectEstimateKey = ep.ProjectEstimateKey
			  ,#project.EstimateNumber = rtrim(ltrim(e.EstimateNumber))
			  ,#project.EstimateName = rtrim(ltrim(e.EstimateName))
			  ,#project.EstimateFullName = isnull(rtrim(ltrim(e.EstimateNumber)) + ' - ', '') + isnull(e.EstimateName, '')
			  ,#project.EstimateDescription = e.EstDescription
 			   
			  ,#project.EstimateTotal = isnull(e.EstimateTotal, 0) + isnull(e.TaxableTotal, 0)
	          ,#project.LaborGross = isnull(e.LaborGross, 0) 
			  ,#project.ExpenseGross = isnull(e.ExpenseGross, 0) 
			  ,#project.TotalGross = isnull(e.EstimateTotal, 0)
   
	  from   #project 
			inner join tEstimateProject ep (nolock) on ep.EstimateKey = @EstimateKey and #project.ProjectKey = ep.ProjectKey
		    inner join tEstimate e (nolock) on ep.ProjectEstimateKey = e.EstimateKey

     -- update parents on projects
     update #project
	 set    #project.ParentLineKey = isnull((
		 select MIN(b.LineKey)
		 from   #project b
		 where  b.CampaignSegmentKey = #project.CampaignSegmentKey
	 ),0)
	 where #project.Entity = 'tProject'
	and   isnull(#project.CampaignSegmentKey, 0) > 0    
	 

	 -- on the estimate report, we do not need the unused projects 
	 If @RemoveUnusedProjects = 1
	 delete #project 
	 where  #project.Entity = 'tProject'
	 and    isnull(#project.EstimateTotal, 0) = 0

	 -- now I delete segments if there are no projects on them
	 -- because that would look weird on the estimate grid
	If @RemoveUnusedSegments = 1
	 delete #project 
	 where  #project.Entity = 'tCampaignSegment'
	 and    not exists (select 1 from #project b where b.Entity = 'tProject' and b.CampaignSegmentKey = #project.CampaignSegmentKey) 
	  

	-- now redetermine DisplayOrder and CampaignOrder since I may have some holes or duplicates

	declare @RootLineKey int
	declare @RootDisplayOrder int
	declare @LineKey int
	declare @DisplayOrder int
	declare @CampaignOrder int

	select @CampaignOrder = 1
	select @RootLineKey = -1
	select @RootDisplayOrder = 1

	-- start with the root
	while (1=1)
	begin
		select @RootLineKey = min(LineKey)
		from   #project
		where  ParentLineKey = 0
		and    LineKey > @RootLineKey

		if @RootLineKey is null
			break

		update #project
		set    DisplayOrder = @RootDisplayOrder
		      ,CampaignOrder = @CampaignOrder
        where LineKey = @RootLineKey

		select @RootDisplayOrder = @RootDisplayOrder + 1, @CampaignOrder = @CampaignOrder + 1

		-- process children now
		if exists (select 1 from  #project where ParentLineKey = @RootLineKey) 
		begin
			select @LineKey = -1, @DisplayOrder = 1

			while (1=1)
			begin
				select @LineKey = min(LineKey)
				from   #project
				where  ParentLineKey = @RootLineKey
				and    LineKey > @LineKey

				if @LineKey is null
					break

				update #project
				set    DisplayOrder = @DisplayOrder
					  ,CampaignOrder = @CampaignOrder
				where LineKey = @LineKey

				select @DisplayOrder = @DisplayOrder + 1, @CampaignOrder = @CampaignOrder + 1
                

			end -- children loop

		end -- exists children

	end -- root loop

	select p.* 
	      ,cs.SegmentName as ReportSegmentName
	from #project p
	left join tCampaignSegment cs (nolock) on p.CampaignSegmentKey = cs.CampaignSegmentKey    
	order by p.CampaignOrder

	RETURN 1
GO
