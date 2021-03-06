USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignFromScheduleTemp]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignFromScheduleTemp]
	(
		@ProjectKey int
		,@EstimateKey int
	)

AS --Encrypt

  /*
  || When     Who Rel   What
  || 04/02/08 GHL 8.5   (16332) This is the opposite from sptTaskAssignFromEstimate  
  ||
  ||                    In sptTaskAssignFromEstimate, we populate tTaskUser from tEstimateTaskLabor
  ||					We go from estimate to schedule
  ||                    In sptTaskAssignFromSchedule, we populate tEstimateTaskLabor from tTaskUser
  ||					We go from schedule to estimate      
  ||					Difference is it only works with estimate by task/person 
  || 07/29/10 GHL 10.533 (86398) Added pull for estimates by task/service or by service only or by task only
  ||                    only valid if estimate is for a project
  || 09/15/10 GHL 10.535 (89676) Only pull records where Hours <> 0
  || 09/20/10 GHL 10.535 (90453) For estimates by task/person, do not error out if there is a missing person on a task user record
  || 09/23/10 GHL 10.535 (90693) For estimates by service, do not error out if there is a missing service on a task user record
  || 11/02/10 GHL 10.537 Cloned sptTaskAssignFromSchedule to get results into temp table instead of permanent table
  || 11/17/10 GHL 10.538 Fixed bad joins with permanent tables instead of temp tables (only apparent on SQL 2000)
  || 12/21/10 GHL 10.539 (97437) For Change Orders, Hours = Hours on the Schedule - Hours on other estimates
  || 03/08/11 GHL 10.542 (105651) For estimate by tasks, added the initial insert into temp tb
  || 06/27/11 GHL 10.545 (115226) For estimate by tasks, recalculating now the LaborGross (EstLabor) after changing hours
  || 10/04/11 GHL 10.549 Fixed typo for expenses
  || 02/16/12 GHL 10.553 (134167) calc labor as sum(round(hours * rate))
  || 05/03/12 GHL 10.555 (142274) If get rate from client, query client not project
  || 05/04/12 GHL 10.555 (142429) For change orders, allow for negative hours
  || 07/11/12 GHL 10.557 (147312) Added cost to estimate user and estimate service
   */

/* 142429
If they are shifting hours from Copy to Design and changed the allocated hours in the Schedule and now create a change order 
using pull from schedule, it will add the new hours for Design but shows zero (instead of negative hours) for Copy.

Assume on schedule
Branding 10
Copy     5
Design   0

Pull from Schedule once and approve, on approved estimates
Branding 10
Copy     5
Design   0

Change on schedule
Branding 10
Copy     0
Design   5

Pull from Schedule on change order
Branding 10 - 10 = 0
Copy     0 - 5 = -5
Design   5 - 0 = 5

Same logic if By Task/Person, Task/Service, Task Only
*/

/* 86398
On a project estimate, need a function to pull labor from the assignments on the project. 
If task and service, use the service on the tTaskUser record. if its blank, use the person's default service. if both are blank, then do not include them and show an error.

If task and person, pull by person, if person is blank, then do not include and show an error. (removed for 90453)
*/
  
	SET NOCOUNT ON 
	
	-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5

	-- get rate from	
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6

	declare @EstType int, @ChangeOrder int, @GetRateFrom int, @ProjectHourlyRate money, @TimeRateSheetKey INT
	declare @ClientKey int, @ClientHourlyRate money 

	select @EstType = EstType, @ChangeOrder = ChangeOrder from tEstimate (nolock) where EstimateKey = @EstimateKey

	select @GetRateFrom = GetRateFrom
	     , @ProjectHourlyRate = isnull(HourlyRate, 0)
		 , @TimeRateSheetKey = isnull(TimeRateSheetKey, 0)
		 , @ClientKey = ClientKey
	from tProject (nolock) where ProjectKey = @ProjectKey

	if @TimeRateSheetKey = 0 and @GetRateFrom = @kGetRateFromServiceRateSheet
		select @GetRateFrom = @kGetRateFromService

	if @GetRateFrom = @kGetRateFromClient
		select @ClientHourlyRate = HourlyRate from tCompany (nolock) where CompanyKey = @ClientKey

CREATE TABLE #tEstimateUser(
	[EstimateKey] [int] NULL,
	[UserKey] [int] NULL,
	[BillingRate] [money] NULL)

CREATE TABLE #tEstimateTaskLabor(
	[EstimateKey] [int] NULL,
	[TaskKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[UserKey] [int] NULL,
	[Hours] [decimal](24, 4) NULL,
	[EstimatedHours] [decimal](24, 4) NULL,
	[Rate] [money] NULL,
	[Cost] [money] NULL,
	[CampaignSegmentKey] [int] NULL
) 

CREATE TABLE #tEstimateTask(
	[EstimateTaskKey] [int] NULL,
	[EstimateKey] [int] NULL,
	[TaskKey] [int] NULL,
	[Hours] [decimal](24, 4) NULL,
	[EstimatedHours] [decimal](24, 4) NULL,
	[Rate] [money] NULL,
	[EstLabor] [money] NULL,
	[BudgetExpenses] [money] NULL,
	[Markup] [decimal](24, 4) NULL,
	[EstExpenses] [money] NULL,
	[Cost] [money] NULL
)

CREATE TABLE #tEstimateService(
	[EstimateKey] [int] NULL,
	[ServiceKey] [int] NULL,
	[Rate] [money] NULL
)

	if @EstType = @kByTaskPerson
	begin
		/*
		if exists (select 1 from tTaskUser tu (nolock) 
					inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
					where t.ProjectKey = @ProjectKey
					and   tu.UserKey is null)
			return -1
		*/

        -- original code from CMP

		DELETE #tEstimateUser 
		WHERE  EstimateKey = @EstimateKey
	
		DELETE #tEstimateTaskLabor 
		WHERE  EstimateKey = @EstimateKey

			
		-- group by budget task
		INSERT #tEstimateTaskLabor (EstimateKey, TaskKey, ServiceKey, UserKey, Hours, Rate, Cost)
		SELECT @EstimateKey, t.BudgetTaskKey, NULL, tu.UserKey, SUM(tu.Hours), ISNULL(u.HourlyRate, 0), isnull(u.HourlyCost, 0) 
		FROM   tTaskUser tu (NOLOCK)
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
			INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
		WHERE t.ProjectKey = @ProjectKey
		AND   ISNULL(t.BudgetTaskKey, 0) > 0
		and   tu.Hours <> 0
		GROUP BY t.BudgetTaskKey, tu.UserKey, isnull(u.HourlyRate, 0), isnull(u.HourlyCost, 0) 
	
	-- because of 142429, we must add what is on the other estimates (we will show negatives)
		if @ChangeOrder = 1
		begin
			insert #tEstimateTaskLabor (EstimateKey, TaskKey, ServiceKey, UserKey, Hours, Rate, Cost)
			select distinct @EstimateKey, etl.TaskKey, null, etl.UserKey, 0, ISNULL(u.HourlyRate, 0), isnull(u.HourlyCost, 0)		
			from   tEstimateTaskLabor etl (nolock)
				inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				inner join tUser u (nolock) on etl.UserKey = u.UserKey
			where  e.ProjectKey = @ProjectKey
			and    e.EstimateKey <> @EstimateKey
			and    e.Approved = 1
			and    etl.UserKey is not null
			and    etl.TaskKey is not null
			-- trick to compare 2 keys: concatenate
			and    isnull(convert(varchar(50),etl.TaskKey), '') + '|' + isnull(convert(varchar(50),etl.UserKey), '') 
			not in (select isnull(convert(varchar(50),TaskKey), '') + '|' + isnull(convert(varchar(50),UserKey), '') from #tEstimateTaskLabor)
		end

		-- should we update the rate when get rate from project/client/task????????

		-- Correct if get rate from project/user
		if @GetRateFrom = @kGetRateFromProjectUser
		Update #tEstimateTaskLabor
		Set    #tEstimateTaskLabor.Rate = ISNULL(a.HourlyRate, 0)
		From   tAssignment a (nolock)	
		Where  a.ProjectKey = @ProjectKey
		And	   #tEstimateTaskLabor.EstimateKey = @EstimateKey
		And    #tEstimateTaskLabor.UserKey = a.UserKey

		
		insert #tEstimateUser (EstimateKey, UserKey, BillingRate)
		select @EstimateKey, UserKey, AVG(Rate)
		from   #tEstimateTaskLabor
		GROUP BY UserKey 

		if @ChangeOrder = 1
		begin
			update #tEstimateTaskLabor
			set    #tEstimateTaskLabor.EstimatedHours = isnull((
				select sum(etl.Hours)
				from   tEstimateTaskLabor etl (nolock)
					inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				where  e.ProjectKey = @ProjectKey
				and    e.EstimateKey <> @EstimateKey
				and    e.Approved = 1
				and    etl.TaskKey = #tEstimateTaskLabor.TaskKey
				and    etl.UserKey = #tEstimateTaskLabor.UserKey        
			),0)

			update #tEstimateTaskLabor 
			set    Hours = isnull(Hours, 0) - isnull(EstimatedHours, 0)
			
			-- we show now negative hours
			delete #tEstimateTaskLabor where Hours = 0
			
			delete #tEstimateUser where UserKey not in (select UserKey from #tEstimateTaskLabor) 
			 
		end

	end

	
	if @EstType in (@kByTaskService, @kByServiceOnly)
	begin
	
		create table #taskuser (TaskKey int null, UserKey int null, ServiceKey int null,  Hours decimal(24,4) null, Rate money null, Cost money null, Type varchar(50) null)

		insert  #taskuser (TaskKey, UserKey, ServiceKey, Hours, Type)
		select t.BudgetTaskKey, tu.UserKey, tu.ServiceKey, tu.Hours, 'On Schedule'
		FROM tTaskUser tu (NOLOCK)
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
		WHERE t.ProjectKey = @ProjectKey
		AND   ISNULL(t.BudgetTaskKey, 0) > 0 -- only if a task points to a budget task
        and   tu.Hours <> 0

		-- because of 142429, we must add what is on the other estimates (we will show negatives)
		if @ChangeOrder = 1
		begin
			if @EstType = @kByServiceOnly
				insert  #taskuser (TaskKey, UserKey, ServiceKey, Hours, Type)
				select distinct null, null, etl.ServiceKey, 0, 'On Approved Estimates'		
				from   tEstimateTaskLabor etl (nolock)
					inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				where  e.ProjectKey = @ProjectKey
				and    e.EstimateKey <> @EstimateKey
				and    e.Approved = 1
				and    etl.ServiceKey is not null
				and    etl.ServiceKey not in (select ServiceKey from #taskuser)
			else
				insert  #taskuser (TaskKey, UserKey, ServiceKey, Hours, Type)
				select distinct etl.TaskKey, null, etl.ServiceKey, 0, 'On Approved Estimates'		
				from   tEstimateTaskLabor etl (nolock)
					inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
				where  e.ProjectKey = @ProjectKey
				and    e.EstimateKey <> @EstimateKey
				and    e.Approved = 1
				and    etl.ServiceKey is not null
				and    etl.TaskKey is not null
				-- trick to compare 2 keys: concatenate
				and    isnull(convert(varchar(50),etl.TaskKey), '') + '|' + isnull(convert(varchar(50),etl.ServiceKey), '') 
				not in (select isnull(convert(varchar(50),TaskKey), '') + '|' + isnull(convert(varchar(50),ServiceKey), '') from #taskuser)
		end

		--select * from #taskuser

		update #taskuser
		set    #taskuser.ServiceKey = u.DefaultServiceKey
		from   tUser u (nolock)
		where  #taskuser.UserKey = u.UserKey  
		and    #taskuser.ServiceKey is null

		/*
		if exists (select 1 from #taskuser (nolock) 
				where isnull(ServiceKey, 0) = 0)
			return -2
		*/

		delete from #taskuser where isnull(ServiceKey, 0) = 0

/*
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
*/

		if @GetRateFrom in (@kGetRateFromClient, @kGetRateFromProject)
		begin
			if @GetRateFrom = @kGetRateFromClient
				update #taskuser
				set    #taskuser.Rate = @ClientHourlyRate
			else
				update #taskuser
				set    #taskuser.Rate = @ProjectHourlyRate
			
			update #taskuser
			set    #taskuser.Cost = s.HourlyCost
			from   tService s (nolock)
			where  #taskuser.ServiceKey = s.ServiceKey
		end
		else if @GetRateFrom = @kGetRateFromServiceRateSheet
			update #taskuser
		    set    #taskuser.Rate = ISNULL(trsd.HourlyRate1, s.HourlyRate1) 
			      ,#taskuser.Cost = s.HourlyCost
			FROM   tTimeRateSheetDetail trsd (NOLOCK)
				  INNER JOIN tService s (NOLOCK) ON trsd.ServiceKey = s.ServiceKey		
			WHERE  trsd.TimeRateSheetKey = @TimeRateSheetKey
			and    s.ServiceKey = #taskuser.ServiceKey
		else --@kGetRateFromService or @kGetRateFromTask
			update #taskuser
		    set    #taskuser.Rate = s.HourlyRate1
			      ,#taskuser.Cost = s.HourlyCost
			FROM   tService s (NOLOCK) 		
			WHERE  s.ServiceKey = #taskuser.ServiceKey
		   

		DELETE #tEstimateService 
		WHERE  EstimateKey = @EstimateKey
	
		DELETE #tEstimateTaskLabor 
		WHERE  EstimateKey = @EstimateKey

		insert #tEstimateService (EstimateKey, ServiceKey, Rate)
		select @EstimateKey, ServiceKey, AVG(Rate)
		from   #taskuser
		GROUP BY ServiceKey 
		
		if @EstType = @kByServiceOnly
		begin
			INSERT #tEstimateTaskLabor 
			      (EstimateKey,  TaskKey, ServiceKey, UserKey, Hours,         Rate,      Cost)
			SELECT @EstimateKey, null,    ServiceKey, null,    SUM(Hours),  AVG(Rate), AVG(Cost) 
			FROM   #taskuser (NOLOCK)
			GROUP BY ServiceKey 
		
			if @ChangeOrder = 1
			begin
				update #tEstimateTaskLabor
				set    #tEstimateTaskLabor.EstimatedHours = isnull((
					select sum(etl.Hours)
					from   tEstimateTaskLabor etl (nolock)
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
					where  e.ProjectKey = @ProjectKey
					and    e.EstimateKey <> @EstimateKey
					and    e.Approved = 1
					and    etl.ServiceKey = #tEstimateTaskLabor.ServiceKey
				),0)

				update #tEstimateTaskLabor 
				set    Hours = isnull(Hours, 0) - isnull(EstimatedHours, 0)
			
				-- we show negative numbers now
				delete #tEstimateTaskLabor where Hours = 0
			
				delete #tEstimateService where ServiceKey not in (select ServiceKey from #tEstimateTaskLabor) 
			 
			end
		
		end
		else
		begin
			-- task/service
			INSERT #tEstimateTaskLabor 
			      (EstimateKey,  TaskKey, ServiceKey, UserKey, Hours,         Rate,      Cost)
			SELECT @EstimateKey, TaskKey, ServiceKey, null,    SUM(Hours),  AVG(Rate), AVG(Cost) 
			FROM   #taskuser (NOLOCK)
			GROUP BY TaskKey, ServiceKey 

			if @ChangeOrder = 1
			begin
				update #tEstimateTaskLabor
				set    #tEstimateTaskLabor.EstimatedHours = isnull((
					select sum(etl.Hours)
					from   tEstimateTaskLabor etl (nolock)
						inner join vEstimateApproved e (nolock) on etl.EstimateKey = e.EstimateKey
					where  e.ProjectKey = @ProjectKey
					and    e.EstimateKey <> @EstimateKey
					and    e.Approved = 1
					and    etl.TaskKey = #tEstimateTaskLabor.TaskKey
					and    etl.ServiceKey = #tEstimateTaskLabor.ServiceKey
				),0)

				update #tEstimateTaskLabor 
				set    Hours = isnull(Hours, 0) - isnull(EstimatedHours, 0)
			
				-- we show negative numbers now
				delete #tEstimateTaskLabor where Hours = 0
			
				delete #tEstimateService where ServiceKey not in (select ServiceKey from #tEstimateTaskLabor) 
			 
			end
	
		end

	end

	if @EstType = @kByTaskOnly
	begin

		INSERT #tEstimateTask(EstimateTaskKey,EstimateKey,TaskKey,Hours,EstimatedHours,Rate,EstLabor,BudgetExpenses,Markup,EstExpenses,Cost)
		select EstimateTaskKey,EstimateKey,TaskKey,0,0,Rate,EstLabor,BudgetExpenses,Markup,EstExpenses,Cost
		from   tEstimateTask (nolock)
		where  EstimateKey = @EstimateKey

		update #tEstimateTask
		set    #tEstimateTask.Hours = ISNULL((
			select sum(tu.Hours)
			from   tTaskUser tu (nolock)
			inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
			where t.BudgetTaskKey = #tEstimateTask.TaskKey
		),0)
		where  	#tEstimateTask.EstimateKey = @EstimateKey
	
		if @ChangeOrder = 1
		begin
			update #tEstimateTask
				set    #tEstimateTask.EstimatedHours = isnull((
					select sum(et.Hours)
					from   tEstimateTask et (nolock)
						inner join vEstimateApproved e (nolock) on et.EstimateKey = e.EstimateKey
					where  e.ProjectKey = @ProjectKey
					and    e.EstimateKey <> @EstimateKey
					and    e.Approved = 1
					and    et.TaskKey = #tEstimateTask.TaskKey
				),0)

				update #tEstimateTask 
				set    Hours = isnull(Hours, 0) - isnull(EstimatedHours, 0)
			
				-- we show negative hours now
				--update #tEstimateTask set Hours = 0 where Hours < 0
			
		end

		--select * from #tEstimateTask

		-- recalc LaborGross
		update #tEstimateTask
		set    #tEstimateTask.EstLabor = ISNULL(#tEstimateTask.Hours, 0) * ISNULL(#tEstimateTask.Rate, 0) 
		where  #tEstimateTask.EstimateKey = @EstimateKey
	
	end
	
-- Now do rollups	
/*
Declare @ApprovedQty smallint,@SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey
*/

	-- we must do the joins like in sptEstimateGetAllDetails

	-- estimate user
	select 'estimate user' as TableName -- help with debugging
			, eu.*
	       ,ltrim(rtrim( isnull(u.FirstName, '') + ' ' + isnull(u.LastName, '') )) as UserName
	       ,eu.BillingRate as Rate
		   ,u.HourlyCost as Cost
	from   #tEstimateUser eu (nolock)  
	   inner join tUser u (nolock) on eu.UserKey = u.UserKey

	-- estimate task labor
	select 'estimate task labor' as TableName -- help with debugging
			,*
			,ROUND(Hours * Rate, 2) as Gross
		from   #tEstimateTaskLabor (nolock) 

	-- estimate task

	-- like in sptEstimateTaskGetTree
	IF @GetRateFrom = 6 AND @EstType = 1
		select 'like in sptEstimateTaskGetTree' as TableName -- help with debugging
		    ,ta1.TaskKey
			,ta1.TaskID
			,ta1.TaskName
			,ta1.TaskLevel
			,ta1.TaskType
			,ta1.Markup
			,ta1.SummaryTaskKey
			,ta1.TaskConstraint
			,ta1.MoneyTask
			,ta1.ScheduleTask
			,ta1.ShowDescOnEst
			,ta1.Description
			,ta1.ProjectOrder
			,ta1.TrackBudget
			,case
				when ta1.TaskType=1 and isnull(ta1.TrackBudget,0) = 0 then 1
				else 0
			end as NonTrackSummary
			,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
			else 2 end as BudgetTaskType
			,et.EstimateKey
			,et.EstimateTaskKey
			,et.Hours
			,isnull(et.Cost, et.Rate) As Cost
			,round(isnull(et.Cost, isnull(et.Rate, 0)) * isnull(et.Hours, 0), 2) as BudgetLabor 
			,ISNULL(et.Rate, ta1.HourlyRate) AS Rate
			,et.EstLabor
			,et.BudgetExpenses
			,et.Markup as EstMarkup
			,et.EstExpenses
			,(select sum(et2.Hours * et2.Cost)
			from  tTask ta2 (nolock)
					inner join #tEstimateTask et2 (nolock) on et2.TaskKey = ta2.TaskKey
				where ta2.SummaryTaskKey = ta1.TaskKey
				) AS DetailBudgetLabor						-- To display on estimate_tasks.aspx grid
		from tTask ta1 (nolock)
			left outer join #tEstimateTask et (nolock) on ta1.TaskKey = et.TaskKey 
		where ta1.ProjectKey = @ProjectKey
		and isnull(ta1.MoneyTask,0) = 1
		order by ta1.ProjectOrder
	ELSE	 
		select 'like in sptEstimateTaskGetTree' as TableName -- help with debugging
		    ,ta1.TaskKey
			,ta1.TaskID
			,ta1.TaskName
			,ta1.TaskLevel
			,ta1.TaskType
			,ta1.Markup
			,ta1.SummaryTaskKey
			,ta1.TaskConstraint
			,ta1.MoneyTask
			,ta1.ScheduleTask
			,ta1.ShowDescOnEst
			,ta1.Description
			,ta1.ProjectOrder
			,ta1.TrackBudget
			,case
				when ta1.TaskType=1 and isnull(ta1.TrackBudget,0) = 0 then 1
				else 0
			end as NonTrackSummary
			,case when ta1.TaskType = 1 and isnull(ta1.TrackBudget,0) = 0 then 1
			else 2 end as BudgetTaskType
			,et.EstimateKey
			,et.EstimateTaskKey
			,et.Hours
			,isnull(et.Cost, et.Rate) As Cost
			,round(isnull(et.Cost, isnull(et.Rate, 0)) * isnull(et.Hours, 0), 2) as BudgetLabor 
			,et.Rate
			,et.EstLabor
			,et.BudgetExpenses
			,et.Markup as EstMarkup
			,et.EstExpenses
			,(select sum(et2.Hours * et2.Cost)
			from  tTask ta2 (nolock)
					inner join #tEstimateTask et2 (nolock) on et2.TaskKey = ta2.TaskKey
				where ta2.SummaryTaskKey = ta1.TaskKey
				) AS DetailBudgetLabor						-- To display on estimate_tasks.aspx grid
		from tTask ta1 (nolock)
			left outer join #tEstimateTask et (nolock) on ta1.TaskKey = et.TaskKey 
		where ta1.ProjectKey = @ProjectKey
		and isnull(ta1.MoneyTask,0) = 1
		order by ta1.ProjectOrder
	
		-- estimate service 	
		
		select 'estimate service' as TableName -- help with debugging
		       ,es.*
			   ,s.ServiceCode
			   ,s.Description
			   ,s.HourlyCost as Cost
		from   #tEstimateService es (nolock)
			inner join tService s (nolock) on es.ServiceKey = s.ServiceKey 
		order by s.Description

	-- Labor summary
	if @EstType = @kByTaskService
	begin
		select  'labor summary' as TableName -- help with debugging
			,s.Description
			,ISNULL((
			select SUM(etl.Hours) from #tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.ServiceKey = es.ServiceKey 
			),0) as Hours
			,ROUND(ISNULL((
			select SUM(ROUND(etl.Hours * etl.Rate,2)) from #tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.ServiceKey = es.ServiceKey 
			),0),2) as LaborGross
		from    #tEstimateService es (nolock)
		inner   join tService s (nolock) on es.ServiceKey = s.ServiceKey
		where   es.EstimateKey = @EstimateKey
		and     es.EstimateKey > 0
		order   by s.Description
	end
	else if @EstType = @kByTaskPerson
	begin
		select  'labor summary' as TableName -- help with debugging
		    ,u.FirstName + ' ' + u.LastName as Description
			,ISNULL((
			select SUM(etl.Hours) from #tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.UserKey = eu.UserKey 
			),0) as Hours
			,ROUND(ISNULL((
			select SUM(ROUND(etl.Hours * etl.Rate, 2)) from #tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey
			and   etl.UserKey = eu.UserKey 
			),0),2) as LaborGross
		from    #tEstimateUser eu (nolock)
		inner   join tUser u (nolock) on eu.UserKey = u.UserKey
		where   eu.EstimateKey = @EstimateKey
		and     eu.EstimateKey > 0
		order   by u.FirstName + ' ' + u.LastName
	end
	else 
		select 'labor summary' as TableName -- help with debugging
			, '' as Description,  0 as LaborGross, *
		from   #tEstimateTaskLabor where 1=2

	-- for tasks on left side
	select 'tasks on the left side' as TableName -- help with debugging
		,t.TaskKey
		,t.TaskID
		,t.TaskName
		,t.Description
		,t.SummaryTaskKey
		,t.BudgetTaskKey
		,t.TaskType
		,t.TaskLevel
		,t.ScheduleTask
		,t.TrackBudget
		,t.MoneyTask
		,case when TaskType=1 and isnull(TrackBudget,0) = 0 then 1
		else 0 end as NonTrackSummary
		,case when TaskType = 1 and isnull(TrackBudget,0) = 0 then 1
	     else 2 end as BudgetTaskType
	    ,ISNULL((
	    select sum(et.Hours) from #tEstimateTask et (nolock) 
	    where et.EstimateKey = @EstimateKey and et.TaskKey = t.TaskKey
	    ),0)
	    +ISNULL((
	    select sum(etl.Hours) from #tEstimateTaskLabor etl (nolock) 
	    where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
	    ),0) As Hours
	    ,ROUND(
			ISNULL((
			select sum(round(et.Hours * et.Rate, 2)) from #tEstimateTask et (nolock) 
			where et.EstimateKey = @EstimateKey and et.TaskKey = t.TaskKey
			),0) 
			+ISNULL((
			select sum(round(etl.Hours * etl.Rate,2)) from #tEstimateTaskLabor etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
			),0)
	    ,2) As Gross
	
		-- Added to display expenses for each task on the grid 
		,ISNULL((
			select sum(BillableCost) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross1
		,ISNULL((
			select sum(BillableCost2) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross2
		,ISNULL((
			select sum(BillableCost3) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross3
		,ISNULL((
			select sum(BillableCost4) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross4
		,ISNULL((
			select sum(BillableCost5) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey =t.TaskKey
		),0) As ExpenseGross5
		,ISNULL((
			select sum(BillableCost6) from tEstimateTaskExpense etl (nolock) 
			where etl.EstimateKey = @EstimateKey and etl.TaskKey = t.TaskKey
		),0) As ExpenseGross6

		, 0 As ExpenseGross -- we will calc on client based on ApprovedQty
		, 0 As TotalGross -- we will calc on client based on ApprovedQty
	
	  from tTask t (nolock)
	 where t.ProjectKey = @ProjectKey
	 and t.MoneyTask = 1
	order by t.ProjectOrder


	RETURN 1
GO
