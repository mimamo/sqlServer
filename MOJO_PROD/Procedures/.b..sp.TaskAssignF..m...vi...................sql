USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignFromService]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignFromService]
	(
	@ProjectKey int
	,@ServiceKey int = null -- can be run for 1 service or all
	,@BreakServicesDownToUsers int = 1 -- option for BSSP, if @BreakServicesDownToUsers = 0, use services only 
	)
AS --Encrypt
	SET NOCOUNT ON

  /*
  || When     Who Rel     What
  || 09/24/10 GHL 10.535  Creation for new task assignment method
  ||                      We pull hours now from both -- estimate (if any approved) OR schedule
  ||                      then replace tTaskUser records on the schedule for tasks which are not 100% complete
  ||                      1) Group hours by service (either service on record OR DefaultServiceKey on user)
  ||                      2) Deduct actual hours from tTime
  ||                      3) Reallocate by user based on tProjectUserServices (delete tTaskUser and recreate)
  ||
  ||                      BT=Budget Task, DT=Detail Task
  ||                      Tree would be like BT==>service==>DT==>user     if we are dealing with budget tasks
  ||                      OR                 DT==>service==>user          if track budget at detail task
  ||              
  ||                      Actual Hours in tTime entries can be entered at DT or BT level
  ||                      Estimated Hours in estimates are entered at BT level only
  ||                      Allocated Hours in task/user recs are entered at DT level only
  ||                  
  ||                      See my VISIO doc for explanations
  || 09/28/10 GHL 10.535  Added returns + fixed joins
  || 09/30/10 GHL 10.536  Cannot allocated negative hours
  || 01/31/11 GHL 10.540  (101309) Changed to 3 dimensions for estimated and actual temp tables 
  ||                      i.e. Task/Service/User instead of Task/Service
  ||                      this way the estimates by task/person can be converted directly to TaskUser
  || 02/15/11 GWG 10.540  Fixed a go comment at the end of a line (messes up the installer)
  || 12/06/11 GHL 10.550  (128093) If AvailableHours = Estimated Hours/Allocated Hours -  Actual Hours = 0
  ||                      do not abort, but continue assigning people
  ||                      Users enter roles with 0 hours on the schedule then enter several users per role on the Team screen
  ||                      Expect to see users assigned on the schedule 
  || 01/26/12 GHL 10.552  (131418) Added protection against records in tProjectUserServices with deleted users
  ||                      Also at the end, when there is no budget, do not blow up the records where UserKey >0. 
  ||                      Because we only reallocate tTaskUser records where UserKey is null 
  || 07/31/14 GHL 10.582  (223866) Enhancement for BSSP
  ||                      1) for summary tasks where AllowAllocatedHours = 1, allocate hours at that level 
  ||                      i.e. do not create underlying task details (and do not allocate hours at detail level )
  ||                      2) Added param @BreakServicesDownToUsers int = 1 so that if 0, we allocate at the service level
  ||                      i.e do not create underlying users (use the service)  
  */

  -- Returns
    declare @kRetNoBudgetApproved int			select @kRetNoBudgetApproved = -1
	declare @kRetAllTasksComplete int			select @kRetAllTasksComplete = -2
	declare @kRetNoTasksAvailableHours int		select @kRetNoTasksAvailableHours = -3
	declare @kRetNoUserServices int				select @kRetNoUserServices = -4
	 

  -- Estimate Types
	declare @kByTaskOnly int					select @kByTaskOnly = 1
	declare @kByTaskService int					select @kByTaskService = 2
	declare @kByTaskPerson int					select @kByTaskPerson = 3
	declare @kByServiceOnly int					select @kByServiceOnly = 4
	declare @kBySegmentService int				select @kBySegmentService = 5
 -- Note: we will process only @kByTaskPerson (where default service can be found) and @kByTaskService

	declare @kDebug int							select @kDebug = 0
	declare @HasBudget int						select @HasBudget = 0
  
	declare @BudgetTaskKey int
	declare @DetailTaskKey int
	declare @LoopServiceKey int
	declare @Hours decimal(24,4)
  
	declare @UserKey int
	declare @EstimatedHours decimal(24,4)
	declare @TotalActualHours decimal(24,4)
	declare @ActualHours decimal(24,4)
	declare @ActualKey int
	declare @EstimatedKey int


   -- general allocation work horse table
   create table #alloc (EntityKey int null, AllocatedHours decimal(24, 4) null, Weight int null)

   create table #estimated_task_service (
      BudgetTaskKey int null
	  ,DetailTaskKey int null
	  ,ServiceKey int null
	  ,UserKey int null
	  ,EstimatedHours decimal(24,4) null
	  ,ActualHours decimal(24,4) null
      ,AvailableHours decimal(24,4) null
	  ,PercComp int null
	  ,EstimatedKey int identity(1,1)

	  ,AllowAllocatedHours int null -- this is for BSSP
	  )

   create table #actual_task_service (
      BudgetTaskKey int null
	  ,DetailTaskKey int null
	  ,ServiceKey int null
	  ,UserKey int null
	  ,ActualHours decimal(24,4) null
	  ,ActualKey int identity(1,1)
      )

   create table #allocated_task_service_user (
      DetailTaskKey int null
	  ,ServiceKey int null
	  ,UserKey int null
	  ,AllocatedHours decimal(24,4) null
      )

   -- just to capture the tasks and help with lookups
   create table #task (
      BudgetTaskKey int null
	  ,TaskKey int null
	  ,PercComp int null
	  ,PlanDuration int null
	  ,TaskType int null)

	/*
     * STEP 1 Capture estimated hours
	 * try to get estimated hours from approved estimates
	 * If no budget, try to get the estimated hours from tTaskUser records where ServiceKey > 0 and UserKey = null 
	 */

   insert #estimated_task_service (BudgetTaskKey, ServiceKey, UserKey, EstimatedHours)
   select estimate.TaskKey, isnull(estimate.ServiceKey, 0), isnull(estimate.UserKey, 0), sum(estimate.Hours)
   from (
		
		-- estimate by task/service ---- ServiceKey > 0 UserKey = null
		-- these records will have to be reallocated to users based on tProjectUserServices

		select etl.TaskKey, etl.ServiceKey, etl.UserKey, etl.Hours
		from   tEstimateTaskLabor etl (nolock)
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
        where  e.ProjectKey = @ProjectKey
        and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
	    Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 
		and etl.ServiceKey > 0
		and e.EstType = @kByTaskService -- no need to take service only

		UNION ALL

		-- estimate by task/person ---- ServiceKey = ? UserKey >0
		-- u.DefaultServiceKey is just to insert at the end to be more accurate
		-- these records are almost good to go, we will just subtract the actual hours

		select etl.TaskKey, u.DefaultServiceKey, etl.UserKey, etl.Hours
		from   tEstimateTaskLabor etl (nolock)
			inner join tEstimate e (nolock) on etl.EstimateKey = e.EstimateKey 
			inner join tUser u (nolock) on etl.UserKey = u.UserKey
		where  e.ProjectKey = @ProjectKey
        and ((isnull(e.ExternalApprover, 0) > 0 and  e.ExternalStatus = 4) 
	    Or (isnull(e.ExternalApprover, 0) = 0 and  e.InternalStatus = 4)) 

		) as estimate
    where (@ServiceKey is null Or estimate.ServiceKey = @ServiceKey)
    group by estimate.TaskKey, isnull(estimate.ServiceKey, 0), isnull(estimate.UserKey, 0)

	if (select count(*) from #estimated_task_service) > 0
		select @HasBudget = 1
	else
	begin
		-- if we do not have a budget, get hours from tTaskUser

	   insert #estimated_task_service (DetailTaskKey, ServiceKey, UserKey, EstimatedHours)
	   select schedule.TaskKey, isnull(schedule.ServiceKey, 0), isnull(schedule.UserKey, 0), sum(schedule.Hours)
	   from (
			
			-- I think that here, the goal is to take all tTaskUser records where ServiceKey > 0 and UserKey = null
			-- then try to reallocate to users based on tProjectUserServices 

			-- hours for services on the project 
			select tu.TaskKey, tu.ServiceKey, tu.UserKey, tu.Hours
			from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
			where t.ProjectKey = @ProjectKey
			and   isnull(tu.ServiceKey, 0) > 0
			and   isnull(tu.UserKey, 0) = 0
			and   t.TaskType = 2 -- detail

			/* 
			
			-- I think that there is no need to take the records below
			-- based on the clarification above

			UNION ALL

			-- hours for people on the project  
			select tu.TaskKey, u.DefaultServiceKey, tu.UserKey, tu.Hours
			from   tTaskUser tu (nolock)
				inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
				inner join tUser u (nolock) on tu.UserKey = u.UserKey
			where t.ProjectKey = @ProjectKey
			and   isnull(tu.ServiceKey, 0) = 0
			and   t.TaskType = 2 -- detail
			*/

			) as schedule

			where (@ServiceKey is null Or schedule.ServiceKey = @ServiceKey)
			group by schedule.TaskKey, isnull(schedule.ServiceKey, 0), isnull(schedule.UserKey, 0)
	end 

	-- change for BSSP
	-- capture the AllowAllocatedHours flag
	update #estimated_task_service 
	set    #estimated_task_service.AllowAllocatedHours = isnull(t.AllowAllocatedHours, 0)
	from   tTask t (nolock)
	where  #estimated_task_service.BudgetTaskKey = t.TaskKey

	update #estimated_task_service 
	set    #estimated_task_service.AllowAllocatedHours = isnull(#estimated_task_service.AllowAllocatedHours, 0)
	
	-- this is just to help with frequent lookups in tTask
	insert #task (BudgetTaskKey,TaskKey,PercComp,PlanDuration,TaskType)
	select BudgetTaskKey,TaskKey,isnull(PercComp, 0),isnull(PlanDuration, 0), TaskType
	from tTask (nolock)
	where ProjectKey = @ProjectKey
	order by ProjectOrder

	if @kDebug = 1
	select 'tasks' as tasks, a.*,bt.TaskID, dt.TaskName from #task a
	left join tTask bt (nolock) on a.BudgetTaskKey = bt.TaskKey
	left join tTask dt (nolock) on a.TaskKey = dt.TaskKey


	if @HasBudget = 1
		update #estimated_task_service 
		set    #estimated_task_service.PercComp = isnull(t.PercComp, 0)
		from   #task t (nolock)  
		where  #estimated_task_service.BudgetTaskKey = t.TaskKey
	else
		update #estimated_task_service 
		set    #estimated_task_service.PercComp = isnull(t.PercComp, 0)
		from   #task t (nolock)  
		where  #estimated_task_service.DetailTaskKey = t.TaskKey
	

	-- if no available hours, abort
	if (select count(*) from #estimated_task_service) = 0
		return @kRetNoBudgetApproved

	-- do not process completed tasks 
	delete #estimated_task_service where PercComp = 100

	-- if no available hours, abort
	if (select count(*) from #estimated_task_service) = 0
		return @kRetAllTasksComplete 
	
	--now capture and process actuals

	/*
     * STEP 2 Capture actual hours
	 * If we have a budget, we are only interested in BudgetTaskKeys because that is all we have (i.e. no detail keys)
	 * If we do not have a budget, we want DetailTaskKeys 
	 */

	if @HasBudget = 1
	begin
		-- we are only interested in budget tasks 

		insert #actual_task_service (BudgetTaskKey,ServiceKey, UserKey, ActualHours)
		select t.TaskKey, isnull(t.ServiceKey, 0), isnull(t.UserKey, 0), sum(t.ActualHours)
		from   tTime t (nolock)
		where  t.ProjectKey = @ProjectKey
		and    t.TaskKey in (select BudgetTaskKey from #estimated_task_service)
		group by t.TaskKey, isnull(t.ServiceKey, 0), isnull(t.UserKey, 0)	

	end
	else
	begin
		-- No budget, we are dealing with detail tasks

		-- we are first interested in detail tasks with service

		insert #actual_task_service (BudgetTaskKey, DetailTaskKey,ServiceKey,ActualHours)
		select t.TaskKey,t.DetailTaskKey,t.ServiceKey, SUM(t.ActualHours)
		from   tTime t (nolock)
		where  t.ProjectKey = @ProjectKey
		and    isnull(t.ServiceKey, 0) > 0
		and    t.DetailTaskKey in (select DetailTaskKey from #estimated_task_service)
		group by t.TaskKey, t.DetailTaskKey,t.ServiceKey	
	
		-- then time entry records without a detail task with service
		insert #actual_task_service (BudgetTaskKey,ServiceKey,ActualHours)
		select t.TaskKey,t.ServiceKey, SUM(t.ActualHours)
		from   tTime t (nolock)
		where  t.ProjectKey = @ProjectKey
		and    isnull(t.ServiceKey, 0) > 0
		and    isnull(t.DetailTaskKey, 0) = 0
		and   (@ServiceKey is null Or t.ServiceKey = @ServiceKey) -- not tied to #estimated_task_service, so we need this clause
		group by t.TaskKey, t.ServiceKey	
	

		-- we need to reallocate the ActualHours on the budget tasks without detail task
		select @BudgetTaskKey = -1
		while (1=1)
		begin
			select @BudgetTaskKey = min(BudgetTaskKey)
			from   #actual_task_service
			where  DetailTaskKey is null
			and    BudgetTaskKey > @BudgetTaskKey

			if @BudgetTaskKey is null
				break

			select @LoopServiceKey = -1
			while (1=1)
			begin
				select @LoopServiceKey  = min(ServiceKey)
				from   #actual_task_service
			    where  DetailTaskKey is null
			    and    BudgetTaskKey = @BudgetTaskKey
				and    ServiceKey > @LoopServiceKey

				if @LoopServiceKey is null
					break
  
				select @Hours = ActualHours from #actual_task_service 
				 where  DetailTaskKey is null
			    and    BudgetTaskKey = @BudgetTaskKey
				and    ServiceKey = @LoopServiceKey

				truncate table #alloc

				insert #alloc (EntityKey, Weight)
				select TaskKey, PlanDuration
				from   #task 
				where  BudgetTaskKey = @BudgetTaskKey
				and    TaskType = 2 -- only interested in details
				--and    PercComp <> 100 -- here we want to take them all
				
				exec sptTaskAssignAllocateHours @Hours
				
				-- careful here because it will not be grouped 
				insert #actual_task_service (BudgetTaskKey, DetailTaskKey,ServiceKey,ActualHours)
				select @BudgetTaskKey,EntityKey,@LoopServiceKey, AllocatedHours
				from   #alloc
		 

			end
				
		end

	end

	/*
     * STEP 3 Calculate AvailableHours = EstimatedHours - ActualHours
	 */

	if @HasBudget = 1
	begin
		-- we are dealing with estimated records with budget tasks and where UserKey may be > 0

		-- process first the records where UserKey > 0
		
		if @kDebug =1
		select 'actuals' as actuals, * from #actual_task_service

		select @EstimatedKey = 0
		while (1=1)
		begin
			select @EstimatedKey = min(EstimatedKey)
			from   #estimated_task_service
			where  EstimatedKey > @EstimatedKey
			and    UserKey > 0

			if @EstimatedKey is null
				break

			select @EstimatedHours = EstimatedHours
			      ,@BudgetTaskKey = BudgetTaskKey
				  ,@UserKey = UserKey 
			from   #estimated_task_service
			where  EstimatedKey = @EstimatedKey

			select @TotalActualHours = 0	    

			select @ActualKey = -1
			while (1=1)
			begin
				select @ActualKey = min(ActualKey)
				from   #actual_task_service
				where  UserKey = @UserKey
				and    BudgetTaskKey = @BudgetTaskKey
				and    ActualKey > @ActualKey
				
				if  @ActualKey is null
					break
				
				select @ActualHours = ActualHours
				from   #actual_task_service
				where  ActualKey = @ActualKey

				if @kDebug =1	
				select @EstimatedKey as EstimatedKey, @ActualKey as ActualKey, @ActualHours AS ActualHours
				
				if (@TotalActualHours + @ActualHours) <= @EstimatedHours
				begin
					update #estimated_task_service
					set    ActualHours = isnull(ActualHours, 0) + isnull(@ActualHours, 0)
					where  EstimatedKey = @EstimatedKey

					update #actual_task_service
					set    ActualHours = 0
					where  ActualKey = @ActualKey
				end
				else
				begin
					select @ActualHours =@EstimatedHours -@TotalActualHours

					if @kDebug =1
					select @ActualHours AS ActualHours

					update #estimated_task_service
					set    ActualHours = isnull(ActualHours, 0) + isnull(@ActualHours, 0)
					where  EstimatedKey = @EstimatedKey

					update #actual_task_service
					set    ActualHours = isnull(ActualHours, 0) - isnull(@ActualHours, 0)
					where  ActualKey = @ActualKey
				end
					
				select @TotalActualHours = @TotalActualHours + @ActualHours
				
				if 	@TotalActualHours  >= @EstimatedHours  
					break

			end -- actual loop

		end -- estimate loop
		
		-- now delete actuals where ActualHours = 0    
		delete #actual_task_service where ActualHours = 0

		-- now process the services
		update #estimated_task_service
		set    #estimated_task_service.ActualHours = ISNULL((
			select Sum(b.ActualHours) from #actual_task_service b 
			where #estimated_task_service.BudgetTaskKey = b.BudgetTaskKey
			and   #estimated_task_service.ServiceKey = b.ServiceKey
			), 0)
		where   #estimated_task_service.UserKey = 0  -- services only

	end
	else 
	begin
		-- No Budget

		-- actuals may NOT be grouped, use subquery
		update #estimated_task_service
		set    #estimated_task_service.ActualHours = ISNULL((
			select Sum(b.ActualHours) from #actual_task_service b 
			where #estimated_task_service.DetailTaskKey = b.DetailTaskKey
			and   #estimated_task_service.ServiceKey = b.ServiceKey 
		    ), 0)

	end

	update #estimated_task_service
	set    #estimated_task_service.AvailableHours = isnull(#estimated_task_service.EstimatedHours, 0) 
			- isnull(#estimated_task_service.ActualHours, 0)

	update #estimated_task_service
	set    #estimated_task_service.ActualHours = isnull(#estimated_task_service.ActualHours, 0)
		    ,#estimated_task_service.AvailableHours = isnull(#estimated_task_service.AvailableHours, 0) 


   if @kDebug = 1
	begin
		select 'estimated' as estimated, a.*, bt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #estimated_task_service a
		left outer join tTask bt (nolock) on a.BudgetTaskKey = bt.TaskKey
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey
		 
        select 'actual' as actual, a.*, bt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #actual_task_service a
		left outer join tTask bt (nolock) on a.BudgetTaskKey = bt.TaskKey
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey
		
		select 'allocated' as allocated, a.*, dt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #allocated_task_service_user a
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey
		
	end

	-- delete #estimated_task_service where isnull(AvailableHours, 0) <= 0
	-- issue 128093 if 0, keep them
	delete #estimated_task_service where isnull(AvailableHours, 0) < 0


	/*
     * STEP 4 now for budget tasks, we need to reallocate AvailableHours among detail tasks
	 */

	if @HasBudget = 1
	begin
		-- we need to reallocate the ActualHours on the budget tasks without detail task
		select @EstimatedKey = -1
		while (1=1)
		begin
			select @EstimatedKey = min(EstimatedKey)
			from   #estimated_task_service
			where  EstimatedKey > @EstimatedKey
			and    DetailTaskKey is null
			and    AllowAllocatedHours = 0 -- change for BSSP

			if @EstimatedKey is null
				break

			select @Hours = AvailableHours 
			      ,@BudgetTaskKey = BudgetTaskKey
				  ,@LoopServiceKey = ServiceKey
				  ,@UserKey = UserKey
			from   #estimated_task_service 
			where  EstimatedKey = @EstimatedKey

			truncate table #alloc

			insert #alloc (EntityKey, Weight)
			select TaskKey, PlanDuration
			from   #task 
			where  BudgetTaskKey = @BudgetTaskKey
			and    TaskType = 2 -- only interested in details
			and    PercComp <> 100 -- here we DO NOT want to take them all

			exec sptTaskAssignAllocateHours @Hours
				
			insert #estimated_task_service (BudgetTaskKey, DetailTaskKey,ServiceKey,UserKey,AvailableHours)
			select @BudgetTaskKey,EntityKey,@LoopServiceKey, @UserKey, AllocatedHours
			from   #alloc
		 
				--select @Hours
				--select * from #alloc
				--return 1
				
		end -- estimated key
    
		-- Now delete where DetailTaskKey is null, these are original budget tasks that we do not need anymore
		--delete #estimated_task_service where DetailTaskKey is null

	if @kDebug = 1
		select  'estimated FIX Detail' as  estimated_FIX_Detail, a.*, bt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #estimated_task_service a
		left outer join tTask bt (nolock) on a.BudgetTaskKey = bt.TaskKey
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey

	end -- budget		 

	--delete #estimated_task_service where isnull(AvailableHours, 0) <= 0
	-- issue 128093 if 0, keep them
	delete #estimated_task_service where isnull(AvailableHours, 0) < 0

	-- if no available hours, abort
	if (select count(*) from #estimated_task_service) = 0
		return @kRetNoTasksAvailableHours 

	/*
     * STEP 5 now build the allocated hours
	 */

	 -- change for BSSP
	 -- trick the system when AllowAllocatedHours = 1
	 -- we need DetailTaskKey for the loop below
	 update #estimated_task_service
	 set    DetailTaskKey = BudgetTaskKey
	 where  AllowAllocatedHours = 1 

	 /* When there is a user key, they are good to go */
	insert #allocated_task_service_user (DetailTaskKey, ServiceKey, UserKey, AllocatedHours)
	select DetailTaskKey, ServiceKey, UserKey, AvailableHours
	from   #estimated_task_service
	where  isnull(UserKey, 0) > 0
	and    isnull(DetailTaskKey, 0) > 0 

	select @DetailTaskKey = -1
	while (1=1)
	begin
		select @DetailTaskKey = min(DetailTaskKey)
		from   #estimated_task_service 
		where  isnull(DetailTaskKey, 0) > 0
		and    DetailTaskKey > @DetailTaskKey
		and    isnull(UserKey, 0) = 0 -- service only

		if @DetailTaskKey is null
			break

		select @LoopServiceKey = -1
		while (1=1)
			begin
				select @LoopServiceKey = min(ServiceKey)
				from   #estimated_task_service 
				where  isnull(DetailTaskKey, 0) > 0
				and    DetailTaskKey = @DetailTaskKey
				and    ServiceKey > @LoopServiceKey
				and    isnull(UserKey, 0) = 0 -- service only

				if @LoopServiceKey is null
					break

				truncate table #alloc

				select @Hours = Sum(AvailableHours)
				from   #estimated_task_service 
				where  isnull(DetailTaskKey, 0) > 0
				and    DetailTaskKey = @DetailTaskKey
				and    ServiceKey = @LoopServiceKey
				and    isnull(UserKey, 0) = 0 -- service only

				if @BreakServicesDownToUsers = 1 -- Change for BSSP
				insert #alloc (EntityKey, Weight)
				select UserKey, 1
				from   tProjectUserServices (nolock)
				where  ProjectKey = @ProjectKey
				and    ServiceKey = @LoopServiceKey
				-- for some reasons tProjectUserServices contains old/inactive users 
				and UserKey in (select UserKey from tAssignment (nolock) where ProjectKey = @ProjectKey)
				
				-- if we do not have anybody for that service, we are going to leave the hours on the service
				if (select count(*) from #alloc) > 0
				begin 
					exec sptTaskAssignAllocateHours @Hours

					insert #allocated_task_service_user (DetailTaskKey, ServiceKey, UserKey, AllocatedHours)
					select @DetailTaskKey, @LoopServiceKey, EntityKey, AllocatedHours
					from   #alloc
				end
				else
				begin
					insert #allocated_task_service_user (DetailTaskKey, ServiceKey, UserKey, AllocatedHours)
					select @DetailTaskKey, @LoopServiceKey, null, @Hours
				end
			end

	end

	if @kDebug = 1
	begin
		select  'estimated' as estimated,  a.*, bt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #estimated_task_service a
		left outer join tTask bt (nolock) on a.BudgetTaskKey = bt.TaskKey
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey
		 
        select 'actual' as actual, a.*, bt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #actual_task_service a
		left outer join tTask bt (nolock) on a.BudgetTaskKey = bt.TaskKey
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey
		
		select 'allocated' as allocated, a.*, dt.TaskID, dt.TaskName, s.ServiceCode, u.FirstName + ' ' + u.LastName as UserName
 		from #allocated_task_service_user a
		left outer join tTask dt (nolock) on a.DetailTaskKey = dt.TaskKey
		left outer join tService s (nolock) on a.ServiceKey = s.ServiceKey
		left outer join tUser u (nolock) on a.UserKey = u.UserKey
	end

	-- if nothing to reallocate, abort
	if (select count(*) from #allocated_task_service_user) = 0
		return @kRetNoUserServices 

if @kDebug = 0
begin
	-- delete current records 	
	if @HasBudget = 1
		DELETE tTaskUser 
		FROM   tTask t (NOLOCK)
		WHERE  t.ProjectKey = @ProjectKey
		AND    t.TaskKey = tTaskUser.TaskKey
		AND    isnull(t.PercComp, 0) <> 100
	ELSE
		-- added this because we only deal with roles above
		DELETE tTaskUser 
		FROM   tTask t (NOLOCK)
		WHERE  t.ProjectKey = @ProjectKey
		AND    t.TaskKey = tTaskUser.TaskKey
		AND    isnull(t.PercComp, 0) <> 100
		AND    tTaskUser.UserKey is null
				
	-- Insert new records		
	INSERT tTaskUser (TaskKey, ServiceKey, UserKey, Hours 
		,PercComp, ActStart, ActComplete
		,ReviewedByTraffic, ReviewedByDate, ReviewedByKey
		,CompletedByDate,CompletedByKey)
	SELECT DetailTaskKey, ServiceKey, UserKey, AllocatedHours
	    ,0, NULL, NULL
	    ,0, NULL, NULL
	    ,NULL, NULL
	 FROM #allocated_task_service_user

	-- roll down from tTask
	-- not sure whether this is the best course of action
	-- but this is what sptTaskAssignFromEstimate does 
	UPDATE	tTaskUser
	SET		tTaskUser.PercComp = ISNULL(tTask.PercComp, 0)
			,tTaskUser.ActStart = tTask.ActStart
			,tTaskUser.ActComplete = tTask.ActComplete
			,tTaskUser.ReviewedByTraffic = ISNULL(tTask.ReviewedByTraffic, 0)
			,tTaskUser.ReviewedByDate = tTask.ReviewedByDate
			,tTaskUser.ReviewedByKey = tTask.ReviewedByKey
			,tTaskUser.CompletedByDate = tTask.CompletedByDate
			,tTaskUser.CompletedByKey = tTask.CompletedByKey
	FROM	tTask (NOLOCK)
			,#allocated_task_service_user b  
	WHERE	tTaskUser.TaskKey = tTask.TaskKey		
	AND		tTask.ProjectKey = @ProjectKey
	AND		ISNULL(tTask.PercCompSeparate, 0) = 0
	AND		tTaskUser.TaskKey = b.DetailTaskKey
end
	
	if @kDebug = 1
		select sum(AllocatedHours) as TotalAllocatedHours from #allocated_task_service_user

	RETURN 1
GO
