USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastCalcBuckets]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastCalcBuckets]
	(
	@ForecastDetailKey int
	,@Sequence int
	,@Debug int = 0
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/11/12  GHL 10.5.6.1 Created for revenue forecasting
||                        This sp breaks down the total into 14 buckets
|| 10/31/12  GHL 10.5.6.1 For item and service entities, do not update tForecastDetailItem but tForecastDetail
|| 11/02/12  GHL 10.5.6.1 Working now with 15 buckets instead of 14 (in case the item end date is several years after)
||                        Prior Years      1 bucket
||                        Current Years   12 buckets
||                        Next 12 Months   1 bucket
||                        Years After      1 bucket
|| 11/05/12  GHL 10.5.6.2 The amount for each bucket should be a function of the number of days in the bucket 
*/

	SET NOCOUNT ON

	/* Prepare a table of 15 buckets (only 14 buckets will be displayed, and Total = sum(14 buckets))

	Example:
	StartMonth = 2
	StartYear = 2010
	
	StartDate  EndDate     Idx    #Days Total
	------------------------------------------
    null       01/31/2010   0     null   null   -- Prior Years (all)    
    
	02/01/2010 02/28/2010   1     28      null
    03/01/2010 03/31/2010   2     31      null
    04/01/2010 04/30/2010   3     30      null
    05/01/2010 05/31/2010   4     31      null
    06/01/2010 06/30/2010   5     30      null
    07/01/2010 07/31/2010   6     30      null
    08/01/2010 08/31/2010   7     30      null
    09/01/2010 09/30/2010   8     30      null
    10/01/2010 10/31/2010   9     30      null
    11/01/2010 11/30/2010   10    30      null
    12/01/2010 12/31/2010   11    30      null
	01/01/2011 01/31/2011   12    30      null
	
	02/01/2011 null         13    null     null  -- Next Year
	02/01/2012 null         14    null     null  -- All years after

	null and #Days will be recalculated for each record 

	update #tBuckets
	set    StartDate = @StartDate
	where  StartDate
	*/

	/*
	Can do this if you want the sequence unique

	declare @Sequence int
	select @Sequence = 0
	update tForecastDetailItem
	set    Sequence = @Sequence
		   ,@Sequence = @Sequence + 1
	where  ForecastDetailKey = @ForecastDetailKey

	select * from tForecastDetailItem

	*/

	/*
	Create and prepare the buckets from the forecast
	Could be done once
	*/

	-- inputs from tForecast or tForecastDetail 
	declare @StartMonth int
	declare @StartYear int
	declare @SpreadExpense int
	declare @Entity varchar(50)
	declare @Months int

	-- inputs from tForecastDetailItem
	declare @Total money
	declare @StartDate smalldatetime
	declare @EndDate smalldatetime
	declare @Spread int
	declare @Labor int -- is it labor or expense?

	declare @kSpreadAtStart int		select @kSpreadAtStart = 0
	declare @kSpreadAtEnd int		select @kSpreadAtEnd = 1
	declare @kSpreadEvenly int		select @kSpreadEvenly = 2
	 

	select @StartMonth = f.StartMonth 
	      ,@StartYear = f.StartYear
		  ,@SpreadExpense = f.SpreadExpense

		  ,@Entity = fd.Entity
		  ,@StartDate = fd.StartDate
		  ,@Months = fd.Months
		  ,@Total = fd.Total
	from   tForecast f (nolock)
           inner join tForecastDetail fd (nolock) on f.ForecastKey = fd.ForecastKey
	where  fd.ForecastDetailKey = @ForecastDetailKey
	
	-- cannot find forecast
	if @@ROWCOUNT = 0
		return -1

	if @Entity = 'tRetainer'
	begin
		exec sptForecastCalcBucketsRetainer @ForecastDetailKey
		return 1
	end

	if @Entity = 'tInvoice'
	begin
		return 1
	end

	create table #tBuckets (
		StartDate smalldatetime null
		,EndDate smalldatetime null
		,Idx int null
		,NumDays int null
		,Total money null
		)

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
	
	-- vars for loop
	declare @BucketStartDate smalldatetime
	declare @BucketIdx int
	
	select @ForecastStartDate = cast (@StartMonth as varchar(2)) + '/01/' + cast (@StartYear as varchar(4))
	select @ForecastEndDate = dateadd(yy, 1, @ForecastStartDate)
	select @ForecastEndDate = dateadd(d, -1, @ForecastEndDate)

	select @PriorEndDate = dateadd(d, -1, @ForecastStartDate)

	select @NextYearStartDate = dateadd(d, 1, @ForecastEndDate)
	select @NextYearEndDate = dateadd(yy, 1, @NextYearStartDate)
	select @NextYearEndDate = dateadd(d, -1, @NextYearEndDate)

	select @YearAfterStartDate = dateadd(d, 1, @NextYearEndDate)

	--select @ForecastStartDate, @ForecastEndDate 

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

	-- insert the bucket for the Years after the next 12 months
	insert #tBuckets (StartDate,EndDate,Idx)
	values (@YearAfterStartDate, '01/01/2050', 14)

	/*
	Now process the record
	Basically expand Total into 15 buckets
	*/

	if @Entity in ('tItem', 'tService', 'tInvoice')
	begin	
		-- total and startdate already known, calc other fields
		if @Months > 0
		begin
			select @EndDate = dateadd(m, @Months, @StartDate)
			select @EndDate = dateadd(d, -1, @EndDate)
		end
		else
			select @EndDate = @StartDate

		if @Entity = 'tItem'
			select @Labor = 0
		else if @Entity = 'tService' 
			select @Labor = 1
		else
			select @Labor = 1
	end
	else
	begin 
		select  @Total = Total
			   ,@StartDate = StartDate
			   ,@EndDate = EndDate
			   ,@Labor = Labor 
		from tForecastDetailItem  (nolock)
		where  ForecastDetailKey =  @ForecastDetailKey
		and    [Sequence] = @Sequence     

		-- abort if we cannot find detail item
		if @@ROWCOUNT = 0
			return -2
	end

	
	if @Labor = 1
		select @Spread = @kSpreadEvenly
	else
		select @Spread = @SpreadExpense
	
	declare @NumDays int
	declare @DayTotal decimal (24,4)
	declare @RoundError money

	-- Add 1 because diff between 10/01/12 and 10/31/12 is 0
	select @NumDays = datediff(d, @StartDate, @EndDate) + 1

	-- protect against div by 0
	if @NumDays < 1
		select @NumDays = 1

	select @DayTotal = @Total / @NumDays
	
	-- resets Totals to 0
	update #tBuckets 
	set    Total = 0
	
	update #tBuckets
	set    StartDate = @StartDate
	where @StartDate > StartDate

	update #tBuckets
	set    EndDate = @EndDate
	where  @EndDate < EndDate

	update #tBuckets
	set    NumDays = datediff(d, StartDate, EndDate) + 1

	update #tBuckets
	set NumDays = 0
	where isnull(NumDays, 0) <=0

	update #tBuckets
	set    Total = ROUND(NumDays * @DayTotal, 2)

	select @RoundError = sum(Total) from #tBuckets
	select @RoundError = @Total - isnull(@RoundError, 0)

	if @RoundError <> 0
	begin
		-- Place the rounding error in the last bucket with a valid NumMonths
		select @BucketIdx = max(Idx) 
		from #tBuckets 
		where NumDays <> 0
		
		update #tBuckets
		set    Total = isnull(Total, 0) + @RoundError
		where  Idx = @BucketIdx
	end

	if @Spread in ( @kSpreadAtStart, @kSpreadAtEnd)
	begin
	
		update #tBuckets
		set    Total = 0
	
		if @Spread = @kSpreadAtStart

			select  @BucketIdx = min(Idx) 
			from #tBuckets 
			where NumDays <> 0
		else

			select  @BucketIdx = max(Idx) 
			from #tBuckets 
			where NumDays <> 0 

		update #tBuckets
		set    Total = @Total
		where  Idx = @BucketIdx
	end

	if @Debug = 1
	begin
		select @StartDate as StartDate
				,@EndDate as EndDate
				, @NumDays as NumDays
				, @RoundError as RoundingError
				,@DayTotal as DayTotal
				, sum(NumDays) as SumNumDays
				, sum(Total) as SumTotal 
		from #tBuckets
		select * from #tBuckets order by Idx
		return
	end
	
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
	-- Note: Bucket 14 (Years After Next 12 months) is lost
	
	if @Entity in ('tItem', 'tService', 'tInvoice')
		update tForecastDetail
		set    [Prior] =isnull(@Bucket0, 0)
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
		where  ForecastDetailKey = @ForecastDetailKey 
	
	else

		update tForecastDetailItem
		set    [Prior] =isnull(@Bucket0, 0)
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
		where  ForecastDetailKey = @ForecastDetailKey 
		and    [Sequence] = @Sequence

	 
	RETURN 1
GO
