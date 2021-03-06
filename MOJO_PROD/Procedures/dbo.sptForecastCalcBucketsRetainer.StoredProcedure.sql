USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastCalcBucketsRetainer]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastCalcBucketsRetainer]
	(
	@ForecastDetailKey int
	,@Debug int = 0
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/05/12  GHL 10.5.6.2 Created for revenue forecasting 
||                        This sp should calculate the buckets for retainers
|| 04/07/14  GHL 10.5.7.8 Added cost info
|| 02/24/15  GHL 10.5.8.9 (245776) as per MW's request
||                         Start at the retainer's start date, not last billing date 
*/

	SET NOCOUNT ON 

	create table #tBuckets (
		StartDate smalldatetime null
		,EndDate smalldatetime null
		,Idx int null
		,UpdateFlag int null
		,Total money null
		)

    -- inputs from tForecast or tForecastDetail 
	declare @StartMonth int
	declare @StartYear int
	declare @Entity varchar(50)
	declare @EntityKey int
	declare @StartDate smalldatetime
	declare @EndDate smalldatetime
	declare @Months int

	select @StartMonth = f.StartMonth 
	      ,@StartYear = f.StartYear
		  
		  ,@Entity = fd.Entity
		  ,@EntityKey = fd.EntityKey
		  ,@StartDate = fd.StartDate 
		  ,@Months = fd.Months -- already calculated as NumberOfPeriods * Frequency, but could be 0 (no limit in time)
	from   tForecast f (nolock)
           inner join tForecastDetail fd (nolock) on f.ForecastKey = fd.ForecastKey
	where  fd.ForecastDetailKey = @ForecastDetailKey
	
	-- cannot find forecast
	if @@ROWCOUNT = 0
		return -1

	-- Current Year
	declare @ForecastStartDate smalldatetime
	declare @ForecastEndDate smalldatetime

	-- Prior Years
	declare @PriorEndDate smalldatetime
	
	-- Next 12 months
	declare @NextYearStartDate smalldatetime
	declare @NextYearEndDate smalldatetime
	
	-- Years after
	declare @YearAfterStartDate smalldatetime

	declare @PeriodCount int
	declare @LastPeriodCount int
	
	select @ForecastStartDate = cast (@StartMonth as varchar(2)) + '/01/' + cast (@StartYear as varchar(4))
	select @ForecastEndDate = dateadd(yy, 1, @ForecastStartDate)
	select @ForecastEndDate = dateadd(d, -1, @ForecastEndDate)

	select @PriorEndDate = dateadd(d, -1, @ForecastStartDate)

	select @NextYearStartDate = dateadd(d, 1, @ForecastEndDate)
	select @NextYearEndDate = dateadd(yy, 1, @NextYearStartDate)
	select @NextYearEndDate = dateadd(d, -1, @NextYearEndDate)

	select @YearAfterStartDate = dateadd(d, 1, @NextYearEndDate)

	-- vars for loop
	declare @BucketStartDate smalldatetime
	declare @BucketIdx int

	select @BucketStartDate = @ForecastStartDate
	select @BucketIdx = 1
	while (@BucketIdx <= 12)
	begin
		insert #tBuckets (StartDate,EndDate,Idx)
		values (@BucketStartDate, null, @BucketIdx)

		select @BucketStartDate = dateadd(m, 1,@BucketStartDate)
		select @BucketIdx = @BucketIdx + 1 
	end

	-- add 1 month and subtract 1 day to find the end of the month
	update #tBuckets 
	set    EndDate = dateadd(m, 1, StartDate)
	update #tBuckets 
	set    EndDate = dateadd(d, -1, EndDate)
	 
	-- insert the bucket for Prev Years
	insert #tBuckets (StartDate,EndDate,Idx)
	values ('01/01/1900', @PriorEndDate, 0)
	
	-- insert the bucket for the next 12 months
	insert #tBuckets (StartDate,EndDate,Idx)
	values (@NextYearStartDate, @NextYearEndDate, 13)

	-- insert the bucket for the Years after the next 12 months (we don't need this one)
	insert #tBuckets (StartDate,EndDate,Idx)
	values (@YearAfterStartDate, '01/01/2050', 14)

	declare @EffStartDate smalldatetime
	declare @LastBillingDate smalldatetime
	declare @Frequency int
	declare @NumberOfPeriods int 
	declare @AmountPerPeriod money
	declare @CostPerPeriod money

	select @LastBillingDate = LastBillingDate
	      ,@Frequency = Frequency
		  ,@NumberOfPeriods = NumberOfPeriods
		  ,@AmountPerPeriod = AmountPerPeriod
		  ,@CostPerPeriod = isnull(CostPerPeriod, 0)

		  -- I reload this in case they have been modified on the retainer
		  ,@StartDate = StartDate
		  ,@Months = CASE Frequency  -- NumberOfPeriods could be 0 (it means that the retainer is unlimited in time)
				WHEN 1 THEN NumberOfPeriods  --Monthly
				WHEN 2 THEN NumberOfPeriods * 3 --Quarterly
				WHEN 3 THEN NumberOfPeriods * 12 --Yearly
			END
	from  tRetainer (nolock)
	where RetainerKey = @EntityKey

	select @LastBillingDate = null -- (245776) do not use LastBillingDate 

	if @Months = 0
		select @EndDate = @NextYearEndDate -- we will not go beyond Next Year End, if the retainer has no time limits
	else
		select @EndDate = dateadd(m, @Months, @StartDate)

	
	declare @NextBillingDate smalldatetime
	declare @NumberOfMonthsPerPeriod int

	if @Frequency = 1
		select @NumberOfMonthsPerPeriod = 1
	if @Frequency = 2
		select @NumberOfMonthsPerPeriod = 3
	if @Frequency = 3
		select @NumberOfMonthsPerPeriod = 12
	 

	-- Process the buckets in the current year
	if @LastBillingDate is null
		select @NextBillingDate = @StartDate
	else
		select @NextBillingDate = dateadd(m, @NumberOfMonthsPerPeriod, @LastBillingDate)

	while (@NextBillingDate < @ForecastEndDate and @NextBillingDate < @EndDate)
	begin
		
		update #tBuckets
		set    UpdateFlag = 1
		where  StartDate <= @NextBillingDate
		and    EndDate >= @NextBillingDate
		and    Idx >0 and Idx < 13 

		select @NextBillingDate = dateadd(m, @NumberOfMonthsPerPeriod, @NextBillingDate)
	end

	update #tBuckets
	set    Total = @AmountPerPeriod
	where  UpdateFlag = 1


	-- Process the buckets in Prior Years
	if @LastBillingDate is null
		select @NextBillingDate = @StartDate
	else
		select @NextBillingDate = dateadd(m, @NumberOfMonthsPerPeriod, @LastBillingDate)

	select  @PeriodCount = 0

	while ( @NextBillingDate <= @PriorEndDate and @NextBillingDate < @EndDate) 
	begin
		select  @PeriodCount  = @PeriodCount + 1
		select @NextBillingDate = dateadd(m, @NumberOfMonthsPerPeriod, @NextBillingDate)		 
	end

	update #tBuckets
	set    Total = @PeriodCount * @AmountPerPeriod
	      ,UpdateFlag = @PeriodCount
	where  Idx = 0


	-- Process the buckets in Next Year
	if @LastBillingDate is null
		select @NextBillingDate = @StartDate
	else
		select @NextBillingDate = dateadd(m, @NumberOfMonthsPerPeriod, @LastBillingDate)

	select  @LastPeriodCount = 0

	while (@NextBillingDate <= @NextYearEndDate and @NextBillingDate <= @EndDate) 
	begin
		-- make sure we are in the range
		if @NextBillingDate >= @NextYearStartDate
			select  @LastPeriodCount  = @LastPeriodCount + 1

		select @NextBillingDate = dateadd(m, @NumberOfMonthsPerPeriod, @NextBillingDate)		 
	end

	update #tBuckets
	set    Total = @LastPeriodCount * @AmountPerPeriod
			,UpdateFlag = @LastPeriodCount
	where  Idx = 13

	if @Debug = 1
	begin
		select @StartDate as StartDate
		      ,@LastBillingDate as LastBillingDate
		      ,@EndDate as EndDate
			  ,@NumberOfMonthsPerPeriod as NumberOfMonthsPerPeriod
			  ,@NumberOfPeriods as NumberOfPeriods
			  ,@Frequency as Frequency
			  ,@Months as Months
		select * from #tBuckets order by Idx
	end

	
	update #tBuckets
	set    Total = isnull(Total, 0)
	

	declare @Bucket0 money,@Bucket1 money,@Bucket2 money,@Bucket3 money,@Bucket4 money,@Bucket5 money,@Bucket6 money
	       ,@Bucket7 money,@Bucket8 money,@Bucket9 money,@Bucket10 money,@Bucket11 money,@Bucket12 money,@Bucket13 money
		

	select @Bucket0 = Total from #tBuckets where Idx = 0
	
	select @Bucket1 = Total from #tBuckets where Idx = 1
	select @Bucket2 = Total from #tBuckets where Idx = 2
	select @Bucket3 = Total from #tBuckets where Idx = 3
	select @Bucket4 = Total from #tBuckets where Idx = 4
	select @Bucket5 = Total from #tBuckets where Idx = 5
	select @Bucket6 = Total from #tBuckets where Idx = 6
	select @Bucket7 = Total from #tBuckets where Idx = 7
	select @Bucket8 = Total from #tBuckets where Idx = 8
	select @Bucket9 = Total from #tBuckets where Idx = 9
	select @Bucket10 = Total from #tBuckets where Idx = 10
	select @Bucket11 = Total from #tBuckets where Idx = 11
	select @Bucket12 = Total from #tBuckets where Idx = 12
	
	select @Bucket13 = Total from #tBuckets where Idx = 13

	declare @Total money
	select @Total = sum(Total) from #tBuckets
	
	if @Months = 0
		select @Months = sum(UpdateFlag) from #tBuckets

	update tForecastDetail
	set    [Prior] =isnull(@Bucket0, 0)
	        ,Total = @Total 
			,Month1 =isnull(@Bucket1, 0)
			,Month2 =isnull(@Bucket2, 0)
			,Month3 =isnull(@Bucket3, 0)
			,Month4 =isnull(@Bucket4, 0)
			,Month5 =isnull(@Bucket5, 0)
			,Month6 =isnull(@Bucket6, 0)
			,Month7 =isnull(@Bucket7, 0)
			,Month8 =isnull(@Bucket8, 0)
			,Month9 =isnull(@Bucket9, 0)
			,Month10 =isnull(@Bucket10, 0)
			,Month11 =isnull(@Bucket11, 0)
			,Month12 =isnull(@Bucket12, 0)
			,NextYear =isnull(@Bucket13, 0)

			-- in case retainer was changed
			,StartDate = @StartDate
			,Months = @Months
	where  ForecastDetailKey = @ForecastDetailKey 
	


	-- No do the cost part

	update #tBuckets
	set    Total = @CostPerPeriod
	where  UpdateFlag = 1
	and    Idx >0 and Idx < 13

	update #tBuckets
	set    Total = @PeriodCount * @CostPerPeriod
	      ,UpdateFlag = @PeriodCount
	where  Idx = 0

	update #tBuckets
	set    Total = @LastPeriodCount * @CostPerPeriod
			,UpdateFlag = @LastPeriodCount
	where  Idx = 13

	if @Debug = 1
	begin
		select @StartDate as StartDate
		      ,@LastBillingDate as LastBillingDate
		      ,@EndDate as EndDate
			  ,@NumberOfMonthsPerPeriod as NumberOfMonthsPerPeriod
			  ,@NumberOfPeriods as NumberOfPeriods
			  ,@Frequency as Frequency
			  ,@Months as Months
		select * from #tBuckets order by Idx
	end

	
	update #tBuckets
	set    Total = isnull(Total, 0)
	

	select @Bucket0 = Total from #tBuckets where Idx = 0
	
	select @Bucket1 = Total from #tBuckets where Idx = 1
	select @Bucket2 = Total from #tBuckets where Idx = 2
	select @Bucket3 = Total from #tBuckets where Idx = 3
	select @Bucket4 = Total from #tBuckets where Idx = 4
	select @Bucket5 = Total from #tBuckets where Idx = 5
	select @Bucket6 = Total from #tBuckets where Idx = 6
	select @Bucket7 = Total from #tBuckets where Idx = 7
	select @Bucket8 = Total from #tBuckets where Idx = 8
	select @Bucket9 = Total from #tBuckets where Idx = 9
	select @Bucket10 = Total from #tBuckets where Idx = 10
	select @Bucket11 = Total from #tBuckets where Idx = 11
	select @Bucket12 = Total from #tBuckets where Idx = 12
	
	select @Bucket13 = Total from #tBuckets where Idx = 13

	select @Total = sum(Total) from #tBuckets
	
	if @Months = 0
		select @Months = sum(UpdateFlag) from #tBuckets

	update tForecastDetail
	set    [PriorN] =-1*isnull(@Bucket0, 0)
	        ,TotalN = -1*@Total 
			,Month1N =-1*isnull(@Bucket1, 0)
			,Month2N =-1*isnull(@Bucket2, 0)
			,Month3N =-1*isnull(@Bucket3, 0)
			,Month4N =-1*isnull(@Bucket4, 0)
			,Month5N =-1*isnull(@Bucket5, 0)
			,Month6N =-1*isnull(@Bucket6, 0)
			,Month7N =-1*isnull(@Bucket7, 0)
			,Month8N =-1*isnull(@Bucket8, 0)
			,Month9N =-1*isnull(@Bucket9, 0)
			,Month10N =-1*isnull(@Bucket10, 0)
			,Month11N =-1*isnull(@Bucket11, 0)
			,Month12N =-1*isnull(@Bucket12, 0)
			,NextYearN =-1*isnull(@Bucket13, 0)

	where  ForecastDetailKey = @ForecastDetailKey 
	


	RETURN 1
GO
