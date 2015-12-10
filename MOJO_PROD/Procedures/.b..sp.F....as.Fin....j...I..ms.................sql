USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindProjectItems]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindProjectItems]
	@ForecastKey int = null
   ,@ENTITY_POTENTIAL_PROJECT varchar(20) --This is a "constant" that's passed in here so that it can be defined in just one place
   ,@ENTITY_APPROVED_PROJECT varchar(20) --This is a "constant" that's passed in here so that it can be defined in just one place
AS

/*
|| When      Who Rel      What
|| 9/7/12    CRG 10.5.6.0 Created
|| 10/23/12  GHL 10.561   Do not group estimate records to help with drill downs
|| 12/14/12  GHL 10.563   Check if expenses are excluded
|| 06/26/13  GHL 10.569   (182036) Taking in now Net values      
|| 07/02/13  GHL 10.5.6.9 (182036) Added logic for tBillingSchedule (FF projects only)   
||                        For each FF project where a billing schedule with % Budget not blank is found in forecast range
||                        apply % Budget on all estimate gross values (regardless of task dates)  
||                        and set detail item dates to billing schedule next date
||                        for subsequent billing schedule records, copy initial set and apply % Budget and next date    
|| 05/29/14 GHL 10.580    (217700) Since users were suprised with FF projects showing records outside of the billing schedule
||                        I added some restrictions and deletions to make sure that recs stick to the billing schedule 
|| 07/30/14 GHL 10.582    (224271) When processing FF projects, take gross and net (I was only taking records at gross)  
|| 11/24/14 GHL 10.5.8.6  (230762) Added tForecastDetail.EndDate because DATEDIFF to get Months is not reliable 
|| 12/11/14 GHL 10.5.8.7  (239178) When the project is non billable, do not take Gross   
|| 03/13/15 GHL 10.5.9.0  (249796) Reviewed logic for approved/unapproved projects  
*/

	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5

	-- reset that flag, I am using it here
	update #DetailItem set UpdateFlag = 0

 	-- estimate task labor
	----------------------

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		UpdateFlag 
		)
	select ForecastDetailKey 
		,'tEstimateTaskLabor'
		, e.EstimateKey -- there is no other key I could use
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,round(etl.Hours * etl.Rate, 2)
		,1 -- labor
		,etl.TaskKey
		,etl.ServiceKey
		,etl.UserKey
		,etl.CampaignSegmentKey
		,1 --update flag

	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and  e.Approved = 1 
	
	-- now same but the Net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ServiceKey,
		UserKey,
		CampaignSegmentKey,
		UpdateFlag, 
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTaskLabor'
		, e.EstimateKey -- there is no other key I could use
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,-1 * round(etl.Hours * etl.Cost, 2)
		,1 -- labor
		,etl.TaskKey
		,etl.ServiceKey
		,etl.UserKey
		,etl.CampaignSegmentKey
		,1 --update flag
		,1 --At Net
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and  e.Approved = 1 
	
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
		UpdateFlag 
		)
	select ForecastDetailKey 
		,'tEstimateTaskLabor'
		, e.EstimateKey -- there is no other key I could use
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,round(etl.Hours * etl.Rate, 2)
		,1 -- labor
		,etl.TaskKey
		,etl.ServiceKey
		,etl.UserKey
		,etl.CampaignSegmentKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	
	-- Same but AtNet
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
		UpdateFlag,
		AtNet 
		)
	select ForecastDetailKey 
		,'tEstimateTaskLabor'
		, e.EstimateKey -- there is no other key I could use
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,-1 * round(etl.Hours * etl.Cost, 2)
		,1 -- labor
		,etl.TaskKey
		,etl.ServiceKey
		,etl.UserKey
		,etl.CampaignSegmentKey
		,1 --UpdateFlag
		,1 --AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskLabor etl (nolock) on e.EstimateKey = etl.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	
	-- estimate task expense
	----------------------

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag
		)
	select ForecastDetailKey 
		,'tEstimateTaskExpense'
		, ete.EstimateTaskExpenseKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, case 
			when e.ApprovedQty = 1 Then ete.BillableCost
			when e.ApprovedQty = 2 Then ete.BillableCost2
			when e.ApprovedQty = 3 Then ete.BillableCost3
			when e.ApprovedQty = 4 Then ete.BillableCost4
			when e.ApprovedQty = 5 Then ete.BillableCost5
			when e.ApprovedQty = 6 Then ete.BillableCost6											 
			end 
		,0 --expense
		,ete.TaskKey
		,ete.ItemKey
		,ete.CampaignSegmentKey
		,ete.ClassKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and   e.Approved = 1 
	and   e.EstType <> @kByTaskOnly -- Task Expenses are already rolled up to EstimateTask

	-- same but AtNet
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTaskExpense'
		, ete.EstimateTaskExpenseKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, case 
			when e.ApprovedQty = 1 Then -1 * ete.TotalCost
			when e.ApprovedQty = 2 Then -1 * ete.TotalCost2
			when e.ApprovedQty = 3 Then -1 * ete.TotalCost3
			when e.ApprovedQty = 4 Then -1 * ete.TotalCost4
			when e.ApprovedQty = 5 Then -1 * ete.TotalCost5
			when e.ApprovedQty = 6 Then -1 * ete.TotalCost6											

 
			end 
		,0 --expense
		,ete.TaskKey
		,ete.ItemKey
		,ete.CampaignSegmentKey
		,ete.ClassKey
		,1 --UpdateFlag
		,1 --AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and   e.Approved = 1 
	and   e.EstType <> @kByTaskOnly -- Task Expenses are already rolled up to EstimateTask

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag
		)
	select ForecastDetailKey 
		,'tEstimateTaskExpense'
		, ete.EstimateTaskExpenseKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, case 
			when e.ApprovedQty = 1 Then ete.BillableCost
			when e.ApprovedQty = 2 Then ete.BillableCost2
			when e.ApprovedQty = 3 Then ete.BillableCost3
			when e.ApprovedQty = 4 Then ete.BillableCost4
			when e.ApprovedQty = 5 Then ete.BillableCost5
			when e.ApprovedQty = 6 Then ete.BillableCost6											 
			end 
		,0 --expense
		,ete.TaskKey
		,ete.ItemKey
		,ete.CampaignSegmentKey
		,ete.ClassKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and   e.EstType <> @kByTaskOnly -- Task Expenses are already rolled up to EstimateTask
    and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	

	-- same but AtNet
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTaskExpense'
		, ete.EstimateTaskExpenseKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, case 
			when e.ApprovedQty = 1 Then -1 * ete.TotalCost
			when e.ApprovedQty = 2 Then -1 * ete.TotalCost2
			when e.ApprovedQty = 3 Then -1 * ete.TotalCost3
			when e.ApprovedQty = 4 Then -1 * ete.TotalCost4
			when e.ApprovedQty = 5 Then -1 * ete.TotalCost5
			when e.ApprovedQty = 6 Then -1 * ete.TotalCost6											

 
			end 
		,0 --expense
		,ete.TaskKey
		,ete.ItemKey
		,ete.CampaignSegmentKey
		,ete.ClassKey
		,1 --UpdateFlag
		,1 --AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTaskExpense ete (nolock) on e.EstimateKey = ete.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and   e.EstType <> @kByTaskOnly -- Task Expenses are already rolled up to EstimateTask
    and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	

	-- estimate by task (labor)
	----------------------

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,et.EstLabor 
		,1 --labor
		,et.TaskKey
		,null -- ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and   e.Approved = 1 
	and   et.EstLabor <>0 
  
	-- same but At Net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,-1 * et.Hours * et.Cost 
		,1 --labor
		,et.TaskKey
		,null -- ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag
		,1 -- AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and  e.Approved = 1 
	and   et.Hours * et.Cost <>0 
   
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, et.EstLabor 
		,1 --labor
		,et.TaskKey
		,null --ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and   et.EstLabor <>0 
    and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	

	-- same but AtNet
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, -1 * et.Hours * et.Cost
		,1 --labor
		,et.TaskKey
		,null --ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag
		,1 -- AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and   et.Hours * et.Cost <>0 
    and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	

	-- estimate by task (expense)
	----------------------

	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,et.EstExpenses 
		,0 --EstExpenses
		,et.TaskKey
		,null -- ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and   et.EstExpenses <>0 
    and  e.Approved = 1 

	-- same but At Net
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		,-1 * et.BudgetExpenses 
		,0 --Expenses
		,et.TaskKey
		,null -- ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag
		,1 -- AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	and   et.BudgetExpenses <>0 
	and  e.Approved = 1 


	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, et.EstExpenses 
		,0 --expense
		,et.TaskKey
		,null --ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and   et.EstExpenses <>0 
	and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	

	-- same but AtNet
	insert #DetailItem 
		(
		ForecastDetailKey,
		Entity,
		EntityKey,
		StartDate,
		EndDate,
		Total,
		Labor,
		TaskKey, 
		ItemKey,
		CampaignSegmentKey,
		ClassKey,
		UpdateFlag,
		AtNet
		)
	select ForecastDetailKey 
		,'tEstimateTask'
		, et.EstimateTaskKey
		,fd.StartDate
		,case when fd.EndDate is not null then fd.EndDate
			else
			case when fd.Months = 0 then fd.StartDate else DATEADD(D, -1, DATEADD(M, fd.Months, fd.StartDate)) end
			end
		, -1 * et.BudgetExpenses 
		,0 --expense
		,et.TaskKey
		,null --ete.ItemKey
		,null --ete.CampaignSegmentKey
		,null --ete.ClassKey
		,1 --UpdateFlag
		,1 --AtNet 
	from #Detail fd (nolock)
		inner join vEstimateApproved e (nolock) on fd.EntityKey = e.ProjectKey
		inner join tEstimateTask et (nolock) on e.EstimateKey = et.EstimateKey
	where fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	and   et.BudgetExpenses <>0 
    and  e.Approved = 0 
	and  isnull(e.IncludeInForecast, 0) = 1
	

	-- Now get the StartDate/End Dates from the tasks
	update #DetailItem
	set    #DetailItem.StartDate = t.PlanStart
		    ,#DetailItem.EndDate = t.PlanComplete
	from   tTask t (nolock)
	where  #DetailItem.TaskKey = t.TaskKey
	and    #DetailItem.UpdateFlag  = 1 -- indicates that they are connected to projects

	declare @ForecastStartDate smalldatetime
	declare @ForecastEndDate smalldatetime
	declare @StartMonth int
	declare @StartYear int
	declare @CompanyKey int

	SELECT	@StartMonth = StartMonth 
			,@StartYear = StartYear
			,@CompanyKey = CompanyKey
	FROM	tForecast (nolock)
	WHERE	ForecastKey = @ForecastKey

	select @ForecastStartDate = cast (@StartMonth as varchar(2)) + '/01/' + cast (@StartYear as varchar(4))
	select @ForecastEndDate = dateadd(yy, 1, @ForecastStartDate)
	select @ForecastEndDate = dateadd(d, -1, @ForecastEndDate)

	declare @NextYearEndDate smalldatetime
	select @NextYearEndDate = dateadd(yy, 1, @ForecastEndDate)
	select @NextYearEndDate = dateadd(d, -1, @NextYearEndDate)

	-- Logic for BillingSchedule
	create table #BillingSchedule (ProjectKey int null, NextBillDate datetime null, PercentBudget decimal(24,4) null)

	-- update Billing Schedule like in Billing Worksheets
	UPDATE tBillingSchedule
	SET	   tBillingSchedule.NextBillDate = t.ActComplete 
	FROM   tProject p (NOLOCK)
		  ,tTask t (NOLOCK)
	WHERE  tBillingSchedule.ProjectKey = p.ProjectKey
	AND    tBillingSchedule.TaskKey = t.TaskKey
	AND    p.CompanyKey = @CompanyKey
	--AND    p.Active = 1
	AND    p.Closed = 0    
	AND	   t.ActComplete IS NOT NULL	
	AND    tBillingSchedule.NextBillDate IS NULL

	insert #BillingSchedule (ProjectKey, NextBillDate, PercentBudget)
	select bs.ProjectKey, bs.NextBillDate, bs.PercentBudget
	from   tBillingSchedule bs (nolock)
		inner join tProject p (nolock) on bs.ProjectKey = p.ProjectKey
	where p.CompanyKey =  @CompanyKey
	and   p.BillingMethod = 2 -- Fixed Fee only
	and   bs.NextBillDate is not null
	and   bs.NextBillDate >= @ForecastStartDate
	and   bs.NextBillDate <= @ForecastEndDate
	and   isnull(bs.PercentBudget, 0) > 0
	and   p.ProjectKey in (select EntityKey from #Detail where Entity = @ENTITY_APPROVED_PROJECT or Entity = @ENTITY_POTENTIAL_PROJECT )

	-- add the schedule before @ForecastStartDate
	insert #BillingSchedule (ProjectKey, NextBillDate, PercentBudget)
	select bs.ProjectKey, bs.NextBillDate, bs.PercentBudget
	from   tBillingSchedule bs (nolock)
		inner join tProject p (nolock) on bs.ProjectKey = p.ProjectKey
	where p.CompanyKey =  @CompanyKey
	and   p.BillingMethod = 2 -- Fixed Fee only
	and   bs.NextBillDate is not null
	and   bs.NextBillDate < @ForecastStartDate
	and   isnull(bs.PercentBudget, 0) > 0
	and   p.ProjectKey in (select ProjectKey from #BillingSchedule) -- must be in the schedule already

	-- add the schedule after @ForecastEndDate
	insert #BillingSchedule (ProjectKey, NextBillDate, PercentBudget)
	select bs.ProjectKey, bs.NextBillDate, bs.PercentBudget
	from   tBillingSchedule bs (nolock)
		inner join tProject p (nolock) on bs.ProjectKey = p.ProjectKey
	where p.CompanyKey =  @CompanyKey
	and   p.BillingMethod = 2 -- Fixed Fee only
	and   bs.NextBillDate is not null
	and   bs.NextBillDate > @ForecastEndDate
	and   bs.NextBillDate <= @NextYearEndDate
	and   isnull(bs.PercentBudget, 0) > 0
	and   p.ProjectKey in (select ProjectKey from #BillingSchedule) -- must be in the schedule already

	--select * from #BillingSchedule
	--select * from #DetailItem

	-- now save the original amount total in UpdateAmount
	update #DetailItem
	set    UpdateAmount = Total
	where  UpdateFlag = 1 -- connected to projects

	-- delete FF items if they do not have a bill schedule 
	delete #DetailItem
	from   #Detail fd
	       ,tProject p (nolock)
	where  #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and (fd.Entity = @ENTITY_APPROVED_PROJECT or fd.Entity = @ENTITY_POTENTIAL_PROJECT)
	and fd.EntityKey = p.ProjectKey 			  
	and p.BillingMethod = 2 -- FF
	and not exists (select 1 from #BillingSchedule bills where bills.ProjectKey =  fd.EntityKey)

	declare @ProjectKey int
	declare @NextBillDate datetime
	declare @PercentBudget decimal(24, 4)
	declare @FirstBill int

	select @ProjectKey = -1
	while (1=1)
	begin
		select @ProjectKey = min(ProjectKey)
		from   #BillingSchedule
		where  ProjectKey > @ProjectKey

		if @ProjectKey is null
			break

		select @NextBillDate = '1/1/1945'
		select @FirstBill = 1
		 
		while (1=1)
		begin
			select @NextBillDate = min(NextBillDate)
			from   #BillingSchedule
			where  ProjectKey = @ProjectKey
			and    NextBillDate > @NextBillDate
			
			if @NextBillDate is null
				break
			
			select @PercentBudget = PercentBudget 
			from   #BillingSchedule
			where  ProjectKey = @ProjectKey
			and    NextBillDate = @NextBillDate
			 	
			if @FirstBill = 1
			begin
				update #DetailItem
				set #DetailItem.Total = round((#DetailItem.Total * @PercentBudget) / 100.0, 2)
					,#DetailItem.StartDate = @NextBillDate
					,#DetailItem.EndDate = @NextBillDate
					,#DetailItem.UpdateDate = @NextBillDate -- this is how we flag the first billed for a project
				from #Detail fd
				where #DetailItem.ForecastDetailKey = fd.ForecastDetailKey
				-- here I could only take tasks which fall within the forecast date range
				-- but it is not exactly the WHOLE BUDGET (talk with GG 7/3/13)
				--and 
				--	(#DetailItem.EndDate between  @ForecastStartDate and @ForecastEndDate
				--	Or #DetailItem.StartDate between @ForecastStartDate and @ForecastEndDate
				--	)
				-- In order to take the WHOLE BUDGET, do not restrict tasks based on dates 

				and (fd.Entity = @ENTITY_APPROVED_PROJECT or fd.Entity = @ENTITY_POTENTIAL_PROJECT)
	  			and fd.EntityKey = @ProjectKey 
			 end
			 else
			 begin
				-- not the first bill date, copy from the first one, but change dates and total
				insert #DetailItem 
					(
					ForecastDetailKey,
					Entity,
					EntityKey,
					StartDate,
					EndDate,
					Total,
					Labor,
					TaskKey, 
					ItemKey,
					CampaignSegmentKey,
					ClassKey,
					UpdateFlag,
					AtNet
					)	
				select
					fdi.ForecastDetailKey,
					fdi.Entity,
					fdi.EntityKey,
					@NextBillDate, -- StartDate,
					@NextBillDate, -- EndDate,
					round((fdi.UpdateAmount * @PercentBudget) / 100.0,2), --Total, -- Original Total saved in UpdateAmount
					fdi.Labor,
					fdi.TaskKey, 
					fdi.ItemKey,
					fdi.CampaignSegmentKey,
					fdi.ClassKey,
					fdi.UpdateFlag,
					fdi.AtNet
				from #DetailItem fdi
				inner join #Detail fd on fdi.ForecastDetailKey = fd.ForecastDetailKey
				where (fd.Entity = @ENTITY_APPROVED_PROJECT or fd.Entity = @ENTITY_POTENTIAL_PROJECT)
	  			and fd.EntityKey = @ProjectKey 
				and fdi.UpdateDate is not null -- this was the first billing
			end

			-- this is not the first bill for the project
			select @FirstBill = 0
		end

	end
	
	--select * from #DetailItem

	-- Also delete the records if there is a task and the task is not in #Task
	delete #DetailItem
	where  UpdateFlag = 1 -- connected to projects
	and    isnull(TaskKey, 0) > 0
	and    StartDate > @NextYearEndDate
	and    EndDate > @NextYearEndDate 

	-- if project is Non Billable delete Gross or Revenue side since no revenue is expected
	-- but keep the Net since a Cost must occur

	delete #DetailItem
	from #Detail fd (nolock)
		inner join tProject p (nolock) on fd.EntityKey = p.ProjectKey
	where (fd.Entity = @ENTITY_POTENTIAL_PROJECT collate database_default
	or    fd.Entity = @ENTITY_APPROVED_PROJECT collate database_default
	)
	and fd.ForecastDetailKey = #DetailItem.ForecastDetailKey
	and p.NonBillable = 1
	and isnull(#DetailItem.AtNet, 0) = 0  -- i.e. At Gross only

	--select * from #DetailItem
	 
	-- Check if we exclude expenses
	if exists (select 1 from tForecast (nolock) where ForecastKey = @ForecastKey and SpreadExpense = 3)
		delete #DetailItem where Labor = 0
GO
