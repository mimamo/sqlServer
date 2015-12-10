USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateTaskLaborLevelGetPopup]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateTaskLaborLevelGetPopup]
	(
	@ServiceKey int 
	,@CompanyKey INT 
	
	,@ProjectKey INT = 0
	,@CampaignKey INT = 0
	,@LeadKey INT = 0
	,@EstimateKey int = 0

	,@Hours1 decimal(24,4) = 0
	,@Rate1 money = 0
	,@Gross1 money = 0
	,@GetDefault1 int = 1
	,@Hours2 decimal(24,4) = 0
	,@Rate2 money = 0
	,@Gross2 money = 0
	,@GetDefault2 int = 1
    ,@Hours3 decimal(24,4) = 0
	,@Rate3 money = 0
	,@Gross3 money = 0
	,@GetDefault3 int = 1
    ,@Hours4 decimal(24,4) = 0
	,@Rate4 money = 0
	,@Gross4 money = 0
	,@GetDefault4 int = 1
	,@Hours5 decimal(24,4) = 0
	,@Rate5 money = 0
	,@Gross5 money = 0
	,@GetDefault5 int = 1
	)

AS --Encrypt

/*
|| When     Who Rel     What
|| 09/15/11 GHL 10.547  Creation for estimate rate levels
||                      This SP should be called when displaying the Edit Rate Level popup
||                      Should return 2 lists:
||                      1) List of rate levels for the service
||                      2) List of users with rate levels  
||                      Note: 5 tEstimateTaskLaborLevel records will be stored only if edited
||                      If some level records are missing, they should be reconstructed 
|| 11/09/11 GHL 10.459 (125839) Filter out inactive users 
|| 11/09/11 GHL 10.459 (125942) If description of rate level 1 is blank, show Level 1 instead of general description
|| 12/01/11 GHL 10.550 (125839) After reading the email from Myles Watling decided to pull the users from 3 possible ways
||                      1) tProjectUserService + tAssignment + tUser
||                      2) tUserServices + tAssignment + tUser
||                      3) tUserServices + tUser
*/	

	SET NOCOUNT ON


	-- These are the GetRateFrom values in tProject and tCompany
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1			-- HourlyRate in tCompany
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2			-- HourlyRate in tCompany/tProject
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6
	
	-- But as far as rate levels are concerned, we can only get them from 2 places
	-- 1) TimeRateSheetKey
	-- 2) Or Service 
	
	DECLARE @ClientKey INT
			,@GetRateFrom INT
			,@TimeRateSheetKey INT
	
	-- At least one of them should be > 0
	select @ProjectKey = isnull(@ProjectKey, 0)
	select @CampaignKey = isnull(@CampaignKey, 0)
	select @LeadKey = isnull(@LeadKey, 0)
		 
	if @ProjectKey > 0
	begin
		SELECT @GetRateFrom = ISNULL(GetRateFrom, @kGetRateFromProject)
			  ,@TimeRateSheetKey = ISNULL(TimeRateSheetKey, 0)  
		FROM   tProject (NOLOCK) 
		WHERE  ProjectKey = @ProjectKey
	end
	
	else if @CampaignKey > 0
	begin
		-- there is no billing info on the campaign, so read the client
		SELECT @GetRateFrom = c.GetRateFrom
			  ,@TimeRateSheetKey = ISNULL(c.TimeRateSheetKey, 0)
		FROM   tCampaign ca (NOLOCK)
			LEFT OUTER JOIN tCompany c (nolock) on ca.ClientKey = c.CompanyKey 
		WHERE  ca.CampaignKey = @CampaignKey 
	end
	
	else if @LeadKey > 0
	begin
		-- there is no billing info on the opp, so read the client
		Select @GetRateFrom = c.GetRateFrom
			  ,@TimeRateSheetKey = ISNULL(c.TimeRateSheetKey, 0)
		from tLead l (nolock) 
			LEFT OUTER JOIN tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey 
		where l.LeadKey = @LeadKey

	end
	
	select @TimeRateSheetKey = isnull(@TimeRateSheetKey, 0)

	-- if the rate is not by service rate sheet, reset the service rate
	IF @GetRateFrom <> @kGetRateFromServiceRateSheet
		SELECT @TimeRateSheetKey = 0

	if not exists (select 1 from tTimeRateSheetDetail (nolock)
					where TimeRateSheetKey = @TimeRateSheetKey
					and   ServiceKey = @ServiceKey
					)
					select  @TimeRateSheetKey = 0

	declare @ServiceCode varchar(100)
	declare @Description varchar(100)

	declare @Description1 varchar(100)
	declare @Description2 varchar(100)
	declare @Description3 varchar(100)
	declare @Description4 varchar(100)
	declare @Description5 varchar(100)
	declare @HourlyRate1 money 
	declare @HourlyRate2 money 
	declare @HourlyRate3 money 
	declare @HourlyRate4 money 
	declare @HourlyRate5 money 

	-- get defaults from the service
	select @ServiceCode = ServiceCode
		   ,@Description = Description
		   ,@Description1 = isnull(Description1, 'Level 1')
	       ,@Description2 = isnull(Description2, 'Level 2')
	       ,@Description3 = isnull(Description3, 'Level 3')
	       ,@Description4 = isnull(Description4, 'Level 4')
	       ,@Description5 = isnull(Description5, 'Level 5')
	       ,@HourlyRate1 = HourlyRate1
		   ,@HourlyRate2 = HourlyRate2
		   ,@HourlyRate3 = HourlyRate3
           ,@HourlyRate4 = HourlyRate4
           ,@HourlyRate5 = HourlyRate5
	from   tService (nolock)
	where  ServiceKey = @ServiceKey

	if ltrim(rtrim(isnull(@Description1, ''))) = '' 
		select @Description1 = 'Level 1' 
	if ltrim(rtrim(isnull(@Description2, ''))) = '' 
		select @Description2 = 'Level 2' 
	if ltrim(rtrim(isnull(@Description3, ''))) = '' 
		select @Description3 = 'Level 3' 
	if ltrim(rtrim(isnull(@Description4, ''))) = '' 
		select @Description4 = 'Level 4' 
	if ltrim(rtrim(isnull(@Description5, ''))) = '' 
		select @Description5 = 'Level 5' 

--select @Description1 = 'This is a very long description a very long description a very long description a very long description'
	select @HourlyRate1 = isnull(@HourlyRate1, 0)
	select @HourlyRate2 = isnull(@HourlyRate2, 0)
	select @HourlyRate3 = isnull(@HourlyRate3, 0)
	select @HourlyRate4 = isnull(@HourlyRate4, 0)
	select @HourlyRate5 = isnull(@HourlyRate5, 0)

	-- get defaults from the ratesheet
	if @TimeRateSheetKey > 0
	select @HourlyRate1 = HourlyRate1
		   ,@HourlyRate2 = HourlyRate2
		   ,@HourlyRate3 = HourlyRate3
           ,@HourlyRate4 = HourlyRate4
           ,@HourlyRate5 = HourlyRate5
	from   tTimeRateSheetDetail (nolock)
	where  ServiceKey = @ServiceKey
	and    TimeRateSheetKey = @TimeRateSheetKey

	create table #level (
		-- for titles
		ServiceKey int, ServiceCode varchar(100) null, Description varchar(100) null, FullDescription varchar(100) null
		
		,Description1 varchar(100) null, Hours1 decimal(24,4) null, Rate1 money null, Gross1 money null
		,Description2 varchar(100) null, Hours2 decimal(24,4) null, Rate2 money null, Gross2 money null
		,Description3 varchar(100) null, Hours3 decimal(24,4) null, Rate3 money null, Gross3 money null
		,Description4 varchar(100) null, Hours4 decimal(24,4) null, Rate4 money null, Gross4 money null
		,Description5 varchar(100) null, Hours5 decimal(24,4) null, Rate5 money null, Gross5 money null

		,HoursTotal decimal(24,4) null, RateTotal money null, GrossTotal money null

		-- save std rates if user wants to reset
		,HourlyRate1 money null, HourlyRate2 money null, HourlyRate3 money null, HourlyRate4 money null, HourlyRate5 money null
	)
	create table #user (UserKey int null, RateLevel int null, UserName varchar(250) null)

	insert #level (
		ServiceKey, ServiceCode, Description, FullDescription
		
		,Description1, Hours1, Rate1, Gross1
		,Description2, Hours2, Rate2, Gross2
		,Description3, Hours3, Rate3, Gross3
		,Description4, Hours4, Rate4, Gross4
		,Description5, Hours5, Rate5, Gross5

		,HourlyRate1, HourlyRate2, HourlyRate3, HourlyRate4, HourlyRate5
	)
	values (
		@ServiceKey, @ServiceCode, @Description, isnull(@ServiceCode + ' - ', '') + isnull(@Description, '')
		
		,@Description1, 0, @HourlyRate1, 0
		,@Description2, 0, @HourlyRate2, 0
		,@Description3, 0, @HourlyRate3, 0
		,@Description4, 0, @HourlyRate4, 0
		,@Description5, 0, @HourlyRate5, 0
		
		,@HourlyRate1, @HourlyRate2, @HourlyRate3, @HourlyRate4, @HourlyRate5
		)

	if @GetDefault1 = 0
		update #level set Hours1 =@Hours1, Rate1 = @Rate1, Gross1 = @Gross1 

	if @GetDefault2 = 0
		update #level set Hours2 =@Hours2, Rate2 = @Rate2, Gross2 = @Gross2  

	if @GetDefault3 = 0
		update #level set Hours3 =@Hours3, Rate3 = @Rate3, Gross3 = @Gross3  

	if @GetDefault4 = 0
		update #level set Hours4 =@Hours4, Rate4 = @Rate4 , Gross4 = @Gross4

	if @GetDefault5 = 0
		update #level set Hours5 =@Hours5, Rate5 = @Rate5 , Gross5 = @Gross5
	
	update #level set HoursTotal = isnull(Hours1, 0) + isnull(Hours2, 0) + isnull(Hours3, 0) + isnull(Hours4, 0) + isnull(Hours5, 0)
	update #level set GrossTotal = isnull(Gross1, 0) + isnull(Gross2, 0) + isnull(Gross3, 0) + isnull(Gross4, 0) + isnull(Gross5, 0)

	-- temp calc
	update #level set RateTotal = isnull(Rate1, 0) + isnull(Rate2, 0) + isnull(Rate3, 0) + isnull(Rate4, 0) + isnull(Rate5, 0)
	
	update #level set RateTotal = ROUND(GrossTotal / HoursTotal, 2) where HoursTotal <> 0
	update #level set RateTotal = ROUND(RateTotal/5, 2) where HoursTotal = 0


	declare @UserInfoOnly int
	select @UserInfoOnly = 1

	if @ProjectKey > 0 
	begin
		if exists (select 1 
					from   tProjectUserServices pus (nolock)
						inner join tUser u (nolock) on pus.UserKey = u.UserKey
						inner join tAssignment asgn (nolock) on pus.ProjectKey = asgn.ProjectKey 
										and pus.UserKey = asgn.UserKey   
					where  pus.ProjectKey = @ProjectKey
					--and    pus.ServiceKey = @ServiceKey --- just checking here that there are some services
					and    u.Active = 1
					)
			select @UserInfoOnly = 0

		if @UserInfoOnly = 1
		
			-- join with tAssignment to only pull the users on the team (125839) 
			-- but get the services from tUserService

			insert #user (UserKey, RateLevel, UserName)
			select distinct u.UserKey, u.RateLevel, isnull(u.FirstName + ' ', '') + isnull(u.LastName, '')
			from   tAssignment asgn (nolock)
				inner join tUser u (nolock) on asgn.UserKey = u.UserKey
				inner join tUserService us (nolock) on u.UserKey = us.UserKey
			where  asgn.ProjectKey = @ProjectKey
			and    us.ServiceKey = @ServiceKey
			and    u.Active = 1
		else
			-- get the services from tProjectUserServices

			insert #user (UserKey, RateLevel, UserName)
			select distinct u.UserKey, u.RateLevel, isnull(u.FirstName + ' ', '') + isnull(u.LastName, '')
			from   tProjectUserServices pus (nolock)
				inner join tUser u (nolock) on pus.UserKey = u.UserKey
				inner join tAssignment asgn (nolock) on pus.ProjectKey = asgn.ProjectKey 
								and pus.UserKey = asgn.UserKey   
			where  pus.ProjectKey = @ProjectKey
			and    pus.ServiceKey = @ServiceKey
			and    u.Active = 1

	end

	if  @ProjectKey = 0
	begin	
		-- that would be the case for estimates for campaigns and opportunities 
		insert #user (UserKey, RateLevel, UserName)
		select distinct u.UserKey, u.RateLevel, isnull(u.FirstName + ' ', '') + isnull(u.LastName, '')
		from   tUserService us (nolock)
			inner join tUser u (nolock) on us.UserKey = u.UserKey
		where  u.CompanyKey = @CompanyKey
		and    us.ServiceKey = @ServiceKey
		and    u.Active = 1
	end
		
	select * from #level

	select * from #user order by UserName

	RETURN 1
GO
