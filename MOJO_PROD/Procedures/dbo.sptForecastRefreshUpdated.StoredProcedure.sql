USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastRefreshUpdated]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastRefreshUpdated]
	(
	@ForecastKey int
	)
	
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/23/12  GHL 10.561   Created to refresh entities with updated estimates
||                        Regenerates detail items when tForecastDetail.RegenerateNeeded = 1 
|| 11/19/12  GHL 10.562   Removed the loop from this stored proc and placed it in the UI instead
*/

	SET NOCOUNT ON

	declare @RegenerateNeeded int
	if exists (select 1 from tForecastDetail (nolock) where ForecastKey = @ForecastKey and RegenerateNeeded =1 )
		select @RegenerateNeeded = 1
	else
		select @RegenerateNeeded = 0

	if @RegenerateNeeded = 0
	begin
		select * from tForecastDetail (nolock) where ForecastKey = @ForecastKey and 1=2
		return 0 
	end

	
	declare @ForecastDetailKey int
	select @ForecastDetailKey = ForecastDetailKey from tForecastDetail (nolock) where ForecastKey = @ForecastKey and RegenerateNeeded =1

	-- this will delete the existing detail item records and recreate them
	exec sptForecastDetailItemGenerate @ForecastDetailKey

	if exists (select 1 from tForecastDetail (nolock) where ForecastKey = @ForecastKey and RegenerateNeeded =1 )
		select @RegenerateNeeded = 1
	else
		select @RegenerateNeeded = 0

	-- return the records for updates on the UI
	select  fd.*,

		cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money) as Month1P,
			cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money) as Month2P,
			cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money) as Month3P,
			cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money) as Month4P,
			cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money) as Month5P,
			cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money) as Month6P,
			cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money) as Month7P,
			cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money) as Month8P,
			cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money) as Month9P,
			cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money) as Month10P,
			cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money) as Month11P,
			cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money) as Month12P,
			cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money) as PriorP,
			cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money) as NextYearP,

			-- this includes Years after the Next 12 months, so we cannot display on the screen
			--cast(round((fd.Total * fd.Probability) / 100.0000, 2)  as money) as TotalP, 

			-- we want the sum(14 buckets)
			cast(round((fd.Month1 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month2 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month3 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month4 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month5 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month6 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month7 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month8 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month9 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month10 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month11 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Month12 * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.Prior * fd.Probability) / 100.0000, 2)  as money) +
			cast(round((fd.NextYear * fd.Probability) / 100.0000, 2)  as money) as TotalP

	from    tForecastDetail fd (nolock)
	where   fd.ForecastDetailKey = @ForecastDetailKey

	return @RegenerateNeeded
GO
