USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastUpdateBalloonRetainer]    Script Date: 12/10/2015 10:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastUpdateBalloonRetainer]
	(
	@ForecastDetailKey int
	,@RetainerKey int
	,@UserKey int
	,@Probability smallint
	,@AccountManagerKey int
	,@Title varchar(200)
	,@StartDate smalldatetime
	,@LastBillingDate smalldatetime
	,@Frequency smallint
	,@NumberOfPeriods int
	,@AmountPerPeriod money
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/06/12  GHL 10.562   Created for revenue forecast app
*/

	SET NOCOUNT ON

	update tRetainer
	set    Title = @Title
	      ,StartDate = @StartDate
	      ,LastBillingDate = @LastBillingDate
	      ,Frequency = @Frequency
		  ,NumberOfPeriods = @NumberOfPeriods
		  ,AmountPerPeriod = @AmountPerPeriod
	where  RetainerKey = @RetainerKey

	-- now rebuild the tForecastDetailItem records and rollup to tForecastDetail
	-- no need to set Months or StartDate, it will be done when executing sptForecastDetailItemGenerate
	update tForecastDetail
	set    EntityName = @Title
	      ,AccountManagerKey = @AccountManagerKey
	      ,Probability = @Probability
		  ,ManualUpdateBy = @UserKey
		  ,ManualUpdateDate = getutcdate() 
	where  ForecastDetailKey = @ForecastDetailKey

	exec sptForecastDetailItemGenerate @ForecastDetailKey

	RETURN 1
GO
