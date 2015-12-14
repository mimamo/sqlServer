USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastCalcBucketsMultiple]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastCalcBucketsMultiple]
	(
	@ForecastKey int,
	@RecalcSequenceNumbers int = 1
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 10/29/12  GHL 10.5.6.1 Created for revenue forecasting
||                        This sp calls sptForecastCalcBuckets for a list of forecast details
||                        will be called when we change the start date or months on tForecastDetail
|| 10/31/12  GHL 10.5.6.1 Added separate loop for items and services
|| 06/26/13  GHL 10.5.6.9 (182036) Taking in now Net values               
*/

	SET NOCOUNT ON 

	-- Assume done in calling program
	-- create table #Detail (ForecastDetailKey int null, Entity varchar(20) null)

	update #Detail
	set    #Detail.Entity = tForecastDetail.Entity -- need this for my loop
	from   tForecastDetail (nolock)
	where  #Detail.ForecastDetailKey = tForecastDetail.ForecastDetailKey 
	and    #Detail.Entity is null
	 
	-- Gross values
	declare @Bucket0 money,@Bucket1 money,@Bucket2 money,@Bucket3 money,@Bucket4 money,@Bucket5 money,@Bucket6 money
	       ,@Bucket7 money,@Bucket8 money,@Bucket9 money,@Bucket10 money,@Bucket11 money,@Bucket12 money,@Bucket13 money

	-- Net values
	declare @Bucket0N money,@Bucket1N money,@Bucket2N money,@Bucket3N money,@Bucket4N money,@Bucket5N money,@Bucket6N money
	       ,@Bucket7N money,@Bucket8N money,@Bucket9N money,@Bucket10N money,@Bucket11N money,@Bucket12N money,@Bucket13N money

	declare @Total money
	declare @TotalN money
	declare @Sequence int
	declare @ForecastDetailKey int
	declare @Entity varchar(50)

	-- since we do not have a key, make sure that the sequence # are unique
	if @RecalcSequenceNumbers = 1
	begin
		select @ForecastDetailKey = -1
		while (1=1)
		begin
			select @ForecastDetailKey = min(ForecastDetailKey)
			from   #Detail
			where  ForecastDetailKey > @ForecastDetailKey   

			if @ForecastDetailKey is null
				break

			select @Sequence = 0
			update tForecastDetailItem
			set    Sequence = @Sequence
				   ,@Sequence = @Sequence + 1
			where  ForecastDetailKey = @ForecastDetailKey

		end
	end

	select @ForecastDetailKey = -1
	while (1=1)
	begin
		select @ForecastDetailKey = min(ForecastDetailKey)
		from   #Detail (nolock)
		where  ForecastDetailKey > @ForecastDetailKey   
		and    Entity not in ('tItem', 'tService', 'tRetainer') -- for these, no rollup is required, there is no  tForecastDetailItem   

		if @ForecastDetailKey is null
			break

		select @Entity = Entity
		from   #Detail (nolock)
		where  ForecastDetailKey = @ForecastDetailKey

		if @Entity <> 'tInvoice'
		begin 
			select @Sequence = -1
			while (1 = 1)
			begin
			
				select @Sequence = min(Sequence)
				from   tForecastDetailItem (nolock)
				where  ForecastDetailKey = @ForecastDetailKey   
				and    Sequence > @Sequence

				if @Sequence is null
					break
			
				exec sptForecastCalcBuckets @ForecastDetailKey, @Sequence
			end
		end

		-- Note: The buckets for invoices were already calculated when loading the tForecastDetailItem recs

		-- and rollup to the forecast detail		
		select @Bucket0 = sum(Prior) 
		       ,@Bucket1 = sum(Month1)
			   ,@Bucket2 = sum(Month2)
		       ,@Bucket3 = sum(Month3) 
			   ,@Bucket4 = sum(Month4) 
			   ,@Bucket5 = sum(Month5) 
			   ,@Bucket6 = sum(Month6) 
			   ,@Bucket7 = sum(Month7) 
		       ,@Bucket8 = sum(Month8) 
			   ,@Bucket9 = sum(Month9) 
		       ,@Bucket10 = sum(Month10)
		       ,@Bucket11 = sum(Month11)
		       ,@Bucket12 = sum(Month12)
		       ,@Bucket13 = sum(NextYear)
			   ,@Total = sum(Total)
        from   tForecastDetailItem (nolock)
		where  ForecastDetailKey = @ForecastDetailKey
		and    isnull(AtNet, 0) = 0

		select @Bucket0N = sum(Prior) 
		       ,@Bucket1N = sum(Month1)
			   ,@Bucket2N = sum(Month2)
		       ,@Bucket3N = sum(Month3) 
			   ,@Bucket4N = sum(Month4) 
			   ,@Bucket5N = sum(Month5) 
			   ,@Bucket6N = sum(Month6) 
			   ,@Bucket7N = sum(Month7) 
		       ,@Bucket8N = sum(Month8) 
			   ,@Bucket9N = sum(Month9) 
		       ,@Bucket10N = sum(Month10)
		       ,@Bucket11N = sum(Month11)
		       ,@Bucket12N = sum(Month12)
		       ,@Bucket13N = sum(NextYear)
			   ,@TotalN = sum(Total)
        from   tForecastDetailItem (nolock)
		where  ForecastDetailKey = @ForecastDetailKey
		and    isnull(AtNet, 0) = 1

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
			  ,Total = isnull(@Total,0)

			  ,[PriorN] =isnull(@Bucket0N, 0)
			  ,Month1N =isnull(@Bucket1N, 0)
			  ,Month2N =isnull(@Bucket2N, 0)
			  ,Month3N =isnull(@Bucket3N, 0)
			  ,Month4N =isnull(@Bucket4N, 0)
			  ,Month5N =isnull(@Bucket5N, 0)
			  ,Month6N =isnull(@Bucket6N, 0)
			  ,Month7N =isnull(@Bucket7N, 0)
			  ,Month8N =isnull(@Bucket8N, 0)
			  ,Month9N =isnull(@Bucket9N, 0)
			  ,Month10N =isnull(@Bucket10N, 0)
			  ,Month11N =isnull(@Bucket11N, 0)
			  ,Month12N =isnull(@Bucket12N, 0)
			  ,NextYearN =isnull(@Bucket13N, 0)
			  ,TotalN = isnull(@TotalN,0)

			  ,RecalcNeeded = 0
		where  ForecastDetailKey = @ForecastDetailKey 
	
	end


	select @ForecastDetailKey = -1
	while (1=1)
	begin
		select @ForecastDetailKey = min(ForecastDetailKey)
		from   #Detail (nolock)
		where  ForecastDetailKey > @ForecastDetailKey   
		and    Entity in ('tItem', 'tService', 'tRetainer') -- for these, there are no rollup, we will affect the tForecastDetail record directly     

		if @ForecastDetailKey is null
			break

		exec sptForecastCalcBuckets @ForecastDetailKey, 0

		update tForecastDetail
		set    RecalcNeeded = 0
		where  ForecastDetailKey = @ForecastDetailKey 

	end

	RETURN 1
GO
