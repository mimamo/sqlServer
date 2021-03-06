USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastDelete]
	(
	@ForecastKey int
	)
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/23/12  GHL 10.5.6.1 Created for revenue forecasting
*/
	SET NOCOUNT ON

	delete tForecastDetailItem
	from   tForecastDetail fd (nolock)
	where  tForecastDetailItem.ForecastDetailKey = fd.ForecastDetailKey
	and    fd.ForecastKey = @ForecastKey

	delete tForecastDetail
	where  ForecastKey = @ForecastKey

	delete tForecast
	where  ForecastKey = @ForecastKey

	RETURN 1
GO
