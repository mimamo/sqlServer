USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTitleGetSegmentList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTitleGetSegmentList]
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
|| 03/05/15 GHL 10.590  Created for Abelson/Taylor by cloning sptEstimateServiceGetSegmentList  
*/	
	
	if isnull(@EstimateKey, 0) > 0
	begin
		select 	etl.CampaignSegmentKey
			,etl.TitleKey 
			,t.TitleID
			,t.TitleName
			,etl.Hours 
			,etl.Rate
			,etl.Cost
			,ROUND(etl.Hours * etl.Rate, 2) as Gross
			,case when etl.Hours * ROUND(etl.Hours * etl.Rate, 2)  <> 0 then 1 else 0 end  as ShowService
		from tEstimateTaskLabor	etl (nolock)
			inner join tTitle t (nolock) on etl.TitleKey = t.TitleKey 
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
	declare @kGetRateFromTitle int              select @kGetRateFromTitle = 9
	declare @kGetRateFromTitleRateSheet int     select @kGetRateFromTitleRateSheet = 10

	-- But as far as titles are concerned, we can only get them from 3 places
	-- 1) HourlyRate (from Client or from Project)
	-- 2) Or TitleRateSheetKey
	-- 3) Or Title 
	
	declare @CampaignSegmentKey int
	declare @ProjectTypeKey int
	declare @HourlyRate money
	declare @GetRateFrom INT
    declare @TimeRateSheetKey INT
	declare @TitleRateSheetKey INT
				
	create table #title (
		CampaignSegmentKey int null
		,TitleKey int null
		,Rate money null
		)

	-- For campaigns and opps, we get the rate settings from the client
	
	SELECT @HourlyRate = HourlyRate
	       ,@GetRateFrom = GetRateFrom
		   ,@TitleRateSheetKey = ISNULL(TitleRateSheetKey, 0) 
	FROM tCompany (NOLOCK) WHERE CompanyKey = @ClientKey

	SELECT @HourlyRate = isnull(@HourlyRate, 0)

	-- start a blank sheet with a cartesian product
	if isnull(@CampaignKey, 0) > 0
	insert #title(
		CampaignSegmentKey
		,TitleKey 
		)
	select cs.CampaignSegmentKey
	      ,t.TitleKey
	from  tCampaignSegment cs (nolock)
         ,tTitle t (nolock)	
	where cs.CampaignKey = @CampaignKey
	and   isnull(cs.LeadKey, 0) = 0		
	and  t.CompanyKey = @CompanyKey
	and  t.Active = 1

	if isnull(@LeadKey, 0) > 0
	insert #title(
		CampaignSegmentKey
		,TitleKey 
		)
	select cs.CampaignSegmentKey
	      ,t.TitleKey
	from  tCampaignSegment cs (nolock)
         ,tTitle t (nolock)	
	where cs.LeadKey = @LeadKey
	and   isnull(cs.CampaignKey, 0) = 0		
	and  t.CompanyKey = @CompanyKey
	and  t.Active = 1
	
	if @GetRateFrom in (@kGetRateFromClient, @kGetRateFromProject)
		update #title
		set    Rate = @HourlyRate
	else if @GetRateFrom = @kGetRateFromTitleRateSheet and @TitleRateSheetKey > 0
		update #title
		set    #title.Rate = ISNULL(trsd.HourlyRate, 0)
		from   tTitleRateSheetDetail trsd (nolock) 
		where  trsd.TitleRateSheetKey = @TitleRateSheetKey
		and    trsd.TitleKey = #title.TitleKey 
	else
		update #title
		set    #title.Rate = ISNULL(t.HourlyRate, 0)
		from   tTitle t (nolock) 
		where  t.TitleKey = #title.TitleKey 
	
	
	select #title.CampaignSegmentKey
			,#title.TitleKey
			,t.TitleID
			,t.TitleName
			,0 as Hours
			,isnull(#title.Rate, 0) as Rate
			,0 as Gross
			,0 as ShowService
			,t.HourlyCost as Cost
	from   #title 
		inner join tTitle t (nolock) on #title.TitleKey = t.TitleKey
	order by t.TitleName
    	
	RETURN 1
GO
