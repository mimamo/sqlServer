USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignFromSchedule]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignFromSchedule]
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

	declare @EstType int, @GetRateFrom int, @ProjectHourlyRate money, @TimeRateSheetKey INT

	select @EstType = EstType from tEstimate (nolock) where EstimateKey = @EstimateKey
	select @GetRateFrom = GetRateFrom
	     , @ProjectHourlyRate = isnull(HourlyRate, 0)
		 , @TimeRateSheetKey = isnull(TimeRateSheetKey, 0)
	from tProject (nolock) where ProjectKey = @ProjectKey

	if @TimeRateSheetKey = 0 and @GetRateFrom = @kGetRateFromServiceRateSheet
		select @GetRateFrom = @kGetRateFromService

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

		DELETE tEstimateUser 
		WHERE  EstimateKey = @EstimateKey
	
		DELETE tEstimateTaskLabor 
		WHERE  EstimateKey = @EstimateKey

		INSERT tEstimateUser (EstimateKey, UserKey, BillingRate) 
		SELECT DISTINCT @EstimateKey, tu.UserKey, ISNULL(u.HourlyRate, 0) 
		FROM tTaskUser tu (NOLOCK)
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
			INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
		WHERE t.ProjectKey = @ProjectKey
		AND   ISNULL(t.BudgetTaskKey, 0) > 0 -- only if a task points to a budget task
	    and   tu.Hours <> 0

		-- Correct if get rate from project/user
		if @GetRateFrom = @kGetRateFromProjectUser
		Update tEstimateUser
		Set    tEstimateUser.BillingRate = ISNULL(a.HourlyRate, 0)
		From   tAssignment a (nolock)	
		Where  a.ProjectKey = @ProjectKey
		And	   tEstimateUser.EstimateKey = @EstimateKey
		And    tEstimateUser.UserKey = a.UserKey

		-- should we update the rate when get rate from project/client/task????????
			
		-- group by budget task
		INSERT tEstimateTaskLabor (EstimateKey, TaskKey, ServiceKey, UserKey, Hours, Rate, Cost)
		SELECT @EstimateKey, t.BudgetTaskKey, NULL, tu.UserKey, SUM(tu.Hours), 0, isnull(u.HourlyCost, 0) 
		FROM   tTaskUser tu (NOLOCK)
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
			INNER JOIN tUser u (NOLOCK) ON tu.UserKey = u.UserKey
		WHERE t.ProjectKey = @ProjectKey
		AND   ISNULL(t.BudgetTaskKey, 0) > 0
		and   tu.Hours <> 0
		GROUP BY t.BudgetTaskKey, tu.UserKey, isnull(u.HourlyCost, 0) 
	
		-- Update the rates/costs
		UPDATE tEstimateTaskLabor
		SET	   tEstimateTaskLabor.Rate = eu.BillingRate
		FROM   tEstimateUser eu (NOLOCK)
		WHERE  tEstimateTaskLabor.EstimateKey = eu.EstimateKey
		AND    eu.EstimateKey = @EstimateKey	
		AND    tEstimateTaskLabor.UserKey = eu.UserKey


	end

	
	if @EstType in (@kByTaskService, @kByServiceOnly)
	begin
	
		create table #taskuser (TaskKey int null, UserKey int null, ServiceKey int null,  Hours decimal(24,4) null, Rate money null, Cost money null)

		insert  #taskuser (TaskKey, UserKey, ServiceKey, Hours)
		select t.BudgetTaskKey, tu.UserKey, tu.ServiceKey, tu.Hours
		FROM tTaskUser tu (NOLOCK)
			INNER JOIN tTask t (NOLOCK) ON tu.TaskKey = t.TaskKey
		WHERE t.ProjectKey = @ProjectKey
		AND   ISNULL(t.BudgetTaskKey, 0) > 0 -- only if a task points to a budget task
        and   tu.Hours <> 0


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
		   

		DELETE tEstimateService 
		WHERE  EstimateKey = @EstimateKey
	
		DELETE tEstimateTaskLabor 
		WHERE  EstimateKey = @EstimateKey

		insert tEstimateService (EstimateKey, ServiceKey, Rate)
		select @EstimateKey, ServiceKey, AVG(Rate)
		from   #taskuser
		GROUP BY ServiceKey 
		
		if @EstType = @kByServiceOnly

			INSERT tEstimateTaskLabor 
			      (EstimateKey,  TaskKey, ServiceKey, UserKey, Hours,         Rate,      Cost)
			SELECT @EstimateKey, null,    ServiceKey, null,    SUM(Hours),  AVG(Rate), AVG(Cost) 
			FROM   #taskuser (NOLOCK)
			GROUP BY ServiceKey 
		
		else
			-- task/service

			INSERT tEstimateTaskLabor 
			      (EstimateKey,  TaskKey, ServiceKey, UserKey, Hours,         Rate,      Cost)
			SELECT @EstimateKey, TaskKey, ServiceKey, null,    SUM(Hours),  AVG(Rate), AVG(Cost) 
			FROM   #taskuser (NOLOCK)
			GROUP BY TaskKey, ServiceKey 
	end

	if @EstType = @kByTaskOnly
	begin
		update tEstimateTask
		set    tEstimateTask.Hours = ISNULL((
			select sum(tu.Hours)
			from   tTaskUser tu (nolock)
			inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
			where t.BudgetTaskKey = tEstimateTask.TaskKey
		),0)
		where  	tEstimateTask.EstimateKey = @EstimateKey
	end
	
-- Now do rollups	
Declare @ApprovedQty smallint,@SalesTax1Amount MONEY, @SalesTax2Amount MONEY
Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey

	RETURN 1
GO
