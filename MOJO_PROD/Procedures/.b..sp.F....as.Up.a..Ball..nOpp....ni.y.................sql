USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastUpdateBalloonOpportunity]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastUpdateBalloonOpportunity]
	(
	@ForecastDetailKey int
	,@LeadKey int
	,@UserKey int
	,@AccountManagerKey int
	,@Subject varchar(200)
	,@FromEstimate int -- as it is on the UI, we will redetermine this fact
	,@StartDate smalldatetime
	,@Probability smallint
	,@Months int
	,@SaleAmount money 
	,@OutsideCostsGross money
	,@OutsideCostsPerc decimal(24,4)
	,@MediaGross money
	,@MediaPerc decimal(24,4)
	,@Labor money
	,@AGI money
	)
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/29/12  GHL 10.561   Created for revenue forecast app
|| 11/7/12   GHL 10.562   Added AccountManagerKey   
*/

	SET NOCOUNT ON

	declare @ActualCloseDate smalldatetime
	declare @EstCloseDate smalldatetime

	select @ActualCloseDate = ActualCloseDate
	      ,@EstCloseDate = EstCloseDate
	from tLead (nolock)
	where LeadKey = @LeadKey

	if @ActualCloseDate is null
		-- if the actual is null, just change the estimated
		select @EstCloseDate = @StartDate
	else
		select @ActualCloseDate = @StartDate

	if @FromEstimate = 0
		update tLead
		set    Subject = @Subject
		      ,Probability = @Probability
			  ,Months = @Months
			  ,ActualCloseDate = @ActualCloseDate
			  ,EstCloseDate = @EstCloseDate
			  ,SaleAmount = @SaleAmount
			  ,OutsideCostsGross = @OutsideCostsGross
			  ,OutsideCostsPerc = @OutsideCostsPerc
			  ,MediaGross = @MediaGross
			  ,MediaPerc = @MediaPerc
			  ,Labor = @Labor
			  ,AGI = @AGI
		where  LeadKey = @LeadKey
	else
		update tLead
		set    Subject = @Subject
		      ,Probability = @Probability
			  ,Months = @Months
		where  LeadKey = @LeadKey
			  
	-- now rebuild the tForecastDetailItem records and rollup to tForecastDetail
	update tForecastDetail
	set    EntityName = @Subject
	      ,AccountManagerKey = @AccountManagerKey
	      ,Probability = @Probability
	      ,Months = @Months
		  ,StartDate = @StartDate
		  ,FromEstimate = 0
		  ,ManualUpdateBy = @UserKey
		  ,ManualUpdateDate = getutcdate() 
	where  ForecastDetailKey = @ForecastDetailKey

	-- determine if we have estimates, they could have been deleted
	UPDATE	tForecastDetail
	SET		tForecastDetail.FromEstimate = 1 
	FROM    tEstimate e (nolock)
	WHERE	tForecastDetail.Entity = 'tLead' 
	AND     tForecastDetail.EntityKey = e.LeadKey
	AND     ISNULL(e.IncludeInForecast, 0) = 1
	AND     tForecastDetail.ForecastDetailKey = @ForecastDetailKey

	-- regenerate the tForecastDetailItem recs...needed because the SaleAmount/Labor/Media/Production may have changed
	-- also tForecastDetailItem.StartDate and EndDate have to be recalced
	exec sptForecastDetailItemGenerate @ForecastDetailKey


	RETURN 1
GO
