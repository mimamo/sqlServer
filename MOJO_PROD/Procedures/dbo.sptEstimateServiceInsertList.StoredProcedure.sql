USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceInsertList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceInsertList]
	(
	@EstimateKey INT
	)
AS -- Encrypt

  /*
  || When     Who Rel    What
  || 01/07/09 GHL 10.015 (43208) Take in account the settings on the client
  || 01/19/15 GHL 10.588 Added support for campaigns and opps
  */
  
	-- This stored proc only inserts the initial list of services for an estimate
	IF EXISTS (SELECT 1 FROM tEstimateService (NOLOCK) WHERE EstimateKey = @EstimateKey)
		RETURN 1
	 
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
	
	DECLARE @CompanyKey INT
			,@ClientKey INT
			,@GetRateFrom INT
			,@ProjectKey INT
			,@TimeRateSheetKey INT
			,@ProjectTypeKey INT
			,@ServiceCount INT
			,@HourlyRate MONEY
			,@CampaignKey INT
			,@LeadKey INT  
			,@EntityHourlyRate MONEY

	SELECT @CompanyKey = CompanyKey
		  ,@ProjectKey = ProjectKey
		  ,@CampaignKey = CampaignKey
		  ,@LeadKey = LeadKey
	FROM   tEstimate (NOLOCK)
	WHERE  EstimateKey = @EstimateKey

	if @ProjectKey > 0 
	begin
		SELECT @ClientKey = p.ClientKey
			  ,@ProjectKey = p.ProjectKey
			  ,@GetRateFrom = ISNULL(GetRateFrom, 2)
			  ,@TimeRateSheetKey = ISNULL(p.TimeRateSheetKey, 0)
			  ,@ProjectTypeKey = ISNULL(p.ProjectTypeKey, 0)
			  ,@EntityHourlyRate = p.HourlyRate
		FROM   tEstimate e (NOLOCK)
			   INNER JOIN tProject p (NOLOCK) ON e.ProjectKey = p.ProjectKey
		WHERE  e.EstimateKey = @EstimateKey

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

	SELECT @ServiceCount = COUNT(pts.ServiceKey) 
	FROM   tProjectTypeService pts (nolock) 
	INNER  JOIN tService s (NOLOCK) ON pts.ServiceKey = s.ServiceKey
	WHERE  pts.ProjectTypeKey = @ProjectTypeKey
	AND    s.Active = 1

	IF @ServiceCount > 0

		INSERT tEstimateService (EstimateKey, ServiceKey, Rate)
		SELECT @EstimateKey
			,pts.ServiceKey
			,CASE WHEN @HourlyRate IS NOT NULL THEN
				@HourlyRate 
			 ELSE
				CASE 
				WHEN @TimeRateSheetKey > 0 THEN 
					ISNULL(trsd.HourlyRate1, 0)
				ELSE 
					ISNULL(s.HourlyRate1, 0)
				END
			END
		FROM  tProjectTypeService pts (nolock) 
			INNER JOIN tService s (NOLOCK) ON pts.ServiceKey = s.ServiceKey
			Left Outer Join tTimeRateSheetDetail trsd (nolock) on trsd.ServiceKey = s.ServiceKey 
												and trsd.TimeRateSheetKey = @TimeRateSheetKey
		WHERE pts.ProjectTypeKey = @ProjectTypeKey
		AND   s.Active = 1

	ELSE

		INSERT tEstimateService (EstimateKey, ServiceKey, Rate)
		SELECT @EstimateKey
			,s.ServiceKey
			,CASE WHEN @HourlyRate IS NOT NULL THEN
				@HourlyRate 
			 ELSE
				CASE 
				WHEN @TimeRateSheetKey > 0 THEN 
					ISNULL(trsd.HourlyRate1, 0)
				ELSE 
					ISNULL(s.HourlyRate1, 0)
				END
			END
		FROM  tService s (NOLOCK) 
			Left Outer Join tTimeRateSheetDetail trsd (nolock) on trsd.ServiceKey = s.ServiceKey 
												and trsd.TimeRateSheetKey = @TimeRateSheetKey
		WHERE s.CompanyKey = @CompanyKey
		AND   s.Active = 1
	
		
	RETURN 1
GO
