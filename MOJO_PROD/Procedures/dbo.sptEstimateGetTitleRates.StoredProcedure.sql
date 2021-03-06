USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEstimateGetTitleRates]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEstimateGetTitleRates]
	(
		 @CompanyKey Int
		,@EstimateKey Int
		,@ProjectKey Int
		,@CampaignKey Int
	)
AS -- Encrypt

  /*
  || When     Who Rel    What
  || 03/04/15 GHL 10.590 Cloned sptEstimateGetRates for titles for Abelson Taylor   
  ||                     At this time campaigns only are supported, Projects could be also added
  ||                     but they have a separate way to use titles 
  || 04/01/14 GHL 10.591 Added support for projects 
  */
  
	SET NOCOUNT ON

	-- These are the possible ways to get the rates from 
	declare @kGetRateFromClient int             select @kGetRateFromClient = 1
	declare @kGetRateFromProject int            select @kGetRateFromProject = 2
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
	

	DECLARE @GetRateFrom INT
           ,@TitleRateSheetKey INT
		   ,@HourlyRate MONEY
		   ,@ClientHourlyRate MONEY

	if isnull(@EstimateKey, 0) > 0
		select @ProjectKey = ProjectKey, @CampaignKey = CampaignKey from tEstimate (nolock) where EstimateKey = @EstimateKey
		
	IF ISNULL(@CampaignKey, 0) > 0		
	BEGIN
		-- there is no billing info on the campaign, so read the client
		
		SELECT @GetRateFrom = c.GetRateFrom
			  ,@TitleRateSheetKey = ISNULL(c.TitleRateSheetKey, 0)
			  ,@ClientHourlyRate = c.HourlyRate 
		FROM   tCampaign ca (NOLOCK)
			LEFT OUTER JOIN tCompany c (nolock) on ca.ClientKey = c.CompanyKey 
		WHERE  ca.CampaignKey = @CampaignKey 
		
		IF @GetRateFrom = @kGetRateFromClient
			SELECT @HourlyRate = @ClientHourlyRate
	END
	
	IF ISNULL(@ProjectKey, 0) > 0		
	BEGIN
		-- there is no billing info on the campaign, so read the client
		
		SELECT @GetRateFrom = p.GetRateFrom
			  ,@TitleRateSheetKey = ISNULL(p.TitleRateSheetKey, 0)
			  ,@ClientHourlyRate = c.HourlyRate 
		FROM   tProject p (NOLOCK)
			LEFT OUTER JOIN tCompany c (nolock) on p.ClientKey = c.CompanyKey 
		WHERE  p.ProjectKey = @ProjectKey 
		
		IF @GetRateFrom = @kGetRateFromClient
			SELECT @HourlyRate = @ClientHourlyRate
	END

	if isnull(@GetRateFrom, 0) not in (@kGetRateFromClient, @kGetRateFromTitle, @kGetRateFromTitleRateSheet)
		select @GetRateFrom = @kGetRateFromTitle

	if isnull(@TitleRateSheetKey, 0) = 0 and @GetRateFrom = @kGetRateFromTitleRateSheet
		select @GetRateFrom = @kGetRateFromTitle

	IF @GetRateFrom = @kGetRateFromTitleRateSheet
	BEGIN
		SELECT t.TitleKey
		      ,t.TitleID
			  ,t.TitleName
		      ,ISNULL(trsd.HourlyRate, t.HourlyRate) AS Rate
			  ,t.HourlyCost as Cost
		FROM  tTitle t (nolock) 
			LEFT OUTER JOIN tTitleRateSheetDetail trsd (NOLOCK) ON trsd.TitleKey = t.TitleKey AND trsd.TitleRateSheetKey = @TitleRateSheetKey 
		WHERE  t.CompanyKey = @CompanyKey
		AND   (t.Active = 1 Or
			   -- we need to check this because the title could have been marked inactive after creating the estimate
			   -- keep it if is already on 
			   t.TitleKey in (select TitleKey from tEstimateTitle (nolock) where EstimateKey = @EstimateKey)
			   )
	END
	ELSE IF @GetRateFrom = @kGetRateFromClient
	BEGIN
		SELECT TitleKey
		,TitleID
		,TitleName
		, @ClientHourlyRate AS Rate
		, HourlyCost as Cost
		FROM   tTitle t (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		AND   (t.Active = 1 Or
			   -- we need to check this because the title could have been marked inactive after creating the estimate
			   -- keep it if is already on 
			   t.TitleKey in (select TitleKey from tEstimateTitle (nolock) where EstimateKey = @EstimateKey)
			   )
	END
	ELSE
	BEGIN
		SELECT TitleKey
		,TitleID
		,TitleName
		, HourlyRate AS Rate, HourlyCost as Cost
		FROM   tTitle t (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		AND   (t.Active = 1 Or
			   -- we need to check this because the title could have been marked inactive after creating the estimate
			   -- keep it if is already on 
			   t.TitleKey in (select TitleKey from tEstimateTitle (nolock) where EstimateKey = @EstimateKey)
			   )
	END
		
	RETURN 1
GO
