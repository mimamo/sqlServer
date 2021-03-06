USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceGetSegmentList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceGetSegmentList]
	(
	@CompanyKey int
	,@ClientKey int
	,@EstimateKey int
	,@CampaignKey int
	,@LeadKey int
	)
AS --Encrypt
	SET NOCOUNT ON
	
	-- This sp should be called only if MultipleSegments = 1 on campaign or opportunity
	
/*
|| When     Who Rel     What
|| 04/06/10 GHL 10.521  Getting now rate from time rate sheet key or service or rate on client 
||                      depending on GetRateFrom setting on the client
|| 01/13/11 GHL 10.540  (99938) Added ShowService to show services with zero amounts on the grid
|| 06/04/12 GHL 10.556  (144282) Added Cost
*/	
	
	if isnull(@EstimateKey, 0) > 0
	begin
		select 	etl.CampaignSegmentKey
			,etl.ServiceKey 
			,s.Description
			,etl.Hours 
			,etl.Rate
			,etl.Cost
			,ROUND(etl.Hours * etl.Rate, 2) as Gross
			,case when etl.Hours * ROUND(etl.Hours * etl.Rate, 2)  <> 0 then 1 else 0 end  as ShowService
		from tEstimateTaskLabor	etl (nolock)
			inner join tService s (nolock) on etl.ServiceKey = s.ServiceKey 
		where etl.EstimateKey =	@EstimateKey
	
		return 1
	end

	-- Estimate does not exist yet
	
	-- These are the GetRateFrom values in tProject and tCompany
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1			-- HourlyRate in tCompany
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2			-- HourlyRate in tCompany/tProject
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
	
	-- But as far as services are concerned, we can only get them from 3 places
	-- 1) HourlyRate (from Client or from Project)
	-- 2) Or TimeRateSheetKey
	-- 3) Or Service 
	
	declare @CampaignSegmentKey int
	declare @ProjectTypeKey int
	declare @HourlyRate money
	declare @GetRateFrom INT
    declare @TimeRateSheetKey INT
				
	create table #service (
		CampaignSegmentKey int null
		,ProjectTypeKey int null
		,ServiceKey int null
		,Rate money null
		)

	-- For campaigns and opps, we get the rate settings from the client
	
	SELECT @HourlyRate = HourlyRate
	       ,@GetRateFrom = GetRateFrom
		   ,@TimeRateSheetKey = ISNULL(TimeRateSheetKey, 0) 
	FROM tCompany (NOLOCK) WHERE CompanyKey = @ClientKey

	SELECT @HourlyRate = isnull(@HourlyRate, 0)

	-- start a blank sheet with a cartesian product
	if isnull(@CampaignKey, 0) > 0
	insert #service(
		CampaignSegmentKey
		,ProjectTypeKey
		,ServiceKey 
		)
	select cs.CampaignSegmentKey
	      ,cs.ProjectTypeKey
	      ,s.ServiceKey
	from  tCampaignSegment cs (nolock)
         ,tService s (nolock)	
	where cs.CampaignKey = @CampaignKey
	and   isnull(cs.LeadKey, 0) = 0		
	and  s.CompanyKey = @CompanyKey
	and  s.Active = 1

	if isnull(@LeadKey, 0) > 0
	insert #service(
		CampaignSegmentKey
		,ProjectTypeKey
		,ServiceKey 
		)
	select cs.CampaignSegmentKey
	      ,cs.ProjectTypeKey
	      ,s.ServiceKey
	from  tCampaignSegment cs (nolock)
         ,tService s (nolock)	
	where cs.LeadKey = @LeadKey
	and   isnull(cs.CampaignKey, 0) = 0		
	and  s.CompanyKey = @CompanyKey
	and  s.Active = 1
	
	-- now double check if the services should be there based on the ProjectTypeKey
	select @CampaignSegmentKey = -1
	while (1=1)
	begin
		select @CampaignSegmentKey = min(CampaignSegmentKey)
		from   #service
		where  CampaignSegmentKey > @CampaignSegmentKey
		
		if @CampaignSegmentKey is null
			break
						
		select @ProjectTypeKey = isnull(ProjectTypeKey, 0)
		from  #service where CampaignSegmentKey = @CampaignSegmentKey 	
		
		if @ProjectTypeKey > 0
		begin
			if (select count(*) from tProjectTypeService (nolock) where ProjectTypeKey = @ProjectTypeKey) > 0
			begin
				delete #service 
				where  CampaignSegmentKey = @CampaignSegmentKey  
				and    ServiceKey not in (select ServiceKey from tProjectTypeService (nolock) 
					where ProjectTypeKey = @ProjectTypeKey)
			end 
		end
		
	end				
		
	
	if @GetRateFrom in (@kGetRateFromClient, @kGetRateFromProject)
		update #service
		set    Rate = @HourlyRate
	else if @GetRateFrom = @kGetRateFromServiceRateSheet and @TimeRateSheetKey > 0
		update #service
		set    #service.Rate = ISNULL(trsd.HourlyRate1, 0)
		from   tTimeRateSheetDetail trsd (nolock) 
		where  trsd.TimeRateSheetKey = @TimeRateSheetKey
		and    trsd.ServiceKey = #service.ServiceKey 
	else
		update #service
		set    #service.Rate = ISNULL(s.HourlyRate1, 0)
		from   tService s (nolock) 
		where  s.ServiceKey = #service.ServiceKey 
	
	select #service.CampaignSegmentKey
	      ,#service.ServiceKey
	      ,s.Description
	      ,0 as Hours
	      ,isnull(#service.Rate, 0) as Rate
	      ,0 as Gross
		  ,0 as ShowService
		  ,s.HourlyCost as Cost
	from   #service 
		inner join tService s (nolock) on #service.ServiceKey = s.ServiceKey
    order by s.Description
    	
	RETURN 1
GO
