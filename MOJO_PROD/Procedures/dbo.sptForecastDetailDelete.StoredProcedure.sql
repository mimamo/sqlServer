USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastDetailDelete]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastDetailDelete]
	(
	@ForecastDetailKey int
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/24/12  GHL 10.561  Created for revenue forecast
*/

	SET NOCOUNT ON

	delete tForecastDetailItem
	where  ForecastDetailKey = @ForecastDetailKey
	
	delete tForecastDetail
	where  ForecastDetailKey = @ForecastDetailKey

	RETURN 1
GO
