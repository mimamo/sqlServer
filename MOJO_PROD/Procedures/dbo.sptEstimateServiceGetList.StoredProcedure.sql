USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateServiceGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateServiceGetList]
	(
	@ProjectKey INT
	,@EstimateKey INT
	)
AS --Encrypt

/*
|| When     Who Rel     What
|| 11/18/08 GHL 10.013 (40702) Ordering now by service code vs description
|| 01/07/09 GHL 10.015 (43208) Take in account the settings on the client
*/	

	SET NOCOUNT ON
	
	DECLARE @CompanyKey INT
			,@ClientKey INT
			,@GetRateFrom INT
			,@TimeRateSheetKey INT
			,@ProjectTypeKey INT
			,@ServiceCount INT
			,@HourlyRate MONEY
			,@ProjectHourlyRate MONEY
		
	SELECT @CompanyKey = CompanyKey
		  ,@ClientKey = ClientKey	
		  ,@ProjectKey = ProjectKey
		  ,@GetRateFrom = ISNULL(GetRateFrom, 2)
		  ,@TimeRateSheetKey = ISNULL(TimeRateSheetKey, 0)
		  ,@ProjectTypeKey = ISNULL(ProjectTypeKey, 0)
		  ,@ProjectHourlyRate = HourlyRate		  
	FROM   tProject (NOLOCK) 
	WHERE  ProjectKey = @ProjectKey

	-- Get Rate from RS = 5
	IF @GetRateFrom <> 5
		SELECT @TimeRateSheetKey = 0
		
	IF @GetRateFrom = 1
		SELECT @HourlyRate = HourlyRate FROM tCompany (NOLOCK) WHERE CompanyKey = @ClientKey
	ELSE IF @GetRateFrom = 2
		SELECT @HourlyRate = @ProjectHourlyRate
		
	SELECT @ServiceCount = COUNT(pts.ServiceKey) 
	FROM   tProjectTypeService pts (nolock) 
	INNER  JOIN tService s (NOLOCK) ON pts.ServiceKey = s.ServiceKey
	WHERE  pts.ProjectTypeKey = @ProjectTypeKey
	AND    s.Active = 1

	IF ISNULL(@EstimateKey, 0) = 0
		-- No Estimate yet, get selected list from Project Type
		-- This is a display list only
		Select Distinct
			s.ServiceCode
			,s.Description
			,ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
			,CASE
				WHEN @ServiceCount = 0		THEN 1		-- If no records on the project type, select them all
				WHEN pts.ServiceKey IS NULL THEN 0
				ELSE						1
			 END AS IsSelected
			,CASE WHEN @HourlyRate IS NOT NULL THEN
				@HourlyRate 
			 ELSE
				CASE 
				WHEN @TimeRateSheetKey > 0 THEN 
					ISNULL(trsd.HourlyRate1, 0)
				ELSE 
					ISNULL(s.HourlyRate1, 0)
				END 
			END AS Rate
			,s.*   		
		From
			tService s (nolock) 
			Left Outer Join tTimeRateSheetDetail trsd (nolock) on trsd.ServiceKey = s.ServiceKey 
											and trsd.TimeRateSheetKey = @TimeRateSheetKey
			Left Outer Join tProjectTypeService pts (nolock) on pts.ServiceKey = s.ServiceKey 
											and pts.ProjectTypeKey = @ProjectTypeKey
		Where
			s.CompanyKey = @CompanyKey
		And
			s.Active = 1
		Order By s.ServiceCode

	ELSE
		-- There is an estimate, get selected list from tEstimateService
		Select Distinct
			s.ServiceCode
			,s.Description
			,ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
			,CASE
				WHEN es.ServiceKey IS NULL THEN 0
				ELSE 1
			END AS IsSelected
			, CASE 
				WHEN es.Rate IS NOT NULL THEN 
					es.Rate
				ELSE
					CASE WHEN @HourlyRate IS NOT NULL THEN
						@HourlyRate
					ELSE
						CASE WHEN @TimeRateSheetKey > 0 THEN 
							ISNULL(trsd.HourlyRate1, 0)
						ELSE 
							ISNULL(s.HourlyRate1, 0)
						END
					END
				END AS Rate 
		    ,s.*  		
		From
			tService s (nolock) 
			Left Outer Join tTimeRateSheetDetail trsd (nolock) on trsd.ServiceKey = s.ServiceKey 
											and trsd.TimeRateSheetKey = @TimeRateSheetKey
			Left Outer Join tEstimateService es (nolock) on es.ServiceKey = s.ServiceKey
											and es.EstimateKey = @EstimateKey
			Where
				s.CompanyKey = @CompanyKey
			And
				s.Active = 1
			Order By s.ServiceCode

	
	RETURN 1
GO
