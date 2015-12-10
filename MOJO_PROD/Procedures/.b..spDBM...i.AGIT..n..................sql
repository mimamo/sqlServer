USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricAGITrend]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricAGITrend]
	@CompanyKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions
  */

declare @AGIAmt decimal(24,4)
declare @COGSAmt decimal(24,4)
declare @ExpenseAmt decimal(24,4)
declare @IncomeAmt decimal(24,4)
declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @AGIFromDate datetime
declare @AGIToDate datetime
declare @MonthlyOverhead decimal(9,2)	
declare @MonthlyOverheadAmtCredit decimal(24,4)
declare @MonthlyOverheadAmtDebit decimal(24,4)
declare @MonthlyOverheadAmt decimal(24,4)
declare @Periods int

create table #tMetric (MonthNum int null, MetricVal decimal(24,4) null)

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)
select @AGIFromDate = dateadd(mm,-11,@FromDate)
select @AGIToDate = @ToDate

while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		-- calculate AGI for last 12 complete months
		exec spDBMetricAGI @CompanyKey, @AGIFromDate, @AGIToDate, @GLCompanyKey, @UserKey, @IncomeAmt output, @COGSAmt output, @ExpenseAmt output, @AGIAmt output
		
		insert #tMetric values (datepart(mm,@FromDate),round(@AGIAmt,0))
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @AGIFromDate = dateadd(mm,1,@AGIFromDate)
		select @AGIToDate = @ToDate
	end
	
-- return calculations in recordset
select * from #tMetric
GO
