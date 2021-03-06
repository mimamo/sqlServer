USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptProjectSummaryScoreboard]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptProjectSummaryScoreboard]
	(
	@CompanyKey int
	,@StartDate datetime
	,@EndDate datetime
	,@ClientDivisionKey int	

	,@ShowZeroes int = 1
	,@ShowLaborNet int = 1
	,@ShowLaborGross int = 1
	
	,@IncludeRequests int = 1
	,@IncludeProjectSummary int = 1
	,@IncludeCompletedProjects int = 1 -- By project type
	
	,@IncludeHoursByProjectType int = 1
	,@IncludeHoursByClient int = 1
	,@IncludeHoursByDivision int = 1
	,@IncludeBillingByClient int = 1
	,@WithAdvBills int = 0
	,@IncludeProjectDetails int = 1

	,@UserKey int = null

	)
AS --Encrypt

  /*
  || When     Who Rel      What
  || 12/02/09 GHL 10.514   (64187) Creation for new customization   
  || 12/14/09 GHL 10.514   (70414) Added filtering of invoice dates
  || 12/21/11 CRG 10.5.5.1 (128004) Added ClientDivisionKey, IncludeProjectDetails for enhancement
  || 04/18/12 GHL 10.5.5.5 Added @UserKey to read tUserGLCompanyAccess
  || 07/17/12 RLB 10.5.5.8 Client Billings should not include RetainerAmount
  || 08/29/12 RLB 10.5.5.9 (152848) Changes made per this issue 
  || 10/30/12 WDF 10.5.6.1 (148834) Added @WithAdvBills flag
  ||  1/5/13  GWG 10.5.6.3 Removed Rounding of hours
  || 01/22/14 GHL 10.5.7.6 Converted to Home Currency 
  */

	SET NOCOUNT ON

	-- For section orders/labels
	declare @OrderRequests int						select @OrderRequests = 1
	declare @OrderProjectSummary int				select @OrderProjectSummary = 2
	declare @OrderCompletedProjects int				select @OrderCompletedProjects = 3 
	declare @OrderHoursByProjectType int			select @OrderHoursByProjectType = 4
	declare @OrderHoursByClient int					select @OrderHoursByClient = 5
	declare @OrderHoursByDivision int				select @OrderHoursByDivision = 6
	declare @OrderBillingByClient int				select @OrderBillingByClient = 7

	declare @LabelRequests varchar(250)				select @LabelRequests = 'Project Requests'
	declare @LabelProjectSummary varchar(250)		select @LabelProjectSummary = 'Project Summary'
	declare @LabelCompletedProjects varchar(250)	select @LabelCompletedProjects = 'Completed Projects by Project Type'
	declare @LabelHoursByProjectType varchar(250)	select @LabelHoursByProjectType = 'Hours by Project Type'
	declare @LabelHoursByClient varchar(250)		select @LabelHoursByClient = 'Hours by Client'
	declare @LabelHoursByDivision varchar(250)		select @LabelHoursByDivision = 'Hours by Division'
	declare @LabelBillingByClient varchar(250)		select @LabelBillingByClient = 'Billings by Client'

	declare @LabelNoProjectType varchar(50)			select @LabelNoProjectType = '[No Project Type]'
	declare @LabelNoClient varchar(50)				select @LabelNoClient = '[No Client]'
	declare @LabelNoDivision varchar(50)			select @LabelNoDivision = '[No Division]'
	
	declare @SectionOrder int
	declare @SectionLabel varchar(250)
	declare @ClientLabel varchar(250)

	select @ClientLabel = isnull(StringSingular, '') from tStringCompany (nolock) 
	where CompanyKey = @CompanyKey and StringID = 'Client' 
	
	if len(@ClientLabel) > 0 and @ClientLabel <> 'Client'
		select @LabelHoursByClient		= 'Hours by ' + @ClientLabel
		      ,@LabelBillingByClient	= 'Billings by ' + @ClientLabel
		      ,@LabelNoClient			= '[No ' + @ClientLabel + ']'
		      
	-- For request section
	declare @RequestsAdded int
	declare @RequestsRejected int
	declare @RequestsOpenApproved int
	declare @ProjectsAdded int
	
	-- For project summary section
	declare @ProjectsNew int
	declare @ProjectsCompleted int
	declare @ProjectsActive int
	declare @ProjectsTotal int
		
	create table #project_completed (
		ProjectKey int null
		,ProjectTypeKey int null
		,NumTasks int null
		,NumTasksCompleted int null
		,MaxActComplete datetime null)
		
	create table #project_active (
		ProjectKey int null
		,NumTasksStarted int null)
		 
	create table #hour (
		ProjectKey int null
		,GLCompanyKey int null
		,ProjectTypeKey int null
		,ClientKey int null
		,ClientDivisionKey int null
		,LaborNet money null
		,LaborGross money null
		,ActualHours decimal(24,4) null)
			 
	create table #results (
	    ActualHours decimal(24,2) null
	    ,LaborNet money null
		,LaborGross money null
		,SectionLabel varchar(250) null
		,SectionOrder int null
		,ItemLabel varchar(250) null
		,ItemOrder int identity(1,1)
		)

	create table #clients (
		ClientKey int null
		)

Declare @RestrictToGLCompany int

Select @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
	from tUser u (nolock)
	inner join tPreference p (nolock) on p.CompanyKey = ISNULL(u.OwnerCompanyKey, u.CompanyKey)
	Where u.UserKey = @UserKey

select @RestrictToGLCompany = isnull(@RestrictToGLCompany, 0)

	if @IncludeRequests = 1
	begin
		-- request added within range
		select @RequestsAdded = count(*) from tRequest (nolock)
		where  CompanyKey = @CompanyKey
		and    DateAdded >= @StartDate and DateAdded <= @EndDate 
	
		-- request rejected within range
		select @RequestsRejected = count(*) from tRequest (nolock)
		where  CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or ClientKey in (select ClientKey from #clients))
		and    DateAdded >= @StartDate and DateAdded <= @EndDate 
	    and    Status = 3 
	    
	    -- regardless of DateAdded within the range
	    select @RequestsOpenApproved = count(*) from tRequest (nolock)
		where  CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or ClientKey in (select ClientKey from #clients))
		and    Status = 4		
		and    DateCompleted is null
		
		-- projects created within range linked to a request
		select @ProjectsAdded = count(*) from tProject (nolock)
		where  CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or ClientDivisionKey = @ClientDivisionKey)
		and    StartDate >= @StartDate and StartDate <= @EndDate -- we do not have a DateAdded
		and    isnull(RequestKey, 0) >0
		
	end

	If @IncludeProjectSummary = 1 Or @IncludeCompletedProjects = 1
	begin
		-- completed projects
		-- Any project where all tasks have actual complete and max date in range
		insert #project_completed (ProjectKey, ProjectTypeKey, NumTasks, NumTasksCompleted, MaxActComplete)
		select p.ProjectKey, p.ProjectTypeKey, 0, 0, Max(t.ActComplete)
		from   tProject p (nolock)
		    inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
		where  p.CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or p.ClientDivisionKey = @ClientDivisionKey)
		and    t.ScheduleTask = 1
		and    t.TaskType = 2 -- detail
		and    t.ActComplete is not null
		AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

		group by p.ProjectKey, p.ProjectTypeKey
		having Max(t.ActComplete) >= @StartDate and Max(t.ActComplete) <= @EndDate 

		update #project_completed
		set    #project_completed.NumTasks = (select count(*) from tTask t (nolock) 
			where t.ProjectKey = #project_completed.ProjectKey 
			and   t.ScheduleTask = 1 
			and   t.TaskType = 2)
			
		update #project_completed
		set    #project_completed.NumTasksCompleted = (select count(*) from tTask t (nolock) 
			where t.ProjectKey = #project_completed.ProjectKey 
			and   t.ScheduleTask = 1 
			and   t.TaskType = 2
			and   t.ActComplete is not null)
			 
		delete #project_completed where isnull(NumTasks, 0) <> isnull(NumTasksCompleted, 0)		 	 
	end
	

	If @IncludeProjectSummary = 1
	begin
		-- Based on Start Date in project set up
		select @ProjectsNew = count(*) from tProject (nolock)
		where  CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or ClientDivisionKey = @ClientDivisionKey)
		and    StartDate >= @StartDate and StartDate <= @EndDate 
		AND (@RestrictToGLCompany = 0 
		OR GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )



		select @ProjectsCompleted = count(*) from #project_completed
		
		-- Active projects regardless of date range
		-- Any project that has at least one task with an actual start date
		-- and one task with no actual complete
		insert #project_active(ProjectKey, NumTasksStarted)
		select distinct p.ProjectKey, 0
		from   tProject p (nolock)
			inner join tTask t (nolock) on p.ProjectKey = t.ProjectKey
		where  p.CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or p.ClientDivisionKey = @ClientDivisionKey)
		and    t.ScheduleTask = 1
		and    t.TaskType = 2 -- detail
		and    t.ActComplete is null
		AND (@RestrictToGLCompany = 0 
		OR p.GLCompanyKey IN (SELECT GLCompanyKey FROM tUserGLCompanyAccess (NOLOCK) WHERE UserKey = @UserKey) )

		
		update #project_active
		set    #project_active.NumTasksStarted = (select count(*) from tTask t (nolock)
			where t.ProjectKey = #project_active.ProjectKey 
			and   t.ScheduleTask = 1 
			and   t.TaskType = 2
			and   t.ActStart is not null)
				
		delete #project_active where isnull(NumTasksStarted, 0) = 0
		
		select @ProjectsActive = count(*) from #project_active
						
		select @ProjectsTotal = isnull(@ProjectsCompleted, 0) + isnull(@ProjectsActive, 0) 
						
	end
	
	if @IncludeHoursByProjectType = 1 Or @IncludeHoursByClient = 1 Or @IncludeHoursByDivision = 1
	begin
		
		-- these flags could have a huge impact on the indexes on tTime
		-- so depending on these flags, have separate queries
		 
		if @ShowLaborNet = 0 and @ShowLaborGross = 0
	
			insert #hour (ProjectKey, ActualHours)
			select t.ProjectKey, SUM(t.ActualHours)
			from   tTime t (nolock)
			   inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey
			   left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
			where  ts.CompanyKey = @CompanyKey
			and	   (@ClientDivisionKey is null or p.ClientDivisionKey = @ClientDivisionKey)
			and    t.WorkDate >= @StartDate and t.WorkDate <= @EndDate
			group by t.ProjectKey
	
		

	     else
	     begin
	        -- we will need to calculate LaborNet and/or LaborGross
	        
	        if @ShowLaborNet = 0 and @ShowLaborGross = 1
	        
				insert #hour (ProjectKey, ActualHours, LaborGross)
				select t.ProjectKey, SUM(t.ActualHours)
				, SUM(
					ROUND(ROUND(t.ActualHours * t.ActualRate, 2) * t.ExchangeRate, 2)
				)
				from   tTime t (nolock)
				   inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey
				   left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
				where  ts.CompanyKey = @CompanyKey
				and	   (@ClientDivisionKey is null or p.ClientDivisionKey = @ClientDivisionKey)
				and    t.WorkDate >= @StartDate and t.WorkDate <= @EndDate
				group by t.ProjectKey
			
			if @ShowLaborNet = 1 and @ShowLaborGross = 0
	        
				insert #hour (ProjectKey, ActualHours, LaborNet)
				select t.ProjectKey, SUM(t.ActualHours), SUM(ROUND(t.ActualHours * t.HCostRate, 2))
				from   tTime t (nolock)
				   inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey
				   left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
				where  ts.CompanyKey = @CompanyKey
				and	   (@ClientDivisionKey is null or p.ClientDivisionKey = @ClientDivisionKey)
				and    t.WorkDate >= @StartDate and t.WorkDate <= @EndDate
				group by t.ProjectKey
			
			if @ShowLaborNet = 1 and @ShowLaborGross = 1
	        
				insert #hour (ProjectKey, ActualHours, LaborNet, LaborGross)
				select t.ProjectKey, SUM(t.ActualHours)
				, SUM(ROUND(t.ActualHours * t.HCostRate, 2))
				, SUM(
					ROUND(ROUND(t.ActualHours * t.ActualRate, 2) * t.ExchangeRate, 2)
				)
				from   tTime t (nolock)
				   inner join tTimeSheet ts (nolock) on ts.TimeSheetKey = t.TimeSheetKey
				   left join tProject p (nolock) on t.ProjectKey = p.ProjectKey
				where  ts.CompanyKey = @CompanyKey
				and	   (@ClientDivisionKey is null or p.ClientDivisionKey = @ClientDivisionKey)
				and    t.WorkDate >= @StartDate and t.WorkDate <= @EndDate
				group by t.ProjectKey
				
		 end
		 
		 update #hour
		 set    #hour.ProjectTypeKey = p.ProjectTypeKey
		       ,#hour.ClientKey = p.ClientKey
		       ,#hour.ClientDivisionKey = p.ClientDivisionKey
			   ,#hour.GLCompanyKey = p.GLCompanyKey 
		 from   tProject p (nolock)
		 where  p.CompanyKey = @CompanyKey
		 and    p.ProjectKey = #hour.ProjectKey
		 
		 if @RestrictToGLCompany = 1
		 begin
			delete #hour
			where  isnull(GLCompanyKey, 0) not in (
				select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey
				)
		 end

		 update  #hour
		 set     #hour.LaborNet = isnull(LaborNet, 0)
				,#hour.LaborGross = isnull(LaborGross, 0)	
				,#hour.ProjectTypeKey = isnull(ProjectTypeKey, 0)	
				,#hour.ClientKey = isnull(ClientKey, 0)	
				,#hour.ClientDivisionKey = isnull(ClientDivisionKey, 0)	
				  
	end
	
	if @IncludeRequests = 1
	begin
		select @SectionLabel = @LabelRequests, @SectionOrder = @OrderRequests
	
		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@RequestsAdded,0), null, null, @SectionLabel, @SectionOrder, 'New Requests'

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@RequestsRejected,0), null, null, @SectionLabel, @SectionOrder, 'Rejected Requests'

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@ProjectsAdded,0), null, null, @SectionLabel, @SectionOrder, 'Projects Created from Approved Requests'

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@RequestsOpenApproved,0), null, null, @SectionLabel, @SectionOrder, 'Open Approved Requests'
	
	end
	
	if @IncludeProjectSummary = 1
	begin
		select @SectionLabel = @LabelProjectSummary, @SectionOrder = @OrderProjectSummary
	
		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@ProjectsNew,0), null, null, @SectionLabel, @SectionOrder, 'New Projects'

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@ProjectsCompleted,0), null, null, @SectionLabel, @SectionOrder, 'Completed Projects'

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@ProjectsActive,0), null, null, @SectionLabel, @SectionOrder, 'Active Projects'

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
		select isnull(@ProjectsTotal,0), null, null, @SectionLabel, @SectionOrder, 'Total Projects'
	
	end
	
	if @IncludeCompletedProjects = 1
	begin
		select @SectionLabel = @LabelCompletedProjects, @SectionOrder = @OrderCompletedProjects
		
		-- order by alpha order
		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)

		select count(b.ProjectKey), null, null, @SectionLabel, @SectionOrder, pt.ProjectTypeName
		from   tProjectType pt (nolock)
			  left outer join #project_completed b (nolock) on pt.ProjectTypeKey = b.ProjectTypeKey
		where  pt.CompanyKey = @CompanyKey
		group by pt.ProjectTypeName
		order by pt.ProjectTypeName
	end 

	if @IncludeHoursByProjectType = 1
	begin
		select @SectionLabel = @LabelHoursByProjectType, @SectionOrder = @OrderHoursByProjectType
				
		-- get a list of projectype for the company since they want
		-- ProjectTypeName is unique
		-- order by ActualHours desc 			
	
		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)

		select isnull(sum(b.ActualHours), 0) as ActualHours
				,isnull(sum(b.LaborNet), 0) as LaborNet
				,isnull(sum(b.LaborGross), 0) as LaborGross
				,@SectionLabel, @SectionOrder
		        ,pt.ProjectTypeName
		from   tProjectType pt (nolock)
			  left outer join #hour b (nolock) on pt.ProjectTypeKey = b.ProjectTypeKey
		where  pt.CompanyKey = @CompanyKey
		group by pt.ProjectTypeName
		
		UNION ALL
		
		select isnull(sum(b.ActualHours), 0) as ActualHours   
				,isnull(sum(b.LaborNet), 0) as LaborNet
				,isnull(sum(b.LaborGross), 0) as LaborGross
				,@SectionLabel, @SectionOrder, @LabelNoProjectType As  ProjectTypeName
		from  #hour b
		where b.ProjectTypeKey = 0
		
		order by ActualHours desc, ProjectTypeName			
	
	end

	if @IncludeHoursByDivision = 1
	begin
		select @SectionLabel = @LabelHoursByDivision, @SectionOrder = @OrderHoursByDivision

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
	  
		-- client divisions	
		-- DivisionName is not unique (may have same name for diff clients)
		select isnull(sum(b.ActualHours), 0) as ActualHours
				,isnull(sum(b.LaborNet), 0) as LaborNet
				,isnull(sum(b.LaborGross), 0) as LaborGross
				,@SectionLabel, @SectionOrder, cd.DivisionName   
		from   tClientDivision cd (nolock)
			  left outer join #hour b (nolock) on cd.ClientDivisionKey = b.ClientDivisionKey
		where  cd.CompanyKey = @CompanyKey
		and	   (@ClientDivisionKey is null or cd.ClientDivisionKey = @ClientDivisionKey)
		group by cd.DivisionName

		UNION ALL
		
		select isnull(sum(b.ActualHours), 0) as ActualHours
				,isnull(sum(b.LaborNet), 0) as LaborNet
				,isnull(sum(b.LaborGross), 0) as LaborGross
				,@SectionLabel, @SectionOrder, @LabelNoDivision as DivisionName   
		from  #hour b
		where @ClientDivisionKey is null --Only include ClientDivisionKey = 0 if we're not filtering on a specific division
		and	  b.ClientDivisionKey = 0
		
		order by ActualHours desc, DivisionName			
	
	end
			
	-- in case they change the BillableClient on the company record, the numbers would be different
	update #hour
	set    #hour.ClientKey = 0
	from   tCompany c (nolock)
	where  c.OwnerCompanyKey = @CompanyKey
	and    c.CompanyKey = #hour.ClientKey
	and    c.BillableClient = 0
		
	if @IncludeHoursByClient = 1
	begin
		select @SectionLabel = @LabelHoursByClient, @SectionOrder = @OrderHoursByClient

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
	  
		-- Client 	
		select isnull(sum(b.ActualHours), 0) as ActualHours
				,isnull(sum(b.LaborNet), 0) as LaborNet
				,isnull(sum(b.LaborGross), 0) as LaborGross
				,@SectionLabel, @SectionOrder, cl.CompanyName   
		from   tCompany cl (nolock)
			  left outer join #hour b (nolock) on cl.CompanyKey = b.ClientKey
		where  cl.OwnerCompanyKey = @CompanyKey
		and    cl.BillableClient = 1
		and	   (@ClientDivisionKey is null or ClientKey in (select ClientKey from #clients))
		group by cl.CompanyName

		UNION ALL
		
		select isnull(sum(b.ActualHours), 0) as ActualHours
				,isnull(sum(b.LaborNet), 0) as LaborNet
				,isnull(sum(b.LaborGross), 0) as LaborGross
				,@SectionLabel, @SectionOrder, @LabelNoClient as CompanyName   
		from  #hour b
		where @ClientDivisionKey is null --Only include ClientKey = 0 if we're not filtering on a specific division
		and   b.ClientKey = 0

		order by ActualHours desc, CompanyName			
	
	end
	
	if @IncludeBillingByClient = 1
	begin
		select @SectionLabel = @LabelBillingByClient, @SectionOrder = @OrderBillingByClient

		insert #results (ActualHours, LaborNet, LaborGross, SectionLabel, SectionOrder, ItemLabel)
	  
		-- Client 	
		select isnull(sum(
				round(i.InvoiceTotalAmount * i.ExchangeRate, 2)
				), 0) as InvoiceTotalAmount
				,null
				,null
				,@SectionLabel, @SectionOrder, cl.CompanyName   
		from   tCompany cl (nolock)
	          left outer join tInvoice i (nolock) 
				on cl.CompanyKey = i.ClientKey
				and i.PostingDate >=@StartDate and i.PostingDate <=@EndDate
				and (i.AdvanceBill = 0 Or i.AdvanceBill = @WithAdvBills)
				and (@RestrictToGLCompany = 0 Or
				(i.GLCompanyKey in (select GLCompanyKey from tUserGLCompanyAccess (nolock) where UserKey = @UserKey) )
				)
		where  (@ClientDivisionKey is null or i.ClientKey in (select ClientKey from #clients))
		and    cl.OwnerCompanyKey = @CompanyKey
		and    cl.BillableClient = 1
		group by cl.CompanyName

		order by InvoiceTotalAmount desc, CompanyName			
	
	end
		
	if @ShowZeroes = 0
		delete #results where SectionOrder > @OrderProjectSummary and ActualHours = 0
		
	-- no matter what delete the [No Project Type], etc...	if no record
	delete #results where SectionOrder > @OrderProjectSummary and ActualHours = 0 and ItemLabel in
		( @LabelNoProjectType, @LabelNoDivision, @LabelNoClient)
			
			
	select * from #results order by SectionOrder, ItemOrder

	if @IncludeProjectDetails = 1
	begin
		select	p.ProjectKey,
				ISNULL(p.ProjectNumber, '') + '-' + ISNULL(p.ProjectName, '') AS Project,
				p.ProjectTypeKey,
				pt.ProjectTypeName,
				p.ClientKey,
				c.CompanyName AS ClientName,
				p.ClientDivisionKey,
				cd.DivisionName,
				p.Duration,
				p.EstHours + p.ApprovedCOHours AS BudgetHours,
				roll.Hours AS ActualHours,
				p.EstLabor + p.EstExpenses + p.ApprovedCOLabor + p.ApprovedCOExpense AS BudgetDollars,
				roll.LaborGross + roll.ExpReceiptGross + roll.MiscCostGross + roll.OrderPrebilled + roll.VoucherOutsideCostsGross AS ActualDollars
		from	#project_completed pc (nolock)
		inner join tProject p (nolock) on pc.ProjectKey = p.ProjectKey
		inner join tProjectRollup roll (NOLOCK) on p.ProjectKey = roll.ProjectKey
		left join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		left join tProjectType pt (nolock) on p.ProjectTypeKey = pt.ProjectTypeKey
		left join tClientDivision cd (nolock) on p.ClientDivisionKey = cd.ClientDivisionKey
	end
			
	RETURN 1
GO
