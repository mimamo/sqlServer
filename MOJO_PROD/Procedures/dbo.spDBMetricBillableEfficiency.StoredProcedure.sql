USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricBillableEfficiency]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricBillableEfficiency]
	@CompanyKey int,
	@LaborBudgetKey int,
	@NbrPeriods int,
	@GLCompanyKey int,
	@UserKey int

AS --Encrypt

/*
|| When     Who Rel      What
|| 10/07/08 GHL 10.0.1.0 Creation 
||                       The date ranges used in the query will be a year long             
||                       12 date ranges will be used
|| 8/15/09  GWG 10.5.07  Fixed an issue with dates used on actual and billable hrs (using date from tTime to tie to time details)
|| 07/31/12 MFT 10.5.5.8 Added @GLCompanyKey & @UserKey params and GL Company restrictions
|| 03/04/14 GHL 10.5.7.8 Added conversion to home currency
*/

SET NOCOUNT ON

------------------------------------------------------------
--GL Company restrictions
DECLARE @RestrictToGLCompany tinyint
DECLARE @tGLCompanies table (GLCompanyKey int)
SELECT @RestrictToGLCompany = ISNULL(RestrictToGLCompany, 0)
FROM tPreference (nolock) WHERE CompanyKey = @CompanyKey

IF ISNULL(@GLCompanyKey, 0) > 0
	INSERT INTO @tGLCompanies VALUES(@GLCompanyKey)
ELSE
	BEGIN --No @GLCompanyKey passed in
		IF @RestrictToGLCompany = 0
			BEGIN --@RestrictToGLCompany = 0
			 	--All GLCompanyKeys + 0 to get NULLs
				INSERT INTO @tGLCompanies VALUES(0)
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tGLCompany (nolock)
					WHERE CompanyKey = @CompanyKey
			END --@RestrictToGLCompany = 0
		ELSE
			BEGIN --@RestrictToGLCompany = 1
				 --Only GLCompanyKeys @UserKey has access to
				INSERT INTO @tGLCompanies
					SELECT GLCompanyKey
					FROM tUserGLCompanyAccess (nolock)
					WHERE UserKey = @UserKey
			END --@RestrictToGLCompany = 1
	END --No @GLCompanyKey passed in
--GL Company restrictions
------------------------------------------------------------

create table #tMetric (MonthNum int null, AGI decimal(24,4) null, Markup decimal(24,4) null 
											 ,BillableLabor decimal(24,4) null, BillableHours decimal(24,4) null
											 ,AvgHourlyRate decimal(24,4) null, BilledHours decimal(24,4) null
											 ,AvailableHours decimal(24,4) null, MetricVal decimal(24,4) null)

declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @YearFromDate datetime
declare @Periods int

-- calculated values to save
declare @AGI decimal(24,4) 
declare @Markup decimal(24,4)  
declare @BillableLabor decimal(24,4) 
declare @BillableHours decimal(24,4) 
declare @AvgHourlyRate decimal(24,4) 
declare @BilledHours decimal(24,4)
declare @AvailableHours decimal(24,4) 
declare @MetricVal decimal(24, 4)
declare @Income decimal(24, 4) -- will not be saved since this is a difference

/*
Fee Income = @AGI - @Markup
Avg Hourly Rate = @BillableLabor / @BillableHours
Billed Hrs = Fee Income / Avg Hourly Rate  
Billed Hrs = (@AGI - @Markup) / Avg Hourly Rate
Billable Efficiency = Billed Hrs / Available Hrs
*/

-- temporary results from AGI routine
declare @IncomeAmt decimal(24,4) 
declare @COGSAmt decimal(24,4)
declare @ExpenseAmt decimal(24,4)

-- Same date calculations than in other metrics
select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)  -- We will not use this date
select @ToDate = dateadd(mm,1,@FromDate) 
select @YearFromDate = dateadd(mm,-11,@FromDate) -- We will use this date, i.e. a window of 1 year

-- Since we are using a window of 12 months for each query, take the whole year
if isnull(@LaborBudgetKey,0) > 0 
	begin
		select 
			@AvailableHours = sum(
				  AvailableHours1
				+ AvailableHours2 
				+ AvailableHours3 
				+ AvailableHours4 
				+ AvailableHours5
				+ AvailableHours6
				+ AvailableHours7
				+ AvailableHours8
				+ AvailableHours9
				+ AvailableHours10
				+ AvailableHours11
				+ AvailableHours12) 
		from
			tLaborBudget lb (nolock) 
			inner join tLaborBudgetDetail lbd (nolock) on lb.LaborBudgetKey = lbd.LaborBudgetKey
		Where lb.LaborBudgetKey = @LaborBudgetKey			
	end

while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		-- calculate based on Labor Budget or actual hours
		if isnull(@LaborBudgetKey,0) = 0 
			begin
				select @AvailableHours = sum(ActualHours)
				from
					tTimeSheet ts (nolock)
				  inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
				  INNER JOIN tUser u (nolock) ON ts.UserKey = u.UserKey
					INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
				where
					t.WorkDate >= @YearFromDate 
					and t.WorkDate < @ToDate 
					and ts.CompanyKey = @CompanyKey
			end
		
		select
			@BillableHours = sum(ActualHours)
			,@BillableLabor = sum(ActualHours * ActualRate * t.ExchangeRate)	
		from
			tTimeSheet ts (nolock)
			inner join tTime t (nolock) on ts.TimeSheetKey = t.TimeSheetKey
			inner join tProject p (NOLOCK) ON t.ProjectKey = p.ProjectKey
			INNER JOIN tUser u (nolock) ON ts.UserKey = u.UserKey
			INNER JOIN @tGLCompanies glc ON ISNULL(u.GLCompanyKey, 0) = glc.GLCompanyKey
		where
			t.WorkDate >= @YearFromDate
			and t.WorkDate < @ToDate
			and ts.CompanyKey = @CompanyKey
			and p.NonBillable = 0 and ActualRate > 0
		
		exec spDBMetricAGI @CompanyKey, @YearFromDate, @ToDate, @GLCompanyKey, @UserKey, @IncomeAmt output, @COGSAmt output, @ExpenseAmt output, @AGI output
		
		select @Markup = ISNULL((
							SELECT SUM(
								ISNULL(vd.AmountBilled, 0) * isnull(vd.PExchangeRate,1) 
								- ISNULL(vd.TotalCost , 0) * isnull(v.ExchangeRate,1)
								)
							FROM
								tVoucherDetail vd (nolock)
								INNER JOIN tVoucher v (nolock) ON v.VoucherKey = vd.VoucherKey
								INNER JOIN @tGLCompanies glc ON ISNULL(v.GLCompanyKey, 0) = glc.GLCompanyKey
							WHERE v.CompanyKey = @CompanyKey
							AND   vd.InvoiceLineKey > 0
							AND   vd.DateBilled >= @YearFromDate
							AND   vd.DateBilled < @ToDate
							),0)
							
							 + ISNULL((
							SELECT SUM(
								ISNULL(pod.AmountBilled, 0) * isnull(pod.PExchangeRate,1) 
								- ISNULL(pod.TotalCost , 0) * isnull(po.ExchangeRate,1) 
								)
							FROM
								tPurchaseOrderDetail pod (nolock)
								INNER JOIN tPurchaseOrder po (nolock) ON po.PurchaseOrderKey = pod.PurchaseOrderKey
								INNER JOIN @tGLCompanies glc ON ISNULL(po.GLCompanyKey, 0) = glc.GLCompanyKey
							WHERE po.CompanyKey = @CompanyKey
							AND   pod.InvoiceLineKey > 0
							AND   pod.DateBilled >= @YearFromDate
							AND   pod.DateBilled < @ToDate
							),0)
		
		-- Eliminate NULL values on queried values
		select
			@AGI = round(isnull(@AGI,0), 0) -- truncate AGI since it is displayed like that on metrics summary 
			,@Markup = isnull(@Markup,0)
			,@BillableLabor = isnull(@BillableLabor,0)
			,@BillableHours = isnull(@BillableHours,0)
			,@AvailableHours = isnull(@AvailableHours,0)
		
		-- Eliminate NULL values on calculated values
		select @Income = isnull(@Income, 0)
			,@AvgHourlyRate = isnull(@AvgHourlyRate,0)
			,@BilledHours = isnull(@BilledHours,0)
			,@MetricVal = isnull(@MetricVal,0)
		
		select @Income = @AGI - @Markup 			
		
		if (@BillableLabor  <> 0 AND @BillableHours <> 0) 
			select @AvgHourlyRate  = @BillableLabor / @BillableHours
		
		if @AvgHourlyRate <> 0
			select @BilledHours = @Income / @AvgHourlyRate
		
		-- if we could not divide at anytime, metric is 0
		if (@AvgHourlyRate <> 0 AND @AvailableHours <> 0)
			select @MetricVal = @BilledHours / @AvailableHours
		else
			select @MetricVal = 0
		
		insert #tMetric values (
				datepart(mm,@FromDate)
				,isnull(@AGI,0)
				,isnull(@Markup,0)
				,isnull(@BillableLabor,0)
				,isnull(@BillableHours,0)
				,isnull(@AvgHourlyRate,0)
				,isnull(@BilledHours,0)
				,isnull(@AvailableHours,0)
				,isnull(@MetricVal,0)
				)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
		select @YearFromDate = dateadd(mm,1,@YearFromDate)
		
	end
	
	-- return calculations in recordset
	select * from #tMetric


	RETURN 1
GO
