USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFixedFeesCampaignProjectList]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spFixedFeesCampaignProjectList]
	(
	@CampaignKey int
	)
AS	--Encrypt

  /*
  || When     Who Rel   What
  || 12/02/10 GHL 10.539 Creation for campaign FF billing by project
  || 01/10/11 GHL 10.540 Instead of pulling all items/services for each project
  ||                     Just display one line per project
  */
  
	SET NOCOUNT ON
	
	declare @MultipleSegments int

	select @MultipleSegments = isnull(MultipleSegments, 0) 
	from   tCampaign (nolock)
	where  CampaignKey = @CampaignKey
	

	create table #project (
		ProjectKey int null
	    ,ProjectFullName varchar(1000) null

		,EstHours decimal(24, 4) null
		,EstLabor money null
		,EstExpenses money null

		,ActHours decimal(24, 4) null
		,ActLabor money null
		,ActExpenses money null

		,Billed money null
	
		,CampaignSegmentKey int null
		,DisplayOrder int identity(1,1)
		)

	-- First calculate budget and actual data
	insert #project (ProjectKey
		, ProjectFullName
		, EstHours
		, EstLabor
		, EstExpenses
		, CampaignSegmentKey
		)
	select ProjectKey, isnull(ProjectNumber, '') + ' - ' + isnull(ProjectName, '')
	    , isnull(EstHours, 0) + isnull(ApprovedCOHours, 0) 
		, isnull(EstLabor, 0) + isnull(ApprovedCOLabor, 0) 
		, isnull(EstExpenses, 0) + isnull(ApprovedCOExpense, 0) 
		, isnull(CampaignSegmentKey, 0)
	from   tProject (nolock)
	where  CampaignKey = @CampaignKey
	order by CampaignOrder, ProjectNumber

	update #project
	set				#project.ActHours = ISNULL((select sum(roll.Hours) 
					from tProjectRollup roll (nolock)
					Where roll.ProjectKey = #project.ProjectKey
					), 0) 
					
					,#project.ActLabor = ISNULL((select sum(roll.LaborGross) 
					from tProjectRollup roll (nolock)
					Where roll.ProjectKey = #project.ProjectKey
					), 0) 			

					,#project.ActExpenses = ISNULL((select sum(roll.ExpReceiptGross + roll.MiscCostGross + roll.VoucherGross + roll.OpenOrderGross) 
					from tProjectRollup roll (nolock)
					Where roll.ProjectKey = #project.ProjectKey
					), 0) 			

					,#project.Billed = ISNULL((SELECT Sum(isum.Amount) 
						from tInvoiceSummary isum (NOLOCK)
						WHERE isum.ProjectKey = #project.ProjectKey
						), 0)


	-- do not rely on display orders in db, create our own
	create table #segment (CampaignSegmentKey int null, SegmentName varchar(500) null, DisplayOrder int identity(1,1))  

	create table #line (
		Entity varchar(50) null
		,EntityKey int null
		,EntityName varchar(500) null
			
		,EstHours decimal(24, 4) null
		,EstLabor money null
		,EstExpenses money null
		,EstTotal money null

		,ActHours decimal(24, 4) null
		,ActLabor money null
		,ActExpenses money null
		,ActTotal money null

		,Billed money null
		,Remaining money null

		,LineKey INT IDENTITY(1,1)
		,ParentLineKey int null
		,DisplayOrder int null
		)

	if @MultipleSegments = 1
	begin
		if exists (select 1 from #project where CampaignSegmentKey = 0) 
		insert #segment (CampaignSegmentKey, SegmentName) values (0, 'No Segment')

		insert #segment (CampaignSegmentKey, SegmentName)
		select CampaignSegmentKey, SegmentName
		from   tCampaignSegment (nolock)
		where  CampaignKey = @CampaignKey
		order  by DisplayOrder, SegmentName

		declare @DisplayOrder int
		declare @SegmentKey int
		declare @SegmentName varchar(500)
		declare @LineKey int

		select @DisplayOrder = -1
		while (1=1)
		begin
			select @DisplayOrder = min(DisplayOrder)
			from   #segment
			where  DisplayOrder > @DisplayOrder

			if @DisplayOrder is null
				break

			select @SegmentKey = CampaignSegmentKey
			      ,@SegmentName = SegmentName 
			from   #segment
			where  DisplayOrder = @DisplayOrder

			insert #line (Entity ,EntityKey ,EntityName ,ParentLineKey)
			select  'tCampaignSegment', @SegmentKey, @SegmentName, 0
			
			select @LineKey = LineKey from #line where Entity = 'tCampaignSegment' and EntityKey = @SegmentKey
			 
			insert #line (Entity,EntityKey,EntityName ,EstHours ,EstLabor,EstExpenses,ActHours,ActLabor,ActExpenses,Billed,ParentLineKey)
			select 'tProject', ProjectKey, ProjectFullName,EstHours ,EstLabor,EstExpenses,ActHours,ActLabor,ActExpenses,Billed, @LineKey
			from   #project
			where  CampaignSegmentKey =@SegmentKey
			order by DisplayOrder

		end
		
	end
	 
	if @MultipleSegments = 0
	begin
		insert #line (Entity,EntityKey,EntityName ,EstHours ,EstLabor,EstExpenses,ActHours,ActLabor,ActExpenses,Billed,ParentLineKey)
			select 'tProject', ProjectKey, ProjectFullName,EstHours ,EstLabor,EstExpenses,ActHours,ActLabor,ActExpenses,Billed, 0
			from   #project
			order by DisplayOrder
	end

	--delete campaign segments without projects
	if @MultipleSegments = 1
		delete #line where #line.Entity = 'tCampaignSegment' 
		and not exists (select 1 from #line b where b.Entity = 'tProject' and b.ParentLineKey = #line.LineKey)  
			
	-- now manufacture a DisplayOrder, this is for the CMHierarchicalData
	declare @ProjectLineKey int

	if @MultipleSegments = 0
		update #line set DisplayOrder = LineKey

	if @MultipleSegments = 1
	begin
		-- do segments
		select @DisplayOrder = 1
		select @LineKey = -1
		while (1=1)
		begin
			select @LineKey = min(LineKey)
			from   #line
			where  ParentLineKey = 0
			and    LineKey > @LineKey

			if @LineKey is null
				break

			update #line set DisplayOrder = @DisplayOrder where LineKey = @LineKey
			set @DisplayOrder = @DisplayOrder + 1

		end

		-- do projects
		select @LineKey = -1
		while (1=1)
		begin
			select @LineKey = min(LineKey)
			from   #line
			where  ParentLineKey = 0
			and    LineKey > @LineKey

			if @LineKey is null
				break

			select @DisplayOrder = 1


			select @ProjectLineKey = -1
			while (1=1)
			begin
				select @ProjectLineKey = min(LineKey)
				from   #line
				where  ParentLineKey = @LineKey
				and    LineKey > @ProjectLineKey

				if @ProjectLineKey is null
					break

				update #line set DisplayOrder = @DisplayOrder where LineKey = @ProjectLineKey
				set @DisplayOrder = @DisplayOrder + 1

			end


		end

	end

	update #line 
	set    EstTotal = EstLabor + EstExpenses
	      ,ActTotal = ActLabor + ActExpenses  

	if @MultipleSegments = 1
		select * 
				,0 as [Percent]
				,0 as BillAmt
				,0 as Selected
				,LineKey as InvoiceOrder
				,case when Entity = 'tCampaignSegment' then 1 else 2 end as LineType
				,case when Entity = 'tCampaignSegment' then 0 else 1 end as LineLevel
		from #line
		order by LineKey
	else
		select * 
				,0 as [Percent]
				,0 as BillAmt
				,0 as Selected
				,LineKey as InvoiceOrder
				,2 as LineType
				,0 as LineLevel
		from #line
		order by LineKey
	

		 
	--select * from #project
	--select * from #segment
											
	RETURN 1
GO
