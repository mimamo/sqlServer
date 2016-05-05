USE [MOJo_dev]
GO

/****** Object:  StoredProcedure [dbo].[sptEstimateApplyClientRateMarkup]    Script Date: 04/29/2016 16:38:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[sptEstimateApplyClientRateMarkup]
	(
	@EstimateKey int
	,@ClientKey int
	,@ApplyRate int = 1
	,@ApplyMarkup int = 1
	,@RecalcTotals int = 1
	,@CampaignSegmentKey int = null -- if null whole estimate
	,@TaskKey int = null
	)
AS
	SET NOCOUNT ON
	
/*
|| When      Who Rel      What
|| 4/07/10   GHL 10.5.2.1 Creation for new functionality (Copy estimates from a template project on opp screen)
||                        This SP applies rates and markups from the client
|| 6/20/13   GHL 10.5.6.9 (181882) Removed restriction on UserKey when setting tEstimateTaskLabor.Rate
||                         when GetRateFrom = From Client
|| 07/28/14 GHL 10.582  (223866) Added the ability to apply the rate to a task 
|| 03/27/15 GHL 10.591  (250940) Added support for titles for Abelson Taylor
|| 04/10/15 GHL 10.591  For Abelson Taylor made the following change:
||                      Initially the defaults were coming from the client
||                      Now I pull defaults from client and project
||                      If the project default says get from client
||                          I look at the client defaults  
||                      else
||                          keep the project defaults
|| 08/03/15 GHL 10.594  (265216) Fixed a case when MU = tEstimateTask.Markup = 0 and Net = tEstimateTask.BudgetExpenses = 0 
||                      i.e. only the Gross is <> 0, when recalculating Gross from MU and Net, the Gross becomes 0
||                      I added a check of Net = tEstimateTask.BudgetExpenses <> 0 before recalc  
|| 08/14/15 GHL 10.594  (266494) After updating the Rate on tEstimateTaskLaborTitle recs, recalc the Gross
||                      I need to update the new rate = Gross/Hours on tEstimateTaskLabor 
*/ 

	-- Estimate Types
	declare @kByTaskOnly int            select @kByTaskOnly = 1
	declare @kByTaskService int         select @kByTaskService = 2
	declare @kByTaskPerson int          select @kByTaskPerson = 3
	declare @kByServiceOnly int         select @kByServiceOnly = 4
	declare @kBySegmentService int      select @kBySegmentService = 5
	declare @kByProject int			    select @kByProject = 6
	declare @kByTitleOnly int	        select @kByTitleOnly = 7
	declare @kBySegmentTitle int	    select @kBySegmentTitle = 8

	-- These are the GetRateFrom values in tProject and tCompany
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1			-- HourlyRate in tCompany
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2			-- HourlyRate in tCompany/tProject
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
	declare @kGetRateFromTitle int              select @kGetRateFromTitle = 9
	declare @kGetRateFromTitleRateSheet int     select @kGetRateFromTitleRateSheet = 10

	-- But as far as services are concerned, we can only get them from 3 places
	-- 1) HourlyRate (from Client or from Project)
	-- 2) Or TimeRateSheetKey
	-- 3) Or Service 
	
	-- These are the GetMarkupFrom values in tCompany
	declare @kGetMarkupFromClient int             select @kGetMarkupFromClient = 1			-- ItemMarkup in tCompany
	declare @kGetMarkupFromProject int            select @kGetMarkupFromProject = 2			-- ItemMarkup in tCompany/tProject
	declare @kGetMarkupFromItem int	              select @kGetMarkupFromItem = 3
	declare @kGetMarkupFromItemRateSheet int      select @kGetMarkupFromItemRateSheet = 4
	declare @kGetMarkupFromTask int               select @kGetMarkupFromTask = 5
	
	
	declare @EstType int
	declare @CompanyKey int
	declare @ProjectKey int
	declare @LeadKey int
	declare @CampaignKey int
	declare @TemplateProjectKey int
	declare @UseTitle int

	declare @GetRateFrom int
	declare @TimeRateSheetKey int
	declare @TitleRateSheetKey int
	declare @HourlyRate money
	declare @GetMarkupFrom int
	declare @ItemRateSheetKey int
	declare @ItemMarkup decimal(24, 4)
	
	declare @ClientGetRateFrom int
	declare @ClientTimeRateSheetKey int
	declare @ClientTitleRateSheetKey int
	declare @ClientHourlyRate money
	declare @ClientGetMarkupFrom int
	declare @ClientItemRateSheetKey int
	declare @ClientItemMarkup decimal(24, 4)
	
	declare @ProjectGetRateFrom int
	declare @ProjectTimeRateSheetKey int
	declare @ProjectTitleRateSheetKey int
	declare @ProjectHourlyRate money
	declare @ProjectGetMarkupFrom int
	declare @ProjectItemRateSheetKey int
	declare @ProjectItemMarkup decimal(24, 4)
	
	select @EstType = EstType
	      ,@CompanyKey = CompanyKey
	      ,@ProjectKey = ProjectKey
	      ,@LeadKey = LeadKey
	      ,@CampaignKey = CampaignKey
		  ,@UseTitle = isnull(UseTitle, 0)
	from   tEstimate (nolock)
	where  EstimateKey = @EstimateKey
		
	select @ClientGetRateFrom = GetRateFrom
	      ,@ClientTimeRateSheetKey = TimeRateSheetKey
	      ,@ClientHourlyRate = HourlyRate
	      ,@ClientGetMarkupFrom = GetMarkupFrom
	      ,@ClientItemRateSheetKey = ItemRateSheetKey
	      ,@ClientItemMarkup = ItemMarkup
		  ,@ClientTitleRateSheetKey = TitleRateSheetKey
	from  tCompany (nolock)
	where CompanyKey = @ClientKey

	if isnull(@ProjectKey, 0) > 0
	begin
		select @ProjectGetRateFrom = GetRateFrom
	      ,@ProjectTimeRateSheetKey = TimeRateSheetKey
	      ,@ProjectHourlyRate = HourlyRate
	      ,@ProjectGetMarkupFrom = GetMarkupFrom
	      ,@ProjectItemRateSheetKey = ItemRateSheetKey
	      ,@ProjectItemMarkup = ItemMarkup
		  ,@ProjectTitleRateSheetKey = TitleRateSheetKey
		from  tProject (nolock)
		where ProjectKey = @ProjectKey
		
		if @ProjectGetRateFrom = @kGetRateFromClient
			select @GetRateFrom = @ClientGetRateFrom
			,@TimeRateSheetKey = @ClientTimeRateSheetKey
			,@HourlyRate = @ClientHourlyRate
			,@TitleRateSheetKey = @ClientTitleRateSheetKey
		 else
			select @GetRateFrom = @ProjectGetRateFrom
			,@TimeRateSheetKey = @ProjectTimeRateSheetKey
			,@HourlyRate = @ProjectHourlyRate
			,@TitleRateSheetKey = @ProjectTitleRateSheetKey
		 
		 if @ProjectGetMarkupFrom = @kGetMarkupFromClient
			select @GetMarkupFrom = @ClientGetMarkupFrom
			,@ItemRateSheetKey = @ClientItemRateSheetKey
			,@ItemMarkup = @ClientItemMarkup
		 else
			select @GetMarkupFrom = @ProjectGetMarkupFrom
			,@ItemRateSheetKey = @ProjectItemRateSheetKey
			,@ItemMarkup = @ProjectItemMarkup
			
	end
	else
	begin
		select @GetRateFrom = @ClientGetRateFrom
	      ,@TimeRateSheetKey = @ClientTimeRateSheetKey
	      ,@HourlyRate = @ClientHourlyRate
	      ,@GetMarkupFrom = @ClientGetMarkupFrom
	      ,@ItemRateSheetKey = @ClientItemRateSheetKey
	      ,@ItemMarkup = @ClientItemMarkup
		  ,@TitleRateSheetKey = @ClientTitleRateSheetKey
	end
	
	if isnull(@LeadKey, 0) > 0
		select @TemplateProjectKey = ProjectKey
		from   tEstimateTaskTemp (nolock)
		where  Entity = 'tLead'
		and    EntityKey = @LeadKey
	
/*
	-- These are the GetRateFrom values in tProject and tCompany
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1			-- HourlyRate in tCompany
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2			-- HourlyRate in tCompany/tProject
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
	declare @kGetRateFromTitle int              select @kGetRateFromTitle = 9
	declare @kGetRateFromTitleRateSheet int     select @kGetRateFromTitleRateSheet = 10
*/

	-- Labor
if @ApplyRate = 1
begin			
	if @GetRateFrom in (@kGetRateFromClient, @kGetRateFromProject)
	begin
		update tEstimateTaskLabor 
		set    Rate = isnull(@HourlyRate, 0)
		where  EstimateKey = @EstimateKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or CampaignSegmentKey = @CampaignSegmentKey)  
		and    (isnull(@TaskKey, 0) = 0 or TaskKey = @TaskKey)  
		
		-- this table does not support segments
		update tEstimateTaskLaborLevel 
		set    Rate = isnull(@HourlyRate, 0)
		where  EstimateKey = @EstimateKey
		and    (isnull(@TaskKey, 0) = 0 or TaskKey = @TaskKey)  

		-- this table does not support segments
		update tEstimateTaskLaborTitle 
		set    Rate = isnull(@HourlyRate, 0)
		      ,Gross = round(isnull(Hours, 0) * isnull(@HourlyRate, 0), 2)
		where  EstimateKey = @EstimateKey
		and    (isnull(@TaskKey, 0) = 0 or TaskKey = @TaskKey)  

		update tEstimateTask
		set    Rate = isnull(@HourlyRate, 0)
		where  EstimateKey = @EstimateKey

		update tEstimateService
		set    Rate = isnull(@HourlyRate, 0)
		where  EstimateKey = @EstimateKey

	end
	
	 
	if @GetRateFrom in (@kGetRateFromService)
	begin
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = isnull(s.HourlyRate1, 0)
		from   tService s (nolock) 
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.ServiceKey = s.ServiceKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey)  
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLabor.TaskKey = @TaskKey)  

		-- this table does not support segments
		update tEstimateTaskLaborLevel
		set    tEstimateTaskLaborLevel.Rate = isnull(s.HourlyRate1, 0)
		from   tService s (nolock) 
		where  tEstimateTaskLaborLevel.EstimateKey = @EstimateKey
		and    tEstimateTaskLaborLevel.ServiceKey = s.ServiceKey
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLaborLevel.TaskKey = @TaskKey)  

		update tEstimateService
		set    tEstimateService.Rate = isnull(s.HourlyRate1, 0)
		from   tService s (nolock) 
		where  tEstimateService.EstimateKey = @EstimateKey
		and    tEstimateService.ServiceKey = s.ServiceKey

	end
	
	if @GetRateFrom in (@kGetRateFromServiceRateSheet)
	begin
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = isnull(trsd.HourlyRate1, 0)
		from   tTimeRateSheetDetail trsd (nolock) 
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.ServiceKey = trsd.ServiceKey
		and    trsd.TimeRateSheetKey = @TimeRateSheetKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey)  
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLabor.TaskKey = @TaskKey)  

		-- this table does not support segments
		update tEstimateTaskLaborLevel
		set    tEstimateTaskLaborLevel.Rate = isnull(trsd.HourlyRate1, 0)
		from   tTimeRateSheetDetail trsd (nolock) 
		where  tEstimateTaskLaborLevel.EstimateKey = @EstimateKey
		and    tEstimateTaskLaborLevel.ServiceKey = trsd.ServiceKey
		and    trsd.TimeRateSheetKey = @TimeRateSheetKey
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLaborLevel.TaskKey = @TaskKey)  

		update tEstimateService
		set    tEstimateService.Rate = isnull(trsd.HourlyRate1, 0)
		from   tTimeRateSheetDetail trsd (nolock) 
		where  tEstimateService.EstimateKey = @EstimateKey
		and    tEstimateService.ServiceKey = trsd.ServiceKey
		and    trsd.TimeRateSheetKey = @TimeRateSheetKey
	
	end
	
	if @GetRateFrom in (@kGetRateFromProjectUser)
	begin
		if isnull(@LeadKey, 0) = 0
			update tEstimateUser
			set    tEstimateUser.BillingRate = isnull(a.HourlyRate, 0)
			from   tAssignment a (nolock) 
			where  tEstimateUser.EstimateKey = @EstimateKey
			and    tEstimateUser.UserKey = a.UserKey
			and    a.ProjectKey = @ProjectKey
		else
			update tEstimateUser
			set    tEstimateUser.BillingRate = isnull(a.HourlyRate, 0)
			from   tAssignment a (nolock) 
			where  tEstimateUser.EstimateKey = @EstimateKey
			and    tEstimateUser.UserKey = a.UserKey
			and    a.ProjectKey = @TemplateProjectKey		
		
		
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = isnull(eu.BillingRate, 0)
		from   tEstimateUser eu (nolock) 
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.UserKey = eu.UserKey
		and    eu.EstimateKey = @EstimateKey
	end
	
	if @GetRateFrom in (@kGetRateFromTask)
	begin
		if isnull(@LeadKey, 0) = 0
		begin
			-- not sure about this? only tEstimateTask?
			update tEstimateTaskLabor
			set    tEstimateTaskLabor.Rate = isnull(t.HourlyRate, 0)
			from   tTask t (nolock) 
			where  tEstimateTaskLabor.EstimateKey = @EstimateKey
			and    tEstimateTaskLabor.TaskKey = t.TaskKey
			and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey)  
			and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLabor.TaskKey = @TaskKey)  

			update tEstimateTaskLaborLevel
			set    tEstimateTaskLaborLevel.Rate = isnull(t.HourlyRate, 0)
			from   tTask t (nolock) 
			where  tEstimateTaskLaborLevel.EstimateKey = @EstimateKey
			and    tEstimateTaskLaborLevel.TaskKey = t.TaskKey
			and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLaborLevel.TaskKey = @TaskKey)  

			update tEstimateTask
			set    tEstimateTask.Rate = isnull(t.HourlyRate, 0)
			from   tTask t (nolock) 
			where  tEstimateTask.EstimateKey = @EstimateKey
			and    tEstimateTask.TaskKey = t.TaskKey
	
		end
		else
		begin
			-- not sure about this? only tEstimateTask?
			update tEstimateTaskLabor
			set    tEstimateTaskLabor.Rate = isnull(ett.HourlyRate, 0)
			from   tEstimateTaskTemp ett (nolock) 
			where  tEstimateTaskLabor.EstimateKey = @EstimateKey
			and    tEstimateTaskLabor.TaskKey = ett.TaskKey
		    and    ett.Entity = 'tLead'
		    and    ett.EntityKey = @LeadKey
			and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey)  
			and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLabor.TaskKey = @TaskKey)  

			update tEstimateTaskLaborLevel
			set    tEstimateTaskLaborLevel.Rate = isnull(ett.HourlyRate, 0)
			from   tEstimateTaskTemp ett (nolock) 
			where  tEstimateTaskLaborLevel.EstimateKey = @EstimateKey
			and    tEstimateTaskLaborLevel.TaskKey = ett.TaskKey
		    and    ett.Entity = 'tLead'
		    and    ett.EntityKey = @LeadKey
			and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLaborLevel.TaskKey = @TaskKey)  

			update tEstimateTask
			set    tEstimateTask.Rate = isnull(ett.HourlyRate, 0)
			from   tEstimateTaskTemp ett (nolock) 
			where  tEstimateTask.EstimateKey = @EstimateKey
			and    tEstimateTask.TaskKey = ett.TaskKey
		    and    ett.Entity = 'tLead'
		    and    ett.EntityKey = @LeadKey
		
		end    
	end

	declare @UpdateFromTitle int
	select @UpdateFromTitle = 0
	if @UseTitle = 1 
		select @UpdateFromTitle = 1
	if @EstType in (@kByTitleOnly, @kBySegmentTitle)
		select @UpdateFromTitle = 1

	if @GetRateFrom in (@kGetRateFromTitle) and @UpdateFromTitle = 1
	begin
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = isnull(t.HourlyRate, 0)
		from   tTitle t (nolock) 
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.TitleKey = t.TitleKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey)  
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLabor.TaskKey = @TaskKey)  

		-- this table does not support segments
		update tEstimateTaskLaborTitle
		set    tEstimateTaskLaborTitle.Rate = isnull(t.HourlyRate, 0)
		       ,tEstimateTaskLaborTitle.Gross = round(isnull(tEstimateTaskLaborTitle.Hours, 0) * isnull(t.HourlyRate, 0), 2)
		from   tTitle t (nolock) 
		where  tEstimateTaskLaborTitle.EstimateKey = @EstimateKey
		and    tEstimateTaskLaborTitle.TitleKey = t.TitleKey
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLaborTitle.TaskKey = @TaskKey)  

		-- If we updated the Rate on tEstimateTaskLaborTitle, we must recalc the Gross, because I need it below (266494)
		update tEstimateTaskLaborTitle
		set    Gross = ROUND(Hours * Rate, 2) 
		where  EstimateKey = @EstimateKey

		-- Now we have to rollup to tEstimateTaskLabor 
		-- tEstimateTaskLaborTitle is organized by task/service/title, rollup by task/service
		if @UseTitle = 1 -- this would be by project, not campaign
			update tEstimateTaskLabor
			set    tEstimateTaskLabor.Rate = titles.Gross / titles.Hours
			      ,tEstimateTaskLabor.Cost = titles.Net / titles.Hours
			from  
			 (
			 select sum(etlt.Gross) as Gross
			       ,sum(etlt.Hours) as Hours
				   ,sum(isnull(etlt.Hours, 0) * isnull(etlt.Cost, 0)) as Net
				   ,etlt.ServiceKey, etlt.TaskKey
			 from   tEstimateTaskLaborTitle etlt (nolock)
			 where etlt.EstimateKey = @EstimateKey 
			 group by etlt.ServiceKey, etlt.TaskKey 
			 ) as titles
			where tEstimateTaskLabor.EstimateKey = @EstimateKey
			and   tEstimateTaskLabor.ServiceKey = titles.ServiceKey
			and   tEstimateTaskLabor.TaskKey = titles.TaskKey
			and   titles.Hours <> 0


		update tEstimateTitle
		set    tEstimateTitle.Rate = isnull(t.HourlyRate, 0)
		from   tTitle t (nolock) 
		where  tEstimateTitle.EstimateKey = @EstimateKey
		and    tEstimateTitle.TitleKey = t.TitleKey

	end
	

	if @GetRateFrom in (@kGetRateFromTitleRateSheet)  and @UpdateFromTitle = 1
	begin
		update tEstimateTaskLabor
		set    tEstimateTaskLabor.Rate = isnull(trsd.HourlyRate, 0)
		from   tTitleRateSheetDetail trsd (nolock) 
		where  tEstimateTaskLabor.EstimateKey = @EstimateKey
		and    tEstimateTaskLabor.TitleKey = trsd.TitleKey
		and    trsd.TitleRateSheetKey = @TitleRateSheetKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskLabor.CampaignSegmentKey = @CampaignSegmentKey)  
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLabor.TaskKey = @TaskKey)  

		-- this table does not support segments
		update tEstimateTaskLaborTitle
		set    tEstimateTaskLaborTitle.Rate = isnull(trsd.HourlyRate, 0)
		from   tTitleRateSheetDetail trsd (nolock) 
		where  tEstimateTaskLaborTitle.EstimateKey = @EstimateKey
		and    tEstimateTaskLaborTitle.TitleKey = trsd.TitleKey
		and    trsd.TitleRateSheetKey = @TitleRateSheetKey
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskLaborTitle.TaskKey = @TaskKey)  

		-- If we updated the Rate on tEstimateTaskLaborTitle, we must recalc the Gross, because I need it below (266494)
		update tEstimateTaskLaborTitle
		set    Gross = ROUND(Hours * Rate, 2) 
		where  EstimateKey = @EstimateKey

		-- Now we have to rollup to tEstimateTaskLabor 
		-- tEstimateTaskLaborTitle is organized by task/service/title, rollup by task/service
		if @UseTitle = 1 -- this would be by project, not campaign
			update tEstimateTaskLabor
			set    tEstimateTaskLabor.Rate = titles.Gross / titles.Hours
			      ,tEstimateTaskLabor.Cost = titles.Net / titles.Hours
			from  
			 (
			 select sum(etlt.Gross) as Gross
			       ,sum(etlt.Hours) as Hours
				   ,sum(isnull(etlt.Hours, 0) * isnull(etlt.Cost, 0)) as Net
				   ,etlt.ServiceKey, etlt.TaskKey
			 from   tEstimateTaskLaborTitle etlt (nolock)
			 where etlt.EstimateKey = @EstimateKey 
			 group by etlt.ServiceKey, etlt.TaskKey 
			 ) as titles
			where tEstimateTaskLabor.EstimateKey = @EstimateKey
			and   tEstimateTaskLabor.ServiceKey = titles.ServiceKey
			and   tEstimateTaskLabor.TaskKey = titles.TaskKey
			and   titles.Hours <> 0

		update tEstimateTitle
		set    tEstimateTitle.Rate = isnull(trsd.HourlyRate, 0)
		from   tTitleRateSheetDetail trsd (nolock) 
		where  tEstimateTitle.EstimateKey = @EstimateKey
		and    tEstimateTitle.TitleKey = trsd.TitleKey
		and    trsd.TitleRateSheetKey = @TitleRateSheetKey
	
	end


end -- Apply Labor	

	-- Expenses
	
/*	
	-- These are the GetMarkupFrom values in tCompany
	declare @kGetMarkupFromClient int             select @kGetMarkupFromClient = 1			
	declare @kGetMarkupFromProject int            select @kGetMarkupFromProject = 2			
	declare @kGetMarkupFromItem int	              select @kGetMarkupFromItem = 3
	declare @kGetMarkupFromItemRateSheet int      select @kGetMarkupFromItemRateSheet = 4
	declare @kGetMarkupFromTask int               select @kGetMarkupFromTask = 5
*/

if @ApplyMarkup = 1
begin	
	if @GetMarkupFrom in (@kGetMarkupFromClient, @kGetMarkupFromProject)
	begin
		update tEstimateTaskExpense 
		set    Markup = isnull(@ItemMarkup, 0)
		where  EstimateKey = @EstimateKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or CampaignSegmentKey = @CampaignSegmentKey)  
		and    (isnull(@TaskKey, 0) = 0 or TaskKey = @TaskKey)  
	
	end
	
	 
	if @GetMarkupFrom in (@kGetMarkupFromItem)
	begin
		update tEstimateTaskExpense
		set    tEstimateTaskExpense.Markup = isnull(i.Markup, 0)
		      ,tEstimateTaskExpense.UnitRate = isnull(i.UnitRate, 0)
		from   tItem i (nolock) 
		where  tEstimateTaskExpense.EstimateKey = @EstimateKey
		and    tEstimateTaskExpense.ItemKey = i.ItemKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskExpense.CampaignSegmentKey = @CampaignSegmentKey)
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskExpense.TaskKey = @TaskKey)	
	end
	
	if @GetMarkupFrom in (@kGetMarkupFromItemRateSheet)
	begin
		update tEstimateTaskExpense
		set    tEstimateTaskExpense.Markup = isnull(irsd.Markup, 0)
		      ,tEstimateTaskExpense.UnitRate = isnull(irsd.UnitRate, 0)
		from   tItemRateSheetDetail irsd (nolock) 
		where  tEstimateTaskExpense.EstimateKey = @EstimateKey
		and    tEstimateTaskExpense.ItemKey = irsd.ItemKey
		and    irsd.ItemRateSheetKey = @ItemRateSheetKey
		and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskExpense.CampaignSegmentKey = @CampaignSegmentKey)  	
		and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskExpense.TaskKey = @TaskKey)	

	end
	
	if @GetMarkupFrom in (@kGetMarkupFromTask)
	begin
		if isnull(@LeadKey, 0) = 0
		begin
			update tEstimateTaskExpense
			set    tEstimateTaskExpense.Markup = isnull(t.Markup, 0)
			from   tTask t (nolock) 
			where  tEstimateTaskExpense.EstimateKey = @EstimateKey
			and    tEstimateTaskExpense.TaskKey = t.TaskKey
			and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskExpense.CampaignSegmentKey = @CampaignSegmentKey)  	
			and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskExpense.TaskKey = @TaskKey)	

			update tEstimateTask
			set    tEstimateTask.Markup = isnull(t.Markup, 0)
			from   tTask t (nolock) 
			where  tEstimateTask.EstimateKey = @EstimateKey
			and    tEstimateTask.TaskKey = t.TaskKey
	
		end
		else
		begin
			update tEstimateTaskExpense
			set    tEstimateTaskExpense.Markup = isnull(ett.Markup, 0)
			from   tEstimateTaskTemp ett (nolock) 
			where  tEstimateTaskExpense.EstimateKey = @EstimateKey
			and    tEstimateTaskExpense.TaskKey = ett.TaskKey
		    and    ett.Entity = 'tLead'
		    and    ett.EntityKey = @LeadKey
			and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskExpense.CampaignSegmentKey = @CampaignSegmentKey)  	
		    and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskExpense.TaskKey = @TaskKey)	

		    update tEstimateTask
			set    tEstimateTask.Markup = isnull(ett.Markup, 0)
			from   tEstimateTaskTemp ett (nolock) 
			where  tEstimateTask.EstimateKey = @EstimateKey
			and    tEstimateTask.TaskKey = ett.TaskKey
		    and    ett.Entity = 'tLead'
		    and    ett.EntityKey = @LeadKey
		end    
	end

end -- Apply Markup

-- now recalc
if @ApplyMarkup = 1
begin	 
	update tEstimateTaskExpense
	set    tEstimateTaskExpense.BillableCost = ROUND(tEstimateTaskExpense.TotalCost * ( 1 + tEstimateTaskExpense.Markup / 100), 2)
	where  EstimateKey = @EstimateKey
	and    Billable = 1
	and    (isnull(@CampaignSegmentKey, 0) = 0 or tEstimateTaskExpense.CampaignSegmentKey = @CampaignSegmentKey)  
	and    (isnull(@TaskKey, 0) = 0 or tEstimateTaskExpense.TaskKey = @TaskKey)	
	

	update tEstimateTask
	set    tEstimateTask.EstExpenses = ROUND(tEstimateTask.BudgetExpenses * ( 1 + tEstimateTask.Markup / 100), 2)
	where  EstimateKey = @EstimateKey
	and    isnull(tEstimateTask.BudgetExpenses, 0) <> 0 -- see issue 265216

end

if @ApplyRate = 1
begin
	update tEstimateTask
	set    tEstimateTask.EstLabor = ROUND(tEstimateTask.Hours * tEstimateTask.Rate, 2)
	where  EstimateKey = @EstimateKey
end
	 
Declare @ApprovedQty int, @SalesTax1Amount MONEY, @SalesTax2Amount MONEY

if @RecalcTotals = 1
begin

Select @ApprovedQty = ApprovedQty from tEstimate (nolock) where EstimateKey = @EstimateKey
Exec sptEstimateRecalcSalesTax @EstimateKey, @ApprovedQty, @SalesTax1Amount OUTPUT, @SalesTax2Amount OUTPUT
Update tEstimate set SalesTaxAmount = @SalesTax1Amount, SalesTax2Amount = @SalesTax2Amount where EstimateKey = @EstimateKey
Exec sptEstimateTaskRollupDetail @EstimateKey

end
 
	RETURN 1

GO


