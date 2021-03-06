USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastFindProjects]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastFindProjects]
	@Approved tinyint, -- 0=Potential projects, 1=Approved projects
	@ForecastKey int,
	@CompanyKey int,
	@UserKey int,
	@GLCompanyKey int, --null = all GL Companies
	@StartDate smalldatetime,
	@EndDate smalldatetime,
	@ENTITY_POTENTIAL_PROJECT varchar(20), --This is a "constant" that's passed in here so that it can be defined in just one place
	@ENTITY_APPROVED_PROJECT varchar(20) --This is a "constant" that's passed in here so that it can be defined in just one place
AS

/*
|| When      Who Rel      What
|| 9/7/12    CRG 10.5.6.0 Created
|| 11/15/12  GHL 10.5.6.2 Removed pulling of estimates in temp table
|| 12/14/12  GHL 10.5.6.3 Approved projects have a probability of 100%
|| 07/03/12  GHL 10.5.6.3 (182036) Keep FF projects with billing schedule 
|| 12/03/12  GHL 10.5.7.4 (198515) Project can be listed twice, once with approved projects
||                         once with unapproved projects
|| 05/29/14  GHL 10.580   (217700) delete FF projects outside of the billing schedule
||                        delete other projects without tasks in date range
|| 06/16/14  GHL 10.581   (219697) Exclude projects tied to a retainer
|| 08/21/14  KMC 10.583   (226748) Sending back the tCompany.AccountManagerKey if tProject.AccountManager is NULL
|| 11/24/14  GHL 10.5.8.6 (230762) Added tForecastDetail.EndDate because DATEDIFF to get Months is not reliable
|| 12/19/14  GHL 10.5.8.7 (240113) Updating now billing schedule next billing date from task actual complete
|| 12/26/14  GHL 10.5.8.7 (240290) Added checking of approved change order estimates (as well as regular estimates) 
|| 02/09/15  GHL 10.5.8.9 (245240) A project with approved and unapproved estimates should not be in the forecast under
||                         potential if it has approved estimates
|| 03/13/15  GHL 10.5.9.0 (249796) Reviewed logic for approved/unapproved projects
*/


/*
 Approved Projects:
	-- Must have approved estimates of any kind (EstType or IncludeInForecast) 
	-- Must have a project status that says Include In Forecast

Potential Projects
	-- Must have unapproved estimates that says Include in Forecast
	-- And must Not be in the previous list (because they could fall potentially in the 2 lists) 

Then the Billing Schedule Next Bill Date is refreshed (for projects in the company) 
and is set to the task actual complete if there is one (only if the Next Bill Date is not set yet)

For Time & Material projects, we check if there are tasks within the forecast data range

For Fixed Fee projects, we check  if there is a billing schedule with Next Bill Date within the forecast data range

Time & Material  Projects with no tasks  within range are not included in the forecast

Fixed Fee  Projects with no billing schedule within range are not included in the forecast
*/

	
	CREATE TABLE #Project
		(ProjectKey int NULL,
		Approved tinyint NULL,
		BillingMethod int null,
		HasTasksInRange int null,
		HasBillingScheduleInRange int null,
		UpdateFlag int null
		)

	CREATE TABLE #Task
			(TaskKey int NULL,
			ProjectKey int NULL,
			PlanStart smalldatetime NULL,
			PlanComplete smalldatetime NULL,

			UpdateFlag int null
			)
	
		-- take the projects upfront if they have IncludeInForecast = 1
		insert #Project (ProjectKey, BillingMethod, Approved)
		SELECT	p.ProjectKey, p.BillingMethod
				-- if one estimate is approved, the status is approved
				, case when (ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) + ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0)) <> 0
				then 1 else 0 end
		FROM	tProject p (nolock)
		INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey
		WHERE	p.CompanyKey = @CompanyKey
		AND		((@GLCompanyKey IS NULL) OR (p.GLCompanyKey = @GLCompanyKey))
		AND		p.ProjectKey NOT IN (
			SELECT EntityKey 
			FROM tForecastDetail (nolock) 
			WHERE ForecastKey = @ForecastKey 
			AND (Entity = @ENTITY_POTENTIAL_PROJECT OR Entity = @ENTITY_APPROVED_PROJECT)
			--AND Entity = @ENTITY_APPROVED_PROJECT
			)
		AND		p.ProjectKey NOT IN (
			SELECT EntityKey 
			FROM #Detail (nolock) 
			WHERE (Entity = @ENTITY_POTENTIAL_PROJECT OR Entity = @ENTITY_APPROVED_PROJECT)
			--WHERE Entity = @ENTITY_APPROVED_PROJECT
			)
		AND     isnull(ps.IncludeInForecast, 0) = 1
		AND     ISNULL(p.RetainerKey, 0) = 0 -- cannot be part of a retainer

		update #Project
		set    #Project.UpdateFlag = 1
		from	tEstimate e
		where	e.ProjectKey = #Project.ProjectKey
		and    isnull(e.IncludeInForecast, 0) = 1

		-- now delete the projects if in Unapproved and there is no estimate flagged as IncludeInForecast
		delete #Project
		where  Approved = 0
		and    isnull(UpdateFlag, 0) = 0
--select * from #Project where Approved = 0
--return
		-- now delete what is not requested
		if @Approved = 1 
			delete #Project where Approved = 0
		else
			delete #Project where Approved = 1

	/* Old Logic
	if @Approved = 1
	
	-- Approved Projects:
	-- Must have approved estimates of any kind (EstType or IncludeInForecast) 
	-- Must have a project status that says Include In Forecast

		insert #Project (ProjectKey, Approved, BillingMethod)
		SELECT	p.ProjectKey, 1, p.BillingMethod
		FROM	tProject p (nolock)
		INNER JOIN tProjectStatus ps (nolock) ON p.ProjectStatusKey = ps.ProjectStatusKey

		WHERE	p.CompanyKey = @CompanyKey
		AND		((@GLCompanyKey IS NULL) OR (p.GLCompanyKey = @GLCompanyKey))
		AND		p.ProjectKey NOT IN (
			SELECT EntityKey 
			FROM tForecastDetail (nolock) 
			WHERE ForecastKey = @ForecastKey 
			--AND (Entity = @ENTITY_POTENTIAL_PROJECT OR Entity = @ENTITY_APPROVED_PROJECT)
			AND Entity = @ENTITY_APPROVED_PROJECT
			)
		AND		p.ProjectKey NOT IN (
			SELECT EntityKey 
			FROM #Detail (nolock) 
			--WHERE (Entity = @ENTITY_POTENTIAL_PROJECT OR Entity = @ENTITY_APPROVED_PROJECT)
			WHERE Entity = @ENTITY_APPROVED_PROJECT
			)
	    
		AND     isnull(ps.IncludeInForecast, 0) = 1
		AND     (
		ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) 
		+ ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0)
		) <> 0 -- these fields are only set for approved estimates
		AND     ISNULL(p.RetainerKey, 0) = 0

	else

	-- Potential Projects
	-- Must have unapproved estimates that says Include in Forecast
	-- And must Not be in the previous list (because they could fall potentially in the 2 lists) 

		insert #Project (ProjectKey, Approved, BillingMethod)
		SELECT	distinct p.ProjectKey, 0, p.BillingMethod
		FROM	tProject p (nolock)
			inner join vEstimateApproved e (nolock) on p.ProjectKey = e.ProjectKey
		WHERE	p.CompanyKey = @CompanyKey
		AND		((@GLCompanyKey IS NULL) OR (p.GLCompanyKey = @GLCompanyKey))
		AND		p.ProjectKey NOT IN (
			SELECT EntityKey 
			FROM tForecastDetail (nolock) 
			WHERE ForecastKey = @ForecastKey 
			--AND (Entity = @ENTITY_POTENTIAL_PROJECT OR Entity = @ENTITY_APPROVED_PROJECT)
			AND Entity = @ENTITY_POTENTIAL_PROJECT
			)
		AND		p.ProjectKey NOT IN (
			SELECT EntityKey FROM #Detail (nolock) 
			--WHERE (Entity = @ENTITY_POTENTIAL_PROJECT OR Entity = @ENTITY_APPROVED_PROJECT)
			WHERE Entity = @ENTITY_POTENTIAL_PROJECT
			)
	    
		AND     isnull(e.IncludeInForecast, 0) = 1
		AND     e.Approved = 0
		AND     ISNULL(p.RetainerKey, 0) = 0

		-- (245240) do not include them if there are some approved estimates
		AND     (
		ISNULL(p.EstLabor, 0) + ISNULL(p.EstExpenses, 0) 
		+ ISNULL(p.ApprovedCOLabor, 0) + ISNULL(p.ApprovedCOExpense, 0)
		) = 0 -- these fields are only set for approved estimates
*/


	--Find tasks within the time frame

	declare @NextYearEndDate smalldatetime
	select @NextYearEndDate = dateadd(yy, 1, @EndDate)
	select @NextYearEndDate = dateadd(d, -1, @NextYearEndDate)

	-- only take the tasks which start BEFORE @NextYearEndDate
	INSERT	#Task
			(TaskKey,
			ProjectKey,
			PlanStart,
			PlanComplete)
	SELECT	t.TaskKey, t.ProjectKey, t.PlanStart, t.PlanComplete
	FROM	tTask t (nolock)
	INNER JOIN #Project p ON t.ProjectKey = p.ProjectKey and p.Approved = @Approved
	WHERE	t.PlanStart < @NextYearEndDate
	
	-- Flag the tasks that are within the forecast date range
	update  #Task
	set     #Task.UpdateFlag = 1
	from    #Project p
	where   #Task.ProjectKey = p.ProjectKey 
	and     p.Approved = @Approved
	and     #Task.PlanStart <= @EndDate
	and		#Task.PlanComplete >= @StartDate

	--Delete projects that don't have tasks within the time frame
	--DELETE	#Project
	--WHERE	ProjectKey NOT IN (SELECT ProjectKey FROM #Task where UpdateFlag = 1)

	-- Keep projects if exists tasks within forecast date range
	-- or if exists Fixed Fee projects with next bill date within forecast date range
	update #Project
	set    #Project.HasTasksInRange = 0
	      ,#Project.HasBillingScheduleInRange = 0

	update #Project
	set    #Project.HasTasksInRange = 1
	from   #Task
	where  #Project.ProjectKey = #Task.ProjectKey 
	and    #Task.UpdateFlag = 1
	and    #Project.BillingMethod <> 2 -- not FF 
	 
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

	update #Project
	set    #Project.HasBillingScheduleInRange = 1
	from   tBillingSchedule bs (nolock)
	where  #Project.BillingMethod = 2 -- FF
	and    #Project.ProjectKey = bs.ProjectKey
	and    bs.NextBillDate is not null
	and    isnull(bs.PercentBudget, 0) > 0
	and    bs.NextBillDate >= @StartDate
	and    bs.NextBillDate <= @EndDate

	delete #Project where HasTasksInRange = 0 and HasBillingScheduleInRange = 0

--select * from #Project
--return

	INSERT	#Detail
			(Entity,
			EntityKey,
			StartDate,
			EndDate,
			Months,
			Probability,
			ClientKey,
			AccountManagerKey,
			GLCompanyKey,
			OfficeKey,
			EntityName,
			EntityID,
			FromEstimate
			)
	SELECT	CASE @Approved
				WHEN 0 THEN @ENTITY_POTENTIAL_PROJECT
				ELSE @ENTITY_APPROVED_PROJECT
			END,
			p.ProjectKey,
			t.StartDate,
			t.EndDate,
			DATEDIFF(M, t.StartDate, t.EndDate) + 1,
			100, --Default to 100
			p.ClientKey,
			ISNULL(p.AccountManager, c.AccountManagerKey),
			p.GLCompanyKey,
			p.OfficeKey,
			ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, ''),
			p.ProjectNumber,
			1 -- no matter what, at this point, we found estimates for the project 
	FROM	tProject p (nolock)
	INNER JOIN tCompany c (nolock) on p.CompanyKey = c.CompanyKey
	INNER JOIN 
			(SELECT t.ProjectKey, MIN(t.PlanStart) AS StartDate, MAX(t.PlanComplete) AS EndDate
			FROM	#Task t
			INNER JOIN #Project tmpP ON t.ProjectKey = tmpP.ProjectKey AND tmpP.Approved = @Approved
			GROUP BY t.ProjectKey) t ON p.ProjectKey = t.ProjectKey

	--Set the Probability if it's from an Opportunity
	UPDATE	#Detail
	SET		#Detail.Probability = ISNULL(l.Probability, 0)
	FROM	#Detail dtl
	INNER JOIN tProject p (nolock) ON dtl.EntityKey = p.ProjectKey
	INNER JOIN tLead l (nolock) ON p.LeadKey = l.LeadKey
	-- potential projects only
	-- approved provects are 100%
	WHERE	dtl.Entity = @ENTITY_POTENTIAL_PROJECT -- in ( @ENTITY_POTENTIAL_PROJECT,  @ENTITY_APPROVED_PROJECT)
GO
