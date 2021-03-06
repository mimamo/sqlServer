USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetRates]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetRates]
	(
		 @CompanyKey Int
		,@ProjectKey Int
		,@CampaignKey Int
		,@LeadKey Int
	)
AS -- Encrypt

  /*
  || When     Who Rel    What
  || 12/15/09 GHL 10.515 Creation for new estimates (similar to sptEstimateRecalcRates) 
  || 02/16/10 GHL 10.518 Estimates may not have Project...so get the company from the estimate
  || 03/09/10 GHL 10.519 Added @CompanyKey to handle Template Estimates (PK = CK= LK = 0)
  || 11/06/12 KMC 10.562 Updated to pull the rates from the HourlyRate on the Project when the GetRateFrom is 2 (Project)
  || 03/31/14 GHL 10.578 (190761) Added hourly cost from service 
  */
  
	SET NOCOUNT ON

	declare @kGetRateFromClient int             select @kGetRateFromClient = 1
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2
	declare @kGetRateFromProjectUser int        select @kGetRateFromProjectUser = 3
	declare @kGetRateFromService int            select @kGetRateFromService = 4
	declare @kGetRateFromServiceRateSheet int   select @kGetRateFromServiceRateSheet = 5
	declare @kGetRateFromTask int               select @kGetRateFromTask = 6

	DECLARE @GetRateFrom INT
           ,@TimeRateSheetKey INT
		   ,@ProjectHourlyRate MONEY

	IF ISNULL(@ProjectKey, 0) > 0		
	BEGIN
		SELECT @GetRateFrom = ISNULL(GetRateFrom, @kGetRateFromClient)
			   ,@TimeRateSheetKey = ISNULL(TimeRateSheetKey, 0)
			   ,@ProjectHourlyRate = ISNULL(HourlyRate, 0)		   
		FROM   tProject (NOLOCK)  
		WHERE  ProjectKey = @ProjectKey
	
		IF @TimeRateSheetKey = 0 AND @GetRateFrom <> @kGetRateFromProject
			SELECT @GetRateFrom = @kGetRateFromService	
	END
	ELSE IF ISNULL(@CampaignKey, 0) > 0
	BEGIN
		-- Campaign or Lead, no time rate sheet, get rate from service
		SELECT @GetRateFrom = @kGetRateFromService	
	END
	ELSE IF ISNULL(@LeadKey, 0) > 0
	BEGIN
		-- Campaign or Lead, no time rate sheet, get rate from service
		SELECT @GetRateFrom = @kGetRateFromService	
	END
	
	IF @GetRateFrom = @kGetRateFromServiceRateSheet
	BEGIN
		SELECT s.ServiceKey
		      ,ISNULL(trsd.HourlyRate1, s.HourlyRate1) AS Rate
			  ,s.HourlyCost as Cost
		FROM   tTimeRateSheetDetail trsd (NOLOCK)
			  INNER JOIN tService s (NOLOCK) ON trsd.ServiceKey = s.ServiceKey		
		WHERE  trsd.TimeRateSheetKey = @TimeRateSheetKey
	END
	ELSE IF @GetRateFrom = @kGetRateFromProject
	BEGIN
		SELECT ServiceKey, @ProjectHourlyRate AS Rate, HourlyCost as Cost
		FROM   tService (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
	END
	ELSE
	BEGIN
		SELECT ServiceKey, HourlyRate1 AS Rate, HourlyCost as Cost
		FROM   tService (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
	END
		
	RETURN 1
GO
