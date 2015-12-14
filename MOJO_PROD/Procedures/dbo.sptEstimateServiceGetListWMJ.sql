USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceGetListWMJ]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceGetListWMJ]
	(
	@CompanyKey INT 
	,@ProjectKey INT = 0
	,@CampaignKey INT = 0
	,@LeadKey INT = 0
	,@InitialList INT = 1
	,@EstimateKey int = null
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/18/08 GHL 10.013 (40702) Ordering now by service code vs description
|| 01/07/09 GHL 10.015 (43208) Take in account the settings on the client
|| 02/16/10 GHL 10.518  Made changes due to the fact that estimate may not have projects now
||                      Also screens in WMJ and CMP are different which require tweaking
|| 04/12/10 GHL 10.521  Getting now ProjectTypeKey from tLead
|| 05/10/11 RLB 10.544  (110900) removed active check the Ds will now filter active = 1 or selected 1
|| 06/22/11 RLB 10.545  (114730) added back the active check and added a section for just IntialList = 1 so i can filter out inactives when an
||						estimate is created but i pull all services for the services drop down and then just filter them for selected. This way
||						if a service is made inactive it will still appear on the service drop so it can be removed.
|| 06/22/11 GHL 10.545  Added EstimateKey to fix 110900 and 114730
|| 06/01/12 GHL 10.556  (144282) Added Cost to edit on UI now
|| 07/26/12 GHL 10.558  Added support for restricted services (hmi)
*/	

	SET NOCOUNT ON
	
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
	
	-- so we need to set the 2 first fields with caution
	
	DECLARE @ClientKey INT
			,@GetRateFrom INT
			,@TimeRateSheetKey INT
			,@ProjectTypeKey INT
			,@ServiceCount INT
			,@HourlyRate MONEY
			,@EntityHourlyRate MONEY
	        ,@RestrictToGLCompany int
			,@GLCompanyKey int

	select @RestrictToGLCompany = isnull(RestrictToGLCompany, 0) from tPreference (nolock) where CompanyKey = @CompanyKey 

	-- At least one of them should be > 0
	select @ProjectKey = isnull(@ProjectKey, 0)
	select @CampaignKey = isnull(@CampaignKey, 0)
	select @LeadKey = isnull(@LeadKey, 0)
		 
	if @ProjectKey > 0
	begin
		SELECT @ClientKey = ClientKey	
			  ,@GetRateFrom = ISNULL(GetRateFrom, @kGetRateFromProject)
			  ,@TimeRateSheetKey = ISNULL(TimeRateSheetKey, 0)
			  ,@ProjectTypeKey = ISNULL(ProjectTypeKey, 0)
			  ,@EntityHourlyRate = HourlyRate
			  ,@GLCompanyKey = GLCompanyKey		  
		FROM   tProject (NOLOCK) 
		WHERE  ProjectKey = @ProjectKey
	
		IF @GetRateFrom = @kGetRateFromClient
			SELECT @HourlyRate = HourlyRate FROM tCompany (NOLOCK) WHERE CompanyKey = @ClientKey
		ELSE IF @GetRateFrom = @kGetRateFromProject
			SELECT @HourlyRate = @EntityHourlyRate
		
	end
	
	else if @CampaignKey > 0
	begin
		-- there is no billing info on the campaign, so read the client
		
		SELECT @ClientKey = ca.ClientKey	
			  ,@GetRateFrom = c.GetRateFrom
			  ,@TimeRateSheetKey = ISNULL(c.TimeRateSheetKey, 0)
			  ,@EntityHourlyRate = c.HourlyRate -- save in EntityHourlyRate for now
			  ,@ProjectTypeKey = 0
			  ,@GLCompanyKey = ca.GLCompanyKey		  
		FROM   tCampaign ca (NOLOCK)
			LEFT OUTER JOIN tCompany c (nolock) on ca.ClientKey = c.CompanyKey 
		WHERE  ca.CampaignKey = @CampaignKey 
		
		IF @GetRateFrom = @kGetRateFromClient
			SELECT @HourlyRate = @EntityHourlyRate
	
		IF @GetRateFrom = @kGetRateFromProject 
			SELECT @HourlyRate = @EntityHourlyRate
								
	end
	
	else if @LeadKey > 0
	begin
		-- there is no billing info on the opp, so read the client
		
		Select @ClientKey = l.ContactCompanyKey
			  ,@GetRateFrom = c.GetRateFrom
			  ,@TimeRateSheetKey = ISNULL(c.TimeRateSheetKey, 0)
			  ,@EntityHourlyRate = c.HourlyRate -- save in EntityHourlyRate for now
			  ,@ProjectTypeKey = ISNULL(l.ProjectTypeKey, 0)
			  ,@GLCompanyKey = l.GLCompanyKey		  
		from tLead l (nolock) 
			LEFT OUTER JOIN tCompany c (nolock) on l.ContactCompanyKey = c.CompanyKey 
		where l.LeadKey = @LeadKey

		IF @GetRateFrom = @kGetRateFromClient
			SELECT @HourlyRate = @EntityHourlyRate
	
		IF @GetRateFrom = @kGetRateFromProject 
			SELECT @HourlyRate = @EntityHourlyRate
	
	end
	
	IF @GetRateFrom <> @kGetRateFromServiceRateSheet
		SELECT @TimeRateSheetKey = 0
				

	if isnull(@GLCompanyKey, 0) = 0
		select @RestrictToGLCompany = 0

	if @RestrictToGLCompany = 1 and not exists (select 1 from tGLCompanyAccess (nolock) 
		where Entity = 'tService' and GLCompanyKey = @GLCompanyKey)
		select @RestrictToGLCompany = 0

	IF @ProjectTypeKey > 0	
		SELECT @ServiceCount = COUNT(pts.ServiceKey) 
		FROM   tProjectTypeService pts (nolock) 
		INNER  JOIN tService s (NOLOCK) ON pts.ServiceKey = s.ServiceKey
		WHERE  pts.ProjectTypeKey = @ProjectTypeKey
		AND    s.Active = 1
		AND (
			@RestrictToGLCompany = 0
			Or
			s.ServiceKey in (select EntityKey from tGLCompanyAccess (nolock) 
							 where  Entity = 'tService' and GLCompanyKey = @GLCompanyKey )
			)
	ELSE
		SELECT @ServiceCount = 0

	
	IF @InitialList = 1 And @ServiceCount > 0 
		-- Initial List
		-- There are services on project status, restrict to them (Inner Join)
		Select Distinct
			ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
			,CASE WHEN @HourlyRate IS NOT NULL THEN
						@HourlyRate
					ELSE
						CASE WHEN @TimeRateSheetKey > 0 THEN 
							ISNULL(trsd.HourlyRate1, 0)
						ELSE 
							ISNULL(s.HourlyRate1, 0)
						END
			END AS Rate
			,s.HourlyCost as Cost
			,s.*   		
		From
			tService s (nolock) 
			Left Outer Join tTimeRateSheetDetail trsd (nolock) on trsd.ServiceKey = s.ServiceKey 
											and trsd.TimeRateSheetKey = @TimeRateSheetKey
			Inner Join tProjectTypeService pts (nolock) on pts.ServiceKey = s.ServiceKey 
											and pts.ProjectTypeKey = @ProjectTypeKey
		Where
			s.CompanyKey = @CompanyKey
		AND s.Active = 1
		AND (
			@RestrictToGLCompany = 0
			Or
			s.ServiceKey in (select EntityKey from tGLCompanyAccess (nolock) 
							 where  Entity = 'tService' and GLCompanyKey = @GLCompanyKey )
			)

		Order By s.Description
		

	Else

		-- Initial List = 0 or no service on project status ==> take all services
		-- Or Later List on POPUP ==> take all services

		Select Distinct
			ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
			,CASE WHEN @HourlyRate IS NOT NULL THEN
						@HourlyRate
					ELSE
						CASE WHEN @TimeRateSheetKey > 0 THEN 
							ISNULL(trsd.HourlyRate1, 0)
						ELSE 
							ISNULL(s.HourlyRate1, 0)
						END
			END AS Rate
			,s.HourlyCost as Cost
			,s.*   		
		From
			tService s (nolock) 
			Left Outer Join tTimeRateSheetDetail trsd (nolock) on trsd.ServiceKey = s.ServiceKey 
											and trsd.TimeRateSheetKey = @TimeRateSheetKey
		Where
			s.CompanyKey = @CompanyKey
		and (
				(s.Active = 1
				AND (
					@RestrictToGLCompany = 0
					Or
					s.ServiceKey in (select EntityKey from tGLCompanyAccess (nolock) 
									 where  Entity = 'tService' and GLCompanyKey = @GLCompanyKey )
					)
				)
				Or 
				s.ServiceKey in (select ServiceKey from tEstimateService (nolock) where EstimateKey = @EstimateKey)
			)

		Order By s.Description

	
	RETURN 1
GO
