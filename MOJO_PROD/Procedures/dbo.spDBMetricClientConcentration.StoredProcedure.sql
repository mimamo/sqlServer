USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricClientConcentration]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricClientConcentration]
	@CompanyKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/05/08 QMD WMJ 1.0   Modified for initial Release of WMJ
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions	
  */

declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @LargestClientSize decimal(9,2)
declare @ClientCompanyKey int
declare @CompanyName varchar(200)
declare @Periods int

create table #tMetric (MonthNum int null, MetricVal decimal(9,2))

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)
	
while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		-- get largest client
		exec spDBMetricLargestClientPerc @CompanyKey, @FromDate, @ToDate, @GLCompanyKey, @UserKey, @ClientCompanyKey output, @CompanyName output, @LargestClientSize output
		
		insert #tMetric values (datepart(mm,@FromDate),round(@LargestClientSize,2))
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
	end

-- return calculations in recordset
select *, UpperTarget = 0.35, LowerTarget = 0.25 from #tMetric
GO
