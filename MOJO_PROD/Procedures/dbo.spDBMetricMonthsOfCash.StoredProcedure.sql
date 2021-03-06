USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spDBMetricMonthsOfCash]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDBMetricMonthsOfCash]
		@CompanyKey int,
		@NbrPeriods int,
		@LargetClientSize int = 0,
		@GLCompanyKey int,
		@UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 03/05/08 QMD WMJ 1.0   Modified for initial Release of WMJ
  || 02/24/09 QMD 10.0.1.9	(47065) Added in the following clause " (isnull(t.Overhead, 0) = 1 or  "
  || 07/31/12 MFT 10.5.5.8  Added @GLCompanyKey & @UserKey params and GL Company restrictions	
  || 03/13/14 GHL 10.5.7.8  Using now vHTransaction
  */

declare @EndRangeDate datetime
declare @FromDate datetime
declare @ToDate datetime
declare @MonthlyOverheadAmtCredit decimal(24,4)
declare @MonthlyOverheadAmtDebit decimal(24,4)
declare @MonthlyOverheadAmt decimal(24,4)
declare @LiquidAssetsDebit decimal(24,4)
declare @LiquidAssetsCredit decimal(24,4)
declare @LiquidAssetAmt decimal(24,4)
declare @MonthsOfCash decimal(9,1)
declare @LargestClientSize decimal(9,2)
declare @ClientCompanyKey int
declare @CompanyName varchar(200)
declare @Periods int
declare @UpperTarget int
declare @LowerTarget int

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

create table #tMetric (MonthNum int null, MetricVal decimal(9,1) null, LargestClientSize decimal(9,2) null)

select @EndRangeDate = cast(cast(datepart(mm,getdate()) as varchar(2)) + '/01/' + cast(datepart(yyyy,getdate()) as varchar(4)) as datetime)
select @Periods = @NbrPeriods * -1
select @FromDate = dateadd(mm,@Periods,@EndRangeDate)
select @ToDate = dateadd(mm,1,@FromDate)

-- get largest client in the past 12 months
exec spDBMetricLargestClientPerc @CompanyKey, @FromDate, @EndRangeDate, @GLCompanyKey, @UserKey, @ClientCompanyKey output, @CompanyName output, @LargestClientSize output

while 1=1
	begin 
		if @ToDate > @EndRangeDate
			break
		
		-- calculate monthly overhead
		select @MonthlyOverheadAmtDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 51  -- Expense Accounts
		and (isnull(t.Overhead, 0) = 1 or isnull(t.ClientKey,0) = 0)
		and TransactionDate >= @FromDate 
		and TransactionDate < @ToDate
		
		select @MonthlyOverheadAmtCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType = 51  -- Expense Accounts
		and (isnull(t.Overhead, 0) = 1 or isnull(t.ClientKey,0) = 0)
		and TransactionDate >= @FromDate 
		and TransactionDate < @ToDate
		
		select @MonthlyOverheadAmt = @MonthlyOverheadAmtDebit - @MonthlyOverheadAmtCredit
		
		select @LiquidAssetsDebit = isnull(sum(isnull(Debit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (10,12)  -- Bank, Current Asset Accounts	
		and TransactionDate < @ToDate
		
		select @LiquidAssetsCredit = isnull(sum(isnull(Credit,0)),0)
		from
			vHTransaction t (nolock)
			inner join tGLAccount g (nolock) on t.GLAccountKey = g.GLAccountKey
			INNER JOIN @tGLCompanies glc ON ISNULL(t.GLCompanyKey, 0) = glc.GLCompanyKey
		where t.CompanyKey = @CompanyKey
		and g.AccountType in (10,12)  -- Bank, Current Asset Accounts	
		and TransactionDate < @ToDate
		
		select @LiquidAssetAmt = @LiquidAssetsDebit - @LiquidAssetsCredit
		
		if @MonthlyOverheadAmt = 0 
			select @MonthsOfCash = 0
		else
			select @MonthsOfCash = round(@LiquidAssetAmt/@MonthlyOverheadAmt,1)
		
		insert #tMetric values (datepart(mm,@FromDate), @MonthsOfCash, @LargestClientSize)
		
		select @FromDate = dateadd(mm,1,@FromDate)
		select @ToDate = dateadd(mm,1,@ToDate)
	end
	
if @LargetClientSize >= 0.36
	 begin
		 set @UpperTarget = 4
		 set @LowerTarget = 3
		 end
	else if @LargetClientSize >=  0.26
	 begin	
		 set @UpperTarget = 3
		 set @LowerTarget = 2
	 end
else
	 begin
		 set @UpperTarget = 2
		 set @LowerTarget = 1
end

-- return calculations in recordset
select *, UpperTarget = @UpperTarget, LowerTarget = @LowerTarget from #tMetric
GO
