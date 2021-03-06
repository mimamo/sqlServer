USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptForecastCalcBucketsInvoice]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptForecastCalcBucketsInvoice]
	(
	@ForecastStartDate smalldatetime
	,@ForecastEndDate smalldatetime
	,@PostingDate smalldatetime
	)
AS --Encrypt

/*
|| When      Who Rel      What
|| 11/15/12  GHL 10.562  Created for revenue forecast
||                       When inserting the record for invoices, the bucket can be determined
||                       right away because it only depends on the PostingDate
*/

	SET NOCOUNT ON

	declare @BucketIdx int
	declare @BucketStartDate smalldatetime
	declare @BucketEndDate smalldatetime

	if @PostingDate < @ForecastStartDate 
	begin
		return  0 -- Prior Bucket
	end

	if @PostingDate > @ForecastEndDate 
	begin
		return  13 -- Next Year Bucket
	end

	
	select @BucketStartDate = @ForecastStartDate
	select @BucketIdx = 1
	while (@BucketIdx <= 12)
	begin
		-- add 1 month and subtract 1 day to find the end of the month
		select @BucketEndDate = dateadd(m, 1, @BucketStartDate)
		select @BucketEndDate = dateadd(d, -1, @BucketEndDate)

		if (@PostingDate >= @BucketStartDate and @PostingDate <= @BucketEndDate)
			break

		select @BucketStartDate = dateadd(m, 1,@BucketStartDate)
		select @BucketIdx = @BucketIdx + 1 
	end

	RETURN @BucketIdx
GO
