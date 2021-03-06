USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindOpportunityItems]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindOpportunityItems]
	@ForecastKey int = null
   ,@ENTITY_OPPORTUNITY varchar(20) = 'tLead' --This is a "constant" that's passed in here so that it can be defined in just one place
AS

/*
|| When      Who Rel      What
|| 9/7/12    CRG 10.5.6.0 Created
|| 10/23/12  GHL 10.561   Added reading of tLead when there are no estimates
||                        Do not group estimate records to help with drill downs
|| 12/14/12  GHL 10.563   Check if expenses are excluded
|| 06/26/13  GHL 10.569   (182036) Taking in now Net values    
|| 04/02/14  GHL 10.578   Added Net values for opps too           
*/

	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5

	-- Case when there is no estimate
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor
		)
	select ForecastDetailKey 
	    ,'tLead-Labor'
		, fd.EntityKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,l.Labor
		,1
	from #Detail fd (nolock)
		inner join tLead l (nolock) on fd.EntityKey = l.LeadKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 0
	and   isnull(l.Labor, 0) <> 0
	   
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor
		)
	select ForecastDetailKey 
		,'tLead-Production'
		, fd.EntityKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,l.OutsideCostsGross
		,0
	from #Detail fd (nolock)
		inner join tLead l (nolock) on fd.EntityKey = l.LeadKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 0
	and   isnull(l.OutsideCostsGross, 0) <> 0
	

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		AtNet
		)
	select ForecastDetailKey 
		,'tLead-Production'
		, fd.EntityKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,-1 * ROUND(l.OutsideCostsGross * ( 1.00 - isnull(l.OutsideCostsPerc, 0) / 100.00), 2)
		,0
		,1
	from #Detail fd (nolock)
		inner join tLead l (nolock) on fd.EntityKey = l.LeadKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 0
	and   isnull(l.OutsideCostsGross, 0) <> 0
	

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor
		)
	select ForecastDetailKey 
		,'tLead-Media'
		, fd.EntityKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,l.MediaGross
		,0
	from #Detail fd (nolock)
		inner join tLead l (nolock) on fd.EntityKey = l.LeadKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 0
	and   isnull(l.MediaGross, 0) <> 0

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		AtNet
		)
	select ForecastDetailKey 
		,'tLead-Media'
		, fd.EntityKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,-1 * ROUND(l.MediaGross * ( 1.00 - isnull(l.MediaPerc, 0) / 100.00), 2)
		,0
		,1
	from #Detail fd (nolock)
		inner join tLead l (nolock) on fd.EntityKey = l.LeadKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 0
	and   isnull(l.MediaGross, 0) <> 0

	-- I noticed that there were opportunities where SaleAmount <> 0 and everything else is 0
	-- place everything in labor

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor
		)
	select ForecastDetailKey 
	    ,'tLead-Labor'
		, fd.EntityKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,l.SaleAmount
		,1
	from #Detail fd (nolock)
		inner join tLead l (nolock) on fd.EntityKey = l.LeadKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 0
	and   isnull(l.SaleAmount, 0) <> 0
	and not exists (select 1 from #DetailItem
					where  #DetailItem.ForecastDetailKey= fd.ForecastDetailKey  
					)

	--case when there is an estimate

	-- estimate labor
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ServiceKey,
		UserKey,
		CampaignSegmentKey
		)
	select ForecastDetailKey 
		,'tEstimateTaskLabor'
		, e.EstimateKey -- there is no other key I could use
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,round(etl.Hours * etl.Rate, 2)
		,1
		,etl.TaskKey
		,etl.ServiceKey
		,etl.UserKey
		,etl.CampaignSegmentKey
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1

	-- now same but At Net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTaskLabor'
		, e.EstimateKey -- there is no other key I could use
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,-1 * round(etl.Hours * etl.Cost, 2)
		,1
		,etl.TaskKey
		,etl.ServiceKey
		,etl.UserKey
		,etl.CampaignSegmentKey
		,1 -- AtNet
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1

	-- estimate expense

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ItemKey,
		CampaignSegmentKey,
		ClassKey
		)
	select ForecastDetailKey 
		,'tEstimateTaskExpense'
		, ete.EstimateTaskExpenseKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		, case 
			when e.ApprovedQty = 1 Then ete.BillableCost
			when e.ApprovedQty = 2 Then ete.BillableCost2
			when e.ApprovedQty = 3 Then ete.BillableCost3
			when e.ApprovedQty = 4 Then ete.BillableCost4
			when e.ApprovedQty = 5 Then ete.BillableCost5
			when e.ApprovedQty = 6 Then ete.BillableCost6											 
			end 
		,0
		,ete.TaskKey
		,ete.ItemKey
		,ete.CampaignSegmentKey
		,ete.ClassKey
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1
	and   e.EstType <> @kByTaskOnly -- Task Expenses are already rolled up to EstimateTask

	-- Now same but At Net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTaskExpense'
		, ete.EstimateTaskExpenseKey
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		, case 
			when e.ApprovedQty = 1 Then -1 * ete.TotalCost
			when e.ApprovedQty = 2 Then -1 * ete.TotalCost2
			when e.ApprovedQty = 3 Then -1 * ete.TotalCost3
			when e.ApprovedQty = 4 Then -1 * ete.TotalCost4
			when e.ApprovedQty = 5 Then -1 * ete.TotalCost5
			when e.ApprovedQty = 6 Then -1 * ete.TotalCost6											 
			end 
		,0
		,ete.TaskKey
		,ete.ItemKey
		,ete.CampaignSegmentKey
		,ete.ClassKey
		,1 -- AtNet
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1
	and   e.EstType <> @kByTaskOnly -- Task Expenses are already rolled up to EstimateTask

	-- estimates by task
	-- Labor
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ServiceKey,
		UserKey,
		CampaignSegmentKey
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey 
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,et.EstLabor
		,1
		,et.TaskKey
		,null -- etl.ServiceKey
		,null ---etl.UserKey
		,null --etl.CampaignSegmentKey
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1
	and   et.EstLabor <> 0

	-- same but at net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey 
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,-1 * et.Hours * et.Cost
		,1
		,et.TaskKey
		,null -- etl.ServiceKey
		,null ---etl.UserKey
		,null --etl.CampaignSegmentKey
		,1 -- AtNet
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1
	and   et.Hours * et.Cost <> 0

	-- expenses
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ServiceKey,
		UserKey,
		CampaignSegmentKey
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey 
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,et.EstExpenses
		,0
		,et.TaskKey
		,null -- etl.ServiceKey
		,null ---etl.UserKey
		,null --etl.CampaignSegmentKey
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1
	and   et.EstExpenses <> 0

	-- now same but at net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, -- carefull: Task info is in tEstimateTaskTemp
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey 
		,fd.StartDate
		,case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
		,-1 * et.BudgetExpenses
		,0
		,et.TaskKey
		,null -- etl.ServiceKey
		,null ---etl.UserKey
		,null --etl.CampaignSegmentKey
		,1 -- AtNet
	from #Detail fd (nolock)
		inner join tEstimate e (nolock) on fd.EntityKey = e.LeadKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_OPPORTUNITY collate database_default
	and   fd.FromEstimate = 1
	and   isnull(e.IncludeInForecast, 0) = 1
	and   et.BudgetExpenses <> 0

	-- Check if we exclude expenses
	if exists (select 1 from tForecast (nolock) where ForecastKey = @ForecastKey and SpreadExpense = 3)
		delete #DetailItem where Labor = 0
GO
