USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastRecalcLoop]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastRecalcLoop]
	(
	@ForecastKey int
	)
	
AS --Encrypt
 
	SET NOCOUNT ON 

/*
|| When      Who Rel      What
|| 11/16/12  GHL 10.5.6.2 Created for revenue forecasting
|| 12/14/12  GHL 10.5.6.3 Remove all details where Total = 0 
||                        (could happend if SpreadExpense is changed and = Exclude)  
|| 12/11/14  GHL 10.5.8.7 (239178) When checking if a detail is 0 (to remove it)
||                        check gross + net = 0 instead of gross = 0 (because if NonBillable, gross = 0, net <0 )
*/

	declare @RecalcNeeded int
	if exists (select 1 from tForecastDetail (nolock) where ForecastKey = @ForecastKey and RecalcNeeded =1 )
		select @RecalcNeeded = 1
	else
		select @RecalcNeeded = 0

	if @RecalcNeeded = 0
	begin
		select * from tForecastDetail (nolock) where ForecastKey = @ForecastKey and 1=2
		return 0 
	end

	CREATE TABLE #Detail
		(
		Entity varchar(50) NULL,
		EntityKey int NULL,
		StartDate smalldatetime NULL,
		EndDate smalldatetime NULL,
		Months int NULL,
		Probability smallint NULL,
		Total money NULL,
		ClientKey int NULL,
		AccountManagerKey int NULL,
		GLCompanyKey int NULL,
		OfficeKey int NULL,
		EntityName varchar(250) NULL,
		FromEstimate tinyint NULL,
		EntityID varchar(250) NULL,

		ForecastDetailKey int NULL, -- we will capture this key after inserts
		UpdateFlag int null, -- general purpose flag
		UpdateDate smalldatetime NULL -- general purpose date
		)

	
	-- this is only what sptForecastCalcBucketsMultiple needs
	insert #Detail (ForecastDetailKey, Entity, EntityKey)
	select top 10 ForecastDetailKey, Entity, EntityKey
	from   tForecastDetail (nolock)
	where  ForecastKey = @ForecastKey
	and    RecalcNeeded = 1
	order by Entity -- Invoices at the top, faster to calc

	-- now calculate the buckets (1 indicates recalc the sequence numbers) 
	-- this sp should update RecalcNeeded on the records
	exec sptForecastCalcBucketsMultiple @ForecastKey, 1

	if exists (select 1 from tForecastDetail (nolock) where ForecastKey = @ForecastKey and RecalcNeeded =1 )
		select @RecalcNeeded = 1
	else
		select @RecalcNeeded = 0

	-- in the case when SpreadExpense = 3 (Exclude)
	-- the detail items could be all 0 or missing
	-- remove detail and detail items where everyting is o
	delete tForecastDetailItem
	from   #Detail dtl
	where  tForecastDetailItem.ForecastDetailKey = dtl.ForecastDetailKey
	and    isnull(tForecastDetailItem.Total, 0) = 0

	delete tForecastDetail
	from   #Detail dtl
	where  tForecastDetail.ForecastDetailKey = dtl.ForecastDetailKey
	and    isnull(tForecastDetail.Total, 0) = 0
	and    isnull(tForecastDetail.TotalN, 0) = 0 -- check total gross + total net = 0

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
	inner   join #Detail dtl on fd.ForecastDetailKey = dtl.ForecastDetailKey

	return @RecalcNeeded
GO
